package org.blockchain.rell.typing

import org.blockchain.rell.rell.Expression
import org.blockchain.rell.rell.ExpressionsModel
import org.blockchain.rell.rell.VariableDeclaration

import static org.eclipse.emf.ecore.util.EcoreUtil.*

import static extension org.eclipse.xtext.EcoreUtil2.*

class RellModelUtil {
	
	def static variablesDefinedBefore(Expression e) {
		val allElements = e.getContainerOfType(typeof(ExpressionsModel)).elements
		val containingElement = allElements.findFirst[isAncestor(it, e)]
		allElements.subList(0, allElements.indexOf(containingElement)).typeSelect(typeof(VariableDeclaration))
	}
}
