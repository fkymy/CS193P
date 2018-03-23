//
//  Deck.swift
//  A3GraphicalSet
//
//  Created by Yuske Fukuyama on 2018/03/23.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import Foundation

struct Deck {
    
    private(set) var cards = [Card]()
    
    mutating func draw(n: ValidDraw) -> [Card]? {
        guard count >= n.rawValue else { return nil }
        var cardsDrawn = [Card]()
        for _ in 1...n.rawValue {
            cardsDrawn.append(cards.remove(at: count.arc4Random))
        }
        return cardsDrawn
    }
    
    enum ValidDraw: Int {
        case three = 3
        case twelve = 12
    }
    
    var count: Int {
        return cards.count
    }
    
    init() {
        let featureRange = 1...3
        for number in featureRange {
            for symbol in featureRange {
                for shading in featureRange {
                    for color in featureRange {
                        let card = Card(with: number, symbol, shading, color)
                        cards.append(card)
                    }
                }
            }
        }
    }
}

extension Int {
    var arc4Random: Int {
        switch self {
        case 1...Int.max:
            return Int(arc4random_uniform(UInt32(self)))
        case -Int.max..<0:
            return -Int(arc4random_uniform(UInt32(abs(self))))
        default:
            return 0
        }
    }
}
