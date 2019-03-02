/*
 * generated by Xtext 2.14.0
 */
package org.blockchain.rell.validation

import com.google.inject.Inject
import java.util.ArrayList
import java.util.List
import org.blockchain.rell.rell.ClassDefinition
import org.blockchain.rell.rell.Expression
import org.blockchain.rell.rell.Model
import org.blockchain.rell.rell.Operation
import org.blockchain.rell.rell.RellPackage
import org.blockchain.rell.typing.RellModelUtil
import org.blockchain.rell.typing.RellType
import org.blockchain.rell.typing.RellTypeProvider
import org.blockchain.rell.typing.VariableReferenceInfo
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.validation.Check
import org.blockchain.rell.integral.RellCompleteValidationAPI
import org.eclipse.emf.ecore.EObject
import org.blockchain.rell.rell.VariableDeclaration

/**
 * Custom validation rules.
 *
 * see http://www.eclipse.org/Xtext/documentation.html#validation
 */
class RellValidator extends AbstractRellValidator {

	@Inject extension RellTypeProvider
	@Inject extension RellModelUtil

	protected static val ISSUE_CODE_PREFIX = "org.blockchain.rell."

	public static val FORWARD_REFERENCE = ISSUE_CODE_PREFIX + "ForwardReference";

	public static val NOT_UNIQUE_NAME = ISSUE_CODE_PREFIX + "NotUniqueName";

	public static val NOT_INIT_VARIABLE = ISSUE_CODE_PREFIX + "NotInitVariable";

	public static val WRONG_TYPE = ISSUE_CODE_PREFIX + "WrongType";

	public static val HIERARCHY_CYCLE = ISSUE_CODE_PREFIX + "HierarchyCycle";

	public static val MORE_TNAN_ONE_VARIABLE = ISSUE_CODE_PREFIX + "Copy"

	public static val TYPE_MISMATCH = ISSUE_CODE_PREFIX + "TypeMismatch"

	public static val NOT_UNIQUE_NANE = "Name conflict"

	public static val DUPLICATE_VARIABLE_NAME = "Duplicate variable"
	
	public static val DUPLICATE_ATTRIBUTE_NAME = "Duplicate attribute"

	public static val SEMANTIC_ERROR = "It doesn't really work"

	val RellCompleteValidationAPI rellAPI = new RellCompleteValidationAPI();

	@Check
	def rellrValidate(EObject o) {
		val errs = rellAPI.validate(o)
		if (!errs.empty) {
			errs.forEach[e | 
				error(e.error,
					RellPackage.Literals.MODEL.getEIDAttribute(), SEMANTIC_ERROR)
			]
			
		}
	}
}
