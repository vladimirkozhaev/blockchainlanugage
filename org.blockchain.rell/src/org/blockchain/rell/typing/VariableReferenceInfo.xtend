package org.blockchain.rell.typing

import org.blockchain.rell.rell.VariableDeclaration
import org.eclipse.xtend.lib.annotations.Accessors

class VariableReferenceInfo {

	new(VariableDeclaration variableDeclaration) {
		this.variableDeclaration = variableDeclaration;
	}

	new(VariableDeclaration variableDeclaration, boolean isDeclared, boolean isInit, boolean isUsed) {
		this.variableDeclaration = variableDeclaration;
		this.isDeclared = isDeclared;
		this.isInit = isInit;
		this.isUsed = isUsed;
	}

	@Accessors(PUBLIC_GETTER) val VariableDeclaration variableDeclaration;
	@Accessors(PUBLIC_GETTER, PUBLIC_SETTER) var boolean isDeclared;
	@Accessors(PUBLIC_GETTER, PUBLIC_SETTER) var boolean isInit;
	@Accessors(PUBLIC_GETTER, PUBLIC_SETTER) var boolean isUsed;
	
	override toString() {
		"name:"+variableDeclaration.name+", isDeclared:"+isDeclared+", isInit:"+isInit+", isUsed:"+isUsed
	}

}
