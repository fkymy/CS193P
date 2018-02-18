//
//  Concentration.swift
//  Concentration
//
//  Created by Yuske Fukuyama on 2018/02/16.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import Foundation

class Concentration
{
    // api
    var cards: [Card] = [Card]() // this corresponds to init for array.
    
    var indexOfOneAndOnlyFaceUpCard: Int?

    init(numberOfPairsOfCards: Int) {
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card] // structs are copied
        }
        // TODO: Shuffle the cards
    }

    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
}
