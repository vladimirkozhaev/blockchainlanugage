package org.blockchain.rell.scoping

import com.google.inject.Inject
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.resource.IContainer
import org.eclipse.xtext.resource.impl.ResourceDescriptionsProvider
import org.blockchain.rell.rell.RellPackage
import org.eclipse.emf.ecore.EClass

class RellIndex {
//	@Inject ResourceDescriptionsProvider rdp
//
//	@Inject IContainer.Manager cm
//	
//	def getVisibleEObjectDescriptions(EObject o) {
//		o.getVisibleContainers.map[ container |
//			container.getExportedObjects
//		].flatten
//	}
//
//	def getVisibleEObjectDescriptions(EObject o, EClass type) {
//		o.getVisibleContainers.map[ container |
//			container.getExportedObjectsByType(type)
//		].flatten
//	}
//
//	def getVisibleClassesDescriptions(EObject o) {
//		o.getVisibleEObjectDescriptions(RellPackage::eINSTANCE.classDefinition)
//	}
//	
//	def getVisibleOperationsDescriptions(EObject o) {
//		o.getVisibleEObjectDescriptions(RellPackage::eINSTANCE.operation)
//	}
//
//	def getVisibleContainers(EObject o) {
//		val index = rdp.getResourceDescriptions(o.eResource)
//		val rd = index.getResourceDescription(o.eResource.URI)
//		if (rd != null)
//			cm.getVisibleContainers(rd, index)
//		else
//			emptyList
//	}
//	
//	def getResourceDescription(EObject o) {
//		val index = rdp.getResourceDescriptions(o.eResource)
//		index.getResourceDescription(o.eResource.URI)
//	}
//
//	def getExportedEObjectDescriptions(EObject o) {
//		o.getResourceDescription.getExportedObjects
//	}
//	
//	def getVisibleExternalClassesDescriptions(EObject o) {
//		val allVisibleClasses =	
//			o.getVisibleClassesDescriptions
//		val allExportedClasses =
//			o.getExportedClassesEObjectDescriptions
//		val difference = allVisibleClasses.toSet
//		difference.removeAll(allExportedClasses.toSet)
//		return difference.toMap[qualifiedName]
//	}
//	
//	def getExportedClassesEObjectDescriptions(EObject o) {
//		o.getResourceDescription.getExportedObjectsByType(RellPackage.eINSTANCE.classDefinition)
//	}
}