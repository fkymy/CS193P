//
//  CardButton.swift
//  A2GameOfSet
//
//  Created by Yuske Fukuyama on 2018/03/22.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

class CardButton: UIButton {
    
    var card: Card? {
        didSet {
            if let card = card {
                setAttributedTitle(attributedString(for: card), for: .normal)
            } else {
                setAttributedTitle(NSAttributedString(), for: .normal)
            }
        }
    }
    
    private func setLayout() {
        backgroundColor = #colorLiteral(red: 0.9628086289, green: 0.8465488767, blue: 0.5487685946, alpha: 1)
        layer.borderWidth = LayOutMetricsForCardView.borderWidth
        layer.borderColor = LayOutMetricsForCardView.borderColor
        layer.cornerRadius = LayOutMetricsForCardView.cornerRadius
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setLayout()
    }

    func attributedString(for card: Card) -> NSAttributedString {
        let symbol: String = ModelToView.symbols[card.symbol]!
        let strokeColor: UIColor = ModelToView.colors[card.color]!
        let strokeWidth: CGFloat = ModelToView.strokeWidth[card.shading]!
        let foregroundColor = strokeColor.withAlphaComponent(ModelToView.alpha[card.shading]!)
        
        var returnString: String = symbol
        for _ in 1..<card.number.rawValue { returnString += symbol }
        
        let attributes: [NSAttributedStringKey:Any] = [
            .strokeColor: strokeColor,
            .strokeWidth: strokeWidth,
            .foregroundColor: foregroundColor
        ]
        return NSAttributedString(string: returnString, attributes: attributes)
    }
}
