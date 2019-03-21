/*
 * generated by Xtext 2.10.0
 */
package org.blockchain.rell.scoping

import java.util.List
import javax.inject.Inject
import org.blockchain.rell.rell.AtOperator
import org.blockchain.rell.rell.AttributeListField
import org.blockchain.rell.rell.ClassMemberDef
import org.blockchain.rell.rell.ClassMemberDefinition
import org.blockchain.rell.rell.Create
import org.blockchain.rell.rell.CreateClassPart
import org.blockchain.rell.rell.CreateWhatPart
import org.blockchain.rell.rell.Delete
import org.blockchain.rell.rell.DotValue
import org.blockchain.rell.rell.Expression
import org.blockchain.rell.rell.Operation
import org.blockchain.rell.rell.SelectOp
import org.blockchain.rell.rell.TableNameWithAlias
import org.blockchain.rell.rell.TupleValue
import org.blockchain.rell.rell.TupleValueMember
import org.blockchain.rell.rell.Update
import org.blockchain.rell.rell.VariableDeclaration
import org.blockchain.rell.rell.VariableDeclarationRef
import org.blockchain.rell.typing.RellClassType
import org.blockchain.rell.typing.RellModelUtil
import org.blockchain.rell.typing.RellTypeProvider
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.EcoreUtil2
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

	@Inject extension RellTypeProvider

	protected def classMemberDefinitionScope(ClassMemberDefinition classMemberDefinition,
		VariableDeclarationRef variableDeclarationRef) {
		if (classMemberDefinition.variableDeclarationRef !== null) {
			val parentClassMemberDef = classMemberDefinition.variableDeclarationRef;
			parentClassMemberDef.eResource
			val typeFor = parentClassMemberDef.typeFor
			// EcoreUtil2.getContainerOfType()
			if (typeFor instanceof RellClassType) {
				val variableDeclarationList = (typeFor as RellClassType).rellClassDefinition.attributeListField.
					makeVariableDeclarationList
				return variableDeclarationList
			}
		}
	}

	def List<VariableDeclaration> getVariableDeclarationRefScope(VariableDeclarationRef variableDeclarationRef, EReference ref) {

		val container = variableDeclarationRef.eContainer;

		switch (container) {
			case (container instanceof VariableDeclarationRef): {

				if (container.eContainer instanceof DotValue) {
					val dotValue = container.eContainer as DotValue
					val parent = dotValue.eContainer

					switch (parent ) {
						case (parent instanceof DotValue): {
							val parentDotValue = (parent as DotValue)
							val currentAtom = parentDotValue.atom;
							switch (currentAtom) {
								case (currentAtom instanceof ClassMemberDef): {
									return classMemberDefinitionScope((currentAtom as ClassMemberDef).value,
										variableDeclarationRef)
								}
								case (currentAtom instanceof SelectOp): {

									return (currentAtom as SelectOp).value.getVariableDeclarationRefScope
								}
							}

						}
						case (parent.eContainer instanceof CreateWhatPart): {
							val variablesList = makeWhatPartVariableDeclarations(parent.eContainer.eContainer)
							val operation = EcoreUtil2.getContainerOfType(variableDeclarationRef, Operation)
							if (operation !== null) {
								var operationVars = RellModelUtil.usedVariables(operation as Operation).filter [ variableInfo |
									variableInfo.declared
								].map[variableInfo|variableInfo.variableDeclaration]
								variablesList.addAll(operationVars)
							}
							return variablesList
						}
					}
				}
			}
			case (container instanceof ClassMemberDefinition): {

				val classMemberDefinition = container as ClassMemberDefinition;
				val classRef = classMemberDefinition.classRef;
				if (classRef !== null) {
					val varDeclList = classRef.getVarDeclList
					return varDeclList

				} else {
					val relContainer = variableDeclarationRef.relationalContainer
					return relContainer.tableWithAlias.flatMap[x|x.makeVariableDeclarationList].toList

				}

			}
			case (container instanceof CreateWhatPart && container.eContainer !== null): {
				return makeWhatPartVariableDeclarations(container.eContainer)
			}
			case (container instanceof DotValue): {

				val DotValue dotValue = container as DotValue;

				if (dotValue.eContainer instanceof DotValue) {
					val parentDotValue = dotValue.eContainer as DotValue;
					val parentValue = parentDotValue.atom;

					switch (parentValue) {
						case (parentValue instanceof ClassMemberDefinition): {
							val classMemberDefinition = parentValue as ClassMemberDefinition;
							if (classMemberDefinition.variableDeclarationRef !== null) {
								val parentClassMemberDef = classMemberDefinition.variableDeclarationRef;
								parentClassMemberDef.eResource
								val typeFor = parentClassMemberDef.typeFor
								// EcoreUtil2.getContainerOfType()
								if (typeFor instanceof RellClassType) {
									val variableDeclarationList = (typeFor as RellClassType).rellClassDefinition.
										attributeListField.makeVariableDeclarationList
									return variableDeclarationList
								}
							}

						}
					}
					val variables = variableDeclarationRefScope(variableDeclarationRef,
						dotValue.eContainer.notExressionContainer, ref);
					if (variables !== null) {
						return variables
					}
				}
			}
		}

		return null

	}

	protected def List<VariableDeclaration> variableDeclarationRefScope(VariableDeclarationRef variableDeclarationRef,
		EObject container, EReference ref) {
		switch (container) {
			case (container instanceof ClassMemberDefinition): {
				val notNotExprContainer = (container as ClassMemberDefinition).notClassMemberDefinition
				switch (notNotExprContainer) {
					case (notNotExprContainer instanceof AtOperator): {
						(notNotExprContainer as AtOperator).variableDeclarationRefScope
					}
					case (notNotExprContainer instanceof TupleValueMember): {
						val tupleValue = notNotExprContainer.eContainer as TupleValue
						val nExprContainer = tupleValue.eContainer.notExressionContainer
						if (nExprContainer instanceof AtOperator) {
							return (nExprContainer as AtOperator).variableDeclarationRefScope
						}
					}
					case (notNotExprContainer instanceof DotValue): {

						val parentDotValue = notNotExprContainer as DotValue;
						val atom = parentDotValue.atom;

						switch (atom) {
							case (atom instanceof ClassMemberDefinition): {

								val classMemberDefinition = atom as ClassMemberDefinition;
								val variableDclarationRef = classMemberDefinition.variableDeclarationRef
								if (variableDclarationRef != null) {

									val typeFor = variableDclarationRef.typeFor
									// EcoreUtil2.getContainerOfType()
									if (typeFor instanceof RellClassType) {
										val variableDeclarationList = (typeFor as RellClassType).rellClassDefinition.
											attributeListField.makeVariableDeclarationList
										return variableDeclarationList
									}
								}

							}
						}
					}
				}

			}
			case (container instanceof CreateWhatPart): {
				return container.eContainer.makeWhatPartVariableDeclarations

			}
			case (container instanceof TupleValueMember): {
				val tupleValue = container.eContainer as TupleValue
				val notNotExprContainer = tupleValue.eContainer.notExressionContainer
				if (notNotExprContainer instanceof AtOperator) {
					return (notNotExprContainer as AtOperator).variableDeclarationRefScope
				}
			}
			default: {

				return null;
			}
		}
		val scope = super.getScope(variableDeclarationRef, ref)
		return null;
	}

	def isEObjectCrudOperation(EObject container) {
		(container instanceof AtOperator) || (container instanceof Update) || (container instanceof Create) ||
			(container instanceof Delete)
	}

	def EList<TableNameWithAlias> getTableWithAlias(EObject container) {
		switch (container) {
			case (container instanceof AtOperator): {
				(container as AtOperator).tableNameWithAlias
			}
			case (container instanceof Update): {
				(container as Update).tableNameWithAlias
			}
			case (container instanceof Create): {
				(container as Create).tableNameWithAlias
			}
			case (container instanceof Delete): {
				(container as Delete).tableNameWithAlias
			}
		}
	}

	protected def List<VariableDeclaration> makeWhatPartVariableDeclarations(EObject container) {

		switch (container) {
			case container.isEObjectCrudOperation: {
				return container.tableWithAlias.flatMap[x|x.makeVariableDeclarationList].toList
			}
			case container instanceof CreateClassPart: {
				return (container as CreateClassPart).entity.attributeListField.makeVariableDeclarationList
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

	protected def getClassDefinitionByTableNameWithAlias(TableNameWithAlias tableNameWithAlias) {
		switch (tableNameWithAlias) {
			case (tableNameWithAlias.classRefDecl !== null): {
				return (tableNameWithAlias.classRefDecl).classDef
			}
			case (tableNameWithAlias.justNameDecl !== null): {
				return tableNameWithAlias.justNameDecl.name
			}
		}
	}

	protected def List<VariableDeclaration> makeVariableDeclarationList(TableNameWithAlias tableNameWithAlias) {
		val attributeListField = tableNameWithAlias.getClassDefinitionByTableNameWithAlias.attributeListField

		return attributeListField.makeVariableDeclarationList

	}

	def IScope getClassMemberDefinition(ClassMemberDefinition classMemberDefinition, EObject processedObject,
		EReference ref) {
		val notExprConst = classMemberDefinition.eContainer.notExressionContainer

		switch (notExprConst) {
			case (notExprConst instanceof AtOperator): {

				return (notExprConst as AtOperator).getClassMemberDefScope;
			}
			case (notExprConst instanceof Update): {
				return (notExprConst as Update).getClassMemberDefScope;
			}
		}
		return super.getScope(processedObject, ref);
	}

	/**
	 * Get variable declaration list for the Table Declarations names
	 */
	def getClassMemberDefScope(AtOperator atOperator) {
		val List<TableNameWithAlias> classDefList = newArrayList
		atOperator.tableNameWithAlias.forEach[x|classDefList.add(x)]
		return Scopes::scopeFor(classDefList);
	}

	def getClassMemberDefScope(Update update) {
		val List<TableNameWithAlias> classDefList = newArrayList
		update.tableNameWithAlias.forEach[x|classDefList.add(x)]
		return Scopes::scopeFor(classDefList);
	}

	/**
	 * Return the variable declaration names scope for AtOperator
	 */
	def getVariableDeclarationRefScope(AtOperator atOperator) {
		val List<VariableDeclaration> classDefList = atOperator.tableNameWithAlias.flatMap[x|x.getVarDeclList].toList

		return classDefList;
	}

	/**
	 * Return the variable declaration names scope for Update
	 */
	def getVariableDeclarationRefScope(Update update) {
		val List<VariableDeclaration> classDefList = update.tableNameWithAlias.flatMap [ x |
			x.getClassDefinitionByTableNameWithAlias.attributeListField.makeVariableDeclarationList
		].toList
		val scope = Scopes::scopeFor(classDefList)

		return scope;
	}

	/**
	 * Return the variable declaration names scope for Update
	 */
	def getVariableDeclarationRefScope(Create create) {
		val List<VariableDeclaration> classDefList = create.tableNameWithAlias.flatMap [ x |
			x.getClassDefinitionByTableNameWithAlias.attributeListField.makeVariableDeclarationList
		].toList

		return Scopes::scopeFor(classDefList);
	}

	def List<VariableDeclaration> getVarDeclList(TableNameWithAlias tableNameWithAlias) {

		var EList<AttributeListField> attrubuteListField = tableNameWithAlias.getClassDefinitionByTableNameWithAlias.
			attributeListField
		if (attrubuteListField === null) {
			return newArrayList
		}
		return makeVariableDeclarationList(attrubuteListField);
	}

	def notExressionContainer(EObject context) {
		var privateContainer = context
		while (privateContainer instanceof Expression) {
			privateContainer = privateContainer.eContainer
		}
		return privateContainer;
	}

	def relationalContainer(EObject context) {
		var privateContainer = context
		while (!(privateContainer instanceof AtOperator || privateContainer instanceof Create ||
			privateContainer instanceof Update)) {
			privateContainer = privateContainer.eContainer
		}
		return privateContainer;
	}

	def notClassMemberDefinition(EObject context) {
		var privateContainer = context
		while (privateContainer instanceof ClassMemberDefinition) {
			privateContainer = privateContainer.eContainer
		}
		return privateContainer;
	}

	override IScope getScope(EObject context, EReference reference) {
		switch (context) {
			case (context === null):
				return IScope.NULLSCOPE
			case (context instanceof VariableDeclarationRef): {
				
				val varDeclList=getVariableDeclarationRefScope(context as VariableDeclarationRef, reference);
				if (varDeclList===null||varDeclList.length==0){
					super.getScope(context, reference);
				}else{
					return Scopes::scopeFor(varDeclList)
				}
			}

		}
		return super.getScope(context, reference);

	}

}
