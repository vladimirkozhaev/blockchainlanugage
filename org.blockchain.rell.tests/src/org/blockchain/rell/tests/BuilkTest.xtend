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
	
class BuilkTest {
	@Inject extension ParseHelper<Model> parseHelper
	@Inject extension ValidationTestHelper
	
	@Test
	def void testLogicalArithmeticOpt() {
		assertParsingTrue('''
			class company { name: text; }
			class user { name: text; company; }
			class optest { b1: boolean;b2: boolean;b3: boolean;i1: integer;i2: integer;i3: integer;t1: text;t2: text;t3: text;ba1: byte_array;ba2: byte_array;ba3: byte_array;j1: json;j2: json;j3: json;user1: user;user2: user;user3: user;company1: company;company2: company;company3: company; }
			query q1() = optest @* { .b1 and .b2 };
			query q2() = optest @ {} ( .b1 and .b2 );
			query q3() = optest @ {} ( .i1 / .i2 );
			query q4() = optest @ {} ( .i1 % .i2 );
			query q5() = optest @ {} ( .i1 * .i2 );
			query q6() = optest @* { not .b1 };
			query q7() = optest @ {} ( not .b1 );
			query q8() = optest @ {} ( .i1 - .i2 );
			query q9() = optest @ {} ( - .i1 );
			query q10() = optest @* { .i1 == .i2 };
			query q11() = optest @ {} ( .i1 == .i2 );
			query q12() = optest @* { .i1 != .i2 };
			query q13() = optest @ {} ( .i1 != .i2 );
			query q14() = optest @* { .i1 < .i2 };
			query q15() = optest @ {} ( .i1 < .i2 );
			query q16() = optest @* { .i1 <= .i2 };
			query q17() = optest @ {} ( .i1 <= .i2 );
			query q18() = optest @* { .i1 > .i2 };
			query q19() = optest @ {} ( .i1 > .i2 );
			query q20() = optest @* { .i1 >= .i2 };
			query q21() = optest @ {} ( .i1 >= .i2 );
			query q22() = optest @ {} ( .i1 + .i2 );
			query q23() = optest @ {} ( .t1 + .t2 );
			query q24() = optest @ {} ( .ba1 + .ba2 );
			query q25() = optest @ {} ( + .i1 );
			query q26() = optest @ {} ( .b1 + .t2 );
			query q27() = optest @ {} ( .t1 + .b2 );
			query q28() = optest @ {} ( .i1 + .t2 );
			query q29() = optest @ {} ( .t1 + .i2 );
			query q30() = optest @ {} ( .j1 + .t2 );
			query q31() = optest @ {} ( .t1 + .j2 );
			query q32() = optest @ {} ( if (.b1) 1 else 2 ); // do not parse
			query q33() = optest @ {} ( if (.b1) 'Yes' else 'No' ); // do not parse
			query q34() = optest @ {} ( if (.b1) .i2 else .i3 ); // do not parse
			query q35() = optest @ {} ( if (.b1) .t2 else .t3 ); // do not parse
			query q36() = optest @* { .b1 or .b2 };
			query q37() = optest @ {} ( .b1 or .b2 );
			query q38() = optest @ {} ( abs(.i1) );
			query q39() = optest @ {} ( min(.i1, .i2) );
			query q40() = optest @ {} ( max(.i1, .i2) );
			query q41() = optest @ {} ( .t1.len() ); // do not parse
			query q42() = optest @ {} ( .ba1.len() ); // do not parse
			query q43() = optest @* { .t1 == .t2 };
			query q44() = optest @ {} ( .t1 == .t2 );
			query q45() = optest @* { .t1 != .t2 };
			query q46() = optest @ {} ( .t1 != .t2 );
			query q47() = optest @* { .t1 < .t2 };
			query q49() = optest @ {} ( .t1 < .t2 );
			query q50() = optest @* { .t1 <= .t2 };
			query q51() = optest @* { .t1 > .t2 };
			query q52() = optest @ {} ( .t1 <= .t2 );
			query q53() = optest @ {} ( .t1 > .t2 );
			query q54() = optest @* { .t1 >= .t2 };
			query q55() = optest @ {} ( .t1 >= .t2 );
			query q56() = optest @* { .b1 == .b2 };
			query q57() = optest @ {} ( .b1 == .b2 );
			query q58() = optest @* { .b1 != .b2 };
			query q59() = optest @ {} ( .b1 != .b2 );
			query q60() = optest @ {} ( json(.t1) );
			query q61() = optest @ {} ( .j1.str() );
			query q62() = optest @* { .user1 == .user2 };
			query q63() = optest @ {} ( .user1 == .user2 );
			query q64() = optest @* { .user1 != .user2 };
			query q65() = optest @ {} ( .user1 != .user2 );
			query q66() = optest @* { .user1 < .user2 };
			query q67() = optest @ {} ( .user1 < .user2 );
			query q68() = optest @* { .user1 <= .user2 };
			query q69() = optest @ {} ( .user1 <= .user2 );
			query q70() = optest @* { .user1 > .user2 };
			query q71() = optest @ {} ( .user1 > .user2 );
			query q72() = optest @* { .user1 >= .user2 };
			query q73() = optest @ {} ( .user1 >= .user2 );
			query q74() = optest @* { .ba1 == .ba2 };
			query q75() = optest @ {} ( .ba1 == .ba2 );
			query q76() = optest @ {} ( .ba1 != .ba2 );
			query q77() = optest @* { .ba1 < .ba2 };
			query q78() = optest @ {} ( .ba1 < .ba2 );
			query q79() = optest @ {} ( .ba1 <= .ba2 );
			query q80() = optest @* { .ba1 <= .ba2 };
			query q91() = optest @* { .ba1 > .ba2 };
			query q92() = optest @ {} ( .ba1 > .ba2 );
			query q93() = optest @* { .ba1 >= .ba2 };
			query q94() = optest @ {} ( .ba1 >= .ba2 );
		''')		
	}
	
	@Test
	def void testQueriesAtExpressionsPart1() {
		assertParsingTrue('''
			class country { name: text; }
			class state { name: text; country; }
			class city { name: text; state; }
			class company { name: text; hq: city; }
			class department { name: text; company; }
			class person { name: text; city; department; }
			query q1() = person @* {} ;
			query q2() = person @* { .city.name == 'San Francisco' } ;
			query q3() = person @* { .city.name == 'Las Vegas' } ;
			query q4() = person @* { .city.name == 'Munich' } ;
			query q5() = person @* { .city.state.name == 'CA' } ;
			query q6() = person @* { .city.state.name == 'WA' } ;
			query q7() = person @* { .city.state.country.name == 'USA' } ;
			query q8() = person @* { .city.state.country.name == 'Germany' } ;
			query q9() = company @* { .hq.state.country.name == 'USA' } ;
			query q10() = person @* { .city.name == 'Las Vegas', .department.company.hq.name == 'Cologne' } ;
			query q11() = person @* { .city.name == 'Stuttgart', .department.company.hq.name == 'Las Vegas' } ;
			query q12() = (p1: person, p2: person) @* { p1.city.name == 'San Francisco', p2.department.company.name == 'Amazon' } ;
			query q13() = (p1: person, p2: person) @* { p1.city.name == 'Munich', p2.department.company.name == 'Mercedes' } ;
			query q14() = person @* { .city == .department.company.hq } ;
			query q15() = person @* { .city.state == .department.company.hq.state } ;
			query q16() = person @* { .city.state.country == .department.company.hq.state.country } ;
			query q17() { val x = city @ { .name == 'Stuttgart' }; return person @* { .city == x }; }
			query q18() { val x = state @ { .name == 'NV' }; return person @* { .city.state == x }; }
			query q19() { val x = state @ { .name == 'BY' }; return person @* { .city.state == x }; }
			query q20() { val x = state @ { .name == 'CA' }; return person @* { .city.state == x }; }
			query q21() { val x = country @ { .name == 'USA' }; return person @* { .city.state.country == x }; }
			query q22() = person @* { .department.company.hq.name == 'Seattle' } ;
			query q23() = person @* { .department.company.hq.name == 'Dusseldorf' } ;
			query q24() = person @* { .department.company.hq.name == 'Los Angeles' } ;
			query q25() = person @* { .department.company.hq.state.country.name == 'USA' } ;
			query q26() = person @* { .department.company.hq.state.country.name == 'Germany' } ;
		''')		
	}
	
	@Test
	def void testQueriesAtExpressionsPart2() {
		assertParsingTrue('''
			class company { name: text; }
			class user { firstName: text; lastName: text; company; }
			query q1() = (user, company) @ { user.firstName == 'Mark', company.name == 'Microsoft' } ;
			query q2() = (u: user, c: company) @ { u.firstName == 'Mark', c.name == 'Microsoft' } ;
			query q3() = (company: user, user: company) @ { company.firstName == 'Mark', user.name == 'Microsoft' } ; // do not parse
			query q4() = user @* { .company == company @ { .name == 'Facebook' } } ;
			query q5() = user @* { .company == company @ { .name == 'Apple' } } ;
			query q6() = user @* { company @ { .name == 'Facebook' } } ;
			query q7() = user @* { company @ { .name == 'Apple' } } ;
			query q8() = user @ { .firstName == 'Bill' } (=.lastName, '' + (123,'Hello')) ; // do not parse
			query q9() = user @* {} limit 0 ; // do not parse
			query q10() = user @* {} limit 1 ; // do not parse
			query q11() = user @* {} ( .lastName ) limit 0 ; // do not parse
			query q12() = user @* {} ( .lastName ) limit 4 ; // do not parse
			query q13() { return user @* { .firstName == 'Mark' }; }
			query q14() { val firstName = 'Bill'; return user @* { firstName == 'Mark' }; }
			query q15() { val firstName = 'Bill'; return user @* { firstName == firstName }; }
			query q16() { val firstName = 'Bill'; return user @ { firstName }; }
			query q17() { val firstName = 'Bill'; return user @ { .firstName == firstName }; }
			query q18() { val firstName = 'Bill'; return user @* {} ( firstName ); }
			query q19() { val firstName = 'Bill'; return user @* {} ( .firstName ); }
			query q20() = '' + user @* {} ( .firstName ) ;
			query q21() = '' + user @* {} ( sort .firstName ) ; // java.lang.NullPointerException
			query q22() = '' + user @* {} ( -sort .firstName ) ; //java.lang.NullPointerException
			query q23() = '' + user @* { .company.name == 'Apple' } ( sort =.firstName, sort =.lastName ) ; //java.lang.NullPointerException
			query q24() = '' + user @* { .company.name == 'Apple' } ( sort =.firstName, -sort =.lastName ) ; //java.lang.NullPointerException
			query q25() = '' + user @* {} ( sort =.company.name, =.lastName ) ; // java.lang.NullPointerException
			query q26() = '' + user @* {} ( sort =.company.name, sort =.lastName ) ; // java.lang.NullPointerException
			query q27() = '' + user @* {} ( -sort user ) ; // java.lang.NullPointerException
			query q28() = '' + user @* {} ( -sort =.company, =user ) ; // java.lang.NullPointerException
			query q29() = (user) @ { user.firstName == 'Bill' } ;
			query q30() = (u: user) @ { u.firstName == 'Bill' } ;
			query q31() = user @ { .firstName == 'Bill' } ( .lastName ) ;
			query q32() = (u: user) @ { .firstName == 'Bill' } ( u.lastName ) ;
			query q33() = (u1: user, u2: user) @ { u1.firstName == 'Bill', u2.firstName == 'Mark' } ( u1.lastName, u2.lastName ) ;
			query q34() = (u1: user, u2: user) @ { u1.firstName == 'Bill', u2.firstName == 'Mark' } ( u1.company.name, u2.company.name ) ; //Couldn't resolve reference to VariableDeclaration 'user'
			query q35() = user @ { .firstName == 'Bill' } (=.lastName, '' + list([1,2,3])) ; //Couldn't resolve reference to VariableDeclaration 'user'
			query q36() = user @ { .firstName == 'Bill' } (=.lastName, '' + set([1,2,3])) ; //Couldn't resolve reference to VariableDeclaration 'user'
			query q37() = user @ { .firstName == 'Bill' } (=.lastName, '' + map([123:'Hello'])) ;
			query q38() = user @ { .lastName == 'Socrates' } ;
			query q39() { val t = user @ { .firstName == 'Bill' } ( .firstName, .lastName, companyName = .company.name ); return t.firstName; }
			query q40() { val t = user @ { .firstName == 'Bill' } ( .firstName, .lastName, companyName = .company.name ); return t.lastName; }
			query q41() { val t = user @ { .firstName == 'Bill' } ( .firstName, .lastName, companyName = .company.name ); return t.companyName; }
			query q42() = (u1: user, u2: user) @* { u1.firstName == u2.firstName, u1 != u2 } ;
			query q43() = user @ { .firstName == 'Bill' } (=.lastName, '' + [1,2,3]) ;
			query q44() = user @ { .firstName == 'Bill' } (=.lastName, '' + [123:'Hello']) ;
			query q45() { val lastName = 'Gates'; return user @ { lastName }; }
			query q46() { val name = 'Microsoft'; return company @ { name }; }
			query q47() { val company = company @ { .name == 'Facebook' }; return user @ { company }; }			
		''')
	}
	
	@Test
	def void testQueriesAtExpWhatPart() {
		assertParsingTrue('''
			class user_account {
			    key tuid;
			    mutable name;
			    mutable login: text;
			    key pubkey;
			    index created_by: pubkey;
			    role: text;
			    mutable password_hash: text;
			    mutable deleted: boolean;
			    mutable aux_data: json;
			}
			
			query q1() { val search_role = 'validator'; val res = user_account @* {
			    .role == search_role or search_role == '',
			    .deleted == false
			} (
			    .tuid,
			    .name,
			    .login,
			    .role,
			    .deleted,
			    .aux_data
			);
			return res.size(); }
			
			query q2() { val search_role = 'foo'; val res = user_account @* {
			    .role == search_role or search_role == '',
			    .deleted == false
			} (
			    .tuid,
			    .name,
			    .login,
			    .role,
			    .deleted,
			    .aux_data
			);
			return res.size(); }
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
