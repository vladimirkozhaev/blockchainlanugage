package org.blockchain.rell.integral

import net.postchain.rell.parser.*;
import org.blockchain.rell.rell.*
import java.util.List
import java.util.HashMap
import org.eclipse.emf.ecore.EObject
import java.util.Map
import org.apache.log4j.Logger;
import org.blockchain.rell.rell.impl.ExpressionImpl
import org.blockchain.rell.rell.impl.IntConstantImpl

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
		
	def List<S_AttributeClause> make_S_RelClause(AttributeListField alf) {
		var response = newArrayList;
		for(var i = 0; i < alf.attributeList.get(0).value.size(); i++) {
			val a = alf.attributeList.get(0).value.get(0)		
			val name = a.name.name
			val type = a.name.type
			val typename = if (type !== null) {
					new S_NameType(getName(type, type.type))
			}
			val attr = new S_NameTypePair(
				getName(a.name, name),
				typename			
			)
			response.add(new S_AttributeClause(
				attr, alf.mutable !== null, if(a.expression != null)convertToS_Expr(a.expression) else null			
			))
		}
		return response;
	}

	def S_ClassDefinition make_S_ClassDefinition(ClassDefinition cd) {
		val List<S_AttributeClause> clauses = cd.attributeListField.map[
			alf| make_S_RelClause(alf)
		].flatMap[it].toList()
		new S_ClassDefinition(getName(cd, cd.name),
			clauses
		)
	}

//	def S_RecordDefinition make_S_RecordDefinition(Record record) {
//		val List<S_AttributeClause> clauses = record.attributeListField.flatMap[
//			alf| make_S_RelClauses(alf)
//		].toList()
//		new S_RecordDefinition(getName(record, record.name),
//			clauses
//		)
//	}

	def S_OpDefinition make_S_OperationDefinition(Operation operation) {
		val sNmmeTypePairs = newArrayList
		if(operation.parameters != null) {
			for(var i = 0; i < operation.parameters.value.length; i++) {
				val a = operation.parameters.value.get(i)
				val name = a.name.name
				val type = a.name.type
				val typename = if (type !== null) {
						new S_NameType(getName(a.name.type, name))
				}
				val attr = new S_NameTypePair(
					getName(a.name, name),
					typename
				)
	
				sNmmeTypePairs.add(attr)
			}
		}
		var statements = newArrayList;
		for(var i = 0; i < operation.getStatements().size(); i++) {
			val currentStatement = operation.getStatements().get(i)
			var S_Statement currentsStatement = null
			if(currentStatement.relation != null) {
				val op = currentStatement.relation.operation;
				if(op instanceof Update) {
					val List<S_AtExprFrom> from = newArrayList
					from.add(new S_AtExprFrom(null, new S_Name(getPos(op), op.entity.name)))
					val conditions = op.conditions.map[it | convertToS_Expr(it)].toList()
					val where = new S_AtExprWhere(conditions)
					
					val what = op.createWhatPart.map[it| new S_UpdateWhat(getPos(it), new S_Name(getPos(it), it.varDeclRef.name.name), S_AssignOpCode.EQ, convertToS_Expr(it.condition.get(0)))]
					currentsStatement = new S_UpdateStatement(getPos(op), from, where, what)
				} else if(op instanceof Create) {
					val List<S_AtExprFrom> from = newArrayList
					from.add(new S_AtExprFrom(null, new S_Name(getPos(op), op.entity.name)))
					val conditions = op.createWhatPart.flatMap[it | it.condition].map[it | convertToS_Expr(it)].toList()
					val to = new S_AtExprWhere(conditions)
					currentsStatement = new S_DeleteStatement(getPos(op), from, to)
				} else if(op instanceof Delete) {
					val List<S_AtExprFrom> from = newArrayList
					from.add(new S_AtExprFrom(null, new S_Name(getPos(op), op.entity.name)))
					val conditions = op.conditions.map[it | convertToS_Expr(it)].toList()
					val to = new S_AtExprWhere(conditions)
					currentsStatement = new S_DeleteStatement(getPos(op), from, to)
				} else if(op instanceof AtOperator) {
					currentsStatement = new S_VarStatement((new S_Name(getPos(op), "")), new S_NameType(new S_Name(getPos(op), "")), null)
					System.out.println(op);
				} else {
					throw new RuntimeException("Unsupported operation type");
				}
			} else if(currentStatement.variable != null) {
				val variable = currentStatement.variable.variable;
				if(currentStatement.variable.assessModificator == "val") {
					val sName = new S_Name(getPos(variable), variable.name.name)
					val typeName = variable.name.type?.type ?: ""
					val sNameType = new S_NameType(new S_Name(getPos(variable), typeName))
					currentsStatement = new S_ValStatement(sName, sNameType, convertToS_Expr(variable.expression))
				} else if(currentStatement.variable.assessModificator == "var") {
					val sName = new S_Name(getPos(variable), variable.name.name)
					val typeName = variable.name.type?.type ?: ""
					val sNameType = new S_NameType(new S_Name(getPos(variable), typeName))
					currentsStatement = new S_VarStatement(sName, sNameType, convertToS_Expr(variable.expression))
				} else {
					throw new RuntimeException("Unknown assessModificator");
				}
			} else if(currentStatement.varInitiation != null) {
				//todo
			}
			statements.add(currentsStatement)
		}
		
		new S_OpDefinition(getName(operation, operation.name),
			sNmmeTypePairs, new S_BlockStatement(statements)
		)
	}
	
	private def S_Expr convertToS_Expr(Expression e) {
		switch (e) {
			StringConstant: new S_StringLiteralExpr(getPos(e), e.value)
			IntConstant: new S_IntLiteralExpr(getPos(e), Integer.valueOf(e.value))
			BoolConstant: new S_BooleanLiteralExpr(getPos(e), Boolean.valueOf(e.value))
			ByteArrayConstant: {
				new S_ByteArrayLiteralExpr(getPos(e), hexStringToByteArray(e.value.substring(1)))
			}
			Not: new S_UnaryExpr(getPos(e), new S_Node(getPos(e),S_UnaryOp_Not), new S_NameExpr(new S_Name(getPos(e), "")))
			MulOrDiv: {
				val binaryExpressionTails = newArrayList
				binaryExpressionTails.add(new S_BinaryExprTail(new S_Node(getPos(e), S_BinaryOpCode.PLUS), new S_IntLiteralExpr(getPos(e), Integer.valueOf((e.right as IntConstant).value))))
					new S_BinaryExpr(
						new S_IntLiteralExpr(getPos(e), Integer.valueOf((e.left as IntConstant).value)), 
						binaryExpressionTails
				)
			}	
			Minus: {
				val binaryExpressionTails = newArrayList
				binaryExpressionTails.add(new S_BinaryExprTail(new S_Node(getPos(e), S_BinaryOpCode.MINUS), new S_IntLiteralExpr(getPos(e), Integer.valueOf((e.right as IntConstant).value))))
					new S_BinaryExpr(
						new S_IntLiteralExpr(getPos(e), Integer.valueOf((e.left as IntConstant).value)), 
						binaryExpressionTails
				)
			}
			Comparison: {
				val binaryExpressionTails = newArrayList
				binaryExpressionTails.add(new S_BinaryExprTail(new S_Node(getPos(e), S_BinaryOpCode.EQ_REF), new S_IntLiteralExpr(getPos(e), Integer.valueOf((e.right as IntConstant).value))))
					new S_BinaryExpr(
						new S_IntLiteralExpr(getPos(e), Integer.valueOf((e.left as IntConstant).value)), 
						binaryExpressionTails
				)
			}
			Equality: {
				val binaryExpressionTails = newArrayList
				binaryExpressionTails.add(new S_BinaryExprTail(new S_Node(getPos(e), S_BinaryOpCode.EQ), new S_IntLiteralExpr(getPos(e), Integer.valueOf((e.right as IntConstant).value))))
					new S_BinaryExpr(
						new S_IntLiteralExpr(getPos(e), Integer.valueOf((e.left as IntConstant).value)), 
						binaryExpressionTails
				)
			}
			And: {
				val binaryExpressionTails = newArrayList
				binaryExpressionTails.add(new S_BinaryExprTail(new S_Node(getPos(e), S_BinaryOpCode.AND), new S_IntLiteralExpr(getPos(e), Integer.valueOf((e.right as IntConstant).value))))
					new S_BinaryExpr(
						new S_IntLiteralExpr(getPos(e), Integer.valueOf((e.left as IntConstant).value)), 
						binaryExpressionTails
				)
			}
			Or: {
				val binaryExpressionTails = newArrayList
				binaryExpressionTails.add(new S_BinaryExprTail(new S_Node(getPos(e), S_BinaryOpCode.OR), new S_IntLiteralExpr(getPos(e), Integer.valueOf((e.right as IntConstant).value))))
					new S_BinaryExpr(
						new S_IntLiteralExpr(getPos(e), Integer.valueOf((e.left as IntConstant).value)), 
						binaryExpressionTails
				)
			}
			ExpressionImpl: {
				convertToS_Expr(e.or)
			//	new S_StringLiteralExpr(getPos(e), e.or.value)
				
			}
			default: throw new RuntimeException("Unknown expression")
		}
	}

	def S_QueryDefinition make_S_QueryDefinition(Query query) {
		val sNmmeTypePairs = newArrayList
		for(var i = 0; i < query.parameters.value.length; i++) {
			val a = query.parameters.value.get(i)
			val name = a.name.name
			val type = a.name.type
			val typename = if (type !== null) {
					new S_NameType(getName(a.name.type, name))
			}
			val attr = new S_NameTypePair(
				getName(a.name, name),
				typename
			)

			sNmmeTypePairs.add(attr)
		}

		var type = query.type;
		val returnType =
			if(type.tuple != null) {
				val List<kotlin.Pair<S_Name, S_NameType>> fields = type.tuple.getVarDecl().map[e|
					val name = new S_Name(getPos(e), e.name)
					new kotlin.Pair(name, new S_NameType(name))
				]
				new S_TupleType(fields)
			} else if(type.map != null){
				val key = type.map.map.keySpec.type;
				val value = type.map.map.valSpec.type;
				new S_MapType(getPos(type), 
					new S_NameType(new S_Name(getPos(type), key)), 
						new S_NameType(new S_Name(getPos(type), key)));
			} else if(type.set != null){
				val setType = type.set.set.listType.type;
				new S_SetType(getPos(type), 
					new S_NameType(new S_Name(getPos(type), setType)));
			} else if(type.list != null){
				val listType = type.list.list.listType.type;
				new S_ListType(getPos(type), 
					new S_NameType(new S_Name(getPos(type), listType)));
			} else {
				throw new RuntimeException("Type not supported");
			}
		val functionBody = new S_FunctionBodyFull(new S_EmptyStatement());
		return new S_QueryDefinition(getName(query, query.name),
			sNmmeTypePairs, returnType, functionBody);

//		new S_QueryDefinition(getName(operation, operation.name),
//			sNmmeTypePairs, new S_EmptyStatement()
//		)
	}

	def S_Definition make_S_Definition_Operation(EObject e) {
		if (e instanceof Operation)
			return make_S_OperationDefinition(e)
	    else if(e instanceof Query)
	        return make_S_QueryDefinition(e)
		else throw new RuntimeException("Operation not supported")
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
		try {
			val modDef = make_S_ModuleDefinition(m)
			val rModule = modDef.compile(true)
			System.out.println()
		} catch (C_Error e) {
			logger.error(e.errMsg)
			var obj = reverseObjectMap.get(e.pos.row)
			if (obj === null) obj = m; // this really should not happen...
			logger.warn("Creating error for" + obj.toString)
			target.put(obj, #[new RellError(e.errMsg)])
		} catch(RuntimeException e) {
			logger.error(e)
			var obj = m
			target.put(obj, #[new RellError(e.toString())])
		}
	}
	
	def hexStringToByteArray(String s) {
    val len = s.length();
    val data = newByteArrayOfSize(len / 2);
    for (var i = 0; i < len; i += 2) {
    	val nextByte = Byte.valueOf(((Character.digit(s.charAt(i), 16) << 4) + Character.digit(s.charAt(i+1), 16)).toString)
        data.set(i / 2, nextByte);
    }
    return data;
}
	
}