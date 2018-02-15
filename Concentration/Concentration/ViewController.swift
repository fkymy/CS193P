//
//  ViewController.swift
//  CS193PConcentration
//
//  Created by Yuske Fukuyama on 2018/02/15.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var flipCount: Int = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }

    @IBOutlet weak var flipCountLabel: UILabel!

    @IBOutlet var cardButtons: [UIButton]!
    
    var emojiChoices: [String] = ["👻", "🎃", "👻", "🎃"]

    @IBAction func tapCard(_ sender: UIButton) {
        flipCount += 1
        // flipCard(withEmoji: "👻", on: sender)
        if let cardNumber = cardButtons.index(of: sender) {
            print("cardNumber = \(cardNumber)")
            flipCard(withEmoji: emojiChoices[cardNumber], on: sender)
        } else {
            print("chosen card was not in cardButtons")
        }
    }

    func flipCard(withEmoji emoji: String, on button: UIButton) {
        print("fliCard(withEmoji\(emoji))")

        if button.currentTitle == emoji {
            button.setTitle("", for: UIControlState.normal)
            button.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        } else {
            button.setTitle(emoji, for: UIControlState.normal)
            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
}
