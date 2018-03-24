//
//  GameOfSetEngine.swift
//  A4AnimatedSet
//
//  Created by Yuske Fukuyama on 2018/03/24.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import Foundation

class GameOfSetEngine {
    
    private var deck = GameOfSetDeck()
    
    lazy var cardsDealt: [GameOfSetCard] = deck.draw(n: .twelve) ?? []
    var cardsTaken = [GameOfSetCard]()
    var cardsSelected = [GameOfSetCard]()
    
    private(set) var score: Int = 0
    var deckCount: Int { return deck.count }
    var hintedIndex = [Int]()
    
    func isSet(cards: [GameOfSetCard]) -> Bool {
        guard cards.count == 3 else { return false }
        
        var sumMatrix = [Int](repeating: 0, count: cards[0].rawValueAsMatrix.count)
        for card in cards {
            let rawValues = card.rawValueAsMatrix
            for index in rawValues {
                sumMatrix[index] += rawValues[index]
            }
        }
        
        return sumMatrix.reduce(true, { $0 && $1 % 3 == 0 })
    }
    
    func chooseCard(at index: Int) {
        if cardsSelected.contains(cardsDealt[index]) {
            cardsSelected.remove(at: cardsSelected.index(of: cardsDealt[index])!)
            return
        }
        
        cardsSelected.append(cardsDealt[index])
        
        if cardsSelected.count == 3 && isSet(cards: cardsSelected) {
            if let newCards = drawCards() {
                for index in cardsSelected.indices {
                    let removeIndex = cardsDealt.index(of: cardsSelected[index])!
                    cardsDealt[removeIndex] = newCards[index]
                }
            } else {
                for index in cardsSelected.indices {
                    let removeIndex = cardsDealt.index(of: cardsSelected[index])!
                    cardsDealt.remove(at: removeIndex)
                }
            }
            score += 3
        } else {
            score -= 1
        }
    }
    
    func drawCards() -> [GameOfSetCard]? {
        if let cards = deck.draw(n: .three) {
            cardsDealt += cards
            return cards
        }
        return nil
    }
    
    func shuffle() {
        let n = cardsDealt.count / 3
        guard n > 1 else { return }
        
        var result = Array(cardsDealt)
        for i in 0..<n {
            let j = Int(arc4random_uniform(UInt32(result.indices.last!)))
            if i != j {
                swap(&result[i], &result[j])
            }
        }
        cardsDealt = result
    }
    
    func hint() {
        hintedIndex.removeAll()
        for i in 0..<cardsDealt.count - 2 {
            for j in (i+1)..<cardsDealt.count - 1 {
                for k in (j+2)..<cardsDealt.count {
                    let cards = [cardsDealt[i], cardsDealt[j], cardsDealt[k]]
                    if isSet(cards: cards) {
                        hintedIndex += [i, j, k]
                    }
                }
            }
        }
    }
}

extension GameOfSetEngine: CustomStringConvertible {
    var description: String {
        var returnString = ""
        returnString += "cardsOnTable: \(cardsDealt.count)\n\(cardsDealt.reduce("") { "\($0)\($1)\n" })"
        returnString += "\n\ncardsTakenFromTable: \(cardsTaken.count)\n \(cardsTaken.reduce("") { "\($0)\($1)\n" })"
        return returnString
    }
}






