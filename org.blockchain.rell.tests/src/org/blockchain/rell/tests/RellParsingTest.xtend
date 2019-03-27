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

	

// Operations with Enum type
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



// check list equal operators ===, !==, ==, !=
	@Test
	def void testListReturnFromQueryOne() {
		assertParsingTrue('''
			query q1() { var x: list<list<text>>; x = [['Hello', 'World']]; return x; }
			query q2() { val a: list<integer>? = [1,2,3]; return a === null; }
			query q3() { val a: list<integer>? = [1,2,3]; return a !== null; }
			query q4() { val a: list<integer>? = [1,2,3]; return a === [1,2,3]; }
			query q5() { val a: list<integer>? = [1,2,3]; return a !== [1,2,3]; }
			query q6() { val a: list<integer>? = [1,2,3]; val b = a; return a === b; }
			query q7() { val a: list<integer>? = [1,2,3]; val b = a; return a !== b; }
			query q8() { val a: list<integer>? = null; return a === null; }
			query q9() { val a: list<integer>? = null; return a !== null; }
			query q10() { val a: list<integer>? = null; return a === [1,2,3]; }
			query q11() { val a: list<integer>? = null; return a !== [1,2,3]; }
			query q12() { val a = [1, 2, 3]; val b = [1, 2, 3]; return a == b; }
			query q13() { val a = [1, 2, 3]; val b = [1, 2, 3]; return a != b; }
			query q14() { val a = [1, 2, 3]; val b = [1, 2, 3]; return a === b; }
			query q15() { val a = [1, 2, 3]; val b = [1, 2, 3]; return a !== b; }
			query q16() { val a = [1, 2, 3]; val b = a; return a === b; }
			query q17() { val a = [1, 2, 3]; val b = a; return a !== b; }
		''')
	}




	@Test
	def void testInSet() {
		assertParsingTrue('''
			query q1() = 123 in set([123, 456]);
			query q2() = 456 in set([123, 456]);
			query q3() = 789 in set([123, 456]);
			query q4() = 123 in set<integer>();	
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


// check map methods
	@Test
	def void testMapMethods() {
		assertParsingTrue('''
			record foo { mutable x: integer; }
			query q1() { val x = map<integer,text?>(); x[123]=null; return ''+x;}
			query q2() = map<text,foo>() ;
			query q3() = map<text,integer>().calculate('Bob') ;
			query q4() = ['Bob':123,'Alice':456].calculate('Bob') ;
		''')
	}


	@Test
	def void testSetToListToSet() {
		assertParsingTrue('''
			query q1() { val x = set<integer>([123]); val y = list<integer?>(x); return ''+y; }
			query q2() { val x = set<integer?>([123]); val y = list<integer?>(x); return ''+y; }
			query q3() { val x = list<integer>([123]); val y = set<integer?>(x); return ''+y; }
			query q4() { val x = list<integer?>([123]); val y = set<integer?>(x); return ''+y; }
			query q5() { val x = set<integer>([123]); val y = set<integer?>(x); return ''+y; }
			query q6() { val x = set<integer?>([123]); val y = set<integer?>(x); return ''+y; }
		''')
	}


// check changing value by position in a set 
	@Test
	def void testSetUnderline() {
		assertParsingTrue('''
			query q1() { val x = [1, 2, 3]; val r = x._set(0, 5); return ''+r+' '+x; }
			query q2() { val x = [1, 2, 3]; val r = x._set(1, 5); return ''+r+' '+x; }
			query q3() { val x = [1, 2, 3]; val r = x._set(2, 5); return ''+r+' '+x; }
			query q4() { val x = [1, 2, 3]; val r = x._set(-1, 5); return ''+r+' '+x; }
			query q5() { val x = [1, 2, 3]; val r = x._set(3, 5); return ''+r+' '+x; }
		''')
	}

// check empty, len, size of set 
	@Test
	def void testSetEmptylenSize() {
		assertParsingTrue('''
			query q1() = set<integer>().empty() ;
			query q2() = set<integer>([1]).empty() ;
			query q3() = set<integer>([1, 2, 3, 4, 5]).empty() ;
			query q4() = set<integer>().size() ;
			query q5() = set([1]).size() ;
			query q6() = set([1, 2, 3, 4, 5]).size() ;
			query q7() = set([1, 2, 3, 2, 3, 4, 5]).size() ;
			query q8() = set<integer>().len() ;
			query q9() = set([1]).len() ;
			query q10() = set([1, 2, 3, 4, 5]).len() ;
			query q11() = set([1, 2, 3, 2, 3, 4, 5]).len() ;
			query q12() = 1 in set([1, 2, 3]) ;
			query q13() = 3 in set([1, 2, 3]) ;
			query q14() = 5 in set([1, 2, 3]) ;
		''')
	}


// check map type/sub-type
	@Test
	def void testMapTypeCompatible() {
		assertParsingTrue('''
			query q1() { val x = map<integer?,text>([123:'Hello']); return x[null];}
			query q2() { val x = map<integer?,text?>([123:'Hello']); return x[null];}
			query q3() { val x = map<integer,text>(); x[123]='Hello'; return ''+x;}
			query q4() { val x = map<integer?,text>(); x[123]='Hello'; return ''+x;}
			query q5() { val x = map<integer?,text>(); x[null]='Hello'; return ''+x;}
			query q6() { val x = map<integer,text>([123:'Hello']); val y = map<integer,text>(x); return ''+y; }
			query q7() { val x = map<integer,text>([123:'Hello']); val y = map<integer?,text>(x); return ''+y; }
			query q8() { val x = map<integer?,text>([123:'Hello']); val y = map<integer?,text>(x); return ''+y; }
			query q9() { val x = map<integer,text>([123:'Hello']); val y = map<integer,text?>(x); return ''+y; }
			query q10() { val x = map<integer,text?>([123:'Hello']); val y = map<integer,text?>(x); return ''+y; }
			query q11() { val x = map<integer,text>([123:'Hello']); val y = map<integer?,text?>(x); return ''+y; }
			query q12() { val x = map<integer?,text>([123:'Hello']); val y = map<integer?,text?>(x); return ''+y; }
			query q13() { val x = map<integer,text?>([123:'Hello']); val y = map<integer?,text?>(x); return ''+y; }
			query q14() { val x = map<integer?,text?>([123:'Hello']); val y = map<integer?,text?>(x); return ''+y; }
			query q15() { val x: map<integer,text> = map<integer,text>([123:'Hello']); return ''+x; }
		''')
	}

// check map put(), putAll() function
	@Test
	def void testMapTypePutAllCompatible() {
		assertParsingTrue('''
			query q1() { val x = map<integer?,text>([123:'Hello']); x.put(null,'World'); return x[null];}
			query q2() { val x = map<integer?,text?>([123:'Hello']); x.put(null,'World'); return x[null];}
			query q3() { val x = map<integer,text>(); x.put(123,'Hello'); return ''+x;}
			query q4() { val x = map<integer?,text>(); x.put(123,'Hello'); return ''+x;}
			query q5() { val x = map<integer?,text>(); x.put(null,'Hello'); return ''+x;}
			query q6() { val x = map<integer,text?>(); x.put(123,'Hello'); return ''+x;}
			query q7() { val x = map<integer,text?>(); x.put(123,null); return ''+x;}
			query q8() { val x = map<integer,text>(); x.putAll(map<integer,text>([123:'Hello'])); return ''+x;}
			query q9() { val x = map<integer?,text>(); x.putAll(map<integer,text>([123:'Hello'])); return ''+x;}
			query q10() { val x = map<integer?,text>(); x.putAll(map<integer?,text>([123:'Hello'])); return ''+x;}
			query q11() { val x = map<integer,text?>(); x.putAll(map<integer,text>([123:'Hello'])); return ''+x;}
			query q12() { val x = map<integer,text?>(); x.putAll(map<integer,text?>([123:'Hello'])); return ''+x;}
			query q13() { val x = map<integer?,text?>(); x.putAll(map<integer,text>([123:'Hello'])); return ''+x;}
			query q14() { val x = map<integer?,text?>(); x.putAll(map<integer?,text>([123:'Hello'])); return ''+x;}
			query q15() { val x = map<integer?,text?>(); x.putAll(map<integer,text?>([123:'Hello'])); return ''+x;}
			query q16() { val x = map<integer?,text?>(); x.putAll(map<integer?,text?>([123:'Hello'])); return ''+x;}
		''')
	}

// check map str() function
	@Test
	def void testMapStr() {
		assertParsingTrue('''
			query q1() = map<text,integer>().str() ;
			query q2() = ['Bob':123].str() ;
			query q3() = ['Bob':123,'Alice':456,'Trudy':789].str() ;
			query q4() { val x = ['Bob':123,'Alice':456]; x.put('Trudy',555); return x.str(); }
		''')
	}

// check map keys() function
	@Test
	def void testMapKeys() {
		assertParsingTrue('''
			query q1() = map<text,integer>().keys() ;
			query q2() = ['Bob':123].keys() ;
			query q3() = ['Bob':123,'Alice':456,'Trudy':789].keys() ;
			query q4() { val x = ['Bob':123,'Alice':456]; x.keys().remove('Bob'); return ''+x; }
			query q5() { val x = ['Bob':123,'Alice':456]; x.keys().clear(); return ''+x; }
			query q6() { val x = ['Bob':123,'Alice':456]; x.keys().add('Trudy'); return ''+x; }
		''')
	}

// check map values() function
	@Test
	def void testMapValues() {
		assertParsingTrue('''
			query q1() = ['Bob':123].values() ;
			query q2() = ['Bob':123,'Alice':456,'Trudy':789].values() ;
			query q3() { val x = ['Bob':123,'Alice':456]; x.values().clear(); return ''+x; }
			query q4() { val x = ['Bob':123,'Alice':456]; val v = x.values(); x.clear(); return ''+x+' '+v; }
		''')
	}

// check 'in' map
	@Test
	def void testMapIn() {
		assertParsingTrue('''
			query q1() = 'Bob' in map<text,integer>() ;
			query q2() = 'Bob' in ['Bob':123] ;
			query q3() = 'Alice' in ['Bob':123] ;
			query q4() = 'Bob' in ['Bob':123,'Alice':456] ;
			query q5() = 'Alice' in ['Bob':123,'Alice':456] ;
			query q6() = 'Trudy' in ['Bob':123,'Alice':456] ;
		''')
	}

// check map
	@Test
	def void testMap() {
		assertParsingTrue('''
			query q1() = ['Bob':123]['Bob'] ;
			query q2() = ['Bob':123]['Alice'] ;
			query q3() = ['Bob':123,'Alice':456]['Bob'] ;
			query q4() = ['Bob':123,'Alice':456]['Alice'] ;
			query q5() = ['Bob':123,'Alice':456]['Trudy'] ;
			query q6() = map(['Bob':123])['Bob'] ;
			query q7() = map(['Bob':123])['Alice'] ;
			query q8() = map(['Bob':123,'Alice':456])['Bob'] ;
			query q9() = map(['Bob':123,'Alice':456])['Alice'] ;
			query q10() = map(['Bob':123,'Alice':456])['Trudy'] ;
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

// check map with record
	@Test
	def void testMapWithRecord() {
		assertParsingTrue('''
			record foo1 { mutable x: integer; }
			record foo2 { x: text; b: bar; } record bar { p: integer; q: integer; }
			query q1() = [ 'Hello' : foo1(123) ];
			query q2() = [foo1(123)] ;
			query q3() = map<text,foo1>();
			query q4() { var m = [foo2('ABC', bar(p=123,q=456)) : 'X']; return m[foo2('ABC', bar(p=123,q=456))]; }
			query q5() { var s = set([foo2('ABC', bar(p=123,q=456))]); return s; }
			query q6() { var s = set([foo2('ABC', bar(p=123,q=456))]); return s.contains(foo2('ABC',bar(p=123,q=456))); }
			query q7() { var m = [foo2('ABC', bar(p=123,q=456)) : 'X']; return m[foo2('DEF', bar(p=123,q=456))]; }
		''')
	}

// check map with function 
	@Test
	def void testMapWithFunction() {
		assertParsingTrue('''
			function f1() : map<integer,text>? = null;
			function f2() : map<integer,text>? = [123:'Hello',456:'World'];
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
