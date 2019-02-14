/*
 * generated by Xtext 2.10.0
 */
package org.blockchain.rell.scoping

import java.util.List
import org.blockchain.rell.rell.AtOperator
import org.blockchain.rell.rell.AttributeListField
import org.blockchain.rell.rell.ClassDefinition
import org.blockchain.rell.rell.ClassMemberDefinition
import org.blockchain.rell.rell.ClassRef
import org.blockchain.rell.rell.ClassRefDecl
import org.blockchain.rell.rell.Create
import org.blockchain.rell.rell.CreateClassPart
import org.blockchain.rell.rell.CreateWhatPart
import org.blockchain.rell.rell.Delete
import org.blockchain.rell.rell.DotValue
import org.blockchain.rell.rell.Expression
import org.blockchain.rell.rell.JustNameDecl
import org.blockchain.rell.rell.TableNameWithAlias
import org.blockchain.rell.rell.Update
import org.blockchain.rell.rell.VariableDeclaration
import org.blockchain.rell.rell.VariableDeclarationRef
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.scoping.Scopes
import org.eclipse.xtext.scoping.impl.AbstractDeclarativeScopeProvider

/**
 * This class contains custom scoping description.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#scoping
 * on how and when to use it.
 */
class RellScopeProvider extends AbstractDeclarativeScopeProvider {

	def IScope getVariableDeclarationRefScope(VariableDeclarationRef variableDeclarationRef, EReference ref) {

		val container = variableDeclarationRef.eContainer;
		switch (container) {
			case (container instanceof ClassMemberDefinition): {
				val classMemberDefinition = container as ClassMemberDefinition;
				val classDefinition = classMemberDefinition.classRef;
				if (classDefinition !== null) {
					var EList<AttributeListField> attrubuteListField;
					switch (classDefinition.value) {
						case (classDefinition.value instanceof ClassRefDecl): {
							val classRefDecl = classDefinition.value as ClassRefDecl
							attrubuteListField = classRefDecl.classDef.attributeListField;
						}
						case (classDefinition.value instanceof JustNameDecl): {
							val justNameDecl = classDefinition as JustNameDecl
							attrubuteListField = justNameDecl.name.attributeListField;
						}
					}
					if (attrubuteListField === null) {
						return IScope.NULLSCOPE;
					}

					val variableDeclarationList = makeVariableDeclarationList(attrubuteListField);

					val scope = Scopes::scopeFor(variableDeclarationList)
					return scope

				} else {
					return getVariableDeclRefDBOper(container.eContainer.notExressionContainer)
				}
			}
			case (container instanceof CreateWhatPart): {
				val scope = makeWhatPartScope(container)
				return scope
			}
			case (container instanceof DotValue): {
				val DotValue dotValue = container as DotValue;
				return variableDeclarationRefScope(variableDeclarationRef,ref,dotValue.eContainer.notExressionContainer);
			}
			case (container instanceof VariableDeclarationRef): {
				val notExprContainer = container.notExressionContainer;
				return variableDeclarationRefScope(variableDeclarationRef,ref,notExprContainer)
			}
		}
		return super.getScope(variableDeclarationRef, ref)

	}

	protected def IScope variableDeclarationRefScope(VariableDeclarationRef variableDeclarationRef,EReference ref,EObject notExprContainer) {
		switch (notExprContainer) {
			case (notExprContainer instanceof AtOperator): {
				val atOperator = notExprContainer as AtOperator
				val List<VariableDeclaration> variableDeclarationList = newArrayList
				atOperator.tableNameWithAlias.forEach [ tableNameWithAlias |
					{
						switch (tableNameWithAlias) {
							case (tableNameWithAlias instanceof JustNameDecl): {
								val nameDecl = tableNameWithAlias as JustNameDecl
								val classDefinition = nameDecl.name
								variableDeclarationList.addAll(
									classDefinition.attributeListField.makeVariableDeclarationList)
							}
						}
					}
				]
				return Scopes::scopeFor(variableDeclarationList)
			}
			case (notExprContainer instanceof Update): {
				val update = notExprContainer as Update
				return Scopes::scopeFor(update.entity.attributeListField.makeVariableDeclarationList)
			}
			case (notExprContainer instanceof Delete): {
				val delete = notExprContainer as Delete
				val List<VariableDeclaration> variableDeclarationList = delete.entity.attributeListField.
					makeVariableDeclarationList
				return Scopes::scopeFor(variableDeclarationList)
			}
			case (notExprContainer instanceof Create): {
				val update = notExprContainer as Create
				return Scopes::scopeFor(update.entity.attributeListField.makeVariableDeclarationList)
			}
			case (notExprContainer instanceof CreateWhatPart): {
				return notExprContainer.makeWhatPartScope

			}default:{
				val scope=super.getScope(variableDeclarationRef,ref)
				//println("scope"+scope.allElements)
				return scope;
			}
		}
	}

	protected def IScope makeWhatPartScope(EObject container) {
		var ClassDefinition en;
		switch (container.eContainer) {
			case container.eContainer instanceof Create: {
				en = (container.eContainer as Create).entity
			}
			case container.eContainer instanceof Update: {
				en = (container.eContainer as Update).entity
			}
			case container.eContainer instanceof CreateClassPart:{
				en=(container.eContainer as CreateClassPart).entity
			}
		}

		val scope = Scopes::scopeFor(en.attributeListField.makeVariableDeclarationList)
		scope
	}

	def getVariableDeclRefDBOper(EObject notExprContainer) {
		switch (notExprContainer) {
			case (notExprContainer instanceof Update): {
				val update = notExprContainer as Update
				return Scopes::scopeFor(update.entity.attributeListField.makeVariableDeclarationList)
			}
			case (notExprContainer instanceof Delete): {
				val delete = notExprContainer as Delete
				val List<VariableDeclaration> variableDeclarationList = delete.entity.attributeListField.
					makeVariableDeclarationList
				return Scopes::scopeFor(variableDeclarationList)
			}
			case (notExprContainer instanceof Create): {
				val update = notExprContainer as Create
				return Scopes::scopeFor(update.entity.attributeListField.makeVariableDeclarationList)
			}
			case (notExprContainer instanceof AtOperator): {

				val atOperator = notExprContainer as AtOperator
				val List<VariableDeclaration> variableDeclarationList = newArrayList
				atOperator.tableNameWithAlias.forEach [ tableNameWithAlias |
					{
						switch (tableNameWithAlias) {
							case (tableNameWithAlias instanceof JustNameDecl): {
								val nameDecl = tableNameWithAlias as JustNameDecl
								val classDefinition = nameDecl.name
								variableDeclarationList.addAll(
									classDefinition.attributeListField.makeVariableDeclarationList)
							}
						}
					}
				]
				return Scopes::scopeFor(variableDeclarationList)
			}
			case (notExprContainer instanceof CreateWhatPart): {
				return notExprContainer.makeWhatPartScope

			}
		}

	}

	protected def List<VariableDeclaration> makeVariableDeclarationList(EList<AttributeListField> attrubuteListField) {
		val List<VariableDeclaration> variableDeclarationList = newArrayList;
		attrubuteListField.forEach [ x |
			if (x.attributeList !== null) {
				x.attributeList.forEach [ attrList |
					if (attrList !== null && attrList.value !== null) {
						attrList.value.forEach [ variable |
							{
								if (variable !== null) {
									variableDeclarationList.add(variable.name)
								}
							}
						]
					}
				]
			}
		]
		variableDeclarationList
	}

	def IScope getClassRefScope(ClassRef classRef, EReference ref) {

		val container = classRef.eContainer.notExressionContainer;
		if (container instanceof ClassMemberDefinition) {

			val notExprCont = container.eContainer.notExressionContainer

			if (notExprCont instanceof AtOperator) {
				val atOperator = notExprCont as AtOperator
				val List<TableNameWithAlias> classDefList = newArrayList
				atOperator.tableNameWithAlias.forEach[x|classDefList.add(x)]
				return Scopes::scopeFor(classDefList);
			}
		}
		return super.getScope(classRef, ref);

	}

	def notExressionContainer(EObject context) {
		var privateContainer = context
		while (privateContainer instanceof Expression) {
			privateContainer = privateContainer.eContainer
		}
		return privateContainer;
	}

	override IScope getScope(EObject context, EReference reference) {
		switch (context) {
			case (context === null):
				return IScope.NULLSCOPE
			case (context instanceof VariableDeclarationRef): {
				return getVariableDeclarationRefScope(context as VariableDeclarationRef, reference);
			}
			case (context instanceof ClassRef): {
				return getClassRefScope(context as ClassRef, reference);
			}
		}
		return super.getScope(context, reference);

	}

}
