package org.blockchain.rell.tests

import com.google.inject.Inject
import com.google.inject.Provider
import org.blockchain.rell.services.RellGrammarAccess
import org.blockchain.rell.typing.ExpressionsType
import org.blockchain.rell.typing.ExpressionsTypeProvider
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.xtext.ParserRule
import org.eclipse.xtext.resource.XtextResource
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.util.StringInputStream
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith

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

	@Test def void varIntRef1() { assertIntType("field2:integer", ga.variableDeclarationRule) }

	@Test def void varIntRef2() { assertIntType("field2:timestamp", ga.variableDeclarationRule) }

	@Test def void varStringRef1() { assertStringType("field2:text", ga.variableDeclarationRule) }

	@Test def void varStringRef2() { assertStringType("field2:tuid", ga.variableDeclarationRule) }

	@Test def void varStringRef3() { assertStringType("field2:name", ga.variableDeclarationRule) }

	@Test def void varBool1() { assertBoolType("true") }

	@Test def void varBool2() { assertBoolType("false") }

	// @Test def void varBoolRef1() { assertStringType("field2:name", ga.variableDeclarationRule) }
	@Test def void testIsInt() {
		(ExpressionsTypeProvider::intType).isInt.assertTrue
	}

	@Test def void testIsString() {
		(ExpressionsTypeProvider::stringType).isString.assertTrue
	}

	@Test def void testIsBool() {
		(ExpressionsTypeProvider::boolType).isBoolean.assertTrue
	}

	def assertStringType(CharSequence input, ParserRule rule) {
		input.assertType(ExpressionsTypeProvider::stringType, rule)
	}

	def assertStringType(CharSequence input) {
		input.assertType(ExpressionsTypeProvider::stringType, ga.expressionRule)
	}

	def assertIntType(CharSequence input, ParserRule rule) {
		input.assertType(ExpressionsTypeProvider::intType, rule)
	}

	def assertIntType(CharSequence input) {
		input.assertType(ExpressionsTypeProvider::intType)
	}

	def assertBoolType(CharSequence input) {
		input.assertType(ExpressionsTypeProvider::boolType, ga.expressionRule)
	}

	def assertBoolType(CharSequence input, ParserRule rule) {
		input.assertType(ExpressionsTypeProvider::boolType, ga.expressionRule)
	}

	def assertUnknownType(CharSequence input) {
		input.assertType(null)
	}

	def assertType(CharSequence input, ExpressionsType expectedType) {

		assertType(input, expectedType, ga.expressionRule)
	}

	def assertType(CharSequence input, ExpressionsType expectedType, ParserRule rule) {

		var rs = rsp.get()
		var r = rs.createResource(URI.createURI("test.rell"));
		(r as XtextResource).entryPoint = rule

		r.load(new StringInputStream(input.toString()), null)
		r.getErrors // test if empty
		var errors = r.errors
		Assert.assertTrue('''Unexpected errors: «errors.join(", ")»''', errors.isEmpty)
		var contents = r.getContents;
		println(contents)
		var model = r.getContents.get(0)
		model.typeFor.assertSame(expectedType)
	}

}
