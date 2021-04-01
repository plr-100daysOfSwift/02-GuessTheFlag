//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Paul Richardson on 31/03/2021.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet var buttons: [UIButton]!
	@IBOutlet var scoreLabel: UILabel!
	
	var countries = [String]()
	var score = 0
	var correctAnswer = 0

	override func viewDidLoad() {
		super.viewDidLoad()

		countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]

		buttons.forEach { button in
			button.layer.borderWidth = 1
			button.layer.borderColor = UIColor.lightGray.cgColor
		}
		scoreLabel.text = "Your score is \(score)."
		askQuestion()
	}

	func askQuestion(action: UIAlertAction! = nil) {
		countries.shuffle()
		correctAnswer = Int.random(in: 0...2)
		title = countries[correctAnswer].uppercased()
		buttons.forEach { button in
			button.setImage(UIImage(named: countries[button.tag]), for: .normal)
		}
	}

	@IBAction func buttonTapped(_ sender: UIButton) {
		var title: String

		if sender.tag == correctAnswer {
			title = "Correct"
			score += 1
		} else {
			title = "Wrong"
			score -= 1
		}
		scoreLabel.text = "Your score is \(score)."

		let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
		present(ac, animated: true)
	}
}

