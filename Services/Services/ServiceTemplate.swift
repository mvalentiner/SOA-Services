//
//  ServiceTemplate.swift
//  Places
//
//  Created by Michael Valentiner on 3/20/19.
//  Copyright © 2019 Michael Valentiner. All rights reserved.
//

import Foundation

/// Template for implementing services.  Replace "ServiceTemplate" with the service name.

private struct ServiceTemplateName {
	static let serviceName = "ServiceTemplate"
}

extension ServiceRegistryImplementation {
	var serviceTemplate : ServiceTemplate {
		get {
			return serviceWith(name: ServiceTemplateName.serviceName) as! ServiceTemplate	// Intentional force unwrapping
		}
	}
}

protocol ServiceTemplate : SOAService {
	func exampleServiceFunction()
}

extension ServiceTemplate {
	var serviceName : String {
		get {
			return ServiceTemplateName.serviceName
		}
	}

	func exampleServiceFunction() {
	}
}

internal class ServiceTemplateImplementation : ServiceTemplate {
	// Only define one register function.
	static func register() {
		ServiceTemplateImplementation().register()
	}

	// Register the service as a lazy service.
//	static func register() {
//		ServiceRegistry.add(service: SOALazyService(serviceName: ServiceTemplateName.serviceName, serviceGetter: { ServiceTemplateImplementation() }))
//	}
}
