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
                selectState = .unselected
            } else {
                setAttributedTitle(NSAttributedString(), for: .normal)
                selectState = .unselected
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
    
    enum SelectState {
        case unselected
        case selected
        case selectedAndMatched
        case hinted
    }
    
    var selectState: SelectState = .unselected {
        didSet {
            switch selectState {
            case .unselected:
                layer.borderWidth = LayOutMetricsForCardView.borderWidth
                layer.borderColor = LayOutMetricsForCardView.borderColor
            case .selected:
                layer.borderWidth = LayOutMetricsForCardView.borderWidthSelected
                layer.borderColor = LayOutMetricsForCardView.borderColorSelected
            case .selectedAndMatched:
                layer.borderWidth = LayOutMetricsForCardView.borderWidthMatched
                layer.borderColor = LayOutMetricsForCardView.borderColorMatched
            case .hinted:
                layer.borderWidth = LayOutMetricsForCardView.borderWidthHinted
                layer.borderColor = LayOutMetricsForCardView.borderColorHinted
            }
        }
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

struct LayOutMetricsForCardView {
    static var cornerRadius: CGFloat = 8.0
    static var borderWidth: CGFloat = 1.0
    static var borderColor: CGColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor

    static var borderWidthSelected: CGFloat = 3.0
    static var borderColorSelected: CGColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1).cgColor
    
    static var borderWidthHinted: CGFloat = 4.0
    static var borderColorHinted: CGColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1).cgColor
    
    static var borderWidthMatched: CGFloat = 4.0
    static var borderColorMatched: CGColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1).cgColor
    
    static var borderWidthDrawButton: CGFloat = 3.0
    static var borderColorDrawButton: CGColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
}
