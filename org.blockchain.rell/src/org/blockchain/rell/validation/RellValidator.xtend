/*
 * generated by Xtext 2.14.0
 */
package org.blockchain.rell.validation

import org.blockchain.rell.rell.RellPackage
import org.blockchain.rell.rell.TheClass
import org.eclipse.xtext.validation.Check
import org.blockchain.rell.rell.VariableRef

import static extension org.example.expressions.typing.ExpressionsModelUtil.*
import org.blockchain.rell.rell.Operation

/**
 * Custom validation rules. 
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#validation
 */
class RellValidator extends AbstractRellValidator {

	public static val FORWARD_REFERENCE = "org.example.expressions.ForwardReference";

	public static val WRONG_TYPE = "org.example.expressions.WrongType";

	public static val HIERARCHY_CYCLE = "org.blockchain.rell.entities.HierarchyCycle";

		


	@Check
	def checkNoCycleClassHierarhy(TheClass theClass) {
		if (theClass.superType === null) {
			return;
		}
		val visitedClasses = <TheClass>newHashSet();
		visitedClasses.add(theClass);
		var current = theClass.superType
		while (current !== null) {
			if (visitedClasses.contains(current)) {
				error("cycle in hierarchy of entity '" + current.name + "'", RellPackage::eINSTANCE.theClass_SuperType,HIERARCHY_CYCLE)
				return
			}
			visitedClasses.add(current)
			current = current.superType
		}

	}
}
