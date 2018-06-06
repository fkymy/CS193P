//
//  GalleryDocumentTableViewController.swift
//  A5Gallery
//
//  Created by Yuske Fukuyama on 2018/06/07.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

class GalleryDocumentTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Galleries Model
    
    var activeGalleries: [Gallery] = {
        var galleries: [Gallery] = []
        return galleries
    }()
    
    var recentlyDeletedGalleries: [Gallery] = []
    
    var galleries: [[Gallery]] {
        return [activeGalleries, recentlyDeletedGalleries]
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBAction func addGallery(_ sender: UIBarButtonItem) {
        let newGallery = Gallery()
        let existingNamesForGalleries: [String] = activeGalleries.map { $0.name } + recentlyDeletedGalleries.map { $0.name }
        newGallery.name = "Untitled".madeUnique(withRespectTo: existingNamesForGalleries)
        activeGalleries.append(newGallery)
        let indexPath = IndexPath(row: activeGalleries.count-1, sections: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
