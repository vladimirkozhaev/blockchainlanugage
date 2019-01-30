/*
 * generated by Xtext 2.14.0
 */
package org.blockchain.rell.validation

import com.google.inject.Inject
import java.util.ArrayList
import java.util.List
import org.blockchain.rell.rell.ClassDefinition
import org.blockchain.rell.rell.Expression
import org.blockchain.rell.rell.Model
import org.blockchain.rell.rell.Operation
import org.blockchain.rell.rell.RellPackage
import org.blockchain.rell.typing.RellModelUtil
import org.blockchain.rell.typing.RellType
import org.blockchain.rell.typing.RellTypeProvider
import org.blockchain.rell.typing.VariableReferenceInfo
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.validation.Check
import org.blockchain.rell.rell.Record

/**
 * Custom validation rules. 
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#validation
 */
class RellValidator extends AbstractRellValidator {

	@Inject extension RellTypeProvider
	@Inject extension RellModelUtil

	protected static val ISSUE_CODE_PREFIX = "org.blockchain.rell."

	public static val FORWARD_REFERENCE = ISSUE_CODE_PREFIX + "ForwardReference";

	public static val NOT_UNIQUE_NAME = ISSUE_CODE_PREFIX + "NotUniqueName";
	
	public static val NOT_INIT_VARIABLE = ISSUE_CODE_PREFIX + "NotInitVariable";

	public static val WRONG_TYPE = ISSUE_CODE_PREFIX + "WrongType";

	public static val HIERARCHY_CYCLE = ISSUE_CODE_PREFIX + "HierarchyCycle";

	public static val MORE_TNAN_ONE_VARIABLE = ISSUE_CODE_PREFIX + "Copy"

	public static val TYPE_MISMATCH = ISSUE_CODE_PREFIX + "TypeMismatch"

	public static val NOT_UNIQUE_NANE = "Name should be unique"

	public static val DUPLICATE_ATTRIBUTE_NAME = "Attribute with the same name already is defined"
//
//	@Check
//	def void checkOperation(Operation operation) {
//
//		val List<VariableReferenceInfo> variableDeclarations = operation.usedVariables;
//
//		variableDeclarations.reverse;
//
//		for (var i = 0; i < variableDeclarations.length; i++) {
//			val element = variableDeclarations.get(i);
//			val sublistToCheck = new ArrayList(variableDeclarations.subList(i, variableDeclarations.length));
//			var boolean isDeclared = false
//			var boolean isInit = false;
//			for (var j = 0; j < sublistToCheck.length; j++) {
//				if (sublistToCheck.get(j).variableDeclaration == element.variableDeclaration) {
//					if (sublistToCheck.get(j).isDeclared) {
//						isDeclared = true
//					}
//
//					if (sublistToCheck.get(j).isInit) {
//						isInit = true;
//					}
//
//				}
//
//			}
//
//			if (!isDeclared ) {
//				error("Forward reference " + element.variableDeclaration.name,
//					RellPackage::eINSTANCE.operation_Statements, FORWARD_REFERENCE)
//
//			}
//
//			if ((!isInit) && element.isUsed) {
//				error("Variable is not init " + element.variableDeclaration.name,
//					RellPackage::eINSTANCE.operation_Statements, NOT_INIT_VARIABLE)
//
//			}
//
//		}
//
//	}
//
//	@Check
//	def checkNoCycleClassHierarhy(ClassDefinition theClass) {
//		if (theClass.superType === null) {
//			return;
//		}
//		val visitedClasses = <ClassDefinition>newHashSet();
//		
//		var current = theClass
//		while (current !== null) {
//			if (visitedClasses.contains(current)) {
//				error("cycle in hierarchy of entity '" + current.name + "'",
//					RellPackage::eINSTANCE.classDefinition_SuperType, HIERARCHY_CYCLE)
//				return
//			}
//			visitedClasses.add(current)
//			current = current.superType
//		}
//
//	}
//
//	@Check
//	def typeReferenceImpl(TypeReference typeReference) {
//	}
//
//	@Check
//	def checkType(Or or) {
//		checkExpectedBoolean(or.left, RellPackage.Literals.OR__LEFT)
//		checkExpectedBoolean(or.right, RellPackage.Literals.OR__RIGHT)
//	}
//
//	@Check
//	def checkType(MulOrDiv mulOrDiv) {
//		checkExpectedInt(mulOrDiv.left, RellPackage.Literals.MUL_OR_DIV__LEFT)
//		checkExpectedInt(mulOrDiv.right, RellPackage.Literals.MUL_OR_DIV__RIGHT)
//	}
//
//	@Check
//	def checkType(Minus minus) {
//		checkExpectedInt(minus.left, RellPackage.Literals.MINUS__LEFT)
//		checkExpectedInt(minus.right, RellPackage.Literals.MINUS__RIGHT)
//	}
//
//	@Check def checkType(Equality equality) {
//		val leftType = getTypeAndCheckNotNull(equality.left, RellPackage.Literals.EQUALITY__LEFT)
//		val rightType = getTypeAndCheckNotNull(equality.right, RellPackage.Literals.EQUALITY__RIGHT)
//		checkExpectedSame(leftType, rightType)
//	}
//
//	@Check def checkVariable(Variable variable) {
//		val typeDecl = variable.name.type;
//		val typeExpr = variable.expression;
//		if (typeDecl===null){
//			return true;
//		}
//		if (typeExpr !== null) {
//			checkExpectedSame(typeDecl.typeFor, typeExpr.typeFor);
//		}
//	}
//
//	@Check def checkVariable(VariableInit init) {
//		val typeDecl = init.name;
//		val typeExpr = init.expression;
//		if (typeExpr !== null) {
//			val typeDeclType = typeDecl.typeFor
//			val typeExprType = typeExpr.typeFor
//			checkExpectedSame(typeDeclType, typeExprType);
//		}
//	}
//
//	@Check def checkType(Comparison comparison) {
//		val leftType = getTypeAndCheckNotNull(comparison.left, RellPackage.Literals.COMPARISON__LEFT)
//		val rightType = getTypeAndCheckNotNull(comparison.right, RellPackage.Literals.COMPARISON__RIGHT)
//		checkExpectedSame(leftType, rightType)
//		checkNotBoolean(leftType, RellPackage.Literals.COMPARISON__LEFT)
//		checkNotBoolean(rightType, RellPackage.Literals.COMPARISON__RIGHT)
//	}
//
//	@Check def checkType(Plus plus) {
//		val leftType = getTypeAndCheckNotNull(plus.left, RellPackage.Literals.PLUS__LEFT)
//		val rightType = getTypeAndCheckNotNull(plus.right, RellPackage.Literals.PLUS__RIGHT)
//		if (leftType.isInt || rightType.isInt || (!leftType.isString && !rightType.isString)) {
//			checkNotBoolean(leftType, RellPackage.Literals.PLUS__LEFT)
//			checkNotBoolean(rightType, RellPackage.Literals.PLUS__RIGHT)
//		}
//	}
	
	@Check def checkUniqueClassName(Model model) {
		val classNames = <String>newHashSet()
		for(classDefinition : model.entities) {
			val name=switch(classDefinition){
				
				case (classDefinition instanceof ClassDefinition):{
					(classDefinition as ClassDefinition).name;
				}
				case (classDefinition instanceof Record):{
					(classDefinition as Record).name;
				}
			}
			if(classNames.contains(name)) {
				error("Class names should be unique. Class with name " + name + " already exists",
					RellPackage.Literals.CLASS_DEFINITION.getEIDAttribute(), NOT_UNIQUE_NANE)
			}
			classNames.add(name);
		}
		
	}
	

//	@Check def checkUniqueVariableName(Operation operation) {
//		val variableNames = <String>newHashSet()
//		for(statement : operation.getStatements()) {
//			if(statement.getVariable() !== null &&
//				statement.getVariable().getVariable() !== null &&
//				statement.getVariable().getVariable().getName() !== null) {
//					val variableName = statement.getVariable().getVariable().getName().getName()
//					if(variableNames.contains(variableName)) {
//						error("Variable names should be unique. Variable with name " + variableName + " already exists",
//					RellPackage.Literals.OPERATION_VARIABLE.getEIDAttribute(), NOT_UNIQUE_NANE)
//					}
//					variableNames.add(variableName);
//			}			
//		}
//	}
//	
//	@Check def checkVariableInitialization(Operation operation) {
//		val variableNames = <String>newHashSet()
//		for(statement : operation.getStatements()) {
//			if(statement.getVariable() !== null &&
//				statement.getVariable().getVariable() !== null &&
//				statement.getVariable().getVariable().getName() !== null) {
//					val variableName = statement.getVariable().getVariable().getName().getName()
//					variableNames.add(variableName);
//			} else if(statement.getInitialization() !== null) {
//				if(!variableNames.contains(statement.getInitialization().getName())) {
//					error("Variable " + statement.getInitialization().getName() + " is not declared yet.",
//					RellPackage.Literals.VARIABLE_INITIALIZATION.getEIDAttribute(), NOT_DECLARED_YET)
//				}
//			}			
//		}
//	}
//	
//	@Check def checkUniqueAttributeName(ClassDefinition classDefinition) {
//		val attributesName = <String>newHashSet
//
//		for (var i = 0; i < classDefinition.attributeListField.size; i++) {
//			val values = classDefinition.attributeListField.get(i).attributeList.get(0).value
//			if (values.size > 1) {
//				for (var j = 0; j < values.size; j++) {
//					if (attributesName.contains(values.get(j).name.name)) {
//						error(
//							"Attribute with the " + values.get(j).name.name + "name already is defined",
//							RellPackage.Literals.VARIABLE_DECLARATION.EIDAttribute,
//							DUPLICATE_ATTRIBUTE_NAME
//						)
//					}
//					attributesName.add(values.get(j).name.name)
//				}
//			} else {
//				if (attributesName.contains(values.get(0).name.name)) {
//					error(
//						"Attribute with the " + values.get(0).name.name  + " name already is defined",
//						RellPackage.Literals.VARIABLE_DECLARATION.EIDAttribute,
//						DUPLICATE_ATTRIBUTE_NAME
//					)
//				}
//				attributesName.add(values.get(0).name.name)
//			}
//		}
//	}
//	
//	def private checkExpectedSame(RellType left, RellType right) {
//		if (right !== null && left !== null && right != left) {
//			error("expected the same type, but was " + left + ", " + right,
//				RellPackage.Literals.EQUALITY.getEIDAttribute(), TYPE_MISMATCH)
//		}
//	}
//
//	def private checkNotBoolean(RellType type, EReference reference) {
//		if (type.isBoolean) {
//			error("cannot be boolean", reference, TYPE_MISMATCH)
//		}
//	}
//
//	def private checkExpectedBoolean(Expression exp, EReference reference) {
//		checkExpectedType(exp, RellTypeProvider.BOOL_TYPE, reference)
//	}
//
//	def private checkExpectedInt(Expression exp, EReference reference) {
//		checkExpectedType(exp, RellTypeProvider.INT_TYPE, reference)
//	}
//
//	def private checkExpectedType(Expression exp, RellType expectedType, EReference reference) {
//		val actualType = getTypeAndCheckNotNull(exp, reference)
//		if (actualType != expectedType)
//			error(
//				"expected " + expectedType + " type, but was " + actualType,
//				reference,
//				TYPE_MISMATCH
//			)
//	}
//
//	def private RellType getTypeAndCheckNotNull(Expression exp, EReference reference) {
//		val type = exp?.typeFor
//		if (type === null)
//			error("null type", reference, TYPE_MISMATCH)
//		return type;
//	}

//	@Check def checkUniqueAttributeName(ClassDefinition classDefinition) {
//		val attributesName = <String>newHashSet
//		for (var i = 0; i < classDefinition.attributeListField.size; i++) {
//			val values = classDefinition.attributeListField.get(i).attributeList.get(0).value
//			if (values.size > 1) {
//				for (var j = 0; j < values.size; j++) {
//					if (attributesName.contains(values.get(j).name.name)) {
//						error(
//							"Attribute with the " + values.get(j).name.name + "name already is defined",
//							RellPackage.Literals.VARIABLE_DECLARATION.EIDAttribute,
//							DUPLICATE_ATTRIBUTE_NAME
//						)
//					}
//					attributesName.add(values.get(j).name.name)
//				}
//			} else {
//				if (attributesName.contains(values.get(0).name.name)) {
//					error(
//						"Attribute with the " + values.get(0).name.name  + " name already is defined",
//						RellPackage.Literals.VARIABLE_DECLARATION.EIDAttribute,
//						DUPLICATE_ATTRIBUTE_NAME
//					)
//				}
//				attributesName.add(values.get(0).name.name)
//			}
//		}
//	}
	
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
	
//	@Check
//	def void checkVariableDeclarationConflict(Operation operation) {
//		val List<VariableReferenceInfo> variableDeclarations = operation.usedVariables;
//		variableDeclarations.reverse;
//		for (var i = 0; i < variableDeclarations.length - 1; i++) {
//			val element = variableDeclarations.get(i);
//			val sublistToCheck = new ArrayList(variableDeclarations.subList(i + 1, variableDeclarations.length));
//			for (var j = 0; j < sublistToCheck.length; j++) {
//				if (sublistToCheck.get(j).variableDeclaration.name == element.variableDeclaration.name) {
//					error("The variable with the same name is already defined: " + element.variableDeclaration.name,
//					RellPackage::eINSTANCE.operation_Statements, NOT_UNIQUE_NAME)
//				}
//			}
//		}
//	}
//	
//	@Check
//	def void checkVariableDeclarationInitialized(Operation operation) {
//		val List<VariableReferenceInfo> variableDeclarations = operation.usedVariables;
//		variableDeclarations.reverse;
//		for (var i = 0; i < variableDeclarations.length - 1; i++) {
//			val element = variableDeclarations.get(i);
//			val sublistToCheck = new ArrayList(variableDeclarations.subList(i + 1, variableDeclarations.length));
//			for (var j = 0; j < sublistToCheck.length; j++) {
//				if (sublistToCheck.get(j).variableDeclaration.name == element.variableDeclaration.name) {
//					error("The variable with the same name is already defined: " + element.variableDeclaration.name,
//					RellPackage::eINSTANCE.operation_Statements, NOT_UNIQUE_NAME)
//				}
//			}
//		}
//	}

	def private RellType getTypeAndCheckNotNull(Expression exp, EReference reference) {
		val type = exp?.typeFor
		if (type === null)
			error("null type", reference, TYPE_MISMATCH)
		return type;
	}

}
