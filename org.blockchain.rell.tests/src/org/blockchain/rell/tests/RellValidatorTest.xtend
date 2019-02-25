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
	

//	@Test
//	def void forwardReferencesTest() {
//		'''operation o(){
//			j:integer=i;
//			i:integer;
//		}'''.parse.assertError(RellPackage.eINSTANCE.operation, RellValidator::FORWARD_REFERENCE,
//			"Forward reference i")
//	}
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
	def void forwardReferencesTest1() {
		val validatedResult = '''operation test(o:integer){
			j:integer=i+1;
			i:integer;
		}'''.parse.validate();
		Assert.assertTrue(validatedResult.get(0) != null);
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
	
//	@Test
//	def void testDublicateAttributeNameDeclaration() {
//		val validated = '''
//			class test {
//				i : integer;
//				i : integer;
//			}
//		'''.parse.validate()
//		Assert.assertTrue(validated.get(0).getCode() == RellValidator::DUPLICATE_ATTRIBUTE_NAME)
//	}
	
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

}
