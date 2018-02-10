//
//  MainViewController.swift
//  Services
//
//  Created by Michael Valentiner on 1/6/18.
//  Copyright © 2018 Heliotropix. All rights reserved.
//

import UIKit

struct SharableText : Sharable {

    let text : String

	init(_ textToShare : String) {
		text = textToShare
	}

	var content : Any {
		get { return text }
	}
}

class MainViewController: UIViewController {

	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var shareTextButton: UIButton!

	@IBAction func handleShareTextButtonTap(_ sender: Any) {
		guard let textToShare = textField.text else {
			return
		}

		let sharingService = ServiceRegistry().getSharingService()
		let sharableText = SharableText(textToShare)
		sharingService.share(sharableText, withActivityItems: [], presentingController: self)
	}
}
