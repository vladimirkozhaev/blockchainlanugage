package org.blockchain.rell.tests

import java.util.List
import javax.inject.Inject
import org.blockchain.rell.rell.Model
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor
import org.eclipse.xtext.testing.IRegistryConfigurator
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.eclipse.xtext.util.EmfFormatter
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.Parameterized
import org.junit.runners.Parameterized.Parameter
import org.junit.runners.model.FrameworkMethod
import org.junit.runners.model.InitializationError
import org.junit.runners.model.Statement
import org.junit.runners.parameterized.ParametersRunnerFactory
import org.junit.runners.parameterized.TestWithParameters

import static org.blockchain.rell.tests.ZipSources.getZipData

@FinalFieldsConstructor
@RunWith(typeof(Parameterized))
@InjectWith(RellInjectorProvider)
@Parameterized.UseParametersRunnerFactory(XtextParametersRunnerFactory)
class RellTestFromZip {
	static val zipFileName = "testsources.rell.zip"
	
	@Parameterized.Parameters
	def static Iterable<String> data() {
		return getZipData(zipFileName)
	}
	
	@Parameter
	val String s
		
	@Inject
	ParseHelper<Model> parseHelper
	@Inject 
	extension ValidationTestHelper
	

	@Test
	def void test() {
		Assert.assertNotNull(s)
		println(s)
		val result = parseHelper.parse(s)
//		println(EmfFormatter.objToStr(result))
		result.assertNoErrors
	}
}

class XtextParametersRunnerFactory implements ParametersRunnerFactory {

	override createRunnerForTestWithParameters(TestWithParameters test) throws InitializationError {
		new ParameterizedXtextRunner(test)
	}

}

class ParameterizedXtextRunner extends XtextRunner {

	val Object[] parameters

	new(TestWithParameters test) throws InitializationError {
		super(test.testClass.javaClass)
		parameters = test.parameters
	}

	override protected createTest() throws Exception {
		val object = testClass.onlyConstructor.newInstance(parameters)
		val injectorProvider = getOrCreateInjectorProvider
		if (injectorProvider != null) {
			val injector = injectorProvider.injector
			if (injector != null)
				injector.injectMembers(object)
		}
		return object
	}
	
	
	override protected Statement methodBlock(FrameworkMethod method) {
		val injectorProvider = getOrCreateInjectorProvider
		 if (injectorProvider instanceof IRegistryConfigurator) {
		 	val registryConfigurator = injectorProvider
		 	registryConfigurator.setupRegistry
		 	val methodBlock = superMethodBlock(method)
		 	return new Statement() {
                override void evaluate() throws Throwable {
                    try {
                        methodBlock.evaluate();
                    } finally {
                        registryConfigurator.restoreRegistry();
                    }
                }
            };
		 } else {
            return superMethodBlock(method)
         }	    
	}
	
	override protected void validateConstructor(List<Throwable> errors) {
		validateOnlyOneConstructor(errors)
	}

}

 