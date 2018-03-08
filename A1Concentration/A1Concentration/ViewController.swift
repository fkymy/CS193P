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

    typealias ThemaData = (emojis: [String], backgroundColor: UIColor, cardBackColor: UIColor)

    private let themata: [String: ThemaData] = [
        "people":  (["👩", "👮🏻‍♂️", "👩‍💻", "👨🏾‍🌾", "🧟‍♀️", "👩🏽‍🎨", "👩🏼‍🍳", "🧕🏼", "💆‍♂️", "🤷🏽‍♂️"], #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)),
        "animals": (["🐶", "🙊", "🐧", "🦁", "🐆", "🐄", "🐿", "🐠", "🦆", "🦉"], #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)),
        "faces":  (["😀", "🤪", "😬", "😭", "😎", "😍", "🤠", "😇", "🤩", "🤢"], #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)),
        "fruits": (["🍏", "🥑", "🍇", "🍒", "🍑", "🥝", "🍐", "🍎", "🍉", "🍌"], #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)),
        "transport": (["🚗", "🚓", "🚚", "🏍", "✈️", "🚜", "🚎", "🚲", "🚂", "🛴"], #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)),
        "sports": (["🏊🏽‍♀️", "🤽🏻‍♀️", "🤾🏾‍♂️", "⛹🏼‍♂️", "🏄🏻‍♀️", "🚴🏻‍♀️", "🚣🏿‍♀️", "⛷", "🏋🏿‍♀️", "🤸🏼‍♂️"], #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1), #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1))
    ]

    private var theme: ThemaData! {
        didSet {
            view.backgroundColor = theme.backgroundColor
            newGameButton.setTitleColor(theme.cardBackColor, for: UIControlState.normal)
            gameScoreLabel.textColor = theme.cardBackColor
            flipCountLabel.textColor = theme.cardBackColor
        }
    }
    
    private lazy var emojiChoices: [String] = { return theme.emojis }()
    
    private var emojiDict = [Card: String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
    }
    
    @IBAction func onNewGame(_ sender: UIButton) {
        startNewGame()
    }

    private func startNewGame() {
        theme = newTheme()
        board = Board(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        emojiDict = [:]
        emojiChoices = theme.emojis

        updateBoardView()
        updateGameScore()
        updateFilpCount()
    }

    private func newTheme() -> ThemaData {
        let randomIndex = themata.count.arc4random
        let key = Array(themata.keys)[randomIndex]
        return themata[key]!
    }

    @IBOutlet var cardButtons: [UIButton]!

    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var gameScoreLabel: UILabel!
    @IBOutlet weak var flipCountLabel: UILabel!

    @IBAction func tapCard(_ sender: UIButton) {
        if let tappedIndex = cardButtons.index(of: sender) {
            board.flipCard(at: tappedIndex)
            updateBoardView()
            updateGameScore()
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
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : theme.cardBackColor
            }
        }
    }

    private func updateFilpCount() {
        let attributes: [NSAttributedStringKey:Any] = [
            .strokeWidth: 2.0
        ]
        let attributedText = NSAttributedString(
            string: "Flips: \(board.flipCount)",
            attributes: attributes
        )
        flipCountLabel.attributedText = attributedText
    }
    
    private func updateGameScore() {
        let attributes: [NSAttributedStringKey:Any] = [
            .strokeWidth: 2.0
        ]
        let attributedText = NSAttributedString(
            string: "Score: \(board.gameScore)",
            attributes: attributes
        )
        gameScoreLabel.attributedText = attributedText
    }

    private func emoji(for card: Card) -> String {
        if emojiDict[card] == nil, emojiChoices.count > 0 {
            let randomIndex = (emojiChoices.count - 1).arc4random
            emojiDict[card] = emojiChoices.remove(at: randomIndex)
        }
        return emojiDict[card] ?? "?"
    }
}

extension Int {
    var arc4random: Int {
        switch self {
        case 1...Int.max:
            return Int(arc4random_uniform(UInt32(self)))
        case -Int.max..<0:
            return -Int(arc4random_uniform(UInt32(abs(self))))
        default:
            return 0
        }
    }
}

