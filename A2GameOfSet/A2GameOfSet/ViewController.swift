//
//  ViewController.swift
//  A2GameOfSet
//
//  Created by Yuske Fukuyama on 2018/03/09.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var game: GameOfSet!

    @IBOutlet var cardButtons: [UIButton]! {
        didSet {
            for button in cardButtons {
                button.backgroundColor = #colorLiteral(red: 0.9628086289, green: 0.8465488767, blue: 0.5487685946, alpha: 1)
                button.layer.borderWidth = LayOutMetricsForCardView.borderWidth
                button.layer.borderColor = LayOutMetricsForCardView.borderColor
                button.layer.cornerRadius = LayOutMetricsForCardView.cornerRadius
            }
        }
    }
    
    @IBOutlet weak var setsFoundLabel: UILabel!
    @IBOutlet weak var cardsInDeckLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
        updateViewFromModel()
    }
    
    private func startNewGame() {
        game = GameOfSet()
        print(game)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onCardButton(_ sender: UIButton) {
        if let index = cardButtons.index(of: sender) {
            let card = game.cardsDealt[index]
            game.cardsSelected.append(card)
            updateViewFromModel()
        }
    }
    
    @IBAction func onNewGameButton(_ sender: UIButton) {
        game = GameOfSet()
    }
    
    @IBAction func onDrawCardsButton(_ sender: UIButton) {
        // check for slots
    }

    func updateViewFromModel() {
        let cardsDealt = game.cardsDealt
        let cardsSelected = game.cardsSelected
        
        for index in cardsDealt.indices {
            let button = cardButtons[index]
            button.setAttributedTitle(attributedString(for: cardsDealt[index]), for: .normal)
        }
        
        for index in cardsSelected.indices {
            let button = cardButtons[index]
            
            if game.isSet() {
                button.layer.borderWidth = LayOutMetricsForCardView.borderWidthMatched
                button.layer.borderColor = LayOutMetricsForCardView.borderColorMatched
            } else {
                button.layer.borderWidth = LayOutMetricsForCardView.borderWidthSelected
                button.layer.borderColor = LayOutMetricsForCardView.borderColorSelected
            }
        }
    }
    
    
    
    func attributedString(for card: Card) -> NSAttributedString {
        let symbol: String = ModelToView.symbols[card.symbol]!
        let strokeColor: UIColor = ModelToView.colors[card.color]!
        let strokeWidth: CGFloat = ModelToView.strokeWidth[card.shading]!
        let foregroundColor = strokeColor.withAlphaComponent(ModelToView.alpha[card.shading]!)
        
        var returnString: String = symbol
        for _ in 1..<card.number.rawValue { returnString += symbol }
        
        let attributes: [NSAttributedStringKey:Any] = [
            .strokeColor: strokeColor,
            .strokeWidth: strokeWidth,
            .foregroundColor: foregroundColor
        ]
        return NSAttributedString(string: returnString, attributes: attributes)
    }
}

struct ModelToView {
    static let symbols: [Card.Symbol: String] = [.diamond: "▲", .squiggle: "■", .oval: "●"]
    static let colors: [Card.Color: UIColor] = [.red: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), .purple: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), .green: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)]
    static let alpha: [Card.Shading: CGFloat] = [.solid: 1.0, .open: 0.40, .striped: 0.2]
    static let strokeWidth: [Card.Shading: CGFloat] = [.solid: -5, .open: 5, .striped: -5]
}

struct LayOutMetricsForCardView {
    static var borderWidth: CGFloat = 1.0
    static var borderWidthSelected: CGFloat = 3.0
    static var borderColorSelected: CGColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1).cgColor
    
    static var borderWidthHinted: CGFloat = 4.0
    static var borderColorHinted: CGColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1).cgColor
    
    static var borderWidthMatched: CGFloat = 4.0
    static var borderColorMatched: CGColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1).cgColor
    
    static var borderColor: CGColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
    static var borderColorDrawButton: CGColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
    static var borderWidthDrawButton: CGFloat = 3.0
    static var cornerRadius: CGFloat = 8.0
}

extension Sequence {
    func filter(by isIncluded: (Iterator.Element) -> Bool, limit: Int) -> [Iterator.Element] {
        var result: [Iterator.Element] = []
        result.reserveCapacity(limit)
        var count = 0
        var it = makeIterator()
        while count < limit, let element = it.next() {
            if isIncluded(element) {
                result.append(element)
                count += 1
            }
        }
        
        return result
    }
}

