package org.blockchain.rell.tests

import com.google.inject.Inject
import org.blockchain.rell.rell.ClassDefinition
import org.blockchain.rell.rell.RellPackage
import org.blockchain.rell.validation.RellValidator
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.Assert

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(RellInjectorProvider))
class RellValidatorTest {
	@Inject extension ParseHelper<ClassDefinition>
	@Inject extension ValidationTestHelper
	
	@Test
	def void emptyClassTest() {
		val response = '''class Test {}'''.parse.validate()
		Assert.assertTrue(response.isEmpty())
	}
	
	@Test
	def void emptyRecordTest() {
		val response = '''record Test {}'''.parse.validate()
		Assert.assertTrue(response.isEmpty())
	}
	
	@Test
	def void classWithNotInitializedFieldWithoutTypeTest() {
		val response = '''class Test {
			test;
		}'''.parse.validate()
		Assert.assertTrue(response.get(0).message.startsWith("Type for 'test' not specified and no type called 'test'"))
	}
	
	@Test
	def void classWithNotInitializedFieldTest() {
		val response = '''class Test {
			test:text;
		}'''.parse.validate()
		Assert.assertTrue(response.isEmpty())
	}
	
	@Test
	def void classWithNotInitializedMutableKeyIndexFieldTest() {
		val response = '''class Test {
			mutable key index test:text;
		}'''.parse.validate()
		Assert.assertTrue(response.isEmpty())
	}
	
	@Test
	def void classWithNotInitializedFieldsTest() {
		val response = '''class Test {
			test:text;
			test2:text;
		}'''.parse.validate()
		Assert.assertTrue(response.isEmpty())
	}
	
	@Test
	def void classWithNotInitializedFieldsCommaTest() {
		val response = '''class Test {
			test:text, test2:text;
		}'''.parse.validate()
		Assert.assertTrue(response.isEmpty())
	}
	
	@Test
	def void classWithInitializedFieldAllPrimitivesTest() {
		var response = "class Test { test: text = \"test\" ;	}".parse.validate()
		Assert.assertTrue(response.isEmpty())
		response = "class Test { test: integer = 1;	}".parse.validate()
		Assert.assertTrue(response.isEmpty())
		response = "class Test { test: tuid = \"test\";	}".parse.validate()
		Assert.assertTrue(response.isEmpty())
		response = "class Test { test: name = \"test\";	}".parse.validate()
		Assert.assertTrue(response.isEmpty())
		response = "class Test { test: timestamp = 12345;	}".parse.validate()
		Assert.assertTrue(response.isEmpty())
		response = "class Test { test: boolean = true;	}".parse.validate()
		Assert.assertTrue(response.isEmpty())
//		var response = "class Test { test: json = \"{}\";	}".parse.validate()
//		Assert.assertTrue(response.isEmpty())
		response = "class Test { test: pubkey = x'00';	}".parse.validate()
		Assert.assertTrue(response.isEmpty())
		response = "class Test { test: byte_array = x'0011';	}".parse.validate()
		Assert.assertTrue(response.isEmpty())
	}
	
	@Test
	def void classWithInitializedListFieldTest() {
		val response = '''class X {
			test: list <integer> = [1,2];
		}'''.parse.validate();
		Assert.assertTrue(response.isEmpty())
	}
	
	@Test
	def void keyFieldTest() {
		'''class test {
						key field1:pubkey;
						
						fieldx:name;	
						field2:guid;
						field3:timestamp;
						field4:signer;
					}'''.parse.assertNoError("Key index is allowed")
	}
	
	@Test
	def void testNotInitVariable() {
		val response = '''operation test(o:integer){
			j:integer=i+1;
			i:integer;
		}'''.parse.validate();
	}
	@Test
	def void testAssertNoError() {
		'''operation o(i:integer){
		
			j:integer=i;
		}'''.parse.assertNoError("Need be compilled")

	}
		
	@Test
	def void testUniqueClassName(){
		val validated = '''	
			class Test {}
			class Test {}
		'''.parse.validate()
		Assert.assertTrue(validated.get(0).message.startsWith(RellValidator::NOT_UNIQUE_NANE))
	}
	
	@Test
	def void testDublicateAttributeNameDeclaration() {
		val validated = '''
			class test {
				i : integer;
				i : integer;
			}
		'''.parse.validate()
		Assert.assertTrue(validated.get(0).message.startsWith(RellValidator::DUPLICATE_ATTRIBUTE_NAME))
	}
	
	@Test
	def void testDublicateAttributeNameDeclarationInOneLine() {
		val validated = '''
			class test {
				i : integer, i : integer;
				t : text;
			}
		'''.parse.validate()
		Assert.assertTrue(validated.get(0).message.startsWith(RellValidator::DUPLICATE_ATTRIBUTE_NAME))
	}
	
	@Test
	def void testVariableDeclarationConflict() {
		val validated = '''
			operation test() {
							val x:integer=1;
							val j:integer=1;
							val j:integer=1;
			}
		'''.parse.validate()
		Assert.assertTrue(validated.get(0).message.startsWith(RellValidator::DUPLICATE_VARIABLE_NAME))
	}
	
	
	@Test
	def void testEmptyOperation() {
		val validated = '''
			operation test() {}
		'''.parse.validate()
		Assert.assertTrue(validated.isEmpty)
	}
	
	@Test
	def void testOperationWithAttributes() {
		val validated = '''
			operation test(test:integer = 1, test2:integer = 1) {}
		'''.parse.validate()
		Assert.assertTrue(validated.isEmpty)
	}
	
	@Test
	def void testOperationWithOperationVariableStatements() {
		val validated = '''
			operation test() {
				val test: integer = 1;
				var test2: integer = 1;
			}
		'''.parse.validate()
		Assert.assertTrue(validated.isEmpty)
	}
	
//	@Test
//	def void testOperationWithCreateStatements() {
//		val validated = '''
//			class X{
//				test: integer = 1;
//			}
//			operation test() {
//				create X@(xx:integer = 22)
//			}
//		'''.parse.validate()
//		Assert.assertTrue(validated.isEmpty)
//	}
	
//	@Test
//	def void testOperationWithUpdateStatements() {
//		val validated = '''
//			class X{
//				test: integer = 1;
//			}
//			operation test() {
//				update X@{
//					2
//				}(test2:integer = 1)
//			}
//		'''.parse.validate()
//		Assert.assertTrue(validated.isEmpty)
//	}

}
