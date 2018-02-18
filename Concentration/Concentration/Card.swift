//
//  Card.swift
//  Concentration
//
//  Created by Yuske Fukuyama on 2018/02/16.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import Foundation

struct Card
{
    var isFaceUp: Bool = false
    var isMatched: Bool = false
    var identifier: Int

    static var identifierFactory = 0

    static func getUniqueIdentifier() -> Int {
        // static is sent to the type Card itself
        identifierFactory += 1 // in a static method, so no need to call Card.var
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
