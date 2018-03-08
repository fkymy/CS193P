//
//  Board.swift
//  A1Concentration
//
//  Created by Yuske Fukuyama on 2018/02/24.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import Foundation

class Board {
    private(set) var cards = [Card]()
    private(set) var gameScore: Int = 0
    private(set) var flipCount: Int = 0
    
    static var matchPoints = 20
    static var wasFaceUpPenalty = 10
    static var maxTimePenalty = 10
    
    private var date = Date()
    private var currentDate: Date { return Date() }
    var timeInterval: Int {
        return Int(-date.timeIntervalSinceNow)
    }

    private var oneAndOnlyFaceUpCardIndex: Int? {
        get {
            let faceUpIndices: [Int] = cards.indices.filter { cards[$0].isFaceUp }
            return faceUpIndices.oneAndOnly
        }
        set (tappedIndex) {
            for index in cards.indices {
                cards[index].isFaceUp = (index == tappedIndex)
            }
        }
    }

    init(numberOfPairsOfCards: Int) {
        var unShuffledCards: [Card] = []
        for _ in 0..<numberOfPairsOfCards {
            let card = Card(), pair = [card, card]
            unShuffledCards += pair
        }
        while !unShuffledCards.isEmpty {
            let randomIndex = unShuffledCards.count.arc4random
            let card = unShuffledCards.remove(at: randomIndex)
            cards.append(card)
        }
    }
    
    private func incrementFlipCount() {
        flipCount += 1
    }
    
    func flipCard(at tappedIndex: Int) {
        assert(cards.indices.contains(tappedIndex), "Board.flipCard(at \(tappedIndex)")

        if cards[tappedIndex].isFlippable {
            if let matchIndex = oneAndOnlyFaceUpCardIndex {
                if cards[tappedIndex] == cards[matchIndex] {
                    cards[tappedIndex].isMatched = true
                    cards[matchIndex].isMatched = true
                    gameScore += (Board.matchPoints - min(timeInterval, Board.maxTimePenalty))
                } else {
                    if cards[tappedIndex].isSeen {
                        gameScore -= (Board.wasFaceUpPenalty + min(timeInterval, Board.maxTimePenalty))
                    }
                }
                cards[tappedIndex].isFaceUp = true
            } else {
                oneAndOnlyFaceUpCardIndex = tappedIndex
            }
            incrementFlipCount()
            date = currentDate
        }
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return self.count == 1 ? self.first : nil
    }
}
