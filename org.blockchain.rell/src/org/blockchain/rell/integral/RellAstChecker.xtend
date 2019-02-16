package org.blockchain.rell.integral

import net.postchain.rell.parser.*;
import org.blockchain.rell.rell.*
import java.util.List
import java.util.HashMap
import org.eclipse.emf.ecore.EObject
import java.util.Map
import org.apache.log4j.Logger;

class RellAstChecker {
	
	HashMap<EObject, Integer> objectMap = new HashMap()
	HashMap<Integer, EObject> reverseObjectMap = new HashMap()	
	
	public static Logger logger = Logger.getLogger(typeof(RellAstChecker))
	
	private def S_Pos getPos(EObject o) {
		var line = objectMap.get(o)
		if (line === null) {
			line = objectMap.size
			objectMap.put(o, line)
			reverseObjectMap.put(line, o)
		}
		new S_Pos(line, 0)
	}
	
	private def S_Name getName(EObject o, String name) {
		new S_Name(getPos(o), name)
	}
		
def S_AttributeClause make_S_RelClause(AttributeListField alf) {
		val a = alf.attributeList.get(0).value.get(0)		
		val name = a.name.name
		val type = a.name.type
		val typename = if (type !== null) {
				new S_NameType(getName(a.name.type, type.type))
		}
		val attr = new S_NameTypePair(
			getName(a.name, name),
			typename			
		)
		new S_AttributeClause(
			attr, alf.mutable !== null, null			
		)
	}

	def S_ClassDefinition make_S_ClassDefinition(ClassDefinition cd) {
		val List<S_AttributeClause> clauses = cd.attributeListField.map[
			alf| make_S_RelClause(alf)
		]
		new S_ClassDefinition(getName(cd, cd.name),
			clauses
		)
	}


	def S_Definition make_S_Definition_Operation(EObject e) {
		throw new RuntimeException("Operation not supported")

	}

	def S_Definition make_S_Definition_Entity(EObject e) {
		if (e instanceof ClassDefinition)
			return make_S_ClassDefinition(e)
	 //   else if(e instanceof Record)
	  //      return make_S_RecordDefinition(e)
		else throw new RuntimeException("Record definition not supported")
	}

	def S_ModuleDefinition make_S_ModuleDefinition(Model m) {
		val List<S_Definition> entityDefs = m.entities.map[e| make_S_Definition_Entity(e)]
		val List<S_Definition> operationDefs = m.operations.map[o| make_S_Definition_Operation(o)]
		new S_ModuleDefinition((entityDefs + operationDefs).toList())
	} 
	
	def computeErrors (Model m, Map<EObject, List<RellError>> target) {
		val modDef = make_S_ModuleDefinition(m)
		try {
			val rModule = modDef.compile(true)
		} catch (C_Error e) {
			logger.error("Caught error via rellr" + e.errMsg)
			var obj = reverseObjectMap.get(e.pos.row)
			if (obj === null) obj = m; // this really should not happen...
			logger.warn("Creating error for" + obj.toString)
			target.put(obj, #[new RellError("rellr says: " + e.errMsg)])
		}		
	}
	
}