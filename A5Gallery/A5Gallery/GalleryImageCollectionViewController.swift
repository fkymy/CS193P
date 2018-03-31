//
//  GalleryImageCollectionViewController.swift
//  A5Gallery
//
//  Created by Yuske Fukuyama on 2018/03/29.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

private let reuseIdentifier = "GalleryImageCell"

class GalleryImageCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var gallery = Gallery(name: "Powerlines")
    
    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            print("collectionView didSet")
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    // MARK: UIViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        print(gallery)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(gallery.images.count)
        return gallery.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        if let galleryImageCell = cell as? GalleryImageCollectionViewCell {
            let image = gallery.images[indexPath.item]
            galleryImageCell.galleryImage = image
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelagateFlowLayout
    
    private var scaleForCollectionViewCell: CGFloat = 1.0
    private var collectionViewWidth: CGFloat {
        return view.frame.size.width
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let aspectRatio = gallery.images[indexPath.item].aspectRatio
        print("sizeForItemAt: \(indexPath.item) with aspectRatio \(aspectRatio)")
        let cellHeight: CGFloat = collectionViewWidth * scaleForCollectionViewCell * aspectRatio
        return CGSize(width: collectionViewWidth * scaleForCollectionViewCell, height: cellHeight)
    }


    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
