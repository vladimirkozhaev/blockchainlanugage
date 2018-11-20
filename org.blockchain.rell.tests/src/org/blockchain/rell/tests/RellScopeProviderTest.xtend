package org.blockchain.rell.tests

import com.google.inject.Inject
import org.blockchain.rell.rell.Model
import org.blockchain.rell.rell.RellPackage
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.scoping.IScopeProvider
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import static extension org.junit.Assert.*

@RunWith(XtextRunner)
@InjectWith(RellInjectorProvider)
class RellScopeProviderTest {
	@Inject extension ParseHelper<Model>
	@Inject extension ValidationTestHelper
	@Inject extension IScopeProvider

	@Test def void testScopeProvider() {
		'''operation o(i:integer){
				
					j:integer=i;
				}
		'''.parse.operations.head => [
			assertScope(RellPackage.eINSTANCE.variable_Declaration, "i, j, o.i, o.j")

		]
	}
	@Test def void testScopeProvider1() {
		'''operation o(i:integer){
					i:integer;
					j:integer=i;
				}
		'''.parse.operations.head => [
			assertScope(RellPackage.eINSTANCE.variable_Declaration, "i, i, j, o.i, o.i, o.j")

		]
	}

	def private assertScope(EObject context, EReference reference, CharSequence expected) {
		expected.toString.assertEquals(context.getScope(reference).allElements.map[name].join(", "))
	}

}
