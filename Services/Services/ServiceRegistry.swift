//
//  ServiceRegistry.swift
//  Services
//
//  Created by Michael Valentiner on 2/6/18.
//  Copyright © 2018 Heliotropix. All rights reserved.
//

import Foundation

struct ServiceRegistry {
	private static var serviceDictionary : [String : Service] = [:]
	
	internal func addService(_ service : Service, withName name: String) {
		ServiceRegistry.serviceDictionary[name] = service.resolve()
	}
	
	internal func getService(withName name: String) -> Service? {
		return ServiceRegistry.serviceDictionary[name]
	}
}
