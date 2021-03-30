//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Paul Richardson on 31/03/2021.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet var button1: UIButton!
	@IBOutlet var button2: UIButton!
	@IBOutlet var button3: UIButton!

	var countries = [String]()
	var score = 0

	override func viewDidLoad() {
		super.viewDidLoad()

		countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]

	}

}

