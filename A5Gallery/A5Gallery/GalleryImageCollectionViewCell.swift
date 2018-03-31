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
    
    //var url: URL? {
    //    didSet {
    //        if url != nil && (oldValue != url) {
    //            fetchData(imageURL: url!)
    //        }
    //    }
    //}
    
    var galleryImage: GalleryImage? {
        didSet {
            // fetch data in the background if not nil
            // set that data to galleryImage.image for aspect ratios
            print(galleryImage!)
            if galleryImage != nil && (galleryImage?.url != oldValue?.url) {
                print("galleryImage != nil && (galleryImage?.url != oldValue?.url)")
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    self?.galleryImage?.fetchData()
                    if let image = self?.galleryImage?.image {
                        print("galleryImage?.image")
                        DispatchQueue.main.async { self?.image = image }
                    } else {
                        // handle error
                    }
                }
            }
        }
    }

    // private func fetchData(imageURL: URL) {
    //     print("fetchData")
    //     DispatchQueue.global(qos: .userInitiated).async { [weak self] in
    //         if let urlContents = try? Data(contentsOf: imageURL) {
    //             print("urlContents is loaded: \(String(describing: urlContents))")
    //             DispatchQueue.main.async {
    //                 if let image = UIImage(data: urlContents) {
    //                     self?.image = image
    //                     print("ImageView was set")
    //                 } else {
    //                     print("error in let image = UIImage(data: urlContents)")
    //                     // handle error
    //                 }
    //             }
    //         } else if self != nil {
    //             print("error in Data(contentsOf: imageURL")
    //             // handler error
    //         }
    //     }
    // }
}
