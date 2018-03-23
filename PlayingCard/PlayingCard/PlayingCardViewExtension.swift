//
//  PlayingCardViewExtension.swift
//  PlayingCard
//
//  Created by Yuske Fukuyama on 2018/03/21.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

extension PlayingCardView {
    static func ==(lhs: PlayingCardView, rhs: PlayingCardView) -> Bool {
        return lhs.rank == rhs.rank && lhs.suit == rhs.suit
    }
}

// extension PlayingCardView {
//     func cardsMatchAnimation(completion: (() -> Swift.Void)? = nil) {
//     }
//
//     func flipCard(completion: (() -> Swift.Void)? = nil) {
//     }
// }
