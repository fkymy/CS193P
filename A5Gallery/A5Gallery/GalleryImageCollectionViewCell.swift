//
//  GalleryImageCollectionViewCell.swift
//  A5Gallery
//
//  Created by Yuske Fukuyama on 2018/03/29.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

class GalleryImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
        }
    }
    
    weak var errorHandler: GalleryImageErrorHandling?

    var url: URL? {
        didSet {
            // if url is the same as oldValue, user has returned to the previous show view
            if (oldValue != url), let url = url {
                fetchData(imageURL: url)
            }
        }
    }
    
    private func fetchData(imageURL: URL) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let urlContents = try? Data(contentsOf: imageURL) {
                DispatchQueue.main.async {
                    if let image = UIImage(data: urlContents) {
                        self?.image = image
                    } else {
                        self?.errorHandler?.noImageData(for: self!)
                        print("error in let image = UIImage(data: urlContents)")
                    }
                }
            } else if self != nil {
                DispatchQueue.main.async {
                    self?.errorHandler?.noImageData(for: self!)
                    print("error in Data(contentsOf: imageURL")
                }
            }
        }
    }
}
