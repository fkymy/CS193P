//
//  ViewController.swift
//  A2GameOfSet
//
//  Created by Yuske Fukuyama on 2018/03/09.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var game: GameOfSet! {
        didSet {
            let cardsOnTable = game.cardsDealt
            cardsOnTable.indices.forEach {
                cardButtons[$0].card = cardsOnTable[$0]
            }
        }
    }

    @IBOutlet var cardButtons: [CardButton]!
    
    @IBOutlet weak var setsFoundLabel: UILabel!
    @IBOutlet weak var cardsInDeckLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
    }
    
    private func startNewGame() {
        game = GameOfSet()
    }

    @IBAction func onCardButton(_ sender: CardButton) {
    }
    
    @IBAction func onNewGameButton(_ sender: UIButton) {
    }
    
    @IBAction func onDrawCardsButton(_ sender: UIButton) {
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

