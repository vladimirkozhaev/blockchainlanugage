package org.blockchain.rell.integral

import net.postchain.rell.parser.C_Utils;
import org.blockchain.rell.rell.Model
import org.eclipse.emf.ecore.EObject
import org.apache.log4j.Logger;
import java.io.ByteArrayOutputStream
import java.util.HashMap
import net.postchain.rell.parser.C_Error
import java.util.List

class RellGen {
/* 	
	RellAstChecker astMaker = new RellAstChecker()
	
	static Logger logger = Logger.getLogger(typeof(RellGen))
	
	static List<RellError> noErrors = #[]

	def List<RellError> getCompileErrors(Model m) {
		var resourceSaved = false	
		var compilerOK = false
		var String message = null
		
		try {
			val baos = new ByteArrayOutputStream()
			m.eResource.save(baos, new HashMap())
			val s = new String(baos.toByteArray, java.nio.charset.StandardCharsets.UTF_8)
			resourceSaved = true
			val ast = C_Utils.INSTANCE.parse(s)
			val module = ast.compile(true)
			compilerOK = true			
		} catch (C_Error e) {
			message = e.toString
			logger.error(e.toString)
		} catch (Exception e) {
			logger.error(e.toString)
		}
		
		val ok2 = !resourceSaved || compilerOK
		if (!ok2 && message === null) {
			message = "Unknown error in Rell model"
		}
		if (ok2) {
			return noErrors
		} else {
			return #[new RellError(message)]
		}		
	}
	
	
	def dispatch IRellValidator validate(Model m) {
		val errs = getCompileErrors(m)
		logger.warn(astMaker.compiles(m))
		return [| errs]
	}
	
	def dispatch IRellValidator validate(EObject m) {
		return [| noErrors]
	}
	* 
	*/
}