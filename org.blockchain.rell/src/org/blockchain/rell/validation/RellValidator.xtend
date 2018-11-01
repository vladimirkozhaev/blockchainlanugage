/*
 * generated by Xtext 2.14.0
 */
package org.blockchain.rell.validation

import com.google.inject.Inject
import java.util.List
import org.blockchain.rell.rell.ClassDefinition
import org.blockchain.rell.rell.Comparison
import org.blockchain.rell.rell.Equality
import org.blockchain.rell.rell.Expression
import org.blockchain.rell.rell.Minus
import org.blockchain.rell.rell.MulOrDiv
import org.blockchain.rell.rell.Operation
import org.blockchain.rell.rell.Or
import org.blockchain.rell.rell.Plus
import org.blockchain.rell.rell.RellPackage
import org.blockchain.rell.rell.TypeReference
import org.blockchain.rell.rell.Variable
import org.blockchain.rell.rell.VariableInit
import org.blockchain.rell.rell.VariableRef
import org.blockchain.rell.typing.RellModelUtil
import org.blockchain.rell.typing.RellType
import org.blockchain.rell.typing.RellTypeProvider
import org.blockchain.rell.typing.VariableReferenceInfo
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.validation.Check
import java.util.ArrayList

/**
 * Custom validation rules. 
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#validation
 */
class RellValidator extends AbstractRellValidator {

	@Inject extension RellTypeProvider
	@Inject extension RellModelUtil
	
	
	protected static val ISSUE_CODE_PREFIX = "org.blockchain.rell."
	
	public static val FORWARD_REFERENCE = ISSUE_CODE_PREFIX+"expressions.ForwardReference";

	public static val WRONG_TYPE = ISSUE_CODE_PREFIX+"WrongType";

	public static val HIERARCHY_CYCLE = ISSUE_CODE_PREFIX+"HierarchyCycle";

	public static val MORE_TNAN_ONE_VARIABLE = ISSUE_CODE_PREFIX+"Copy"

	public static val TYPE_MISMATCH = ISSUE_CODE_PREFIX + "TypeMismatch"
	
	

	@Check
	def void checkOperation(Operation operation) {
		
		val List<VariableReferenceInfo> variableDeclarations=operation.usedVariables;
		
		variableDeclarations.reverse;
		
		for (var i = 0 ; i < variableDeclarations.length ; i++) {
  			val element=variableDeclarations.get(i);
  			val sublistToCheck=new ArrayList(variableDeclarations.subList(i,variableDeclarations.length));
  			var boolean isDeclared=false
  			for (var j=0;j<sublistToCheck.length;j++){
  				if (sublistToCheck.get(j).variableDeclaration==element.variableDeclaration&&sublistToCheck.get(j).isDeclared){
  					isDeclared=true
  				}
  			}
  			
  			if (!isDeclared){
  				error("Forward reference " + element.variableDeclaration.name,	RellPackage::eINSTANCE.operation_Statements, FORWARD_REFERENCE)
  				
  			}

		}
		

	}

	@Check
	def checkNoCycleClassHierarhy(ClassDefinition theClass) {
		if (theClass.superType === null) {
			return;
		}
		val visitedClasses = <ClassDefinition>newHashSet();
		visitedClasses.add(theClass);
		var current = theClass
		while (current !== null) {
			if (visitedClasses.contains(current)) {
				error("cycle in hierarchy of entity '" + current.name + "'", RellPackage::eINSTANCE.classDefinition_SuperType,
					HIERARCHY_CYCLE)
				return
			}
			visitedClasses.add(current)
			current = current.superType
		}

	}

	@Check
	def typeReferenceImpl(TypeReference typeReference) {
	}

	@Check
	def checkType(Or or) {
		checkExpectedBoolean(or.left, RellPackage.Literals.OR__LEFT)
		checkExpectedBoolean(or.right, RellPackage.Literals.OR__RIGHT)
	}

	@Check
	def checkType(MulOrDiv mulOrDiv) {
		checkExpectedInt(mulOrDiv.left, RellPackage.Literals.MUL_OR_DIV__LEFT)
		checkExpectedInt(mulOrDiv.right, RellPackage.Literals.MUL_OR_DIV__RIGHT)
	}

	@Check
	def checkType(Minus minus) {
		checkExpectedInt(minus.left, RellPackage.Literals.MINUS__LEFT)
		checkExpectedInt(minus.right, RellPackage.Literals.MINUS__RIGHT)
	}

	@Check def checkType(Equality equality) {
		val leftType = getTypeAndCheckNotNull(equality.left, RellPackage.Literals.EQUALITY__LEFT)
		val rightType = getTypeAndCheckNotNull(equality.right, RellPackage.Literals.EQUALITY__RIGHT)
		checkExpectedSame(leftType, rightType)
	}

	@Check def checkVariable(Variable variable) {
		val typeDecl = variable.declaration.type;
		val typeExpr = variable.expression;
		if (typeExpr !== null) {
			checkExpectedSame(typeDecl.typeFor, typeExpr.typeFor);
		}
	}

	@Check def checkVariable(VariableInit init) {
		val typeDecl = init.name;
		val typeExpr = init.expression;
		if (typeExpr !== null) {
			val typeDeclType = typeDecl.typeFor
			val typeExprType = typeExpr.typeFor
			checkExpectedSame(typeDeclType, typeExprType);
		}
	}

	@Check def checkType(Comparison comparison) {
		val leftType = getTypeAndCheckNotNull(comparison.left, RellPackage.Literals.COMPARISON__LEFT)
		val rightType = getTypeAndCheckNotNull(comparison.right, RellPackage.Literals.COMPARISON__RIGHT)
		checkExpectedSame(leftType, rightType)
		checkNotBoolean(leftType, RellPackage.Literals.COMPARISON__LEFT)
		checkNotBoolean(rightType, RellPackage.Literals.COMPARISON__RIGHT)
	}

	@Check def checkType(Plus plus) {
		val leftType = getTypeAndCheckNotNull(plus.left, RellPackage.Literals.PLUS__LEFT)
		val rightType = getTypeAndCheckNotNull(plus.right, RellPackage.Literals.PLUS__RIGHT)
		if (leftType.isInt || rightType.isInt || (!leftType.isString && !rightType.isString)) {
			checkNotBoolean(leftType, RellPackage.Literals.PLUS__LEFT)
			checkNotBoolean(rightType, RellPackage.Literals.PLUS__RIGHT)
		}
	}

	def private checkExpectedSame(RellType left, RellType right) {
		if (right !== null && left !== null && right != left) {
			error("expected the same type, but was " + left + ", " + right,
				RellPackage.Literals.EQUALITY.getEIDAttribute(), TYPE_MISMATCH)
		}
	}

	def private checkNotBoolean(RellType type, EReference reference) {
		if (type.isBoolean) {
			error("cannot be boolean", reference, TYPE_MISMATCH)
		}
	}

	def private checkExpectedBoolean(Expression exp, EReference reference) {
		checkExpectedType(exp, RellTypeProvider.BOOL_TYPE, reference)
	}

	def private checkExpectedInt(Expression exp, EReference reference) {
		checkExpectedType(exp, RellTypeProvider.INT_TYPE, reference)
	}

	def private checkExpectedType(Expression exp, RellType expectedType, EReference reference) {
		val actualType = getTypeAndCheckNotNull(exp, reference)
		if (actualType != expectedType)
			error(
				"expected " + expectedType + " type, but was " + actualType,
				reference,
				TYPE_MISMATCH
			)
	}

	def private RellType getTypeAndCheckNotNull(Expression exp, EReference reference) {
		val type = exp?.typeFor
		if (type === null)
			error("null type", reference, TYPE_MISMATCH)
		return type;
	}
}
