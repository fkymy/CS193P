//
//  GalleryDocumentTableViewCell.swift
//  A5Gallery
//
//  Created by Yuske Fukuyama on 2018/05/27.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

class GalleryDocumentTableViewCell: UITableViewCell, UITextFieldDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
            textField.clearsOnBeginEditing = false
            textField.isUserInteractionEnabled = false
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap(_:)))
            tapGestureRecognizer.numberOfTapsRequired = 2
            self.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    @objc func onDoubleTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            textField.isUserInteractionEnabled = true
            textField.becomeFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.isUserInteractionEnabled = false
        return true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
