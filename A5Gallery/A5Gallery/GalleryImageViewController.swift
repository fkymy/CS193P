//
//  GalleryImageViewController.swift
//  A5Gallery
//
//  Created by Yuske Fukuyama on 2018/03/29.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

class GalleryImageViewController: UIViewController, UIScrollViewDelegate {
    
    var imageView = UIImageView()
    
    var imageURL: URL? {
        didSet {
            print("imageURL didSet")
            image = nil
            // Somehow this didn't work..?
            //if view.window != nil {
            //    print("view.window is not nil")
            //    fetchData()
            //}
            fetchData()
        }
    }
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            print("image setting")
            scrollView?.zoomScale = 1.0
            imageView.image = newValue
            let size = newValue?.size ?? CGSize.zero
            imageView.frame = CGRect(origin: CGPoint.zero, size: size)
            scrollView?.contentSize = size
            scrollViewHeight?.constant = size.height
            scrollViewWidth?.constant = size.width
            let safeZoneBounds = UIEdgeInsetsInsetRect(view.bounds, view.safeAreaInsets)
            // imageView.sizeToFit()
            if size.height > 0, size.width > 0 {
                scrollView?.zoomScale = max(safeZoneBounds.width/size.width, safeZoneBounds.height/size.height)
            }
            spinner?.stopAnimating()
        }
    }
    
    private func fetchData() {
        print("fetchData has started")
        if let url = imageURL {
            print("url = imageURL")
            spinner.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContent = try? Data(contentsOf: url)
                print("urlContent is loaded: \(String(describing: urlContent!))")
                DispatchQueue.main.async {
                    if let imageData = urlContent, url == self?.imageURL {
                        self?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }

    // MARK: - Outlets
    
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 5.0
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewHeight.constant = scrollView.contentSize.height
        scrollViewWidth.constant = scrollView.contentSize.width
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // MARK: - UIViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if imageURL == nil {
            let data = SampleGalleryData.data
            if let urlList = data["Powerlines"], let url = urlList.first {
                print(url ?? "image is nil")
                imageURL = url
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
