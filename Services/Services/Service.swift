//
//  Service.swift
//  Places
//
//  Created by Michael Valentiner on 3/20/19.
//  Copyright © 2019 Michael Valentiner. All rights reserved.
//

protocol Service : class {
	var serviceName : String { get }
}

class LazyService : Service {
	internal let serviceName : String
	internal lazy var serviceGetter : (() -> Service) = {
			if self.service == nil {
    			self.service = self.implementationGetter()
			}
			return self.service!
		}
	private var implementationGetter : (() -> Service)
	private var service : Service? = nil

	init(serviceName : String, serviceGetter : @escaping (() -> Service)) {
		self.serviceName = serviceName
		self.implementationGetter = serviceGetter
	}
}

struct ServiceRegistry {
	private static var serviceDictionary : [String : LazyService] = [:]
	
	internal func add(service: LazyService) {
		ServiceRegistry.serviceDictionary[service.serviceName] = service
	}
	
	internal func add(service: Service) {
		ServiceRegistry.serviceDictionary[service.serviceName] = LazyService(serviceName: service.serviceName, serviceGetter: { service })
	}

	private func get(serviceWithName name: String) -> Service? {
		return ServiceRegistry.serviceDictionary[name]?.serviceGetter()
	}

	internal func serviceWith(name: String) -> Service {
		guard let resolvedService = ServiceRegistry().get(serviceWithName: name) else {
			fatalError("Error: Service \(name) is not registered with the ServiceRegistry.")
		}
		return resolvedService
	}
}

let SR = ServiceRegistry()
