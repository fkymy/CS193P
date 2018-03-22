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
    @IBOutlet weak var drawCardButton: UIButton!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var setsFoundLabel: UILabel!
    @IBOutlet weak var cardsInDeckLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
    }
    
    private func startNewGame() {
        cardButtons.forEach { $0.card = nil }
        game = GameOfSet()
    }
    
    private var cardButtonsSelected: [CardButton] {
        return cardButtons.filter { cardButton in
            cardButton.selectState == .selected || cardButton.selectState == .selectedAndMatched
        }
    }

    // TODO: clean up
    @IBAction func onCardButton(_ sender: CardButton) {
        guard sender.card != nil else { return }
        
        var previousCardButtonsSelected = cardButtonsSelected
        if previousCardButtonsSelected.count == 3 {
            let cards = previousCardButtonsSelected.filter { $0.card != nil }.map { $0.card! }
            if cards.count == 3 && game.isSet(cards: cards) {
                game.removeCardsFromTable(cards: cards)
                previousCardButtonsSelected.forEach { $0.card = nil } // for when draw []

                let newCards = game.drawCards()
                for index in newCards.indices {
                    let slot = previousCardButtonsSelected[index]
                    slot.card = newCards[index]
                }
                previousCardButtonsSelected.forEach { $0.selectState = .unselected }
            } else {
                previousCardButtonsSelected.forEach { $0.selectState = .unselected }
            }
        }
        
        sender.selectState = sender.selectState == .unselected ? .selected : .unselected
        if cardButtonsSelected.count == 3 {
            let cards = cardButtonsSelected.filter { $0.card != nil }.map { $0.card! }
            if cards.count == 3 && game.isSet(cards: cards) {
                cardButtonsSelected.forEach { $0.selectState = .selectedAndMatched }
            }
        }
        updateViewLabels()
    }
    
    @IBAction func onNewGameButton(_ sender: UIButton) {
        startNewGame()
    }
    
    // TODO: clean up
    @IBAction func onDrawCardsButton(_ sender: UIButton) {
        var previousCardButtonsSelected = cardButtonsSelected
        let cards = previousCardButtonsSelected.map { $0.card! }
        if cards.count == 3 && game.isSet(cards: cards) {
            game.removeCardsFromTable(cards: cards)
            previousCardButtonsSelected.forEach { $0.card = nil }
            
            let newCards = game.drawCards()
            for index in newCards.indices {
                let slot = previousCardButtonsSelected[index]
                slot.card = newCards[index]
            }
            previousCardButtonsSelected.forEach { $0.selectState = .unselected }
        } else {
            let openSlotCount = cardButtons.count - game.cardsDealt.count
            if openSlotCount >= 3 {
                let newCards = game.drawCards()
                var openSlots: [CardButton] = cardButtons.filter { $0.card == nil }
                for index in newCards.indices {
                    let cardButton = openSlots[index]
                    cardButton.card = newCards[index]
                }
            }
        }
    }

    func updateViewLabels() {
        setsFoundLabel.text = "Sets found: \(game.cardsTaken.count / 3)"
        cardsInDeckLabel.text = "Cards in deck: \(game.deckCount)"
    }
}

struct ModelToView {
    static let symbols: [Card.Symbol: String] = [.diamond: "▲", .squiggle: "■", .oval: "●"]
    static let colors: [Card.Color: UIColor] = [.red: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), .purple: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), .green: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)]
    static let alpha: [Card.Shading: CGFloat] = [.solid: 1.0, .open: 0.40, .striped: 0.2]
    static let strokeWidth: [Card.Shading: CGFloat] = [.solid: -5, .open: 5, .striped: -5]
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

