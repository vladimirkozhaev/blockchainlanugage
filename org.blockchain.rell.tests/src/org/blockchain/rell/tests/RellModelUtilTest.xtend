package org.blockchain.rell.tests

import com.google.inject.Inject
import com.google.inject.Provider
import org.blockchain.rell.rell.Operation
import org.blockchain.rell.services.RellGrammarAccess
import org.blockchain.rell.typing.RellModelUtil
import org.blockchain.rell.typing.RellTypeProvider
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.xtext.ParserRule
import org.eclipse.xtext.resource.XtextResource
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.util.StringInputStream
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(RellInjectorProvider)
class RellModelUtilTest {
	@Inject extension ParseHelper<Operation>
	@Inject extension RellModelUtil
	@Inject extension RellTypeProvider
	@Inject Provider<ResourceSet> rsp
	@Inject
	RellGrammarAccess ga;
	
	
	@Test def void testExpressionVariablesRefCount(){
		
	} 
	
	def Resource assertType(CharSequence input,  ParserRule rule) {

		var rs = rsp.get()
		var r = rs.createResource(URI.createURI("test.rell"));
		(r as XtextResource).entryPoint = rule

		r.load(new StringInputStream(input.toString()), null)
		r
	}
	
//	def private void assertVariablesDefinedBefore(Operation operation, int elemIndex, CharSequence expectedVars) {
//		expectedVars.assertEquals(
//			operation.statements.get(elemIndex).variablesDefinedBefore.map[name].join(",")
//			
//		)
//	}
}