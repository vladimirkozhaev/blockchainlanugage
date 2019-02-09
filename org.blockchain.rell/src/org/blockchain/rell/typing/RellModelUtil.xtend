package org.blockchain.rell.typing

import java.util.ArrayList
import java.util.Arrays
import java.util.List
import org.blockchain.rell.rell.And
import org.blockchain.rell.rell.Comparison
import org.blockchain.rell.rell.Create
import org.blockchain.rell.rell.Equality
import org.blockchain.rell.rell.Expression
import org.blockchain.rell.rell.Minus
import org.blockchain.rell.rell.MulOrDiv
import org.blockchain.rell.rell.Operation
import org.blockchain.rell.rell.Or
import org.blockchain.rell.rell.Plus
import org.blockchain.rell.rell.Query
import org.blockchain.rell.rell.RelAttrubutesList
import org.blockchain.rell.rell.Relational
import org.blockchain.rell.rell.Statement
import org.blockchain.rell.rell.Variable
import org.blockchain.rell.rell.VariableDeclarationRef

class RellModelUtil {

	def List<VariableReferenceInfo> usedVariables(Operation operation) {
//		val List<VariableReferenceInfo> variables = newArrayList
//
//		if (operation.parameters !== null) {
//			operation.parameters.value.forEach([ x |
//				{
//					// var VariableReferenceInfo varRefInfo;
//					val Variable v = x as Variable;
//					new VariableReferenceInfo(v.name, true, v.expression !== null, false)
//
//				}
//			])
//		}
//		if (operation.statements !== null) {
//			operation.statements.forEach[el|variables.addAll(usedVariables(el))];
//
//		}
		val parametersInfo = if (operation.parameters !== null)
				operation.parameters.value.map [ parameter |
					new VariableReferenceInfo((parameter as Variable).name, true, true, false)
				]
			else
				newArrayList
		val statementsInfo = if (operation.statements !== null)
				operation.statements.flatMap[x|usedVariables(x)]
			else
				newArrayList;

		parametersInfo.addAll(statementsInfo)
		return parametersInfo
	}

	def List<VariableReferenceInfo> usedVariables(Query operation) {
		val List<VariableReferenceInfo> variables = newArrayList

		if (operation.parameters !== null) {
			operation.parameters.value.forEach([ x |
				{
					// var VariableReferenceInfo varRefInfo;
					val Variable v = x as Variable;
//				Variable v=x as Variable;
					new VariableReferenceInfo(v.name, true, v.expression !== null, false)

				}
			])
		}
		if (operation.statements !== null) {
			operation.statements.forEach[el|variables.addAll(usedVariables(el))];

		}
		variables
	}

	def List<VariableReferenceInfo> usedVariables(Statement statement) {

		val List<VariableReferenceInfo> variables = newArrayList

		switch (statement) {
			case statement.variable !== null: {
				variables.addAll((statement.variable.variable).usedVariables)
			}
			default: {
				variables.addAll((statement.relation).usedVariables)
			}
		}

		variables;
	}

	def List<VariableReferenceInfo> usedVariables(Relational relation) {
		switch (relation) {
//			case (relation instanceof Update): {
//				(relation as Update).usedVariables
//
//			}
//			case (relation instanceof Delete): {
//				(relation as Delete).usedVariables
//
//			}
			case (relation instanceof Create): {
				(relation as Create).usedVariables

			}
			default: {
				newArrayList
			}
		}
	}

//	def List<VariableReferenceInfo> usedVariables(Update update) {
//		val List<VariableReferenceInfo> variables = newArrayList
//		update.conditions.elements.stream.forEach([x|variables.addAll(x.expr.usedVariables)])
//		update.variableList.stream.forEach([x|variables.addAll(x.usedVariables)])
//		variables;
//	}
//
//	def List<VariableReferenceInfo> usedVariables(Delete update) {
//		val List<VariableReferenceInfo> variables = newArrayList
//		update.conditions.elements.stream.forEach([x|variables.addAll(x.expr.usedVariables)])
//		variables;
//	}
	def List<VariableReferenceInfo> usedVariables(Create create) {
		val List<VariableReferenceInfo> variables = newArrayList
		// create.attributeList.forEach([x|variables.addAll(x.usedVariables)]) //.attributeList.usedVariables
		variables

	}

//	def List<VariableReferenceInfo> usedVariables(CreateAttrMember member){
//		if (member instanceof Default){
//			val m=member as Default
//			m.expr.usedVariables
//		}else{
//			val ref = member as VarRefDecl
//			val List<VariableReferenceInfo> variables = newArrayList
//			variables.add(new VariableReferenceInfo(ref.name,false,false,true))
//			variables
//		}
//		val List<VariableReferenceInfo> variables = newArrayList
//		switch(member.name){
//			case (member.name instanceof VariableDeclaration):{
//				variables.add(new VariableReferenceInfo(member.name,false,member.expr!==null,true));
//			
//			}			
//		}
//		
//		if (member.expr!==null){
//			variables.addAll(member.expr.usedVariables)
//		}
//		variables
//	}
	def usedVariables(RelAttrubutesList rellAttributesList) {
		val List<VariableReferenceInfo> variables = newArrayList
		rellAttributesList.value.forEach([x|variables.addAll(x.usedVariables)])
		variables
	}

	def List<VariableReferenceInfo> usedVariables(Variable variable) {
		val List<VariableReferenceInfo> array = new ArrayList
		val varRefInfo = new VariableReferenceInfo(variable.name, true, false, false);
		array.add(varRefInfo)
		if (variable.expression !== null) {
			varRefInfo.isInit = true;
			array.addAll(usedVariables(variable.expression));
		}

		array
	}

//	def List<VariableReferenceInfo> usedVariables(VariableInit variableInit) {
//		var List<VariableReferenceInfo> variables = newArrayList
//		variables.add(new VariableReferenceInfo(variableInit.name))
//		variables.addAll(usedVariables(variableInit.expression))
//
//		variables
//	}
	def List<VariableReferenceInfo> processExpression(Expression expression) {
		var List<VariableReferenceInfo> variables = newArrayList;
		switch (expression) {
			case (expression instanceof Or): {
				variables = usedVariables((expression as Or).left)
				variables.addAll(usedVariables((expression as Or).right))
			}
			case (expression instanceof And): {
				variables = usedVariables((expression as And).left)
				variables.addAll(usedVariables((expression as Or).right))
			}
			case (expression instanceof Equality): {
				variables = usedVariables((expression as Equality).left)
				variables.addAll(usedVariables((expression as Equality).right))
			}
			case (expression instanceof Equality): {
				variables = usedVariables((expression as Equality).left)
				variables.addAll(usedVariables((expression as Equality).right))
			}
			case (expression instanceof Comparison): {
				variables = usedVariables((expression as Comparison).left)
				variables.addAll(usedVariables((expression as Comparison).right))
			}
			case (expression instanceof Plus): {
				variables = usedVariables((expression as Plus).left)
				variables.addAll(usedVariables((expression as Plus).right))
			}
			case (expression instanceof Minus): {
				variables = usedVariables((expression as Plus).left)
				variables.addAll(usedVariables((expression as Plus).right))
			}
			case (expression instanceof MulOrDiv): {
				variables = usedVariables((expression as MulOrDiv).left)
				variables.addAll(usedVariables((expression as MulOrDiv).right))
			}
			case (expression instanceof VariableDeclarationRef): {
			

				variables.add(
					new VariableReferenceInfo((expression as VariableDeclarationRef).decl, false, false, true))
			}
			default:
				variables = new ArrayList<VariableReferenceInfo>()
		}
		variables
	}

	def List<VariableReferenceInfo> usedVariables(VariableDeclarationRef variableDeclRef) {
		return Arrays.asList(new VariableReferenceInfo(variableDeclRef.decl, false, false, true))
	}

//	def List<VariableReferenceInfo> usedVariables(DotValue dotValue) {
//		if (dotValue instanceof VariableDeclarationRef) {
//			(dotValue as VariableDeclarationRef).usedVariables
//		} else {
//			// dotValue.
//			val left = dotValue.left.usedVariables
//			val right = dotValue.right.usedVariables
//			left.addAll(right)
//			left
//
//		}
//	}

	def List<VariableReferenceInfo> usedVariables(Expression expression) {

		val or = expression.or
		if (or !== null) {
			processExpression(or);
		} else {
			processExpression(expression);

		}

	}
}
