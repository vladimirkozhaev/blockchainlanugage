package org.blockchain.rell.integral

import org.blockchain.rell.rell.Model
import java.util.List
import org.eclipse.emf.ecore.EObject
import java.util.HashMap

class RellValidationState {
	
	HashMap<EObject, List<RellError>> errorMap = new HashMap();
	
	new (Model m) {
		val checker = new RellAstChecker;
		checker.computeErrors(m, errorMap)
	}
	
	def List<RellError> errorsFor(EObject o) {
		val errs = errorMap.get(o)
		RellAstChecker.logger.warn(o.toString + " has " + 
			if (errs !== null) "errors" else "no errors"
		)
		if (errs !== null) {
			return errs
		} else return RellCompleteValidationAPI.noErrors;
	}
}