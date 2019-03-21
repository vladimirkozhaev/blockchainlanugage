package org.blockchain.rell.tests

import com.google.inject.Inject
import org.blockchain.rell.rell.Model
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(RellInjectorProvider)
class RellParsingV7 {
	@Inject
	extension ParseHelper<Model> parseHelper
	@Inject extension ValidationTestHelper
	
	/*Object type (from Rell v7). Attributes of an object must have default values, 
	 * cannot to be applied to object attributes 'key' and 'index'
	 */
	@Test
	def void testObjectType() {
		assertParsingTrue('''
			object obj {
			    k : pubkey = x'e04fd020ea3a6910a2d808002b30309d';
			    mutable value : integer = 0;
			    mutable text : text = 'text';
			    mutable active : boolean = true; 
			}
		''')
	}
	
	
	// "if" can be used in expressions (Rell v.7)
	@Test
	def void testIfInExpressions() {
		assertParsingTrue('''
			query q1() = if (true) 'A' else 'B' + 'C' ;
			query q2() = if (false) 'A' else 'B' + 'C' ;
			query q3() = if (true) 'A' else if (true) 'B' else 'C' + 'D' ;
			query q4() = if (false) 'A' else if (true) 'B' else 'C' + 'D' ;
			query q5() = if (false) 'A' else if (false) 'B' else 'C' + 'D' ;
			query q6(a: boolean, b: integer, c: integer) = if (a) b else c;
		''')
	}
	
	// Expression update (Rell v.7)
	@Test
	def void testUpdateExpression() {
		assertParsingTrue('''
			class user { name: text; mutable score: integer; }
			operation o(i : integer) { 
			    val u = user @* { .name == 'Alice' }; 
			    update u ( score += 100 ); 
			    update u ( score *= 2 );
			    update u ( score *= 4 * i );
			    update u ( score /= 6 * i * i );
			    update u ( score -= 8 + .score - i );
			}
		''')
	}
	
	// Operations with Enum type (Rell v.7)
	@Test
	def void testEnumTypeOperation() {
		assertParsingTrue('''
			enum countryCode {
			    AF, AD, BE, BR, CA, EE,
			    DE, LT, MD, NL, GB, UA,
			    US, SA, SK, VU, VN, ZW 
			}
			
			enum currency {
			USD, EUR, GBP
			}
			
			operation op() {
			    var ccode1 = countryCode.value('UA');
			    var ccode2 = countryCode.value(5);
			    
			    var c: currency;
			    c = currency.USD;
			    val eurStr: text = currency.EUR.name;
			    val eurValue: integer = currency.EUR.value;
			    
			    val countryCodes: list<countryCode> = countryCode.values();
			    val currencies: list<currency> = currency.values();
			}
		''')
	}
	
	@Test
	def void testEnumAsObjectAttribute() {
		assertParsingTrue('''
			enum countryCode {
					 AF, AD, BE, BR, CA, EE,
					 DE, LT, MD, NL, GB, UA,
					 US, SA, SK, VU, VN, ZW 
			}
						
			object country {
			        name = 'Canada';
			        countryCode = countryCode.value('CA');
			}
		''')
	}
	
	def void assertParsingTrue(String codeSnippet) {
		val result = parseHelper.parse(codeSnippet)
		Assert.assertNotNull(result);
		Assert.assertNotNull(result.eResource)
		Assert.assertNotNull(result.eResource.errors)
		val errors = result.eResource.errors

		Assert.assertTrue( '''Unexpected errors: �errors.join(", ")�''', errors.empty)

		result.assertNoErrors
	}
	
}