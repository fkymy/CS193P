//
//  Card.swift
//  A1Concentration
//
//  Created by Yuske Fukuyama on 2018/02/24.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import Foundation

struct Card: Hashable {
    private let identifier: Int
    var isFaceUp: Bool = false { didSet { if isFaceUp { isSeen = true } } }
    var isSeen: Bool = false
    var isMatched: Bool = false

    var isFlippable: Bool {
        return !isFaceUp && !isMatched
    }

    var hashValue: Int

    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private static var identifierFactory = 0
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }

    init() {
        identifier = Card.getUniqueIdentifier()
        hashValue = identifier
    }
}
