//
//  ViewController.swift
//  A3GraphicalSet
//
//  Created by Yuske Fukuyama on 2018/03/23.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LayoutViews {
    
    var cardViews: [CardView] = []

    @IBOutlet weak var newGameButton: UIButton! { didSet { layout(for: newGameButton) } }
    @IBOutlet weak var hintButton: UIButton! { didSet { layout(for: hintButton) } }
    @IBOutlet weak var drawCardsButton: UIButton! {
        didSet {
            // drawCardButton.setTitle("none", for: .disabled)
            layout(for: drawCardsButton)
        }
    }
    
    @IBOutlet weak var deckCountLabel: UILabel! { didSet { layout(for: deckCountLabel) } }
    @IBOutlet weak var scoreLabel: UILabel! { didSet { layout(for: scoreLabel) } }

    @IBOutlet weak var boardView: BoardView! {
        didSet {
            layout(for: boardView)
            boardView.backgroundColor = #colorLiteral(red: 0.9628086289, green: 0.8465488767, blue: 0.5487685946, alpha: 1)
            boardView.delegate = self // as! LayoutViews
        }
    }
    
    func layout(for view: UIView) {
        view.layer.borderWidth = LayOutMetricsForCardView.borderWidth
        view.layer.borderColor = LayOutMetricsForCardView.borderColor
        view.layer.cornerRadius = LayOutMetricsForCardView.cornerRadius
        view.clipsToBounds = true
    }
    
    func updateViewFromModel() {
        let grid = aspectRatioGrid(for: boardView.bounds, withNoOfFrames: game.cardsDealt.count)
        for index in cardViews.indices {
            let insetXY = (grid[index]?.height ?? 400) / 100
            cardViews[index].frame = grid[index]?.insetBy(dx: insetXY, dy: insetXY) ?? CGRect.zero
        }
    }

    private var game: GameOfSet! {
        didSet {
            let cardsDealt = game.cardsDealt
            hints.cards = game.hints
            cardsDealt.indices.forEach { addCardView(for: cardsDealt[$0]) }
        }
    }
    
    private func addCardView(for card: Card) {
        let cardView = CardView()
        cardView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 0.9070095486, alpha: 1)
        cardView.card = card
        cardView.contentMode = .redraw
        cardViews.append(cardView)
        cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCardTapGesture)))
        boardView.addSubview(cardView)
    }
    
    private var selectedCardViews: [CardView] {
        return cardViews.filter { cardView in
            cardView.selectState == .selected || cardView.selectState == .selectedAndMatched
        }
    }
    
    private var setExists: Bool {
        let cards = selectedCardViews.map { $0.card! }
        if game.isSet(cards: cards) {
            selectedCardViews.forEach { $0.selectState = .selectedAndMatched }
            drawCardsButton.isEnabled = true
            return true
        }
        return false
    }
    
    private func handleSetState() {
        let cards = selectedCardViews.map { $0.card! }
        if game.isSet(cards: cards) {
            hints.cards = game.hints
            scoreLabel.text = "Score: \(game.score)"
            selectedCardViews.forEach {
                $0.card = nil
                cardViews.remove(at: cardViews.index(of: $0)!)
                $0.removeFromSuperview()
            }
        }
    }
    
    @objc func onCardTapGesture(_ recognizer: UITapGestureRecognizer) {
        guard let tappedCard = recognizer.view as? CardView else { return }
        if selectedCardViews.count == 3 {
            if setExists { return }
            selectedCardViews.forEach { $0.selectState = .unselected }
        }
        tappedCard.selectState = tappedCard.selectState == .selected ? .unselected : .selected
        if setExists { return }
    }
    
    private func drawCards() {
        if setExists {
            handleSetState()
            drawCardsButton.isEnabled = game.deckCount >= 3
        }
        if let cards = game.drawCards() {
            for card in cards {
                addCardView(for: card)
            }
            hints.cards = game.hints
        } else {
            drawCardsButton.isEnabled = false
        }
    }
    
    @IBAction func onDrawCardButton(_ sender: UIButton) {
        drawCards()
    }
    
    @IBAction func onNewGameButton(_ sender: UIButton) {
        cardViews.forEach {
            $0.card = nil
            $0.removeFromSuperview()
        }
        cardViews = []
        game = GameOfSet()
    }
    
    private var hints: (cards: [[Card]], index: Int) = ([[]], 0) {
        didSet {
            if hints.index == oldValue.index {
                hints.index = 0
            }
            hintButton!.isEnabled = !hints.cards.isEmpty ? true : false
        }
    }
    
    private var lastHint: [CardView]?
    
    @IBAction func onHintButton(_ sender: UIButton) {
        lastHint?.forEach { $0.selectState = .unselected }
        selectedCardViews.forEach { $0.selectState = .unselected }
        let cardsToHint = cardViews(for: hints.cards[hints.index])
        cardsToHint.forEach { $0.selectState = .hinted }
        lastHint = cardsToHint
        
        hints.index = hints.index < hints.cards.count - 1 ? hints.index + 1 : 0
    }
    
    private func cardViews(for cards: [Card]) -> [CardView] {
        var views: [CardView] = []
        for card in cards {
            if let view = (cardViews.filter { $0.cardIndex == card.hashValue }).first {
                views.append(view)
            }
        }
        return views
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game = GameOfSet()
    }
}

struct LayOutMetricsForCardView {
    static var borderWidth: CGFloat = 1.0
    static var borderWidthIfSelected: CGFloat = 4.0
    static var borderColorIfSelected: CGColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1).cgColor
    
    static var borderWidthIfHinted: CGFloat = 4.0
    static var borderColorIfHinted: CGColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1).cgColor
    
    static var borderWidthIfMatched: CGFloat = 4.0
    static var borderColorIfMatched: CGColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1).cgColor
    
    static var borderColor: CGColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
    static var borderColorForDrawButton: CGColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
    static var borderWidthForDrawButton: CGFloat = 3.0
    static var cornerRadius: CGFloat = 8.0
}
