package org.blockchain.rell.typing

import com.google.inject.Inject
import java.util.List
import org.blockchain.rell.rell.Expression
import org.blockchain.rell.rell.ExpressionsModel
import org.blockchain.rell.rell.Operation
import org.blockchain.rell.rell.Variable
import org.blockchain.rell.rell.VariableInit
import org.blockchain.rell.rell.VariableRef
import org.eclipse.xtext.AbstractElement
import org.eclipse.xtext.util.IResourceScopeCache

import static extension org.eclipse.xtext.EcoreUtil2.*

class RellModelUtil {

	@Inject IResourceScopeCache cache

	def isVariableDefinedBefore(VariableRef varRef) {
		varRef.variablesDefinedBefore.contains(varRef.variable)
	}

	def isVariableDefinedBefore(VariableInit varRef) {
		varRef.variablesDefinedBefore.contains(varRef.name)
	}

	def variablesDefinedBefore(Expression e) {
		e.getContainerOfType(AbstractElement).variablesDefinedBefore
	}

	def variablesDefinedBefore(VariableInit e) {
		e.getContainerOfType(AbstractElement).variablesDefinedBefore
	}

	def variablesDefinedBefore(AbstractElement containingElement) {
		cache.get(containingElement, containingElement.eResource) [
			val allElements = (containingElement.eContainer as ExpressionsModel).elements

			allElements.subList(
				0,
				allElements.indexOf(containingElement)
			).typeSelect(Variable).toSet
		]
	}

	def  variablesList(Operation operation) {
		val List<String> variableInitList = newArrayList;
		operation.parameters.value.forEach [element, index | variableInitList.add(element.name)]
		operation.statements.stream.forEach[if (this instanceof Variable) {
			println(this)
		} ]
	}
}
