//
//  EmojiArtView.swift
//  EmojiArt
//
//  Created by Yuske Fukuyama on 2018/03/24.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

class EmojiArtView: UIView {
    
    var backgroundImage: UIImage? { didSet { setNeedsDisplay() } }

    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: bounds)
    }

}
