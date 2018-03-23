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
            cardsOnTable.indices.forEach { cardButtons[$0].card = cardsOnTable[$0] }
            hints.cards = game.hints
        }
    }

    @IBOutlet var cardButtons: [CardButton]!
    
    @IBOutlet weak var newGameButton: UIButton! { didSet { layoutFor(newGameButton) } }
    @IBOutlet weak var drawCardButton: UIButton! { didSet { layoutFor(drawCardButton) } }
    @IBOutlet weak var hintButton: UIButton! { didSet { layoutFor(hintButton) } }
    @IBOutlet weak var setsFoundLabel: UILabel!
    @IBOutlet weak var cardsInDeckLabel: UILabel!
    
    func layoutFor(_ view: UIView) {
        view.layer.cornerRadius = LayOutMetricsForCardView.cornerRadius
        view.layer.borderWidth = LayOutMetricsForCardView.borderWidthDrawButton
        view.layer.borderColor = LayOutMetricsForCardView.borderColorDrawButton
        view.clipsToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
    }
    
    private func startNewGame() {
        cardButtons.forEach { $0.card = nil }
        game = GameOfSet()
        updateViewLabels()
    }
    
    private func updateViewLabels() {
        setsFoundLabel.text = "Sets found: \(game.cardsTaken.count / 3)"
        cardsInDeckLabel.text = "Cards in deck: \(game.deckCount)"
    }
    
    
    private var cardButtonsSelected: [CardButton] {
        return cardButtons.filter { cardButton in
            cardButton.selectState == .selected || cardButton.selectState == .selectedAndMatched
        }
    }
    
    private func removeAndDraw(cards: [Card]) {
        game.removeCardsFromTable(cards: cards)
        var buttons = buttonsFor(cards: cards)
        buttons.forEach { $0.card = nil } // for when draw []
        
        let newCards = game.drawCards()
        hints.cards = game.hints
        for index in newCards.indices {
            let slot = buttons[index]
            slot.card = newCards[index]
        }
        buttons.forEach { $0.selectState = .unselected }
    }

    @IBAction func onCardButton(_ sender: CardButton) {
        guard sender.card != nil else { return }
        
        let previousCardButtonsSelected = cardButtonsSelected
        if previousCardButtonsSelected.count == 3 {
            let cards = previousCardButtonsSelected.filter { $0.card != nil }.map { $0.card! }
            if  game.isSet(cards: cards) {
                removeAndDraw(cards: cards)
            } else {
                previousCardButtonsSelected.forEach { $0.selectState = .unselected }
            }
        }
        
        sender.selectState = sender.selectState == .unselected || sender.selectState == .hinted ? .selected : .unselected
        
        if cardButtonsSelected.count == 3 {
            let cards = cardButtonsSelected.filter { $0.card != nil }.map { $0.card! }
            if game.isSet(cards: cards) {
                cardButtonsSelected.forEach { $0.selectState = .selectedAndMatched }
            }
        }
        updateViewLabels()
    }
    
    @IBAction func onNewGameButton(_ sender: UIButton) {
        startNewGame()
    }
    
    @IBAction func onDrawCardsButton(_ sender: UIButton) {
        let previousCardButtonsSelected = cardButtonsSelected
        let cards = previousCardButtonsSelected.map { $0.card! }
        if  game.isSet(cards: cards) {
            removeAndDraw(cards: cards)
        } else {
            let openSlotCount = cardButtons.count - game.cardsDealt.count
            if openSlotCount >= 3 {
                let newCards = game.drawCards()
                hints.cards = game.hints
                var openSlots: [CardButton] = cardButtons.filter { $0.card == nil }
                for index in newCards.indices {
                    let cardButton = openSlots[index]
                    cardButton.card = newCards[index]
                }
            }
        }
        
        updateViewLabels()
    }
    
    private var hints: (cards: [[Card]], index: Int) = ([[]], 0) {
        didSet {
            if hints.index == oldValue.index {
                hints.index = 0
            }
        }
    }
    
    @IBAction func onHintButton(_ sender: UIButton) {
        let previousCardButtonsSelected = cardButtonsSelected
        let cards = previousCardButtonsSelected.map { $0.card! }
        let hint = hints.cards[hints.index]
        hints.index = hints.index < hints.cards.count - 1 ? hints.index + 1 : 0
        
        let cardButtonsWithSet = buttonsFor(cards: hint)
        if game.isSet(cards: cards) {
            if Set(hint).union(cards).count != 0 { return }
        }

        cardButtonsWithSet.forEach { $0.selectState = .hinted }
    }
    
    private func buttonsFor(cards: [Card]) -> [CardButton] {
        var buttons: [CardButton] = []
        for card in cards {
            if let button = (cardButtons.filter { $0.card == card }).first {
                buttons.append(button)
            }
        }
        return buttons
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

