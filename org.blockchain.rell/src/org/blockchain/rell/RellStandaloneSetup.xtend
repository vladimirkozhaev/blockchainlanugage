/*
 * generated by Xtext 2.14.0
 */
package org.blockchain.rell


/**
 * Initialization support for running Xtext languages without Equinox extension registry.
 */
class RellStandaloneSetup extends RellStandaloneSetupGenerated {

	def static void doSetup() {
		new RellStandaloneSetup().createInjectorAndDoEMFRegistration()
	}
}
