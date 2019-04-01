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
	
	@Test
	def void testIfInExpressions1() {
		assertParsingTrue('''
			class company { name: text; }
			class user { name: text; company; }
			class optest { b1: boolean;b2: boolean;b3: boolean;i1: integer;i2: integer;i3: integer;t1: text;t2: text;t3: text;
			ba1: byte_array;ba2: byte_array;ba3: byte_array;j1: json;j2: json;j3: json;user1: user;
			user2: user;user3: user;company1: company;company2: company;company3: company; }
			
			query q1() = optest @ {} ( if (.b1) 1 else 2 ); 
			query q33() = optest @ {} ( if (.b1) 'Yes' else 'No' ); 
			query q34() = optest @ {} ( if (.b1) .i2 else .i3 ); 
			query q35() = optest @ {} ( if (.b1) .t2 else .t3 ); 
			query q41() = optest @ {} ( .t1.len() ); 
			query q42() = optest @ {} ( .ba1.len() ); 
		''')		
	}
		
	// "if" can be used in expressions (Rell v.7)
	@Test
	def void testIfInExpressions2() {
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
	
	@Test
	def void testClassAnnotations() {
		assertParsingTrue('''
			class user (log) {
			    name: text;
			}
		''')
	}
	
	def void assertParsingTrue(String codeSnippet) {
		val result = parseHelper.parse(codeSnippet)
		Assert.assertNotNull(result);
		Assert.assertNotNull(result.eResource)
		Assert.assertNotNull(result.eResource.errors)
		val errors = result.eResource.errors

		Assert.assertTrue( '''Unexpected errors: «errors.join(", ")»''', errors.empty)

		result.assertNoErrors
	}
	
}