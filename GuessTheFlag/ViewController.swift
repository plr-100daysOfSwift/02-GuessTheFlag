//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Paul Richardson on 31/03/2021.
//

import UIKit
import UserNotifications

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

	// MARK: - IBOutlets

	@IBOutlet var buttons: [UIButton]!
	@IBOutlet var scoreLabel: UILabel!

	// MARK: - IBActions

	@IBAction func buttonTapped(_ sender: UIButton) {
		var title: String
		var message: String

		tries += 1

		if sender.tag == correctAnswer {
			title = "Well Done!"
			message = "That's correct."
			score += 1
		} else {
			title = "Incorrect."
			message = "You chose the flag of \(countries[sender.tag].description)."
		}

		updateLabel()

		let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: continuePlaying))
		present(ac, animated: true)
	}

	// MARK: - Properties

	var countries = Country.allCases
	var score = 0
	var correctAnswer = 0
	let gameLength = 10
	var tries = 0


	// MARK: - Life Cycle

	override func viewDidLoad() {
		super.viewDidLoad()

		buttons.forEach { button in
			button.layer.borderWidth = 1
			button.layer.borderColor = UIColor.lightGray.cgColor
		}
		scheduleNotifications()
		startGame()
	}

	// MARK: - Private Methods

	private func updateLabel() {
		scoreLabel.text = "Your score is \(score)/\(tries)."
	}

	private func askQuestion() {
		countries.shuffle()
		correctAnswer = Int.random(in: 0...2)
		title = countries[correctAnswer].title
		buttons.forEach { button in
			button.setImage(UIImage(named: countries[button.tag].rawValue), for: .normal)
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

	private func scheduleNotifications() {

		registerLocal()
		registerCategories()

		let center = UNUserNotificationCenter.current()
		center.removeAllPendingNotificationRequests()

		center.getNotificationSettings { settings in
			guard settings.authorizationStatus == .authorized else { return }

			let content = UNMutableNotificationContent()
			content.title = "Daily Exercise"
			content.body = "Time for a little flags exercise."
			content.categoryIdentifier = "exercise"
			content.sound = .default

//			let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: true)
			let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
			let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

			center.add(request)

		}
		
	}

	private func registerCategories() {
		let centre = UNUserNotificationCenter.current()

		let play = UNNotificationAction(identifier: "play", title: "Play", options: [.foreground])
		let postpone = UNNotificationAction(identifier: "postpone", title: "Maybe Tomorrow", options: [])
		let categories = UNNotificationCategory(identifier: "exercise", actions: [play, postpone], intentIdentifiers: [], options: [])
		centre.setNotificationCategories([categories])

	}

	private func registerLocal() {
		let centre = UNUserNotificationCenter.current()
		centre.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
			if let error = error {
				// Handle error
			}
		}
	}

}

