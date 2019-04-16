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

	@IBAction func handleShareTextButtonTap(_ sender: Any) {
		guard let textToShare = textField.text else {
			return
		}

		SR.sharingService.share(textToShare, presentingController: self)
	}
}
