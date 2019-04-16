//
//  SharingService.swift
//  Services
//
//  Created by Michael Valentiner on 2/6/18.
//  Copyright © 2018 Heliotropix. All rights reserved.
//

import Foundation
import UIKit

private let sharingServiceName = "SharingService"

extension ServiceRegistry {
	func getSharingService() -> SharingService {
		guard let resolvedService = ServiceRegistry().serviceWith(name: sharingServiceName) as? SharingService else {
			fatalError("Programmer error: Service \(sharingServiceName) is not registered with the ServiceRegistry.")
		}
		return resolvedService
	}
}

protocol SharingService : Service {
	func share(_ content : Any, withActivityItems activityItems : [Any], presentingController : UIViewController)
}

extension SharingService {
	var serviceName : String { get { return sharingServiceName } }

	internal func share(_ sharable : Any, withActivityItems activityItems : [Any], presentingController : UIViewController) {
		showActivityViewController(with: [sharable] + activityItems, presentingController: presentingController)
	}

	private func showActivityViewController(with activityItems: [Any], presentingController : UIViewController) {
		let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
		var excludedActivityTypes = [
			UIActivity.ActivityType.postToWeibo,
			UIActivity.ActivityType.print,
			UIActivity.ActivityType.assignToContact,
			UIActivity.ActivityType.saveToCameraRoll,
			UIActivity.ActivityType.addToReadingList,
			UIActivity.ActivityType.postToVimeo,
			UIActivity.ActivityType.postToTencentWeibo,
			UIActivity.ActivityType.airDrop,
			UIActivity.ActivityType.openInIBooks
		]
		if #available(iOS 11.0, *) {
			excludedActivityTypes = excludedActivityTypes + [UIActivity.ActivityType.markupAsPDF]
		}
		activityViewController.excludedActivityTypes = excludedActivityTypes
		presentingController.present(activityViewController, animated: true)
    }
}

// Production implementation
internal class SharingServiceImplementation : SharingService {
	internal static func register() {
		ServiceRegistry().add(service: self.init())
	}
	
	internal required init() {
	}
}

// Example test implementation
internal class TestSharingServiceImplementation : SharingService {
	internal static func register() {
		ServiceRegistry().add(service: self.init())
	}

	internal required init() {
	}
}
