//
//  ViewController.swift
//  A1Concentration
//
//  Created by Yuske Fukuyama on 2018/02/24.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var emojiStore = "👻🎃👺💩🤖🌚"
    var emojis = [Card: String]()

    func emoji(for card: Card) -> String {
        if emojis[card] == nil, emojiStore.count > 0 {
            let randomIndex = emojiStore.count.arc4random
            let randomStringIndex = emojiStore.index(emojiStore.startIndex, offsetBy: randomIndex)
            emojis[card] = String(emojiStore.remove(at: randomStringIndex))
        }
        return emojis[card] ?? "?"
    }

    lazy var game: Board = Board(numberOfPairsOfCards: (cardButtons.count + 1) / 2)

    @IBOutlet weak var flipCountLabel: UILabel!

    @IBOutlet var cardButtons: [UIButton]!

    @IBAction func tapCard(_ sender: UIButton) {
        if let tappedIndex = cardButtons.index(of: sender) {
            game.flipCard(at: tappedIndex)
            updateBoardView()
        }
    }
    
    func updateBoardView() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
            }
        }

        let attributes: [NSAttributedStringKey:Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        ]
        let attributedText = NSAttributedString(string: "Flips: \(game.flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedText
        // flipCountLabel.text = "Flips: \(game.flipCount)"
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

