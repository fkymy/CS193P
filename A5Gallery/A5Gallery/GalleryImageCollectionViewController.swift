//
//  GalleryImageCollectionViewController.swift
//  A5Gallery
//
//  Created by Yuske Fukuyama on 2018/03/29.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

protocol GalleryImageErrorHandling: class {
    func noImageData(for cell: UICollectionViewCell)
}

protocol ImageGalleryDataSource: class {
    var imageGallery: Gallery { get set }
}

class GalleryImageCollectionViewController: UIViewController, ImageGalleryDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate, GalleryImageErrorHandling {

    // MARK: - ImageGalleryDataSource

    // todo: make this optional
    var imageGallery: Gallery = Gallery() {
        didSet {
            collectionView?.reloadData()
        }
    }

    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.dropDelegate = self
            collectionView.dragDelegate = self

            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.minimumInteritemSpacing = 1
                layout.minimumLineSpacing = 1
            }
        }
    }
    
    // MARK: UIViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
    }

    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let cell = sender as? GalleryImageCollectionViewCell {
            return cell.image != nil
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination.contents as? GalleryImageViewController else { return }
        if let cell = sender as? GalleryImageCollectionViewCell {
            vc.transferedImage = cell.image
        }
    }
 
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageGallery != nil ? imageGallery.images.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryImageCell", for: indexPath)
        if let cell = cell as? GalleryImageCollectionViewCell {
            cell.image = imageGallery.images[indexPath.item].image
            cell.url = imageGallery.images[indexPath.item].url
            cell.errorHandler = self
        }
        return cell
    }

    // MARK: - UICollectionViewDelagateFlowLayout

    private var scaleForCollectionViewCell: CGFloat = 1.0
    
    private var collectionViewWidth: CGFloat {
        // return view.frame.size.width
        return 300
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let aspectRatio = imageGallery.images[indexPath.item].aspectRatio
        let cellWidth: CGFloat = collectionViewWidth * scaleForCollectionViewCell
        let cellHeight: CGFloat = collectionViewWidth * scaleForCollectionViewCell / aspectRatio
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    // MARK: - Drag n Drop

    // not called with local drag 'n drop, unlike in a tableView drag 'n drop operation.

    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    // will be called with local drag 'n drop

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let imageData = imageGallery.images.remove(at: sourceIndexPath.item)
        imageGallery.images.insert(imageData, at: destinationIndexPath.item)
    }
    
    // MARK: - UICollectionViewDragDelegate

    private var indexPathsForDragging: [IndexPath] = []

    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        indexPathsForDragging = []
        return dragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }
    
    // For external dropping images are added as dragItems
    // For Local drag n drop only indexPaths suffice
    func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        if let cell = collectionView.cellForItem(at: indexPath) as? GalleryImageCollectionViewCell, let image = cell.image {
            indexPathsForDragging += [indexPath]
            let dragItemImage = UIDragItem(itemProvider: NSItemProvider(object: image))
            dragItemImage.localObject = image
            return [dragItemImage]
        }
        return []
    }

    // MARK: - UICollectionViewDropDelegate
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        let isLocalSession = session.localDragSession != nil
        return session.canLoadObjects(ofClass: UIImage.self) && (isLocalSession || session.canLoadObjects(ofClass: NSURL.self))
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isLocalSession = session.localDragSession != nil
        return UICollectionViewDropProposal(operation: isLocalSession ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        var destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                // local
                collectionView.performBatchUpdates({
                    let imageData = imageGallery.images[sourceIndexPath.item]
                    imageGallery.images.remove(at: sourceIndexPath.item)
                    collectionView.deleteItems(at: [sourceIndexPath])
                    imageGallery.images.insert(imageData, at: destinationIndexPath.item)
                    collectionView.insertItems(at: [destinationIndexPath])
                })
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            } else {
                // external
                let placeholderContext: UICollectionViewDropPlaceholderContext? = coordinator.drop(
                    item.dragItem,
                    to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "DropPlaceholderCell")
                )
                var imageDataForCell = Gallery.Image()
                item.dragItem.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (provider, error) in
                    if let image = provider as? UIImage {
                        imageDataForCell.image = image
                    } else {
                        return
                    }
                })
                item.dragItem.itemProvider.loadObject(ofClass: NSURL.self, completionHandler: { [weak self] (provider, error) in
                    if let imageURL = (provider as? URL)?.imageURL {
                        DispatchQueue.main.async {
                            placeholderContext?.commitInsertion(dataSourceUpdates: { (insertionIndexPath) in
                                imageDataForCell.url = imageURL
                                self?.imageGallery.images.insert(imageDataForCell, at: insertionIndexPath.item)
                            })
                            placeholderContext?.deletePlaceholder()
                        }
                    }
                })
            }
        }
    }
    
    // MARK: UICollectionViewDelegate

    
    // MARK: - GalleryImageErrorHandling

    func noImageData(for cell: UICollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            imageGallery.images.remove(at: indexPath.item)
            collectionView.deleteItems(at: [indexPath])
        }
    }
}
