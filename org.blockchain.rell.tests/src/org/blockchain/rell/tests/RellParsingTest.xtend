/*
 * generated by Xtext 2.14.0
 */
package org.blockchain.rell.tests

import com.google.inject.Inject
import org.blockchain.rell.rell.Model
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(RellInjectorProvider)
class RellParsingTest {
	@Inject
	ParseHelper<Model> parseHelper

	@Test
	def void testSimpleClassWithPrimitiveTypes() {
		val result = parseHelper.parse('''
			class test {
				field1:text;
				field2:integer;
				field3:byte_array;
				field4:json;
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

	@Test
	def void testSimpleClassWithPrimitiveTypesMnemonics() {
		val result = parseHelper.parse('''
			class test {
				field1:pubkey;
				
				fieldx:name;	
				field2:guid;
				field3:timestamp;
				field4:signer;
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

	@Test
	def void testFieldsCommaList() {
		val result = parseHelper.parse('''
			class test {
									key field1:text,field11:text;
									
									fieldx:text;	
									field2:guid;
									
									
								}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

	@Test
	def void testKeyField() {
		val result = parseHelper.parse('''
			class test {
									key field1:text;
									
									fieldx:name;	
									field2:tuid;
									field3:timestamp;
									
								}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

	@Test
	def void testClassReferenceFields() {
		val result = parseHelper.parse('''
			class test{
				bbbb:test;
				sex:text;
			}
			
			class test1{
				xxx:test1;
				ssss:text;
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}
	
//	Check initialization byte_array
    @Test
	def void testInitValueToByteArray() {
		val result = parseHelper.parse('''
			class foo {
			    ba : byte_array = x"0373599a61cc6b3bc02a78c34313e1737ae9cfd56b9bb24360b437d469efdf3b15";
			}		
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}
	
//	Check initialization pubkey
    @Test
	def void testInitValueToPubkey() {
		val result = parseHelper.parse('''
			class foo {
			    pb : pubkey = x"0373599a61cc6b3bc02a78c34313e1737ae9cfd56b9bb24360b437d469efdf3b15";
			}		
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}
	
//  Check create tuple with named fields and two values 
	@Test
	def void testCreateSimpleTupleTwoValues() {
		val result = parseHelper.parse('''
			operation op() {
				 val test_tuple: (text, integer)  = ("Bill", 38);
			}
		'''
		)
        Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}	
	
//  Check create tuple with named fields and two values 
	@Test
	def void testCreateSimpleNamedTupleTwoValues() {
		val result = parseHelper.parse('''
			operation op() {
				 val test_tuple: (name:text, age:integer)  = (name="John", age=18);
			}
		'''
		)
        Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}	
	
//  Check create nested tuple 
	@Test
	def void testCreateNestedTuple() {
		val result = parseHelper.parse('''
			operation op() {
					 val test_tuple: (text, (integer, boolean))  = ("Bill", (38, true));
			}
		'''
		)
        Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}	
	
//  Check create named nested tuple 
	@Test
	def void testCreateNamedNestedTuple() {
		val result = parseHelper.parse('''
			operation op() {
					 val test_tuple: (name: text, (age : integer, active : boolean))  = (name = "Bill", (age = 38, active = true));
			}
		'''
		)
        Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}	
	
// Check return tuple of reference types of values
	@Test
	def void testAssignTupleWithExplicitValues() {
		val result = parseHelper.parse('''
			class city { name: text;}
			class person { name: text; age : integer; homeCity: city; workCity: city;}
			operation o() { 
			    val test_tuple : (homeCity : city, workCity : city) = person @ {.name == "Bob"} (.homeCity, .workCity);
			}
		'''
		)
        Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}	
	
	// Check tuple of two values from at expression
	@Test
	def void testSimpleTuple() {
		val result = parseHelper.parse('''
				operation op() {
			    val u: (integer,boolean, (boolean,boolean))=(100,true, (true,false));
			}
		'''
		)
        Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}	
	
// Check tuple of three values from at expression 
	@Test
	def void testTupleThreeValues() {
		val result = parseHelper.parse('''
			class company {
			    name;
			    address : name;
			    type : integer;    
			}
			
			class user {
			    name;
			    company;
			}
			
			operation op() {
			    val u = user @ { .name == 'Bob' } ( .company.name, .company.address, .company.type );
			}
		'''
		)
        Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}	
	
// Check tuple of three values from at expression
	@Test
	def void testNestedTupleTwoTypes() {
		val result = parseHelper.parse('''
			class company {
			    name;
			    address : name;
			    type : integer;    
			}
			
			class user {
			    name;
			    company;
			}
			
			operation op() {
			    val u = user @ { .name == 'Bob' } ( .company.name, .company.address );
			}
		'''
		)
        Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}	
	
// Check record declaration 
	@Test	
	def void testRecordDeclaration() {
		val result = parseHelper.parse('''
			record foo {
						    k : pubkey;
						    i : integer;
						    name: text;
						}
			operation o(){
					val name = 'Bob';
					val address = 'New York';
					val u = foo(name, address);
					val u2 = foo(address, name); // Order does not matter - same record object is created.	
			}

		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
		
	}

// Check if attribute type is not specified, it will be the same as attribute name 
	@Test
	def void testAttributeTypeAsAttributeName() {
		val result = parseHelper.parse(''' 
			class test1 {
				id : guid;
			}
			
			class test2 {
				test1;
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

	@Test
	def void testIndexWithAttributeDefinition() {
		val result = parseHelper.parse(''' 
			class test {
			index testIndex : text;
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

// Check default values for attribute
	@Test
	def void testDefaultAttributeValue() {
		val result = parseHelper.parse(''' 
			class test {
				testText: text = 'test_text';
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}
	
// Check set default attribute value via at-operator 
	@Test
	def void testDefaultAttributeValueWithAtOperator() {
		val result = parseHelper.parse(''' 
			class version { 
				id : pubkey;
				value: integer;
			}
			class model { 
				name: text; 
				version: version = version@{};
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}
	
// Check set default attribute value via at-operator with 'where' part
	@Test
	def void testDefaultAttributeValueWithAtOperatorWherePart() {
		val result = parseHelper.parse(''' 
			class version { 
				id : pubkey;
				value: integer;
			}
			class model { 
				name: text; 
				version: version = version@{.id == x'0123abcd'};
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}
	@Test
	def void testDefaultAttributeValueWithAtOperatorWherePartAndPubkey() {
		val result = parseHelper.parse(''' 
			class version { 
				id : pubkey;
				value: integer;
			}
			class model { 
				name: text; 
				version: version = version@{.id == x'0123abcd'};
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

// Check set default attribute value via at-operator that return value from 'what' part
	@Test
	def void testDefAttribValWithAtOperatorReturnWhatPart() {
		val result = parseHelper.parse(''' 
			class version { 
				id : pubkey;
				value: integer;
			}
			class model { 
				name: text; 
				version: integer = version@{.id == x'0123abcd'}(version.value);
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}
	
// Check default attribute value via at-operator that return value by member access
	@Test
	def void testDefAttribValWithAtOperatorReturnMemberAccess() {
		val result = parseHelper.parse(''' 
			class version { 
				id : pubkey;
				value: integer;
			}
			class model { 
				name: text; 
				version: integer = version@{.id == x'0123abcd'}.value;
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

// Check that a class can have the 'key' clause after an attribute definition
	@Test
	def void testKeyAfterAttributeDefinition() {
		val result = parseHelper.parse(''' 
			class test {
				testKey : text;
				key testKey;
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

// Check that a class can have the 'key' clause with an attribute definition	
	@Test
	def void testKeyWithAttributeDefinition() {
		val result = parseHelper.parse(''' 
			class test {
				key testKey : text;
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

// Check that a class can have the composite "key" clause with multiple attributes in definition
	@Test
	def void testCompositeKeyWithAttributeDefinition() {
		val result = parseHelper.parse('''
			class test {
				key firstField : text, secondField : text;
			}	
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

// Check that a class can have the composite "key" clause with multiple attributes after their definition
	@Test
	def void testCompositeKeyAfterAttributeDefinition() {
		val result = parseHelper.parse('''
			class test {
				firstField : text; 
				secondField : text;
				key firstField, secondField; 
			}	
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

// Check that a class can have the 'index' clause after an attribute definition
	@Test
	def void testIndexAfterAttributeDefinition() {
		val result = parseHelper.parse(''' 
			class test {
				testIndex : text;
				index testIndex;
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

// Check that a class can have the 'index' clause with an attribute definition
	@Test
	def void testIndexWihAttributeDefiniton() {
		val result = parseHelper.parse(''' 
			class test {
				index testIndex : text;
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

// Check that a class can have the composite "index" clause with multiple attributes in definition
	@Test
	def void testCompositeIndexWithAttributeDefinition() {
		val result = parseHelper.parse('''
			class test {
				index firstField : text, secondField : text;
			}	
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

// Check that a class can have the composite composite "index" clause with multiple attributes after their definition
	@Test
	def void testCompositeIndexAfterAttributeDefinition() {
		val result = parseHelper.parse('''
			class test {
				firstField : text; 
				secondField : text;
				index firstField, secondField; 
			}	
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

// Check an attribute, that has reference type to a class, as index clause	
	@Test
	def void testIndexOnAttributeWithRefType() {
		val result = parseHelper.parse('''
			class test1 {
			}
			
			class test2 {
				index attrTest1 : test1;
			}	
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

//Check the 'mutable' keyword to an attribute	
	@Test
	def void testMutableToAttribute() {
		val result = parseHelper.parse('''
			class test {
				mutable firstField : text;
			}	
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

//Check creating the object of a class within 'operation' 	
	@Test
	def void testCreateObjectWithinOperation() {
		val result = parseHelper.parse('''
			class test {a: text; b: text; c : text; key a; index b; }
			operation createTest() {
			    create test(a = 'akey', b = 'btext', c = 'ctext');
			}	
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

//Check operation parameters
	@Test
	def void testOperationMustProvideParameters() {
		val result = parseHelper.parse('''
			class test {a: text; b: text; c : text; key a; index b; }
			operation createTest(aParameter : text, bParameter : text, cParameter : text) {
			    create test(a=aParameter, b=bParameter, c=cParameter);
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

//Check assign a value of returning 'create' statement to 'val' within 'operation'	
	@Test
	def void testAssignValueFromCreateStatment() {
		val result = parseHelper.parse('''
			class test {a: text; b: text; c : text; key a; index b; }
			operation createTest() {
			   val newTest =  create test(a = 'akey', b = 'btext', c = 'ctext');
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)

	}

//Check assign a value of returning 'create' statement to 'val' within 'operation'	
	@Test
	def void testTheIndex() {
		val result = parseHelper.parse('''
			class test {
			x: integer;
			index x: integer;
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)

	}

//Check creating the object of a class with default values of attributes within 'operation' 	
	@Test
	def void testCreateObjectDefaultValuesWithinOperation() {
		val result = parseHelper.parse('''
			class test {a: text='akey'; b: text='btext'; c : text='ctext'; key a; index b; }
			operation createTest() {
			    create test();
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

//Check '@'(exactly one) cardinality with Where-part '{}'
	@Test
	def void testExactlyOneCardinalityWherePart() {
		val result = parseHelper.parse('''
			class test {field: text; key field; }
			operation o() { 
			    val t = test @ {.field == 'some_text'};
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

//Check '@*'(zero or more) cardinality with Where-part '{}'
	@Test
	def void testZeroOrMoreCardinalityWherePart() {
		val result = parseHelper.parse('''
			class test {field: text; key field; }
			operation o() { 
			    val t = test @* {.field == 'some_text'};
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

	@Test
	def void testVarAndValOperation() {
		val result = parseHelper.parse('''
			operation o() { 
			    val x = 1;
			    var y = 1;
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

//Check '@*'(zero or one, fails if more than one found) cardinality with Where-part '{}'
	@Test
	def void testZeroOrMoreFailCardinalityWherePart() {
		val result = parseHelper.parse('''
			class test {field: text; key field; }
			operation o() { 
			    val t = test @? {.field == 'some_text'};
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

//Check '@*'(one or more) cardinality with Where-part '{}'
	@Test
	def void testOneOrMoreCardinalityWherePart() {
		val result = parseHelper.parse('''
			class test {field: text; key field; }
			operation o() { 
			    val t = test @+ {.field == 'some_text'};
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

// check create new object with explicit attributes initialization in 'create' statement
	@Test
	def void testCreateStatementWithExplicitAttributeInit() {
		val result = parseHelper.parse('''
			class foo {
				id : integer;
				name : text;
			}
			
			operation op() {
				create foo(id = 1, name = 'test');
				create foo(name = 'test', id = 1);
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

	// check create new object with implicit attributes initialization in 'create' statement
	@Test
	def void testCreateStatementWithImplicitAttributeInit() {
		val result = parseHelper.parse('''
			class foo {
				id : integer;
				name1 : text;
			}
			
			operation op() {
				create foo(1,'test');
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

	// check nested 'create' statement with explicit attributes initialization
	@Test
	def void testNestedCreateStatementWithExplicitAttributeInit() {
		val result = parseHelper.parse('''
			class foo {
				id : integer;
				name : text;
			}
			
			class bar {
				id : integer;
				name : text;
				f : foo;
			}
			operation op() {
				create bar (id = 1, name = 'test', create foo(id = 1, name = 'test'));
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

	// check nested 'create' statement with implicit attributes initialization
	@Test
	def void testNestedCreateStatementWithImlicitAttributeInit() {
		val result = parseHelper.parse('''
			class foo {
				id : integer;
				name : text;
			}
			
			class bar {
				id : integer;
				name : text;
				f : foo;
			}
			operation op() {
				create bar (1, 'test', create foo(1, 'test'));
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

	// check arbitrary order of 'create' statement parameters with explicit attributes initialization
	@Test
	def void testExplicitArbitraryOrderOfParameters() {
		val result = parseHelper.parse('''
			class foo {
				id : integer;
				name1 : text;
			}
			
			operation op() {

				create foo(.id == 1, .name1 == 'test');
				create foo(.name1 == 'test', .id == 1);
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}
	@Test
	def void testKeywordsAsFieldNameInTheCreate() {
		val result = parseHelper.parse('''
			class foo {
				id : integer;
				name : text;
			}
			
			operation op() {
			
				create foo(id = 1, name1 = 'test');
				create foo(name1 = 'test', id = 1);
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}
	
	// check arbitrary order of 'create' statement parameters with implicit attributes initialization
	@Test
	def void testImplicitArbitraryOrderOfParameters() {
		val result = parseHelper.parse('''
			class foo {
				id : integer;
				name : text;
			}
			
			operation op() {
				create foo(1, 'test');
				create foo('test', 1);
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}
	
	// check at-operator within 'create' statement as parameter
	@Test
	def void testAtOperatorAsParameterInCreate() {
		val result = parseHelper.parse('''
			class foo {
				id : integer;
				name : text;
			}
			
			class bar {
				id : integer;
				name1 : text;
				f : foo;
			}
			operation op() {

				create bar (1, 'test', foo @ {.name == 'foo'});
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}
	
	// check alias in 'where' part of at-operator within operation
	@Test
	def void testAliasWherePartWithinOperation() {
		val result = parseHelper.parse('''
			class foo { 
				pubkey;
				name;
			}
			
			operation op() {
			    val foo_obj = (f: foo) @{f.pubkey == x'0123abcd'};    
			}
			
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}
	
	// check alias in 'where' and 'what' part of at-operator within operation 
	@Test
	def void testAliasWhatPartWithinOperation() {
		val result = parseHelper.parse('''
			class foo { 
				pubkey;
				name;
			}
			
			operation op() {
			    val foo_name = (f: foo) @{f.pubkey == x'0123abcd'}(f.name);    
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}
	
	// check explicit reference to a class variable in 'where' part within operation
	@Test
	def void testExplicitRefWherePart() {
		val result = parseHelper.parse('''
			class foo { 
				key k: integer;
				name;
			}
			
			operation op() {
			    val foo = foo @{.k == 122};    
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}
	
	// check explicit reference to a class variable in 'what' part within operation
	@Test
	def void testExplicitRefWhatPart() {
		val result = parseHelper.parse('''
			class foo { 
				key k: integer;
				name;
			}
			
			operation op() {
			    val foo = foo @{.k == 122}(.name);    
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}
	
	// check simple update operation (short expression to access to class members)
	@Test
	def void testUpdateOperationShortAccess() {
		val result = parseHelper.parse('''
			class foo { 
				key k: integer;
				mutable name;
			}
			
			operation op() {
			    update foo @{.k == 122}(name = "new_name");    
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}
	
	// check simple update operation (full expression to access to class members)
	@Test
	def void testUpdateOperationFullAccess() {
		val result = parseHelper.parse('''
			class foo { 
				key k: integer;
				mutable name;
			}
			
			operation op() {
			    update foo @{foo.k == 122}(name = "new_name");    
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

	// check pass val variable to where part of at expression 
	@Test
	def void testUpdateOperationValInWherePart() {
		val result = parseHelper.parse('''
			class foo { 
			    key k: integer;
			    mutable name;
			}
			
			operation op() {
			  val k = 122;
			  update foo @{.k == k}(name = "new_name");    
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}
	
	// check update operation with alias
	@Test
	def void testUpdateOperationWithAlias() {
		val result = parseHelper.parse('''
			class country { name: text; }
			class city { name: text; country; }
			class person { name: text; homeCity: city; workCity: city; mutable score: integer; }
			operation o() { 
			            update p: person (c1: city, c2: city) @ {
			                p.homeCity.name == c1.name,
			                p.workCity.name == c2.name,
			                c1.country.name == 'Germany',
			                c2.country.name == 'USA'
			            } ( score = 999 );
			         }
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

	// check alias in at-expression in update statement
	@Test
	def void testUpdateOperationAliasWithAssignFromAt() {
		val result = parseHelper.parse('''
			class country { name: text; }
			class city { name: text; country; }
			class person { name: text; homeCity: city; workCity: city; mutable score: integer; }
			operation o() { update p1: person (p2: person) @ { p1.homeCity == p2.workCity } ( score = p1.score * 3 + p2.score ); }
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}
	
	// check assign value from at-expression in update statement
	@Test
	def void testUpdateOperationWithAssignFromAt() {
		val result = parseHelper.parse('''
			class default_score { name : text; value: integer; }
			class person { name: text; mutable score: integer = default_score@{}.value; }
			operation o() { update person @ {} (.score = default_score @{.name == "super_score"}.value); }
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}
	
	
	// check query short form
	@Test
	def void testQueryShortForm() {
		val result = parseHelper.parse('''
			query q(x: integer): integer = x * x;
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)		
	} 
	
	//check query full from
	@Test
	def void testQueryFullForm() {
		val result = parseHelper.parse('''
			query q(x: integer): integer {
			    return x * x;
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		println(errors.join(", "))
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)		
	} 
	
	//check query full from
	@Test
	def void testQuery1() {
		val result = parseHelper.parse('''
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
			query q() = optest @* { .b1 and .b2 };
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)		
	} 
	
	// check return record from query
	@Test
	def void testReturnRecordWithinQuery() {
		val result = parseHelper.parse('''
			record foo { i: integer; s: text; q: text = 'test'; }
			query q() { val s = 'Hello'; val q = 'Bye'; return foo(i = 123, q, s); }
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		println(errors.join(", "))
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}
	
	// check tuple return from query
	@Test
	def void testReturnTupleFromQuery(){
		val result = parseHelper.parse('''
			class company { name: text; }
			class user { firstName: text; lastName: text; company; }
			query q() {  return user @ { .firstName == 'Bill' } (.lastName, '' + (123,'Hello')); }
		''')
		Assert.assertNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
		
	}
	
	@Test
	def void testSimpleDefList(){
		val result = parseHelper.parse('''
			class TestClass{
				test:integer;
			}	
			
			operation t1(){
				val t:list<integer>;
				val t1:list<integer?>;
				val t2:list<TestClass>;
				
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
		
	}
	
	@Test
	def void testListCreation(){
		val result = parseHelper.parse('''
			class TestClass{
				test:integer;
			}
			
			operation t1(){
				val t:list<integer> = [1,2,3];
				val t1:list<integer?> =[1,2,3];
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
		
	}
	
	// check simple declaration of function 
	@Test
	def void testsimpleFunctionDeclaration(){
		val result = parseHelper.parse('''
			function f(x: integer): integer = x * x;
		''')
		Assert.assertNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
		
	}
	
	// check simple declaration of function 
	@Test
	def void testUpdateStatementInFunction(){
		val result = parseHelper.parse('''
			class user { name: text; mutable score: integer; }
			function f(name: text, s: integer): integer { update user @ { name } ( score += s ); return s; } query q() = f('Bob', 500) ;
		''')
		Assert.assertNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
		
	}
	
	@Test
	def void testAceesToList(){
		val result = parseHelper.parse('''
			query q() { val x = list<integer?>([123]); x[0] = null; return ''+x; }
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}
	
	
	@Test
	def void testOperations() {
		val result = parseHelper.parse('''
			class Test{
				sex:Test;
				box:text;
			}
			
			operation test(sex:Test,box:text){
				
			}
			
			operation test1(sex:Test,box:text){
				
			}
			
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}



	

	@Test
	def void testVariablesInsideOperations() {
		val result = parseHelper.parse('''
			operation test(){
				var sex:integer;
				update test@{id==sex}(id=1);
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

	@Test
	def void testCreateInOperation() {
		val result = parseHelper.parse('''
			class user {
			        key pubkey;
			        index username: text;
			        firstName: text;
			        lastName: text;
			        email: text;
			
			    }
			    operation add_user (admin_pubkey: integer, pubkey, username: text, firstName: text, lastName: text, email: text) {
			           create user (pubkey, username, firstName, lastName, email);
			    }
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

	@Test
	def void testDefaultVariableName() {
		val result = parseHelper.parse('''
			operation test(){
				var integer=5;
				var i:integer=integer;
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

	@Test
	def void testDefaultVariableNameInsideTheOperation() {
		val result = parseHelper.parse('''
			
			operation test (pubkey) {
			      var test:pubkey=pubkey;
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}
	
	@Test
	def void testAliases() {
		val result = parseHelper.parse('''class Test{
			t:text;
		}
		class Test1{
			t1:text;
		}
		class Test2{
			t2:text;
		}
		
		operation o(){
			val op=(a:Test,b:Test)@{a.t=="rrrr"};
		}		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}
	@Test
	def void testWrongAliases() {
		val result = parseHelper.parse('''class Test{
			t:text;
		}
		class Test1{
			t1:text;
		}
		class Test2{
			t2:text;
		}
		
		operation o(){
			val op=(a:Test,b:Test)@{a1.t=="rrrr"};
		}		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

}
