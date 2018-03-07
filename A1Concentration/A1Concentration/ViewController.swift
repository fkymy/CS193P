//
//  ViewController.swift
//  A1Concentration
//
//  Created by Yuske Fukuyama on 2018/02/24.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var board: Board!

    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
    }

    @IBAction func onNewGame(_ sender: UIButton) {
        print("newGameButton has been tapped!")
        startNewGame()
    }
    
    private func startNewGame() {
        board = Board(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        emojiStore = "👻🎃👺💩🤖🌚"
        emojis = [:]
        updateBoardView()
        updateFilpCount()
    }

    @IBOutlet var cardButtons: [UIButton]!

    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var flipCountLabel: UILabel!

    private var emojiStore = "👻🎃👺💩🤖🌚"
    private var emojis = [Card: String]()

    private func emoji(for card: Card) -> String {
        if emojis[card] == nil, emojiStore.count > 0 {
            let randomIndex = (emojiStore.count - 1).arc4random
            let randomStringIndex = emojiStore.index(emojiStore.startIndex, offsetBy: randomIndex)
            emojis[card] = String(emojiStore.remove(at: randomStringIndex))
        }
        return emojis[card] ?? "?"
    }


    @IBAction func tapCard(_ sender: UIButton) {
        if let tappedIndex = cardButtons.index(of: sender) {
            board.flipCard(at: tappedIndex)
            updateBoardView()
            updateFilpCount()
        }
    }
    
    private func updateBoardView() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = board.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0.9662213922, green: 0.3991800845, blue: 0.4120171368, alpha: 1)
            }
        }
    }
    
    private func updateFilpCount() {
        let attributes: [NSAttributedStringKey:Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 0.9662213922, green: 0.3991800845, blue: 0.4120171368, alpha: 1)
        ]
        let attributedText = NSAttributedString(string: "Flips: \(board.flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedText
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

