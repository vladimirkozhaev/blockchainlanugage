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
import org.blockchain.rell.rell.PrimitiveType
import org.blockchain.rell.rell.StringConstant
import org.blockchain.rell.rell.TypeReference
import org.blockchain.rell.rell.Variable
import org.blockchain.rell.rell.VariableDeclaration
import org.blockchain.rell.rell.VariableRef
import javax.lang.model.element.VariableElement

class RellTypeProvider {

	public static val STRING_TYPE = new StringType
	public static val INT_TYPE = new IntType
	public static val BOOL_TYPE = new BoolType
	public static val BYTE_ARRAY = new ByteArray
	public static val JSON = new Json

	def dispatch RellType typeFor(Expression e) {
		switch (e) {
			StringConstant: RellTypeProvider.STRING_TYPE
			IntConstant: RellTypeProvider.INT_TYPE
			BoolConstant: RellTypeProvider.BOOL_TYPE
			Not: RellTypeProvider.BOOL_TYPE
			MulOrDiv: RellTypeProvider.INT_TYPE
			Minus: RellTypeProvider.INT_TYPE
			Comparison: RellTypeProvider.BOOL_TYPE
			Equality: RellTypeProvider.BOOL_TYPE
			And: RellTypeProvider.BOOL_TYPE
			Or: RellTypeProvider.BOOL_TYPE
			VariableRef:{
				val VariableRef varRef=e as VariableRef
				varRef.value.typeFor
			}
			default: e.or.typeFor
		}
	}

	def dispatch RellType typeFor(VariableDeclaration declaration) {
		val name=declaration.name;
		switch (name) {
			case 'name':RellTypeProvider.STRING_TYPE
			case 'tuid':RellTypeProvider.BYTE_ARRAY
			case 'pubkey':RellTypeProvider.STRING_TYPE
			default: {
				val primitive = declaration.type.primitive
				if (primitive !== null) {

					primitive.typeFor

				} else if (declaration.type.entityType !== null) {
					null;
				}

			}
		}

	}

	def dispatch RellType typeFor(Plus e) {
		val leftType = e.left.typeFor
		val rightType = e.right?.typeFor
		if (leftType == RellTypeProvider.STRING_TYPE || rightType == RellTypeProvider.STRING_TYPE)
			RellTypeProvider.STRING_TYPE
		else
			RellTypeProvider.INT_TYPE
	}

	def dispatch RellType typeFor(TypeReference e) {
		if (e.primitive != null) {
			e.primitive.typeFor;
		} else {
			null;
		}

	}

	def typeFor(PrimitiveType primitiveType) {
		switch (primitiveType.primitiveType) {
			case "text": RellTypeProvider.STRING_TYPE
			case "tuid": RellTypeProvider.STRING_TYPE
			case "name": RellTypeProvider.STRING_TYPE
			case "integer": RellTypeProvider.INT_TYPE
			case "timestamp": RellTypeProvider.INT_TYPE
			case "bool": RellTypeProvider.BOOL_TYPE
		}

	}

	def dispatch RellType typeFor(Variable variable) {
		variable.declaration.typeFor
	}

	def dispatch RellType typeFor(VariableRef varRef) {
		if (varRef.value === null)
			return null
		else
			return varRef.value.typeFor
	}

	def isInt(RellType type) { type == RellTypeProvider.INT_TYPE }

	def isString(RellType type) { type == RellTypeProvider.STRING_TYPE }

	def isBoolean(RellType type) { type == RellTypeProvider.BOOL_TYPE }

}
