//
//  BoardView.swift
//  A3GraphicalSet
//
//  Created by Yuske Fukuyama on 2018/03/23.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

protocol LayoutViews: class {
    func updateViewFromModel()
}

class BoardView: UIView {

    weak var delegate: LayoutViews?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        delegate?.updateViewFromModel()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
