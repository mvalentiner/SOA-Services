//
//  Service.swift
//  Services
//
//  Created by Michael Valentiner on 1/6/18.
//  Copyright © 2018 Heliotropix. All rights reserved.
//

import Foundation

protocol Service {
	func instance() -> Service
}

extension Service {
	func instance() -> Service {
		return self
	}
}
