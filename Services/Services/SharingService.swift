//
//  SharingService.swift
//  Services
//
//  Created by Michael Valentiner on 2/6/18.
//  Copyright © 2018 Heliotropix. All rights reserved.
//

import Foundation
import UIKit

extension ServiceRegistry {
	func getSharingService() -> SharingService {
		let serviceName = "SharingService"
		guard let resolvedService = ServiceRegistry().getService(withName: serviceName) as? SharingService else {
			fatalError("Programmer error: Service \(serviceName) is not registered with the ServiceRegistry.")
		}
		return resolvedService
	}
}

protocol Sharable {
	var content : Any { get }
}

protocol SharingService : Service {
	func share(_ content : Sharable, withActivityItems activityItems : [Any], presentingController : UIViewController)
}

extension SharingService {
	internal func share(_ sharable : Sharable, withActivityItems activityItems : [Any], presentingController : UIViewController) {
		showActivityViewController(with: [sharable.content] + activityItems, presentingController: presentingController)
	}

	private func showActivityViewController(with activityItems: [Any], presentingController : UIViewController) {
		let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
		var excludedActivityTypes = [
			UIActivityType.postToWeibo,
			UIActivityType.print,
			UIActivityType.assignToContact,
			UIActivityType.saveToCameraRoll,
			UIActivityType.addToReadingList,
			UIActivityType.postToVimeo,
			UIActivityType.postToTencentWeibo,
			UIActivityType.airDrop,
			UIActivityType.openInIBooks
		]
		if #available(iOS 11.0, *) {
			excludedActivityTypes = excludedActivityTypes + [UIActivityType.markupAsPDF]
		}
		activityViewController.excludedActivityTypes = excludedActivityTypes
//		activityViewController.completionWithItemsHandler = {
//			activityType, wasCompleted, items, error in
//		}
		presentingController.present(activityViewController, animated: true)
    }
}

internal struct SharingServiceImplementation : SharingService {
	static func register() {
		ServiceRegistry().addService(SharingServiceImplementation(), withName: "SharingService")
	}
	
	private init() {
	}
}

// Example test implementation
internal struct TestSharingServiceImplementation : SharingService {
	static func register() {
		ServiceRegistry().addService(TestSharingServiceImplementation(), withName: "SharingService")
	}

	private init() {
	}
}
