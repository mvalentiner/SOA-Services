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

extension ServiceRegistryImplementation {
	var sharingService : SharingService {
		get {
			return serviceWith(name: sharingServiceName) as! SharingService
		}
	}
}

protocol SharingService : SOAService {
	func share(_ content : Any, withActivityItems activityItems : [Any], presentingController : UIViewController)
}

extension SharingService {
	var serviceName : String { get { return sharingServiceName } }

	internal func share(_ sharable : Any, withActivityItems activityItems : [Any] = [], presentingController : UIViewController) {
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
		LazyService(serviceName: sharingServiceName, serviceGetter: { SharingServiceImplementation() }).register()

	}
}

// Example test implementation
internal class TestSharingServiceImplementation : SharingService {
	internal static func register() {
		TestSharingServiceImplementation().register()
	}
}
