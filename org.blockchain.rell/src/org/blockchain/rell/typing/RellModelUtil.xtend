package org.blockchain.rell.typing

import java.util.ArrayList
import java.util.List
import org.blockchain.rell.rell.And
import org.blockchain.rell.rell.Comparison
import org.blockchain.rell.rell.Create
import org.blockchain.rell.rell.Delete
import org.blockchain.rell.rell.Equality
import org.blockchain.rell.rell.Expression
import org.blockchain.rell.rell.Minus
import org.blockchain.rell.rell.MulOrDiv
import org.blockchain.rell.rell.Operation
import org.blockchain.rell.rell.Or
import org.blockchain.rell.rell.Plus
import org.blockchain.rell.rell.Relational
import org.blockchain.rell.rell.Statement
import org.blockchain.rell.rell.Update
import org.blockchain.rell.rell.Variable
import org.blockchain.rell.rell.VariableInit
import org.blockchain.rell.rell.VariableRef

class RellModelUtil {

	def List<VariableReferenceInfo> usedVariables(Operation operation) {
		val List<VariableReferenceInfo> variables = newArrayList

		operation.parameters.value.stream.forEach([x|variables.add(new VariableReferenceInfo(x, true, true, false))])

		operation.statements.forEach[el|variables.addAll(usedVariables(el))];
		variables
	}

	def List<VariableReferenceInfo> usedVariables(Statement statement) {

		val List<VariableReferenceInfo> variables = newArrayList

		switch (statement) {
			case statement instanceof Variable: {
				variables.addAll((statement as Variable).usedVariables)
			}
			case statement instanceof VariableInit: {
				variables.add(new VariableReferenceInfo((statement as VariableInit).name, false, true, false))
			}
			default: {
				variables.addAll((statement as Relational).usedVariables)
			}
		}

		variables;
	}

	def List<VariableReferenceInfo> usedVariables(Update update) {
		val List<VariableReferenceInfo> variables = newArrayList
		update.conditions.elements.stream.forEach([x|variables.addAll(x.expr.usedVariables)])
		update.variableList.stream.forEach([x|variables.addAll(x.usedVariables)])
		variables;
	}

	def List<VariableReferenceInfo> usedVariables(Delete update) {
		val List<VariableReferenceInfo> variables = newArrayList
		update.conditions.elements.stream.forEach([x|variables.addAll(x.expr.usedVariables)])
		variables;
	}

	def List<VariableReferenceInfo> usedVariables(Create update) {
		val List<VariableReferenceInfo> variables = newArrayList
		update.conditions.elements.stream.forEach([x|variables.addAll(x.expr.usedVariables)])
		variables;
	}

	def List<VariableReferenceInfo> usedVariables(Variable variable) {
		val List<VariableReferenceInfo> array = new ArrayList
		val varRefInfo = new VariableReferenceInfo(variable.declaration, true, false, false);
		array.add(new VariableReferenceInfo(variable.declaration, true, false, false))
		if (variable.expression !== null) {
			varRefInfo.isInit = true;
			array.addAll(usedVariables(variable.expression));
		}

		array
	}

	def List<VariableReferenceInfo> usedVariables(VariableInit variableInit) {
		var List<VariableReferenceInfo> variables = newArrayList
		variables.add(new VariableReferenceInfo(variableInit.name))
		variables.addAll(usedVariables(variableInit.expression))

		variables
	}

	def List<VariableReferenceInfo> usedVariables(Expression expression) {
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
			case (expression instanceof VariableRef): {
				variables.add(new VariableReferenceInfo((expression as VariableRef).variable,false,false,true))
			}
			default:
				new ArrayList<Variable>()
		}

		variables

	}
}
