//
//  ServiceTemplate.swift
//  Places
//
//  Created by Michael Valentiner on 3/20/19.
//  Copyright © 2019 Michael Valentiner. All rights reserved.
//

import Foundation

//** Template for implementing services.  Replace "ServiceTemplate" with the service name.

// 1) define a unique name for the service
private let serviceTemplateName = "ServiceTemplate"

extension ServiceRegistry {
	var serviceTemplate : ServiceTemplate {
		get {
			return serviceWith(name: serviceTemplateName) as! ServiceTemplate	// Intentional force unwrapping
		}
	}
}

internal class ServiceTemplateImplementation : ServiceTemplate {
	static func register() {
		ServiceTemplateImplementation().register()
	}
}

internal class LazyServiceTemplateImplementation : ServiceTemplate {
	static func register() {
		LazyService(serviceName: serviceTemplateName, serviceGetter: { LazyServiceTemplateImplementation() }).register()
	}
}

protocol ServiceTemplate : Service {
	func exampleServiceFunction()
}

extension ServiceTemplate {
	var serviceName : String { get { return serviceName } }

	func exampleServiceFunction() {
	}
}
