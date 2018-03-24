//
//  ViewController.swift
//  A4AnimatedSet
//
//  Created by Yuske Fukuyama on 2018/03/24.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

class GameOfSetViewController: UIViewController {

    @IBOutlet weak var gameOfSetView: GameOfSetView!
    
    private var game = GameOfSetEngine() {
        didSet {
            if game.deckCount == 0 {
                drawButton.isEnabled = true
            } else {
                drawButton.isEnabled = false
            }
        }
    }
    
    private var cardsOnTable = [GameOfSetCardView]()
    private var cardsSelected = [GameOfSetCardView]()
    private var cardsHinted = [GameOfSetCardView]()
    private var cardsNeedAnimated = [GameOfSetCardView]()

    @IBOutlet weak var hintButton: UIButton! { didSet { layout(for: hintButton) } }
    @IBOutlet weak var newGameButton: UIButton! { didSet { layout(for: newGameButton) } }
    @IBOutlet weak var drawButton: UIButton! { didSet { layout(for: drawButton) } }
    @IBOutlet weak var scoreLabel: UILabel!
    
    func layout(for: UIView) {
        view.layer.borderWidth = LayOutMetricsForCardView.borderWidth
        view.layer.borderColor = LayOutMetricsForCardView.borderColor
        view.layer.cornerRadius = LayOutMetricsForCardView.cornerRadius
        view.clipsToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
    }
    
    private func addCardView(for card: GameOfSetCard) {
        // let cardView = GameOfSetCardView()
        // cardView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 0.9070095486, alpha: 1)
        // cardView.card = card
        // cardView.contentMode = .redraw
        // cardsOnTable.append(cardView)
        // cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCardTapGesture)))
        // gameOfSetView.addSubview(cardView)
    }
    
    @objc func onCardTapGesture() {
        
    }
    
    @IBAction func onHintButton(_ sender: UIButton) {
    }
    @IBAction func onNewGameButton(_ sender: UIButton) {
    }
    @IBAction func onDrawButton(_ sender: UIButton) {
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


