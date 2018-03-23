//
//  GameOfSet.swift
//  A3GraphicalSet
//
//  Created by Yuske Fukuyama on 2018/03/23.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import Foundation

class GameOfSet {
    
    private var deck = Deck()
    
    lazy var cardsDealt: [Card] = deck.draw(n: .twelve) ?? []
    var cardsTaken: [Card] = []
    
    var score: Int = 0
    var deckCount: Int { return deck.count }
    
    func isSet(cards: [Card]) -> Bool {
        // return true to test
        guard cards.count == 3 else { return false }
        var sumMatrix = [Int](repeating: 0, count: cards[0].rawValuesAsMatrix.count)
        
        for card in cards {
            let rawValues = card.rawValuesAsMatrix
            for index in rawValues.indices {
                sumMatrix[index] += rawValues[index]
            }
        }
        
        return sumMatrix.reduce(true, { $0 && ($1 % 3 == 0) })
    }
    
    func drawCards() -> [Card]? {
        if let cards = deck.draw(n: .three) {
            cardsDealt += cards
            return cards
        }
        return nil
    }
    
    // func removeCardsFromTable(cards: [Card]) {
    //     guard isSet(cards: cards) else { return }
    //     for index in cards.indices {
    //         let cardFromTable = cardsDealt.remove(at: index)
    //         cardsTaken.append(cardFromTable)
    //     }
    // }
    func ifSetThenRemoveFromTable(cards: [Card]) -> Bool {
        guard isSet(cards: cards) else { return false }
        for card in cards {
            if let index = cardsDealt.index(of: card) {
                let cardTaken = cardsDealt.remove(at: index)
                cardsTaken.append(cardTaken)
            }
        }
        score += 3
        return true
    }
    
    var hints: [[Card]] {
        var hints = [[Card]]()
        for i in 0..<cardsDealt.count - 2 {
            for j in (i+1)..<cardsDealt.count - 1 {
                for k in (j+2)..<cardsDealt.count {
                    let cards = [cardsDealt[i], cardsDealt[j], cardsDealt[k]]
                    if isSet(cards: cards) { hints.append(cards)}
                }
            }
        }
        return hints
    }
}

extension GameOfSet: CustomStringConvertible {
    var description: String {
        var returnString = ""
        returnString += "cardsOnTable: \(cardsDealt.count)\n\(cardsDealt.reduce("") { "\($0)\($1)\n" })"
        returnString += "\n\ncardsTakenFromTable: \(cardsTaken.count)\n \(cardsTaken.reduce("") { "\($0)\($1)\n" })"
        return returnString
    }
}
