//
//  ViewController.swift
//  A2GameOfSet
//
//  Created by Yuske Fukuyama on 2018/03/09.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        for index in cardButtons.indices {
            let button = cardButtons[index]
            button.layer.borderWidth = 2.0
            button.layer.borderColor = UIColor.blue.cgColor
            button.layer.cornerRadius = 8.0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func tapCardButton(_ sender: UIButton) {
        if let tappedIndex = cardButtons.index(of: sender) {
            print(tappedIndex)
        }
    }
    
    @IBAction func onNewGame(_ sender: UIButton) {
    }
    
    @IBAction func onDrawCards(_ sender: UIButton) {
    }
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBOutlet weak var setsFoundLabel: UILabel!
    @IBOutlet weak var cardsInDeckLabel: UILabel!
    
}


