//
//  GameOfSetCardView.swift
//  A4AnimatedSet
//
//  Created by Yuske Fukuyama on 2018/03/24.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

class GameOfSetCardView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(frame: CGRect, card: GameOfSetCard) {
        self.init(frame: frame)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
