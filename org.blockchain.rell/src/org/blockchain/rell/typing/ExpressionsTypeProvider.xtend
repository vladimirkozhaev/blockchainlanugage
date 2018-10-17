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

import static extension org.blockchain.rell.typing.ExpressionsModelUtil.*

class ExpressionsTypeProvider {
	public static val stringType = new StringType
	public static val intType = new IntType
	public static val boolType = new BoolType
	
	def dispatch ExpressionsType typeFor(Expression e) {
		switch (e) {
			StringConstant: stringType
			IntConstant: intType
			BoolConstant: boolType
			Not: boolType
			MulOrDiv: intType
			Minus: intType
			Comparison: boolType
			Equality: boolType
			And: boolType
			Or: boolType
		}
	}

	def dispatch ExpressionsType typeFor(Plus e) {
		val leftType = e.left.typeFor
		val rightType = e.right?.typeFor
		if (leftType == stringType || rightType == stringType)
			stringType
		else
			intType
	}
	
	def dispatch ExpressionsType typeFor(Variable variable) {
		variable?.expression?.typeFor
	}
	
	def dispatch ExpressionsType typeFor(VariableRef varRef) {
		if (varRef.variable === null || 
				!(variablesDefinedBefore(varRef).contains(varRef.variable)))
			return null
		else
			return varRef.variable.typeFor
	}
	
	def isInt(ExpressionsType type) { type == intType }
	def isString(ExpressionsType type) { type == stringType }
	def isBoolean(ExpressionsType type) { type == boolType }

}
