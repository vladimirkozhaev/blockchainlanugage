package org.blockchain.rell.typing

import org.blockchain.rell.rell.And
import org.blockchain.rell.rell.BoolConstant
import org.blockchain.rell.rell.Comparison
import org.blockchain.rell.rell.Equality
import org.blockchain.rell.rell.Expression
import org.blockchain.rell.rell.IntConstant
import org.blockchain.rell.rell.Minus
import org.blockchain.rell.rell.MulOrDiv
import org.blockchain.rell.rell.Not
import org.blockchain.rell.rell.Or
import org.blockchain.rell.rell.Plus
import org.blockchain.rell.rell.StringConstant
import org.blockchain.rell.rell.Variable
import org.blockchain.rell.rell.VariableRef

import org.blockchain.rell.rell.VariableDeclaration
import static extension org.blockchain.rell.typing.RellModelUtil.*

class RellTypeProvider {
	
	
	public static val STRING_TYPE = new StringType
	public static val INT_TYPE = new IntType
	public static val BOOL_TYPE = new BoolType

	def dispatch RellType typeFor(Expression e) {
		switch (e) {
			StringConstant: org.blockchain.rell.typing.RellTypeProvider.STRING_TYPE
			IntConstant: org.blockchain.rell.typing.RellTypeProvider.INT_TYPE
			BoolConstant: org.blockchain.rell.typing.RellTypeProvider.BOOL_TYPE
			Not: org.blockchain.rell.typing.RellTypeProvider.BOOL_TYPE
			MulOrDiv: org.blockchain.rell.typing.RellTypeProvider.INT_TYPE
			Minus: org.blockchain.rell.typing.RellTypeProvider.INT_TYPE
			Comparison: org.blockchain.rell.typing.RellTypeProvider.BOOL_TYPE
			Equality: org.blockchain.rell.typing.RellTypeProvider.BOOL_TYPE
			And: org.blockchain.rell.typing.RellTypeProvider.BOOL_TYPE
			Or: org.blockchain.rell.typing.RellTypeProvider.BOOL_TYPE
		}
	}

	def dispatch RellType typeFor(VariableDeclaration declaration) {
		val primitive=declaration.type.primitive
		if (primitive !== null) {

			switch (primitive) {
			case "text":org.blockchain.rell.typing.RellTypeProvider.STRING_TYPE
			case "tuid":org.blockchain.rell.typing.RellTypeProvider.STRING_TYPE
			case "name":org.blockchain.rell.typing.RellTypeProvider.STRING_TYPE
			case "integer":org.blockchain.rell.typing.RellTypeProvider.INT_TYPE 
			case "timestamp":org.blockchain.rell.typing.RellTypeProvider.INT_TYPE
			default:null
			
//			"text": stringType
//			IntConstant: intType
//			BoolConstant: boolType
//			Not: boolType
//			MulOrDiv: intType
//			Minus: intType
//			Comparison: boolType
//			Equality: boolType
//			And: boolType
//			Or: boolType
			}
		}
	}

	def dispatch RellType typeFor(Plus e) {
		val leftType = e.left.typeFor
		val rightType = e.right?.typeFor
		if (leftType == org.blockchain.rell.typing.RellTypeProvider.STRING_TYPE || rightType == org.blockchain.rell.typing.RellTypeProvider.STRING_TYPE)
			org.blockchain.rell.typing.RellTypeProvider.STRING_TYPE
		else
			org.blockchain.rell.typing.RellTypeProvider.INT_TYPE
	}

	def dispatch RellType typeFor(Variable variable) {
		variable?.expression?.typeFor
	}

	def dispatch RellType typeFor(VariableRef varRef) {
		if (varRef.variable === null || !(variablesDefinedBefore(varRef).contains(varRef.variable)))
			return null
		else
			return varRef.variable.typeFor
	}

	def isInt(RellType type) { type == org.blockchain.rell.typing.RellTypeProvider.INT_TYPE }

	def isString(RellType type) { type == org.blockchain.rell.typing.RellTypeProvider.STRING_TYPE }

	def isBoolean(RellType type) { type == org.blockchain.rell.typing.RellTypeProvider.BOOL_TYPE }

}
