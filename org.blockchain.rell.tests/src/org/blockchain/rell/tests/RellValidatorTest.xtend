package org.blockchain.rell.tests

import com.google.inject.Inject
import org.blockchain.rell.rell.ExpressionsModel
import org.blockchain.rell.rell.RellPackage
import org.blockchain.rell.validation.RellValidator
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(RellInjectorProvider))
class RellValidatorTest {
	@Inject extension ParseHelper<ExpressionsModel>
	@Inject extension ValidationTestHelper
	

	@Test
	def void testEntityExtendsItself() {
		'''class Test extends Test{
			
		}'''.parse.assertError(RellPackage.eINSTANCE.theClass, RellValidator::HIERARCHY_CYCLE,
			"cycle in hierarchy of entity 'Test'")
	}

}
