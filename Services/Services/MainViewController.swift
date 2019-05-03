//
//  MainViewController.swift
//  Services
//
//  Created by Michael Valentiner on 1/6/18.
//  Copyright © 2018 Heliotropix. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var shareTextButton: UIButton!

	// "Inject" service here.
	let sharingService = ServiceRegistry.sharingService

	@IBAction func handleShareTextButtonTap(_ sender: Any) {
		guard let textToShare = textField.text else {
			return
		}
		self.sharingService.share(textToShare, presentingController: self)
	}
}
