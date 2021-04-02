//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Paul Richardson on 31/03/2021.
//

import UIKit

enum Country: String, CaseIterable {
	case estonia, france, germany, ireland, italy, monaco, nigeria, poland, russia, spain, uk, us

	var title: String {
		switch self {
		case .uk:
			return "United Kingdom"
		case .us:
			return "United States"
		default:
			return self.rawValue.capitalized
		}
	}

	var description: String {
		switch self {
		case .uk:
			return "the United Kingdom"
		case .us:
			return "the United States"
		default:
			return self.rawValue.capitalized
		}
	}
}

class ViewController: UIViewController {
	@IBOutlet var buttons: [UIButton]!
	@IBOutlet var scoreLabel: UILabel!

	var countries = Country.allCases
	var score = 0
	var correctAnswer = 0
	let gameLength = 10
	var tries = 0


	override func viewDidLoad() {
		super.viewDidLoad()

		buttons.forEach { button in
			button.layer.borderWidth = 1
			button.layer.borderColor = UIColor.lightGray.cgColor
		}
		startGame()
	}

	private func askQuestion() {
		countries.shuffle()
		correctAnswer = Int.random(in: 0...2)
		title = countries[correctAnswer].uppercased()
		buttons.forEach { button in
			button.setImage(UIImage(named: countries[button.tag]), for: .normal)
		}
	}

	private func startGame(action: UIAlertAction! = nil) {
		updateLabel()
		askQuestion()
	}

	private func continuePlaying(action: UIAlertAction! = nil) {
		if tries < gameLength {
			askQuestion()
		} else {
			let ac = UIAlertController(title: "All Done", message: "You scored \(score) out of \(gameLength)", preferredStyle: .alert)
			score = 0
			tries = 0
			ac.addAction(UIAlertAction(title: "Play again", style: .default, handler: startGame))
			present(ac, animated: true)
		}
	}

	@IBAction func buttonTapped(_ sender: UIButton) {
		var title: String
		var message: String

		tries += 1

		if sender.tag == correctAnswer {
			title = "Correct"
			message = "Well Done!"
			score += 1
		} else {
			title = "Wrong"
			message = "That's the flag of \(countries[sender.tag])."
		}
		updateLabel()

		let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: continuePlaying))
		present(ac, animated: true)
	}

	private func updateLabel() {
		scoreLabel.text = "Your score is \(score)/\(tries)."
	}
}

