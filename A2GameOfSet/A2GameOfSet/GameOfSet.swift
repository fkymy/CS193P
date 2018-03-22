//
//  GameOfSet.swift
//  A2GameOfSet
//
//  Created by Yuske Fukuyama on 2018/03/22.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import Foundation

class GameOfSet {
    
    private var deck = Deck()
    
    lazy var cardsDealt: [Card] = deck.draw(n: .twelve) ?? []
    var cardsTaken: [Card] = []

    func isSet(cards: [Card]) -> Bool {
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
    
    func drawCards() -> [Card] {
        let cards = deck.draw(n: .three) ?? []
        cardsDealt += cards
        return cards
    }
    
    func selectCard() {}
}

extension GameOfSet: CustomStringConvertible {
    var description: String {
        var returnString = ""
        returnString += "cardsOnTable: \(cardsDealt.count)\n\(cardsDealt.reduce("") { "\($0)\($1)\n" })"
        returnString += "\n\ncardsTakenFromTable: \(cardsTaken.count)\n \(cardsTaken.reduce("") { "\($0)\($1)\n" })"
        return returnString
    }
}
