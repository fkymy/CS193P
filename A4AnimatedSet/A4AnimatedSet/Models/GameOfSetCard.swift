//
//  GameOfSetCard.swift
//  A4AnimatedSet
//
//  Created by Yuske Fukuyama on 2018/03/24.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import Foundation

struct GameOfSetCard: Equatable, Hashable {
    
    let number: Number
    let symbol: Symbol
    let shading: Shading
    let color: Color
    
    private static var identityFactory = 0
    
    let hashValue: Int = {
        identityFactory += 1
        return identityFactory
    }()
    
    var rawValueAsMatrix: [Int] {
        return [number.rawValue, symbol.rawValue, shading.rawValue, color.rawValue]
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    enum Number: Int {
        case one = 1
        case two
        case three
    }
    
    enum Symbol: Int {
        case diamond = 1
        case squiggle
        case oval
    }
    
    enum Shading: Int {
        case solid = 1
        case striped
        case open
    }
    
    enum Color: Int {
        case red = 1
        case green
        case purple
    }
    
    init(with number: Int, _ symbol: Int, _ shading: Int, _ color: Int) {
        self.number = Number(rawValue: number)!
        self.symbol = Symbol(rawValue: symbol)!
        self.shading = Shading(rawValue: shading)!
        self.color = Color(rawValue: color)!
    }
}

extension Card: CustomStringConvertible {
    var description: String {
        return "Card \(hashValue): \(number), \(symbol), \(shading), \(color)"
    }
}

