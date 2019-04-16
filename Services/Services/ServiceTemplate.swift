//
//  ServiceTemplate.swift
//  Places
//
//  Created by Michael Valentiner on 3/20/19.
//  Copyright © 2019 Michael Valentiner. All rights reserved.
//

import Foundation

//** Template for implementing services.  Replace "ServiceTemplate" with the service name.

private struct ServiceTemplateName {
	static let serviceName = "ServiceTemplate"
}

extension ServiceRegistry {
	var serviceTemplate : ServiceTemplate {
		get {
			return serviceWith(name: ServiceTemplateName.serviceName) as! ServiceTemplate	// Intentional force unwrapping
		}
	}
}

protocol ServiceTemplate : Service {
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
	static func register() {
		SR.add(service: ServiceTemplateImplementation())
	}
}
