package org.blockchain.rell.tests

import com.google.inject.Inject
import com.google.inject.Provider
import org.blockchain.rell.services.RellGrammarAccess
import org.blockchain.rell.typing.ExpressionsType
import org.blockchain.rell.typing.ExpressionsTypeProvider
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.xtext.resource.XtextResource
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.util.StringInputStream
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith
import static org.blockchain.rell.typing.ExpressionsTypeProvider.*

import static extension org.junit.Assert.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(RellInjectorProvider))
class ExpressionsTypeProviderTest {
	@Inject extension ExpressionsTypeProvider
	@Inject Provider<ResourceSet> rsp
	@Inject
	RellGrammarAccess ga;
	
	@Test def void intConstant() { "10".assertIntType }
	@Test def void stringConstant() { "'foo'".assertStringType }
	
	@Test def void testIsInt() { 
		(ExpressionsTypeProvider::intType).isInt.assertTrue
	}

	@Test def void testIsString() { 
		(ExpressionsTypeProvider::stringType).isString.assertTrue
	}

	@Test def void testIsBool() { 
		(ExpressionsTypeProvider::boolType).isBoolean.assertTrue
	}
	
	def assertStringType(CharSequence input) {
		input.assertType(ExpressionsTypeProvider::stringType)
	}
	
	def assertIntType(CharSequence input) {
		input.assertType(ExpressionsTypeProvider::intType)
	}

	def assertBoolType(CharSequence input) {
		input.assertType(ExpressionsTypeProvider::boolType)		
	}

	def assertUnknownType(CharSequence input) {
		input.assertType(null)		
	}
	
	def assertType(CharSequence input, ExpressionsType expectedType) {

		var rs = rsp.get()
		var r = rs.createResource(URI.createURI("test.rell"));
		(r as XtextResource).entryPoint = ga.expressionRule
		
		r.load(new StringInputStream(input.toString()),null)
		r.getErrors // test if empty
		var errors = r.errors
		Assert.assertTrue('''Unexpected errors: «errors.join(", ")»''', errors.isEmpty)
		var model = r.getContents.get(0)
		model.typeFor.assertSame(expectedType)
	}



}
