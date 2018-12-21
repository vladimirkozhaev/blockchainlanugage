/*
 * generated by Xtext 2.14.0
 */
package org.blockchain.rell.tests

import com.google.inject.Inject
import org.blockchain.rell.rell.Model
import org.blockchain.rell.scoping.RellIndex
import org.eclipse.emf.ecore.EObject
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
	@Inject extension RellIndex

	@Test def void testExportedEObjectDescriptions() {
		val result = parseHelper.parse('''class test {
						field1:text;
						field2:integer;
						field3:byte_array;
						field4:json;
					}
		''')
		Assert.assertNotNull(result)
		result.assertExportedEObjectDescriptions("test, test.field1, test.field2, test.field3, test.field4")
	}

	def private assertExportedEObjectDescriptions(EObject o, CharSequence expected) {
		Assert.assertEquals(
			expected.toString,
			o.getExportedEObjectDescriptions.map[qualifiedName].join(", ")
		)
	}

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
			   val newTest =  create test(a == 'akey', b == 'btext', c == 'ctext');
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
			    val t = test @ {field == 'some_text'};
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
			    val t = test @* {field == 'some_text'};
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
			    val t = test @? {field == 'some_text'};
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
			    val t = test @+ {field == 'some_text'};
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
				create foo(id == 1, name == 'test');
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
				create bar (id == 1, name == 'test', create foo(id == 1, name == 'test'));
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
				create foo(id == 1, name1 == 'test');
				create foo(name1 == 'test', id == 1);
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
				create foo(id = 1, name = 'test');
				create foo(name = 'test', id = 1);
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
				create bar (1, 'test', foo @ {name1 == 'foo'});
			}
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
	def void testOperationsWithNotEmptyStatement() {
		val result = parseHelper.parse('''
			class Test{
							test:text;
							sex:integer;
							box:json;
						}
						
						operation test_update(sex:Test,box:Test){
							update test(sex==1,box==5+10){box=5};
							test:Test;
						}
						
						operation test_del(sex:Test,box:Test){
							delete test(sex==1,box==5+10);
						}
						
						operation test_create(sex:Test,box:Test){
							delete test(sex==not box or jazz and sex ,box==5+10);
						}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

	@Test
	def void testNotAndBrackets() {
		val result = parseHelper.parse('''
			operation sex (test:integer){
				update sex(test==1,sex == not (sex or box)){sex=1};
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
				update test(id==sex){id=1};
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
