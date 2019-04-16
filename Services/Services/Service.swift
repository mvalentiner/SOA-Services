//
//  Service.swift
//  Places
//
//  Created by Michael Valentiner on 3/20/19.
//  Copyright © 2019 Michael Valentiner. All rights reserved.
//

protocol Service {
	// Every Service has a unique name.
	var serviceName : String { get }
	// Every Service has a means to register itself with the ServiceRegistry.
	func register()
}

extension Service {
	// Default implementation for a service to register itself with the ServiceRegistry.
	internal func register() {
		SR.add(service: self)	// ServiceRegistry.add(service: Service)
	}
}

// LazyService is a wrapper class around the actual service that defers instantiation of the service until it is first accessed.
class LazyService : Service {
	// Service protocol name
	internal let serviceName : String
	// Accessor instantiates the service the first time this is called.
	internal lazy var serviceGetter : (() -> Service) = {
			if self.service == nil {
    			self.service = self.implementationGetter()
			}
			return self.service!
		}
	// Reference to the closure that instantiate the service.
	private var implementationGetter : (() -> Service)
	// Reference to the instantiated service.
	private var service : Service? = nil

	// Initializer takes a name and a closure that will instantiate the service.
	internal init(serviceName : String, serviceGetter : @escaping (() -> Service)) {
		self.serviceName = serviceName
		self.implementationGetter = serviceGetter
	}

	internal func register() {
		SR.add(service: self)	// ServiceRegistry.add(service: LazyService)
	}
}

// ServiceRegistry wrapper class around a static [name : LazyService] dictionary that adds type safety and limits the interface.
// All services are managed as LazyService, whether they are lazy or not.
// https://en.wikipedia.org/wiki/Service_locator_pattern
struct ServiceRegistry {
	private static var serviceDictionary : [String : LazyService] = [:]
	
	internal func add(service: LazyService) {
		if ServiceRegistry.serviceDictionary[service.serviceName] != nil {
			print("WARNING: registering service \(service.serviceName) is already registered.")
		}
		ServiceRegistry.serviceDictionary[service.serviceName] = service
	}
	
	internal func add(service: Service) {
		add(service: LazyService(serviceName: service.serviceName, serviceGetter: { service }))
	}

	internal func serviceWith(name: String) -> Service {
		guard let resolvedService = ServiceRegistry().get(serviceWithName: name) else {
			fatalError("Error: Service \(name) is not registered with the ServiceRegistry.")
		}
		return resolvedService
	}

	private func get(serviceWithName name: String) -> Service? {
		return ServiceRegistry.serviceDictionary[name]?.serviceGetter()
	}
}

// Shorthand for accessing the ServiceRegistry
let SR = ServiceRegistry()
