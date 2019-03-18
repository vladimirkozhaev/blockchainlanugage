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

	

// Update object
	@Test
	def void testObjectUpdateOperation() {
		assertParsingTrue('''
			object obj {
			    k : pubkey = x'e04fd020ea3a6910a2d808002b30309d';
			    mutable value : integer = 0;
			    mutable text : text = 'text';
			    mutable active : boolean = true; 
			}
			operation op_obj() { update obj (value *= 2, text = 'new text', active = false);}
		''')
	}

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










// check alias in at-expression in update statement !ERROR (4:29) Syntax error
	@Test
	def void testUpdateOperationAliasWithAssignFromAt() {
		assertParsingTrue('''
			class country { name: text; }
			class city { name: text; country; }
			class person { name: text; homeCity: city; workCity: city; mutable score: integer; }
			operation o() { update (p1: person, p2: person) @ { p1.homeCity == p2.workCity } ( score = p1.score * 3 + p2.score ); }
		''')
	}





// check query short form
//	@Test
	def void testQueryShortForm() {
		assertParsingTrue('''
			query q(x: integer): integer = x * x;
		''')
	}

// check query full from
//	@Test
	def void testQueryFullForm() {
		assertParsingTrue('''
			query q(x: integer): integer { return x * x; }
		''')
	}

// check return record from query
//	@Test
	def void testReturnRecordWithinQuery() {
		assertParsingTrue('''
			record foo { i: integer; s: text; q: text = 'test'; }
			query q() { val s = 'Hello'; val q = 'Bye'; return foo(i = 123, q, s); }
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

// check list addAll, removeAll, containsAll
//	@Test
	def void testListaddAllremoveAllcontainsAll() {
		assertParsingTrue('''
			query q1() { val x = list<integer?>(); x.addAll(list<integer>([123])); return ''+x; }
			query q2() { val x = list<integer?>(); x.addAll(list<integer?>([123,null])); return ''+x; }
			query q3() { val x = list<integer>([123,456]); x.removeAll(list<integer>([123])); return ''+x; }
			query q4() { val x = list<integer?>([123,456,null]); x.removeAll(list<integer>([123])); return ''+x; }
			query q5() { val x = list<integer?>([123,456,null]); x.removeAll(list<integer?>([123,null])); return ''+x; }
			query q6() { val x = list<integer>([123,456]); return x.containsAll(list<integer>([123])); }
			query q7() { val x = list<integer?>([123,456,null]); return x.containsAll(list<integer>([123])); }
			query q8() { val x = list<integer?>([123,456,null]); return x.containsAll(list<integer?>([123,null])); }
		''')
	}



// check list calculate
//	@Test
	def void testListCalculate() {
		assertParsingTrue('''
			query q1() = list([1, 2, 3, 4, 5]).calculate(0) ;
			query q2() = list([1, 2, 3, 4, 5]).calculate(4) ;
			query q3() = list([1, 2, 3, 4, 5]).calculate(-1) ;
			query q4() = list([1, 2, 3, 4, 5]).calculate(5) ;
			query q5() = [1, 2, 3, 4, 5].calculate(0) ;
			query q6() = [1, 2, 3, 4, 5].calculate(4) ;
			query q7() = [1, 2, 3, 4, 5].calculate(-1) ;
			query q8() = [1, 2, 3, 4, 5].calculate(5) ;
		''')
	}

// check list clear, empty
//	@Test
	def void testListClearEmpty() {
		assertParsingTrue('''
			query q1() { val x = [1, 2, 3]; x.clear(); return x; }
			query q2() = list<integer>().empty() ;
			query q3() = list<integer>([1]).empty() ;
			query q4() = list<integer>([1, 2, 3, 4, 5]).empty() ;
		''')
	}

//	@Test
	def void testListSizeLen() {
		assertParsingTrue('''
			query q1() = list<integer>().size() ;
			query q2() = list([1]).size() ;
			query q3() = list([1, 2, 3, 4, 5]).size() ;
			query q4() = list<integer>().size() ;
			query q5() = list([1]).size() ;
			query q6() = list([1, 2, 3, 4, 5]).size() ;
		''')
	}

// check list from set
//	@Test
	def void testListFromSet() {
		assertParsingTrue('''
			query q1() = list<integer>(list<integer>()) ;
			query q2() = list<integer>(set<integer>()) ;
			query q3() = list<integer?>(list<integer>()) ;
			query q4() = list<integer?>(list<integer?>()) ;
			query q5() = list<integer?>(set<integer>()) ;
			query q6() = list<integer?>(set<integer?>()) ;
		''')
	}

// check list with records
	@Test
	def void testListWithRecords() {
		assertParsingTrue('''
			record foo { x: integer; b: list<bar>; } record bar { s: list<text>; q: boolean; }
			query q1() { val f = foo(123, [bar(['Hello'], true)]); return f == foo(123, [bar(['Hello'], true)]); }
			query q2() { val l = ['Hello']; val f = foo(123, [bar(l, true)]);
			                l.add('Bye');
			                return f == foo(123, [bar(['Hello'], true)]); }
		''')
	}

// check simple create of set
//	@Test
	def void testCreateSet() {
		assertParsingTrue('''
			query q1() = set<integer>() ;
			query q2() = set([123]) ;
			query q3() = set([123, 456, 789]) ;
			query q4() = set([1, 2, 3, 2, 3, 4, 5]) ;
			query q5() = set(list([123, 456, 789])) ;
		''')
	}

// check create set from list, set
//	@Test
	def void testCreateSetFromListSet() {
		assertParsingTrue('''
			query q1() = set<integer>(list<integer>());
			query q2() = set<integer>(set<integer>());
			query q3() = set<integer?>(list<integer>());
			query q4() = set<integer?>(list<integer?>());
			query q5() = set<integer?>(set<integer>());
			query q6() = set<integer?>(set<integer?>());
		''')
	}

// check equals of set 
//	@Test
	def void testSetEqualsOperator() {
		assertParsingTrue('''
			query q1() { val a = set([1, 2, 3]); val b = set([1, 2, 3]); return a == b; }
			query q2() { val a = set([1, 2, 3]); val b = set([1, 2, 3]); return a != b; }
			query q3() { val a = set([1, 2, 3]); val b = set([1, 2, 3]); return a === b; }
			query q4() { val a = set([1, 2, 3]); val b = set([1, 2, 3]); return a !== b; }
			query q5() { val a = set([1, 2, 3]); val b = a; return a === b; }
			query q6() { val a = set([1, 2, 3]); val b = a; return a !== b; }
		''')
	}

// check 'in' set 
//	@Test
	def void testSetMethods() {
		assertParsingTrue('''
			query q1() = set<integer>().str() ;
			query q2() = set<integer>([1]).str() ;
			query q3() = set<integer>([1, 2, 3, 4, 5]).str() ;
			query q4() { val x = set<integer?>(); x.add(null); return ''+x; }
			query q5() { val x = set<integer?>(); x.add(123); return ''+x; } 
			query q6() { val x = set<integer?>([123,456,null]); x.removeAll(set<integer>([123])); return ''+x; }
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

// check contains, containsAll set 
//	@Test
	def void testSetContains() {
		assertParsingTrue('''
			query q1() { val x = set<integer>([123]); return x.contains(123); }
			query q2() { val x = set<integer?>([123]); return x.contains(null); }
			query q3() { val x = set<integer?>([123]); x.add(null); return x.contains(null); }
			query q4() = set([1, 2, 3]).contains(1) ;
			query q5() = set([1, 2, 3]).contains(3) ;
			query q6() = set([1, 2, 3]).contains(5) ;
			query q7() { val x = set<integer?>([123]); return x.contains(123); }
			query q8() = list<integer>().containsAll(set<integer>()) ;
			query q9() = [1, 2, 3].containsAll(set([1, 2, 3])) ;
			query q10() = [1, 2, 3].containsAll(set([0])) ;
			query q11() = [1, 2, 3].containsAll(set([2])) ;
			query q12() = set<integer>().containsAll(list<integer>()) ;
			query q13() = set<integer>().containsAll(set<integer>()) ;
			query q14() = set<integer>([1, 2, 3]).containsAll([1, 2, 3]) ;
			query q15() = set<integer>([1, 2, 3]).containsAll(set([1, 2, 3])) ;
			query q16() = set<integer>([1, 2, 3]).containsAll([0]) ;
			query q17() = set<integer>([1, 2, 3]).containsAll([2]) ;
			query q18() = set<integer>([1, 2, 3]).containsAll(set([0])) ;
			query q19() = set<integer>([1, 2, 3]).containsAll(set([2])) ;
			query q20() = set<integer>([1, 2, 3]).containsAll([1, 3]) ;
			query q21() = set<integer>([1, 2, 3]).containsAll([0, 1]) ;
			query q22() = set<integer>([1, 2, 3]).containsAll([1, 2, 3, 4]) ;
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

// check remove, removeAll set 
//	@Test
	def void testSetRemove() {
		assertParsingTrue('''
			query q1() { val x = set([1, 2, 3]); val r = x.remove(1); return ''+r+' '+x; }
			query q2() { val x = set([1, 2, 3]); val r = x.remove(2); return ''+r+' '+x; }
			query q3() { val x = set([1, 2, 3]); val r = x.remove(3); return ''+r+' '+x; }
			query q4() { val x = set([1, 2, 3]); val r = x.remove(0); return ''+r+' '+x; }
			query q5() { val x = set([1, 2, 3]); val r = x.removeAll(set([0])); return ''+r+' '+x; }
			query q6() { val x = set([1, 2, 3]); val r = x.removeAll(set([1])); return ''+r+' '+x; }
			query q7() { val x = set([1, 2, 3]); val r = x.removeAll(set([2])); return ''+r+' '+x; }
			query q8() { val x = set([1, 2, 3]); val r = x.removeAll(set([3])); return ''+r+' '+x; }
			query q9() { val x = set([1, 2, 3]); val r = x.removeAll([0]); return ''+r+' '+x; }
			query q10() { val x = set([1, 2, 3]); val r = x.removeAll([2]); return ''+r+' '+x; }
			query q11() { val x = set([1, 2, 3]); val r = x.removeAll([1, 2, 3]); return ''+r+' '+x; }
			query q12() { val x = set([1, 2, 3]); val r = x.removeAll([1, 3]); return ''+r+' '+x; }
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

//	@Test
	def void testListCreation() {
		assertParsingTrue(
			'''
				class TestClass{
					test:integer;
				}
				
				operation t1(){
					val t:list<integer> = [1,2,3];
				}
			'''
		)
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

// check set with records
//	@Test
	def void testSetWithRecords() {
		assertParsingTrue('''
			record foo1 { x: list<set<(a: text, b: integer)>>; }
			record foo2 { x: list<set<(q: text, integer)>>; }
			record bar { p: integer; q: integer; }
			record foo3 { x: text; b: bar; } 
			record foo4 { x: integer; }
			query q1() { var s = set([foo3('ABC', bar(p=123,q=456))]); return s; }
			query q2() { var s = set([foo3('ABC', bar(p=123,q=456))]); return s.contains(foo3('ABC',bar(p=123,q=456))); } 
			query q3() { var s = set([foo4(123)]); return s; }
		''')
	}

//	@Test
	def void testMethodCall() {
		assertParsingTrue('''operation o(){
			val s=set<integer>([123]);
			val isContains=s.contains(1);
		}
		''')
	}

	// check set with records
	// @Test
	def void testSetMethodsCall() {
		assertParsingTrue('''
			record foo1 { x: list<set<(a: text, b: integer)>>; }
			record foo2 { x: list<set<(q: text, integer)>>; }
			record bar { p: integer; q: integer; }
			record foo3 { x: text; b: bar; } 
			record foo4 { x: integer; }
			query q1() { var s = set([foo3('ABC', bar(p=123,q=456))]); return s; }
			query q2() { var s = set([foo3('ABC', bar(p=123,q=456))]); return s.contains(foo3('ABC',bar(p=123,q=456))); } 
			query q3() { var s = set([foo4(123)]); return s; }
		''')
	}

//	@Test
	def void testTheRecordType() {
		assertParsingTrue('''		
			record bar { p: integer; q: integer; }
			query q1() { var s:bar; return s; }
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

// check set requireNotEmpty
//	@Test
	def void testSetRequireNotEmpty() {
		assertParsingTrue('''
			query q1() { val x = set<integer>(); return requireNotEmpty(x); }
			query q2() { val x = set([123]); return requireNotEmpty(x); }
			query q3() { val x: set<integer>? = null; return requireNotEmpty(x); }
			query q4() { val x: set<integer>? = set<integer>(); return requireNotEmpty(x); }
			query q5() { val x: set<integer>? = set([123]); return requireNotEmpty(x); }
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

// check map clear() function
//	@Test
	def void testMapClear() {
		assertParsingTrue('''
			query q() { val x = ['Bob':123,'Alice':567,'Trudy':789]; x.clear(); return x; }
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

// check map contains() function
//	@Test
	def void testMapContains() {
		assertParsingTrue('''
			query q1() = ['Bob':123].contains('Bob') ;
			query q2() = ['Bob':123].contains('Alice') ;
			query q3() = ['Bob':123,'Alice':456].contains('Bob') ;
			query q4() = ['Bob':123,'Alice':456].contains('Alice') ;
			query q5() = ['Bob':123,'Alice':456].contains('Trudy') ;
		''')
	}

// check '==' map
//	@Test
	def void testMapEquals() {
		assertParsingTrue('''
			query q1() = ['Bob':123,'Alice':456,'Trudy':789] == ['Bob':123,'Alice':456,'Trudy':789] ;
			query q2() = ['Bob':123,'Alice':456,'Trudy':789] == ['Bob':321,'Alice':654,'Trudy':987] ;
			query q3() = ['Bob':123,'Alice':456,'Trudy':789] == ['Bob':123,'Alice':456] ;
			query q4() = ['Bob':123,'Alice':456,'Trudy':789] == ['Bob':123,'Alice':456,'Trudy':789,'Satoshi':555] ;
			query q5() = ['Bob':123,'Alice':456,'Trudy':789] == map<text,integer>() ;		
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

// check simple declaration of function (short form)
	@Test
	def void testShortFunctionDeclaration() {
		assertParsingTrue('''
			function f(x: integer): integer = x * x;
		''')
	}

// check simple declaration of function (full form)
	@Test
	def void testFullFunctionDeclaration() {
		assertParsingTrue('''
			function f(x: integer): integer {
			    return x * x;
			}
		''')
	}

// check call function from another function
	@Test
	def void testCallFunctionFromFunction() {
		assertParsingTrue('''
			function f1() : integer = f2();
			
			function f2() : integer {
			    val b = 2;			    
			    return b * 2;
			}
		''')
	}

// check update statement in function
	@Test
	def void testUpdateStatementInFunction() {
		assertParsingTrue('''
			class user { name: text; mutable score: integer; }
			function f(name: text, s: integer): integer { update user @ { name } ( score += s ); return s; } query q() = f('Bob', 500) ;
		''')
	}

//	@Test
	def void testCreateInOperation() {
		assertParsingTrue('''
			class user { key pubkey; index username: text; firstName: text; lastName: text; email: text; }
			    operation add_user (admin_pubkey: integer, pubkey, username: text, firstName: text, lastName: text, email: text) {
			           create user (pubkey, username, firstName, lastName, email);
			    }
		''')
	}

// check logical, arithmetical, comparison operators
	@Test
	def void testDefaultVariableName() {
		assertParsingTrue('''
			class company { name: text; }
			class user { name: text; company; }
			class optest {
			                    b1: boolean; b2: boolean;
			                    i1: integer; i2: integer;
			                    t1: text; t2: text;
			                    ba1: byte_array; ba2: byte_array;
			                    j1: json; j2: json;
			                    user1: user; user2: user;
			                    company1: company; company2: company;
			}
			query q1() = optest @ {} ( .b1 and .b2 );
			query q2() = optest @ {} ( .i1 / .i2 );
			query q3() = optest @ {} ( .i1 % .i2 );
			query q4() = optest @ {} ( .i1 * .i2 );
			query q5() = optest @* { not .b1 };
			query q6() = optest @ {} ( not .b1 );
			query q7() = optest @ {} ( .i1 - .i2 );
			query q8() = optest @ {} ( - .i1 );
			query q9() = optest @* { .i1 == .i2 };
			query q10() = optest @ {} ( .i1 == .i2 );
			query q11() = optest @* { .i1 != .i2 };
			query q12() = optest @ {} ( .i1 != .i2 );
			query q13() = optest @* { .i1 < .i2 };
			query q14() = optest @ {} ( .i1 < .i2 );
			query q15() = optest @* { .i1 <= .i2 };
			query q16() = optest @ {} ( .i1 <= .i2 );
			query q17() = optest @* { .i1 > .i2 };
			query q18() = optest @ {} ( .i1 > .i2 );
			query q19() = optest @* { .i1 >= .i2 };
			query q20() = optest @ {} ( .i1 >= .i2 );
			query q21() = optest @ {} ( .i1 + .i2 );
			query q22() = optest @ {} ( .t1 + .t2 );
			query q23() = optest @ {} ( .ba1 + .ba2 );
			query q24() = optest @ {} ( + .i1 );
			query q25() = optest @ {} ( .b1 + .t2 );
			query q26() = optest @ {} ( .t1 + .b2 );
			query q27() = optest @ {} ( .i1 + .t2 );
			query q28() = optest @ {} ( .t1 + .i2 );
			query q29() = optest @ {} ( .j1 + .t2 );
			query q30() = optest @ {} ( .t1 + .j2 );
			query q31() = optest @* { .b1 or .b2 };
			query q32() = optest @ {} ( .b1 or .b2 );
			query q33() = optest @ {} ( abs(.i1) );
			query q34() = optest @ {} ( min(.i1, .i2) );
			query q35() = optest @ {} ( max(.i1, .i2) );
			query q36() = optest @ {} ( .t1.len() );
			query q37() = optest @ {} ( .ba1.len() );
			query q38() = optest @* { .t1 == .t2 };
			query q39() = optest @ {} ( .t1 == .t2 );
			query q40() = optest @* { .t1 != .t2 };
			query q41() = optest @ {} ( .t1 != .t2 );
			query q42() = optest @* { .t1 < .t2 };
			query q43() = optest @ {} ( .t1 < .t2 );
			query q44() = optest @* { .t1 <= .t2 };
			query q45() = optest @ {} ( .t1 <= .t2 );
			query q46() = optest @* { .t1 > .t2 };
			query q47() = optest @ {} ( .t1 > .t2 );
			query q48() = optest @* { .t1 >= .t2 };
			query q49() = optest @ {} ( .t1 >= .t2 );
			query q50() = optest @* { .b1 == .b2 };
			query q51() = optest @ {} ( .b1 == .b2 );
			query q52() = optest @* { .b1 != .b2 };
			query q53() = optest @ {} ( .b1 != .b2 );
			query q54() = optest @ {} ( json(.t1) );
			query q55() = optest @ {} ( .j1.str() );
			query q56() = optest @* { .user1 == .user2 };
			query q57() = optest @ {} ( .user1 == .user2 );
			query q58() = optest @* { .user1 != .user2 };
			query q59() = optest @ {} ( .user1 != .user2 );
			query q60() = optest @* { .user1 < .user2 };
			query q61() = optest @ {} ( .user1 < .user2 );
			query q62() = optest @* { .user1 <= .user2 };
			query q63() = optest @ {} ( .user1 <= .user2 );
			query q64() = optest @* { .user1 > .user2 };
			query q65() = optest @ {} ( .user1 > .user2 );
			query q66() = optest @* { .user1 >= .user2 };
			query q67() = optest @ {} ( .user1 >= .user2 );
			query q68() = optest @ {} ( .ba1 == .ba2 );
			query q69() = optest @* { .ba1 != .ba2 };
			query q70() = optest @ {} ( .ba1 != .ba2 );
			query q71() = optest @* { .ba1 < .ba2 };
			query q72() = optest @ {} ( .ba1 < .ba2 );
			query q73() = optest @* { .ba1 <= .ba2 };
			query q74() = optest @ {} ( .ba1 <= .ba2 );
			query q75() = optest @* { .ba1 > .ba2 };
			query q76() = optest @ {} ( .ba1 > .ba2 );
			query q77() = optest @* { .ba1 >= .ba2 };
			query q78() = optest @ {} ( .ba1 >= .ba2 );
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
