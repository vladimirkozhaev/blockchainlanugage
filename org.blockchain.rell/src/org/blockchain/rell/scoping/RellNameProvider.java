package org.blockchain.rell.scoping;

import java.util.List;

import org.blockchain.rell.rell.RellPackage;
import org.blockchain.rell.rell.TableNameWithAlias;
import org.eclipse.xtext.naming.DefaultDeclarativeQualifiedNameProvider;
import org.eclipse.xtext.naming.QualifiedName;
import org.eclipse.xtext.nodemodel.INode;
import org.eclipse.xtext.nodemodel.util.NodeModelUtils;

public class RellNameProvider extends DefaultDeclarativeQualifiedNameProvider  {
	public QualifiedName qualifiedName(TableNameWithAlias t) {
		QualifiedName result = null;
		if (t.getClassRefDecl() != null) {
			if (t.getClassRefDecl().getName() != null) {
				result = getConverter().toQualifiedName(t.getClassRefDecl().getName());
			}
		}
		if (t.getJustNameDecl() != null) {
			List<INode> nodes = NodeModelUtils.findNodesForFeature(t.getJustNameDecl(), RellPackage.Literals.JUST_NAME_DECL__NAME);
			if (!nodes.isEmpty()) {
				result = getConverter().toQualifiedName(nodes.get(0).getText());
			}
		}
		return result;
	}
}
