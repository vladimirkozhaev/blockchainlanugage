package org.blockchain.rell.integral

import org.eclipse.emf.ecore.EObject
import java.util.List
import org.blockchain.rell.rell.Model

class RellCompleteValidationAPI {	
	RellValidationState state = null;

	public static List<RellError> noErrors = #[]

	def resetState() {
		state = null
	}

	def List<RellError> validate(EObject o) {
		if (o instanceof Model) {
			resetState()
			state = new RellValidationState(o)
		}
		if (state === null) {
			// TODO: we can go upwards to find the model
			return noErrors;
		} else return state.errorsFor(o);
	}
}