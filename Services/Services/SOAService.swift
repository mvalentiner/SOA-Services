//
//  SOAService.swift
//  Places
//
//  Created by Michael Valentiner on 3/20/19.
//  Copyright © 2019 Michael Valentiner. All rights reserved.
//

// SOAServices and ServiceRegistry implement the Service Locator pattern, https://en.wikipedia.org/wiki/Service_locator_pattern.
// ServiceRegistryImplementation is a registry of SOAServices.
// ServiceRegistry is shorthand for accessing the ServiceRegistryImplementation
let ServiceRegistry = ServiceRegistryImplementation()

protocol SOAService {
	// Every SOAService has a unique name.
	var serviceName : String { get }

	// Every SOAService has a means to register itself with the ServiceRegistry.
	func register()
}

extension SOAService {
	// Default implementation for a service to register itself with the ServiceRegistry.
	internal func register() {
		ServiceRegistry.add(service: self)
	}
}

// SOALazyService is a wrapper class around the actual service that defers instantiation of the service until it is first accessed.
final class SOALazyService : SOAService {
	// SOAService protocol name
	internal let serviceName : String

	// Accessor instantiates the service the first time this is called.
	internal lazy var serviceGetter : (() -> SOAService) = {
		if self.service == nil {
			self.service = self.implementationGetter()
		}
		return self.service!
	}

	// Reference to the closure that instantiates the service.
	private var implementationGetter : (() -> SOAService)

	// Reference to the instantiated service.
	private var service : SOAService? = nil

	// Initializer takes a name and a closure that will instantiate the service.
	internal init(serviceName : String, serviceGetter : @escaping (() -> SOAService)) {
		self.serviceName = serviceName
		self.implementationGetter = serviceGetter
	}
}

// ServiceRegistryImplementation is wrapper around a static [name : SOALazyService] dictionary that adds type safety.
// All services are managed as SOALazyService, whether they are lazy or not.
// https://en.wikipedia.org/wiki/Service_locator_pattern
struct ServiceRegistryImplementation {
	private static var serviceDictionary : [String : SOALazyService] = [:]
	
	internal func add(service: SOALazyService) {
		if ServiceRegistryImplementation.serviceDictionary[service.serviceName] != nil {
			print("WARNING: registering service \(service.serviceName) is already registered.")
		}
		ServiceRegistryImplementation.serviceDictionary[service.serviceName] = service
	}
	
	internal func add(service: SOAService) {
		add(service: SOALazyService(serviceName: service.serviceName, serviceGetter: { service }))
	}

	internal func serviceWith(name: String) -> SOAService {
		guard let resolvedService = ServiceRegistryImplementation().get(serviceWithName: name) else {
			fatalError("Error: SOAService \(name) is not registered with the ServiceRegistry.")
		}
		return resolvedService
	}

	private func get(serviceWithName name: String) -> SOAService? {
		return ServiceRegistryImplementation.serviceDictionary[name]?.serviceGetter()
	}
}
