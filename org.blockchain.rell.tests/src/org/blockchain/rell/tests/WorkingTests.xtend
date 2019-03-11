/*
 * generated by Xtext 2.14.0
 */
package org.blockchain.rell.tests

import javax.inject.Inject
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
class WorkingTests {
	@Inject extension ParseHelper<Model> parseHelper
	@Inject extension ValidationTestHelper




// Check operation parameters
	@Test
	def void testOperationMustProvideParameters() {
		assertParsingTrue('''
			class test {a: text; b: text; c : text; key a; index b; }
			operation createTest(aParameter : text, bParameter : text, cParameter : text) {
			    create test(a=aParameter, b=bParameter, c=cParameter);
			}
		''')
	}
// Create statement
	@Test
	def void testCreate1() {
		assertParsingTrue('''
			class country { name: text; }
			class city { name: text; country; }
			class person { name: text; homeCity: city; workCity: city; mutable score: integer; }
			operation o() { create city('London', country @ { 'England' }); }
		''')
	}

// check simple update operation (short expression to access to class members)
	@Test
	def void testUpdateOperationShortAccess() {
		assertParsingTrue('''
			class foo { key k: integer; mutable name; }
			operation op() {
			    update foo @{.k == 122 }(name = "new_name");    
			}
		''')
	}
	
	// check pass val variable to where part of at expression 
	@Test
	def void testUpdateOperationValInWherePart() {
		assertParsingTrue('''
			class foo { key k: integer; mutable name; }
			operation op() {
			 val k = 122;
			  update foo @{.k == 122}(name = "new_name");    
			}
		''')
	}

// Create statement
	@Test
	def void testCreateCase1() {
		assertParsingTrue('''
			class country { name: text; }
			class city { name: text; country; }
			class person { name: text; homeCity: city; workCity: city; mutable score: integer; }
			operation o() { create person('John', homeCity = city @ { 'New York' }, workCity = city @ { 'London' }, score = 100); }
		''')

	}

// Create statement
	@Test
	def void testCreateCase2() {
		assertParsingTrue('''
			class country { name: text; }
			class city { name: text; country; }
			class person { name: text; homeCity: city; workCity: city; mutable score: integer; }
			operation o() { create person('John', homeCity = city @ { 'New York' }, workCity = city @ { 'London' }, score = 100); }
		''')

	}

// Create statement
	@Test
	def void testCreateCase3() {
		assertParsingTrue('''
			class default_score { mutable value: integer; }
			class person { name: text; score: integer = default_score@{}.value; }
		''')
	}


// check map empty() function
	@Test
	def void testMapEmpty() {
		assertParsingTrue('''
			query q1() = map<text,integer>().empty() ;
			query q2() = ['Bob':123].empty() ;
			query q3() = ['Bob':123,'Alice':456].empty() ;
		''')
	}


// check assign value from at-expression in update statement
	@Test
	def void testAssesToVariableFromSelect() {
		assertParsingTrue('''
			class default_score { name : text; value: integer; }
			class person { name: text; mutable score: integer = default_score@{}.value; }
		''')
	}

// Test at in the dot value
	@Test
	def void testAtInTheDotValue() {
		assertParsingTrue(''' 
			class version { id : pubkey; value: integer; }
			operation O(){
				val version : integer = version@{.id == x'0123abcd'}.value;
			}
		''')
	}
	
// Check default attribute value via at-operator that return value by member access
	@Test
	def void testDefAttribValWithAtOperatorReturnMemberAccess() {
		assertParsingTrue(''' 
			class version { id : pubkey; value: integer; }
			class model { name: text; version : integer = version@{.id == x'0123abcd'}.value; }
		''')
	}

	// Check a tuple of two values from at expression with condition 
	@Test
	def void testOneChainTuple() {
		assertParsingTrue('''
			class company { name;  type : integer;}
			operation op() {
			    val u = company @ { .name == 'Bob' } ( .name, .type );
			}
		''')
	}
	
	// Check initialization byte_array
	@Test
	def void testInitValueToByteArray() {
		assertParsingTrue('''
			class foo {
			    ba : byte_array = x"0373599a61cc6b3bc02a78c34313e1737ae9cfd56b9bb24360b437d469efdf3b15";
			}		
		''')
	}

	// Check initialization pubkey
	@Test
	def void testInitValueToPubkey() {
		assertParsingTrue('''
			class foo {
			    pb : pubkey = x"0373599a61cc6b3bc02a78c34313e1737ae9cfd56b9bb24360b437d469efdf3b15";
			}		
		''')
	}

	// Check create tuple with named fields and two values 
	@Test
	def void testCreateSimpleTupleTwoValues() {
		assertParsingTrue('''
			operation op() {
				 val test_tuple: (text, integer)  = ("Bill", 38);
			}
		''')
	}

	// Check create tuple with named fields and two values 
	@Test
	def void testCreateSimpleNamedTupleTwoValues() {
		assertParsingTrue('''
			operation op() {
				 val test_tuple: (name:text, age:integer)  = (name="John", age=18);
			}
		''')
	}

	// Check create nested tuple 
	@Test
	def void testCreateNestedTuple() {
		assertParsingTrue('''
			operation op() {
					 val test_tuple: (text, (integer, boolean))  = ("Bill", (38, true));
			}
		''')
	}

	// Check create named nested tuple 
	@Test
	def void testCreateNamedNestedTuple() {
		assertParsingTrue('''
			operation op() {
					 val test_tuple: (name: text, (age : integer, active : boolean))  = (name = "Bill", (age = 38, active = true));
			}
		''')
	}

	// Check return a tuple of two values from at expression
	@Test
	def void testNestedTupleTwoTypesWithTypeSpecification() {
		assertParsingTrue('''
			class company { name:name; address : name; type : integer;}
			class user { name,company:company; }
			operation op() {
			    val u = user @ { .name == 'Bob' } ( .company.name, .company.address );
			}
		''')
	}



	// Check return a tuple of two values from at expression without condition
	@Test
	def void testOneChainTupleWithoutCondition() {
		assertParsingTrue('''
			class company { name;  type : integer;}
			operation op() {
			    val u = company @ {} ( .name, .type );
			}
		''')
	}

	// Check at operator
	@Test
	def void testAtOperator() {
		assertParsingTrue('''
			class company { name;  type : integer;}
			operation op() {
			    val u = company @ { .name == 'Bob' };
			}
		''')
	}

	// Check index attribute 
	@Test
	def void testIndexWithAttributeDefinition() {
		assertParsingTrue(''' 
			class test { index testIndex : text; }
		''')
	}

	// Check default values for attribute
	@Test
	def void testDefaultAttributeValue() {
		assertParsingTrue(''' 
			class test { testText: text = 'test_text'; }
		''')
	}

	// Check set default attribute value via at-operator 
	@Test
	def void testDefaultAttributeValueWithAtOperator() {
		assertParsingTrue(''' 
			class version { id : pubkey; value: integer; }
			class model { name: text; version: version = version@{}; }
		''')
	}

	// Check set default attribute value via at-operator with 'where' part
	@Test
	def void testDefaultAttributeValueWithAtOperatorWherePart() {
		assertParsingTrue(''' 
			class version { id : pubkey; value: integer; }
			class model { name: text; version: version = version@{.id == x'0123abcd'};}
		''')
	}

	// Check that a class can have the 'key' clause after an attribute definition
	@Test
	def void testKeyAfterAttributeDefinition() {
		assertParsingTrue(''' 
			class test { testKey : text; key testKey; }
		''')
	}

	// Check that a class can have the 'key' clause with an attribute definition	
	@Test
	def void testKeyWithAttributeDefinition() {
		assertParsingTrue(''' 
			class test {
				key testKey : text;
			}
		''')
	}

	// Check that a class can have the composite "key" clause with multiple attributes in definition
	@Test
	def void testCompositeKeyWithAttributeDefinition() {
		assertParsingTrue('''
			class test {
				key firstField : text, secondField : text;
			}	
		''')
	}

	// Check that a class can have the 'index' clause after an attribute definition
	@Test
	def void testIndexAfterAttributeDefinition() {
		assertParsingTrue(''' 
			class test { testIndex : text; index testIndex; }
		''')
	}

	// Check that a class can have the 'index' clause with an attribute definition
	@Test
	def void testIndexWihAttributeDefiniton() {
		assertParsingTrue(''' 
			class test { index testIndex : text; }
		''')
	}

	// Check that a class can have the composite "index" clause with multiple attributes in definition
	@Test
	def void testCompositeIndexWithAttributeDefinition() {
		assertParsingTrue('''
			class test { index firstField : text, secondField : text; }
		''')
	}

	// Check that a class can have the composite composite "index" clause with multiple attributes after their definition
	@Test
	def void testCompositeIndexAfterAttributeDefinition() {
		assertParsingTrue('''
			class test { firstField : text; secondField : text; index firstField, secondField; }
		''')
	}

	// Check an attribute, that has reference type to a class, as index clause	
	@Test
	def void testIndexOnAttributeWithRefType() {
		assertParsingTrue('''
			class test1 {}
			class test2 { index attrTest1 : test1; }
		''')
	}

	// Check the 'mutable' keyword to an attribute	
	@Test
	def void testMutableToAttribute() {
		assertParsingTrue('''
			class test {
				mutable firstField : text;
			}	
		''')
	}

	// Check creating the object of a class within 'operation' 	
	@Test
	def void testCreateObjectWithinOperation() {
		assertParsingTrue('''
			class test {a: text; b: text; c : text; key a; index b; }
			operation createTest() {
			    create test(a = 'akey', b = 'btext', c = 'ctext');
			}	
		''')
	}

	// Check assign a value of returning 'create' statement to 'val' within 'operation'	
	@Test
	def void testAssignValueFromCreateStatment() {
		assertParsingTrue('''
			class test {a: text; b: text; c : text; key a; index b; }
			operation createTest() {
			   val newTest =  create test(a = 'akey', b = 'btext', c = 'ctext');
			}
		''')
	}

	// Check creating the object of a class with default values of attributes within 'operation' 	
	@Test
	def void testCreateObjectDefaultValuesWithinOperation() {
		assertParsingTrue('''
			class test {a: text='akey'; b: text='btext'; c : text='ctext'; key a; index b; }
			operation createTest() {
			    create test();
			}
		''')
	}

	// Check '@'(exactly one) cardinality with Where-part '{}'
	@Test
	def void testExactlyOneCardinalityWherePart() {
		assertParsingTrue('''
			class test {field: text; key field; }
			operation o() { 
			    val t = test @ {.field == 'some_text'};
			}
		''')
	}

	// Check '@*'(zero or more) cardinality with Where-part '{}'
	@Test
	def void testZeroOrMoreCardinalityWherePart() {
		assertParsingTrue('''
			class test {field: text; key field; }
			operation o() { 
			    val t = test @* {.field == 'some_text'};
			}
		''')
	}

	@Test
	def void testVarAndValOperation() {
		assertParsingTrue('''
			operation o() { val x = 1; var y = 1; }
		''')
	}

	// Check '@*'(zero or one, fails if more than one found) cardinality with Where-part '{}'
	@Test
	def void testZeroOrMoreFailCardinalityWherePart() {
		assertParsingTrue('''
			class test {field: text; key field; }
			operation o() { 
			    val t = test @? {.field == 'some_text'};
			}
		''')
	}

	// Check '@*'(one or more) cardinality with Where-part '{}'
	@Test
	def void testOneOrMoreCardinalityWherePart() {
		assertParsingTrue('''
			class test {field: text; key field; }
			operation o() { 
			    val t = test @+ {.field == 'some_text'};
			}
		''')
	}

	// check create new object with explicit attributes initialization in 'create' statement
	@Test
	def void testCreateStatementWithExplicitAttributeInit() {
		assertParsingTrue('''
			class foo { id : integer; name : text; }
			operation op() {
				create foo(id = 1, name = 'test');
				create foo(name = 'test', id = 1);
			}
		''')
	}

	// check create new object with implicit attributes initialization in 'create' statement
	@Test
	def void testCreateStatementWithImplicitAttributeInit() {
		assertParsingTrue('''
			class foo { id : integer; name1 : text; }
			operation op() {
				create foo(1,'test');
			}
		''')
	}

	// check nested 'create' statement with explicit attributes initialization
	@Test
	def void testNestedCreateStatementWithExplicitAttributeInit() {
		assertParsingTrue('''
			class foo { id : integer; name : text; }
			class bar { id : integer; name : text; f : foo; }
			operation op() {
				create bar (id = 1, name = 'test', create foo(id = 1, name = 'test'));
			}
		''')
	}

	// check nested 'create' statement with implicit attributes initialization
	@Test
	def void testNestedCreateStatementWithImlicitAttributeInit() {
		assertParsingTrue('''
			class foo { id : integer; name : text; }
			class bar { id : integer; name : text; f : foo; }
			operation op() {
				create bar (1, 'test', create foo(1, 'test'));
			}
		''')
	}

	// check arbitrary order of 'create' statement parameters with implicit attributes initialization
	@Test
	def void testImplicitArbitraryOrderOfParameters() {
		assertParsingTrue('''
			class foo { id : integer; name : text; }
			operation op() {
				create foo(1, 'test');
				create foo('test', 1);
			}
		''')
	}

	// check at-operator within 'create' statement as parameter
	@Test
	def void testAtOperatorAsParameterInCreate() {
		assertParsingTrue('''
			class foo { id : integer; name : text; }
			class bar { id : integer; name1 : text;	f : foo; }
			operation op() {
				create bar (1, 'test', foo @ {.name == 'foo'});
			}
		''')
	}

	// check explicit reference to a class variable in 'where' part within operation
	@Test
	def void testExplicitRefWherePart() {
		assertParsingTrue('''
			class foo { key k: integer; name; }
			operation op() {
			    val foo = foo @{.k == 122};    
			}
		''')
	}

	// check explicit reference to a class variable in 'what' part within operation
	@Test
	def void testExplicitRefWhatPart() {
		assertParsingTrue('''
			class foo { key k: integer; name; }
			operation op() {
			    val foo = foo @{.k == 122}(.name);    
			}
		''')
	}

	

	// check query short form
	@Test
	def void testQueryShortForm() {
		assertParsingTrue('''
			query q(x: integer): integer = x * x;
		''')
	}

	// check query full from
	@Test
	def void testQueryFullForm() {
		assertParsingTrue('''
			query q(x: integer): integer { return x * x; }
		''')
	}

	// check return record from query
	@Test
	def void testReturnRecordWithinQuery() {
		assertParsingTrue('''
			record foo { i: integer; s: text; q: text = 'test'; }
			query q() { val s = 'Hello'; val q = 'Bye'; return foo(i = 123, q, s); }
		''')
	}

	// check list addAll, removeAll, containsAll
	@Test
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
	@Test
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
	@Test
	def void testListClearEmpty() {
		assertParsingTrue('''
			query q1() { val x = [1, 2, 3]; x.clear(); return x; }
			query q2() = list<integer>().empty() ;
			query q3() = list<integer>([1]).empty() ;
			query q4() = list<integer>([1, 2, 3, 4, 5]).empty() ;
		''')
	}

	@Test
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
	@Test
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

	// check simple create of set
	@Test
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
	@Test
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
	@Test
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

	// check contains, containsAll set 
	@Test
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
	@Test
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
	@Test
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

	@Test
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

	// check set with records
	@Test
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

	@Test
	def void testMethodCall() {
		assertParsingTrue('''operation o(){
			val s=set<integer>([123]);
			val isContains=s.contains(1);
		}
		''')
	}

	// check set with records
	@Test
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

	@Test
	def void testTheRecordType() {
		assertParsingTrue('''		
			record bar { p: integer; q: integer; }
			query q1() { var s:bar; return s; }
		''')
	}

	// check set requireNotEmpty
	@Test
	def void testSetRequireNotEmpty() {
		assertParsingTrue('''
			query q1() { val x = set<integer>(); return requireNotEmpty(x); }
			query q2() { val x = set([123]); return requireNotEmpty(x); }
			query q3() { val x: set<integer>? = null; return requireNotEmpty(x); }
			query q4() { val x: set<integer>? = set<integer>(); return requireNotEmpty(x); }
			query q5() { val x: set<integer>? = set([123]); return requireNotEmpty(x); }
		''')
	}

	// check map clear() function
	@Test
	def void testMapClear() {
		assertParsingTrue('''
			query q() { val x = ['Bob':123,'Alice':567,'Trudy':789]; x.clear(); return x; }
		''')
	}

	// check map contains() function
	@Test
	def void testMapContains() {
		assertParsingTrue('''
			query q1() = ['Bob':123].contains('Bob') ;
			query q2() = ['Bob':123].contains('Alice') ;
			query q3() = ['Bob':123,'Alice':456].contains('Bob') ;
			query q4() = ['Bob':123,'Alice':456].contains('Alice') ;
			query q5() = ['Bob':123,'Alice':456].contains('Trudy') ;
		''')
	}
	
	// check map size() function
	@Test
	def void testMapSize() {
		assertParsingTrue('''
			query q1() = map<text,integer>().size() ;
			query q2() = ['Bob':123].size() ;
			query q3() = ['Bob':123,'Alice':456].size() ;
		''')
	}

	// check '==' map
	@Test
	def void testMapEquals() {
		assertParsingTrue('''
			query q1() = ['Bob':123,'Alice':456,'Trudy':789] == ['Bob':123,'Alice':456,'Trudy':789] ;
			query q2() = ['Bob':123,'Alice':456,'Trudy':789] == ['Bob':321,'Alice':654,'Trudy':987] ;
			query q3() = ['Bob':123,'Alice':456,'Trudy':789] == ['Bob':123,'Alice':456] ;
			query q4() = ['Bob':123,'Alice':456,'Trudy':789] == ['Bob':123,'Alice':456,'Trudy':789,'Satoshi':555] ;
			query q5() = ['Bob':123,'Alice':456,'Trudy':789] == map<text,integer>() ;		
		''')
	}

	@Test
	def void testCreateInOperation() {
		assertParsingTrue('''
			class user { key pubkey; index username: text; firstName: text; lastName: text; email: text; }
			    operation add_user (admin_pubkey: integer, pubkey, username: text, firstName: text, lastName: text, email: text) {
			           create user (pubkey, username, firstName, lastName, email);
			    }
		''')
	}

	// check map calculate() function
	@Test
	def void testMapCalculate() {
		assertParsingTrue('''
			query q1() = map<text,integer>().calculate('Bob') ;
			query q2() = ['Bob':123].calculate('Bob') ;
			query q3() = ['Bob':123].calculate('Alice') ;
			query q4() = ['Bob':123,'Alice':456].calculate('Bob') ;
			query q5() = ['Bob':123,'Alice':456].calculate('Alice') ;
			query q6() = ['Bob':123,'Alice':456].calculate('Trudy') ;
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
