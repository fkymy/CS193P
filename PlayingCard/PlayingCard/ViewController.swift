//
//  ViewController.swift
//  PlayingCard
//
//  Created by Yuske Fukuyama on 2018/02/26.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

struct Constants {
    static var flipCardAnimationDuration: TimeInterval = 0.6
    static var matchCardAnimationDuration: TimeInterval = 0.6
    static var matchCardAnimationScaleUp: CGFloat = 3.0
    static var matchCardAnimationScaleDown: CGFloat = 0.1
    // static var behaviorResistance: CGFloat = 0
    // static var behaviorElasticity: CGFloat = 1.0
    // static var behaviorPushMagnitudeMinimum: CGFloat = 0.5
    // static var behaviorPushMagnitudeRandomFactor: CGFloat = 1.0
    // static var cardsPerMainViewWidth: CGFloat = 5
}

class ViewController: UIViewController {
    var deck = PlayingCardDeck()

    @IBOutlet private var cardViews: [PlayingCardView]!
    
    // Dynamic Animator 3 steps: animator, behaviors, items
    lazy var animator = UIDynamicAnimator(referenceView: view)
    lazy var cardBehavior = CardBehavior(in: animator)

    override func viewDidLoad() {
        super.viewDidLoad()
        var cards = [PlayingCard]()
        for _ in 1...((cardViews.count+1)/2) {
            let card = deck.drawCard()!
            cards += [card, card]
        }
        for cardView in cardViews {
            cardView.isFaceUp = false
            let card = cards.remove(at: cards.count.arc4Random)
            cardView.rank = card.rank.order
            cardView.suit = card.suit.rawValue
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
            cardBehavior.addItem(cardView)
            cardBehavior.addItem(cardView)
        }
    }
    
    private var faceUpCardViews: [PlayingCardView] {
        return cardViews.filter { $0.isFaceUp && !$0.isHidden && $0.transform != CGAffineTransform.identity.scaledBy(x: Constants.matchCardAnimationScaleUp, y: Constants.matchCardAnimationScaleUp) && $0.alpha == 1 }
    }
    
    private var faceUpCardViewsMatch: Bool {
        return faceUpCardViews.count == 2 && faceUpCardViews[0] == faceUpCardViews[1]
    }
    
    var lastChosenCardView: PlayingCardView?
    
    @objc func flipCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let chosenCardView = recognizer.view as? PlayingCardView {
                lastChosenCardView = chosenCardView
                cardBehavior.removeItem(chosenCardView)
                UIView.transition(
                    with: chosenCardView,
                    duration: Constants.flipCardAnimationDuration,
                    options: [.transitionFlipFromLeft],
                    animations: { chosenCardView.isFaceUp = !chosenCardView.isFaceUp },
                    completion: { finished in
                        let cardToAnimate = self.faceUpCardViews
                        if self.faceUpCardViewsMatch {
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: Constants.matchCardAnimationDuration,
                                delay: 0,
                                options: [],
                                animations: {
                                    cardToAnimate.forEach {
                                        $0.transform = CGAffineTransform.identity.scaledBy(x: Constants.matchCardAnimationScaleUp, y: Constants.matchCardAnimationScaleUp)
                                    }
                                },
                                completion: { position in
                                    UIViewPropertyAnimator.runningPropertyAnimator(
                                        withDuration: Constants.matchCardAnimationDuration,
                                        delay: 0,
                                        options: [],
                                        animations: {
                                            cardToAnimate.forEach {
                                                $0.transform = CGAffineTransform.identity.scaledBy(x: Constants.matchCardAnimationScaleDown, y: Constants.matchCardAnimationScaleDown)
                                                $0.alpha = 0
                                            }
                                        },
                                        completion: { position in
                                            cardToAnimate.forEach {
                                                $0.isHidden = true
                                                $0.alpha = 1 // to make sure no small views are roaming around in view hierarchy
                                                $0.transform = .identity
                                            }
                                        }
                                    )
                                    
                                }
                            )
                        } else if cardToAnimate.count == 2 {
                            if chosenCardView == self.lastChosenCardView {
                                cardToAnimate.forEach { cardView in
                                    UIView.transition(
                                        with: cardView,
                                        duration: Constants.flipCardAnimationDuration,
                                        options: [.transitionFlipFromLeft],
                                        animations: { cardView.isFaceUp = false },
                                        completion: { finished in
                                            self.cardBehavior.addItem(cardView)
                                        }
                                    )
                                }
                            }
                        } else {
                            if !chosenCardView.isFaceUp {
                                self.cardBehavior.addItem(chosenCardView)
                            }
                        }
                }
                )
            }
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

