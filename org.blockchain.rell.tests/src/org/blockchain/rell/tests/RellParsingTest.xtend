/*
 * generated by Xtext 2.14.0
 */
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
class RellParsingTest {
	@Inject
	extension ParseHelper<Model> parseHelper
	@Inject extension ValidationTestHelper

// Read object attributes
	@Test	
	def void testReadObjectAtributes() {
		assertParsingTrue('''
			object obj {
			    k : pubkey = x'e04fd020ea3a6910a2d808002b30309d';
			    mutable value : integer = 0;
			    mutable text : text = 'text';
			    mutable active : boolean = true; 
			}
			
			query get_obj_k() = obj.k;
			query get_obj_value() = obj.value;
			query get_obj_text() = obj.text;
			query get_obj_active() = obj.active;
		''')
	}

// check add, addAll set 
//	@Test
	def void testSetAdd() {
		assertParsingTrue('''
			query q1() { val x = set<integer>(); x.add(123); return ''+x; }
			query q2() { val x = set<integer?>(); x.add(null); return ''+x; }
			query q3() { val x = set<integer?>(); x.add(123); return ''+x; }
			query q4() { val x = set([1, 2, 3]); val r = x.addAll(set<integer>()); return r+' '+x; }
			query q5() { val x = set([1, 2, 3]); val r = x.addAll(list<integer>()); return r+' '+x; }
			query q6() { val x = set([1, 2, 3]); val r = x.addAll(set<integer>([1, 2, 3])); return r+' '+x; }
			query q7() { val x = set([1, 2, 3]); val r = x.addAll(list<integer>([1, 2, 3])); return r+' '+x; }
			query q8() { val x = set([1, 2, 3]); val r = x.addAll(set<integer>([3, 4, 5])); return r+' '+x; }
			query q9() { val x = set([1, 2, 3]); val r = x.addAll(list<integer>([3, 4, 5])); return r+' '+x; }
			query q10() { val x = set([1, 2, 3]); val r = x.addAll([4, 5, 6]); return r+' '+x; }
		''')
	}

// check map with class
	@Test
	def void testMapWithClass() {
		assertParsingTrue('''
			class company { name: text; }
			class user { firstName: text; lastName: text; company; }
			query q() {  return user @ { .firstName == 'Bill' } (=.lastName, '' + map([123:'Hello'])); }
		''')
	}
	
// check limit
	@Test
	def void testLimit() {
		assertParsingTrue('''
			class company { name: text; }
			class user { firstName: text; lastName: text; company; }
						
			query q1() = user @* {} limit 0 ; 
			query q2() = user @* {} limit 1 ; 
			query q3() = user @* {} ( .lastName ) limit 0 ; 
			query q4() = user @* {} ( .lastName ) limit 10 ; 
		''')
	}
	
// check sort (java.lang.NullPointerException error)
	@Test
	def void testSort() {
		assertParsingTrue('''
			class company { name: text; }
			class user { firstName: text; lastName: text; company; }

			query q1() = '' + user @* {} ( sort .firstName ) ; 
			query q2() = '' + user @* {} ( -sort .firstName ) ; 
			query q3() = '' + user @* { .company.name == 'Apple' } ( sort =.firstName, sort =.lastName ) ; 
			query q4() = '' + user @* { .company.name == 'Apple' } ( sort =.firstName, -sort =.lastName ) ; 
			query q5() = '' + user @* {} ( sort =.company.name, =.lastName ) ; 
			query q6() = '' + user @* {} ( sort =.company.name, sort =.lastName ) ; 
			query q7() = '' + user @* {} ( -sort user ) ; 
			query q8() = '' + user @* {} ( -sort =.company, =user ) ;
		''')
	}
	
	@Test
	def void testAlias() {
		assertParsingTrue('''
			class company { name: text; }
			class user { firstName: text; lastName: text; company; }

			query q1() = (company: user, user: company) @ { company.firstName == 'Mark', user.name == 'Microsoft' } ;
			query q2() = (user) @ { user.firstName == 'Bill' } ;
		''')
	}
	
	// check '=.' in what part
	@Test 
	def void testAssignOperatorInWhatPart() {
		assertParsingTrue('''
			class company { name: text; }
			class user { firstName: text; lastName: text; company; }
			
			query q() = user @* {} ( =.name, =.company ) ;
			query q1() = user @ { .firstName == 'Bill' } (=.lastName, '' + (123,'Hello')) ; 
			query q2() = user @ { .firstName == 'Bill' } (=.lastName, '' + list([1,2,3])) ; 
			query q3() = user @ { .firstName == 'Bill' } (=.lastName, '' + set([1,2,3])) ; 
			query q4() = user @ { .firstName == 'Bill' } (=.lastName, '' + map([123:'Hello'])) ;
		''')
	}
	
	// dynamical variable 'companyName' in What part
	@Test 
	def void testBuilkAssignOperatorInWhatPart() {
		assertParsingTrue('''
			class company { name: text; }
			class user { firstName: text; lastName: text; company; }
			
			query q1() { val t = user @ { .firstName == 'Bill' } ( .firstName, .lastName, companyName = .company.name ); return t.firstName; }
			query q2() { val t = user @ { .firstName == 'Bill' } ( .firstName, .lastName, companyName = .company.name ); return t.lastName; }
			query q3() { val t = user @ { .firstName == 'Bill' } ( .firstName, .lastName, companyName = .company.name ); return t.companyName; }
		''')
	}
	
	@Test 
	def void testAtOperatorWithSizeInAttribute() {
		assertParsingTrue('''
			class foo { x: integer; k: integer = (bar@*{ .v > 0 }).size(); }
			class bar { v: integer; }
		''')
	}
	
	@Test 
	def void testSingleTuple() {
		assertParsingTrue('''
			query q3() = (123,) ;
		''')
	}
	
	@Test 
	def void testIntegerOperations() {
		assertParsingTrue('''
			class user { name: text; score: integer; }
			query q1() = user @ { .score == integer('-5678') } ( .name ) ;
			query q2() = user @ { .score == -integer.parseHex('162e') } ( .name ) ;
			query q3() = user @ { .score < integer.MAX_VALUE } ( .name ) ;
			query q4() = user @* { .score < integer.MIN_VALUE } ( .name ) ;
			query q5() = user @ { integer.MAX_VALUE + .score == 9223372036854770129 } ( .name ) ;
		''')
	}
	
	@Test 
	def void testRange() {
		assertParsingTrue('''
			query q1() { val a = range(123); val b = range(123); return a == b; }
			query q2() { val a = range(123); val b = range(123); return a != b; }
			query q3() { val a = range(123); val b = range(123); return a === b; }
			query q4() { val a = range(123); val b = range(123); return a !== b; }
			query q5() { val a = range(123); val b = a; return a === b; }
			query q6() { val a = range(123); val b = a; return a !== b; }
		''')
	}
	
	@Test 
	def void testIntegerSubtypes() {
		assertParsingTrue('''
			query q1() { val a: integer? = 123; return a == null; }
			query q2() { val a: integer? = 123; return a != null; }
			query q3() { val a: integer? = null; return a == null; }
			query q4() { val a: integer? = null; return a != null; }
			query q5() { val a: integer? = 123; val b: integer? = 123; return a == b; }
			query q6() { val a: integer? = 123; val b: integer? = 123; return a != b; }
			query q7() { val a: integer? = 123; val b: integer? = 456; return a == b; }
			query q8() { val a: integer? = 123; val b: integer? = 456; return a != b; }
			query q9() { val a: integer? = 123; val b: integer? = null; return a == b; }
			query q10() { val a: integer? = 123; val b: integer? = null; return a != b; }
			query q11() { val x: integer? = 123; return x?.hex(); }
			query q12() { val x: integer? = null; return x?.hex(); }
			query q13() { val x: (a:integer?)? = (a=123); return x?.a?.hex(); }
			query q14() { val x: (a:integer?)? = (a=null); return x?.a?.hex(); }
			query q15() { val x: (a:integer?)? = null; return x?.a?.hex(); }
			query q16() { return integer.parseHex('7b'); }
		''')
	}
	
	@Test 
	def void testTextSubtypes() {
		assertParsingTrue('''
			query q() { val x: text? = 'Hello'; return x?.upperCase(); }
			query q() { val x: text? = null; return x?.upperCase(); }
			query q() { val x: text? = 'Hello'; return x?.upperCase()?.lowerCase(); }
			query q() { val x: text? = null; return x?.upperCase()?.lowerCase(); }
			query q() { val x: text? = 'Hello'; return x?.upperCase()?.lowerCase()?.size(); }
		''')
	}

	@Test 
	def void testTypeOf() {
		assertParsingTrue('''
			query q1() = _typeOf([null:null]) ;
			query q2() = _typeOf([123:null]) ;
			query q3() = _typeOf([null:'Hello']) ;
			query q4() = _typeOf([123:'Hello',null:'World']) ;
			query q5() = _typeOf([null:'Hello',123:'World']) ;
			query q6() = _typeOf([123:'Hello',456:null]) ;
			query q7() = _typeOf([123:null,456:'Hello']) ;
			query q8() = _typeOf([123:null,null:'Hello']) ;
			query q9() = _typeOf([null:'Hello',123:null]) ;
			query q10() = _typeOf([123:'Hello',null:null]) ;
			query q11() = _typeOf([123:'Hello',null:null,456:'World']) ;
			query q12() = _typeOf([null:null,123:'Hello',456:'World']) ;
			query q13() { return _typeOf([(1,'A')]); }
			query q14() { return _typeOf([(1,'A'), (null,'B')]); }
			query q15() { return _typeOf([(1,'A'), (2,null)]); }
			query q16() { return _typeOf([(1,'A'), (null,null)]); }
			query q(17) { return _typeOf([(null,'A'), (2,'B')]); }
			query q18() { return _typeOf([(1,null), (2,'B')]); }
			query q19() { return _typeOf([(null,null), (2,'B')]); }
			query q20() { return _typeOf([(1,'A'), (null,'B'), null]); }
			query q21() { return _typeOf([(1,'A'), (2,null), null]); }
			query q22() { return _typeOf([(1,'A'), (null,null), null]); }
			query q23() { return _typeOf([(null,'A'), (2,'B'), null]); }
			query q24() { return _typeOf([(1,null), (2,'B'), null]); }
			query q25() { return _typeOf([(null,null), (2,'B'), null]); }
		''')
	}
	
	@Test 
	def void testAccessToValues() {
		assertParsingTrue('''
			class c1 { name: text; }
			class c2 { name: text; c1; }
			class c3 { name: text; c2; }
			class c4 { name: text; c3; }
			query q() = ((c: c4) @ { 'c4_2' } ( t3 = .c3, t2 = .c3.c2 )).t2.c1.name ;
		''')
	}
	
	@Test 
	def void testFunctionInQuery() {
		assertParsingTrue('''
			function f(s: text, v: integer): integer {
			   print(s);
			   return v;
			}
			query q(a: boolean) = if (a) f('Yes', 123) else f('No', 456);
		''')
	}
	
	@Test 
	def void testAssignObjectToQuery() {
		assertParsingTrue('''
			object foo { x: integer = 123; }
			query q() = '' + foo ;		
		''')
	}
	
	@Test 
	def void testAssignObjectToFunction() {
		assertParsingTrue('''
			object foo { x: integer = 123; }
			function f(): integer = foo.x;
		''')
	}

	@Test // Exception caused by: java.lang.NullPointerException at org.blockchain.rell.scoping.RellScopeProvider.getVarDeclList
	def void testObjectInOperation() {
		assertParsingTrue('''
			object foo { mutable x: integer = 100; y: integer = 250; }
			operation o() { foo.x = 50; }
			operation o() { foo.x += 33; }
			operation o() { foo.x *= 55; }
		''')
	}
	
	@Test 
	def void testMicSubtypes1() {
		assertParsingTrue('''
			query q() { val x: (integer,text) = (123,'Hello'); val y: (integer?,text) = x; return y; }
			query q() { val x: (integer?,text) = (123,'Hello'); val y: (integer?,text) = x; return y; }
			query q() { val x: (integer?,text) = (null,'Hello'); val y: (integer?,text) = x; return y; }
			query q() { val x: (integer,text) = (123,'Hello'); val y: (integer,text?) = x; return y; }
			query q() { val x: (integer,text?) = (123,'Hello'); val y: (integer,text?) = x; return y; }
			query q() { val x: (integer,text?) = (123,null); val y: (integer,text?) = x; return y; }
			query q() { val x: (integer,text) = (123,'Hello'); val y: (integer?,text?) = x; return y; }
			query q() { val x: (integer?,text) = (123,'Hello'); val y: (integer?,text?) = x; return y; }
			query q() { val x: (integer?,text) = (null,'Hello'); val y: (integer?,text?) = x; return y; }
			query q() { val x: (integer,text?) = (123,'Hello'); val y: (integer?,text?) = x; return y; }
			query q() { val x: (integer,text?) = (123,null); val y: (integer?,text?) = x; return y; }
			query q() { val x: (integer?,text?) = (123,'Hello'); val y: (integer?,text?) = x; return y; }
			query q() { val x: (integer?,text?) = (null,'Hello'); val y: (integer?,text?) = x; return y; }
			query q() { val x: (integer?,text?) = (123,null); val y: (integer?,text?) = x; return y; }
			query q() { val x: (integer?,text?) = (null,null); val y: (integer?,text?) = x; return y; }
		''')
	}
	
	@Test 
	def void testMiscSubtypes2() {
		assertParsingTrue('''
			query q1() { val x: (a:integer)? = (a=123); return x?.a; }
			query q2() { val x: (a:integer)? = null; return x?.a; }
			query q3() { val x: (a:(b:(c:integer)?)?)? = (a=(b=(c=123))); return x?.a?.b?.c; }
			query q4() { val x: (a:(b:(c:integer)?)?)? = (a=(b=null)); return x?.a?.b?.c; }
			query q5() { val x: (a:(b:(c:integer)?)?)? = (a=null); return x?.a?.b?.c; }
			query q6() { val x: (a:(b:(c:integer)?)?)? = null; return x?.a?.b?.c; }
			query q7() { val x: (a:(b:(c:integer)))? = (a=(b=(c=123))); return x?.a?.b?.c; }
			query q8() { val x: (a:(b:(c:integer)))? = (a=(b=(c=123))); return _typeOf(x?.a); }
			query q9() { val x: (a:(b:(c:integer)))? = (a=(b=(c=123))); return _typeOf(x?.a?.b); }
			query q10() { val x: (a:(b:(c:integer)))? = (a=(b=(c=123))); return _typeOf(x?.a?.b?.c); }
			query q11() { val x: integer? = 123; return _typeOf(x); }
			query q12() { val x: integer? = 123; return _typeOf(x!!); }
			query q13() { val x: integer? = 123; return x!!; }
			query q14() { val x: integer? = null; return x!!; }
			query q15() { val x: integer? = 123; return x!!.hex(); }
			query q16() { val x: integer? = null; return x!!.hex(); }
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
