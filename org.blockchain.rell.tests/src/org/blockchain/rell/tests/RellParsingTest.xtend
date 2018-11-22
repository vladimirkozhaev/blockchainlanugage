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

// Check that a class can apply the 'key' clause after an attribute definition
	@Test
	def void testApplyKeyAfterAttrDef() {
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
	
// Check that a class can apply the 'key' clause with an attribute definition	
	@Test
	def void testApplyKeyWithAttrDef() {
		val result = parseHelper.parse(''' 
			class test {
				key testKey : text;
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}
	
// Check applying the composite "key" clause with multiple attributes in definition
	@Test
	def void testCompositeKeyInDefinition() {
		val result = parseHelper.parse('''
			class test {
				key firstField : text, secondField : text;
			}	
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

// Check applying the composite "key" clause with multiple attributes after their definition
	@Test
	def void testCompositeKeyAfterDefinition() {
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

// Check that a class can apply the 'index' clause after an attribute definition
	@Test
	def void testApplyIndexAfterAttrDef() {
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

// Check that a class can apply the 'index' clause with an attribute definition
	@Test
	def void testApplyIndexWihAttrDef() {
		val result = parseHelper.parse(''' 
			class test {
				index testIndex : text;
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

// Check applying the composite "index" clause with multiple attributes in definition
	@Test
	def void testCompositeIndexInDefinition() {
		val result = parseHelper.parse('''
			class test {
				index firstField : text, secondField : text;
			}	
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}
	
// Check applying the composite "index" clause with multiple attributes after their definition
	@Test
	def void testCompositeIndexAfterDefinition() {
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
				sex:integer;
				update test(id==sex){id=1};
			}
		''')
		Assert.assertNotNull(result)
		val errors = result.eResource.errors
		Assert.assertTrue('''Unexpected errors: �errors.join(", ")�''', errors.isEmpty)
	}

}
