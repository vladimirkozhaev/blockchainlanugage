package org.blockchain.rell.typing

import org.blockchain.rell.rell.ClassDefinition
import org.eclipse.xtend.lib.annotations.Accessors

class RellClassType implements RellType {
	@Accessors(PUBLIC_GETTER)
	ClassDefinition rellClassDefinition;
	
	new(ClassDefinition rellClassDefinition){
		this.rellClassDefinition=rellClassDefinition;
	}
	override String toString() {
		"Rell class";
	}
}