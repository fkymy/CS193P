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
        for name in ["1", "2", "3"] {
            let gallery = Gallery()
            gallery.name = name
            galleries.append(gallery)
        }
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
        let indexPath = IndexPath(row: activeGalleries.count-1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition(rawValue: 0)!)
        splitViewController?.delegate = self
        
        for vc in splitViewController?.viewControllers ?? [] {
            if let secondaryVC = vc.contents as? ImageGalleryDataSource {
                secondaryVC.imageGallery = activeGalleries[0]
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return galleries.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return galleries[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "Recently Deleted" : nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageGalleryNameCell", for: indexPath)
        if let cell = cell as? GalleryDocumentTableViewCell {
            cell.textField.text = galleries[indexPath.section][indexPath.row].name
        }
        return cell
    }
    
    // MARK: TableView Delegate
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        if let cell = tableView.cellForRow(at: indexPath) as? GalleryDocumentTableViewCell {
            cell.textField?.resignFirstResponder()
            cell.textField?.isUserInteractionEnabled = false
        }
        return indexPath
    }
    
    // MARK: editing
    
    // conditional editing
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.section == 1 else { return nil }
        let restoreAction = UIContextualAction(style: .destructive, title: "Restore") { [weak self] (action: UIContextualAction, view: UIView, closure: (Bool) -> Void) in
            if let gallery = self?.galleries[indexPath.section][indexPath.row] {
                self?.recentlyDeletedGalleries.remove(at: indexPath.row)
                self?.activeGalleries.insert(gallery, at: 0)
                tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
                tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
        }
        restoreAction.backgroundColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        return UISwipeActionsConfiguration(actions: [restoreAction])
    }

    // editing
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                let gallery = galleries[indexPath.section][indexPath.row]
                activeGalleries.remove(at: indexPath.row)
                recentlyDeletedGalleries += [gallery]
                tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 1))
            } else {
                recentlyDeletedGalleries.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    // TODO: reordering
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    // MARK: - Navigation
    
    private var indexPathRowForSegue: Int?

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            if indexPath.section == 0 {
                indexPathRowForSegue = indexPath.row
                return true
            }
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dataForGalleryImageVC = segue.destination.contents as? ImageGalleryDataSource {
            let index = indexPathRowForSegue ?? 0
            dataForGalleryImageVC.imageGallery = activeGalleries[index]
        }
        indexPathRowForSegue = nil
    }
}

extension GalleryDocumentTableViewController: UISplitViewControllerDelegate {
    func targetDisplayModeForAction(in svc: UISplitViewController) -> UISplitViewControllerDisplayMode {
        switch svc.displayMode {
        case .allVisible: return .primaryHidden
        case .primaryHidden: return .allVisible
        default: return .primaryHidden
        }
    }
    
    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewControllerDisplayMode) {
        if let indexPath = tableView.indexPathForSelectedRow, let cell = tableView.cellForRow(at: indexPath) as? GalleryDocumentTableViewCell {
            cell.textField?.resignFirstResponder()
            cell.textField?.isUserInteractionEnabled = false
        }
    }
}
