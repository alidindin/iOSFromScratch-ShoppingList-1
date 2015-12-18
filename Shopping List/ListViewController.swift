//
//  ListViewController.swift
//  Shopping List
//
//  Created by Bart Jacobs on 12/12/15.
//  Copyright © 2015 Envato Tuts+. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController, AddItemViewControllerDelegate {

    let CellIdentifier = "Cell Identifier"
    
    var items = [Item]()
    
    // MARK: -
    // MARK: Initialization
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        // Load Items
        loadItems()
    }
    
    // MARK: -
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Title
        title = "Items"
        
        // Register Class
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: CellIdentifier)
        
        // Create Add Button
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addItem:")
    }
    
    // MARK: -
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddItemViewController" {
            if let navigationController = segue.destinationViewController as? UINavigationController,
               let addItemViewController = navigationController.viewControllers.first as? AddItemViewController {
                addItemViewController.delegate = self
            }
        }
    }

    // MARK: -
    // MARK: Table View Data Source Methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Dequeue Reusable Cell
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath)
        
        // Fetch Item
        let item = items[indexPath.row]
        
        // Configure Table View Cell
        cell.textLabel?.text = item.name

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: -
    // MARK: Add Item View Controller Delegate Methods
    func controller(controller: AddItemViewController, didSaveItemWithName name: String, andPrice price: Float) {
        // Create Item
        let item = Item(name: name, price: price)
        
        // Add Item to Items
        items.append(item)
        
        // Add Row to Table View
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: (items.count - 1), inSection: 0)], withRowAnimation: .None)
        
        // Save Items
        saveItems()
    }
    
    // MARK: -
    // MARK: Actions
    func addItem(sender: UIBarButtonItem) {
        performSegueWithIdentifier("AddItemViewController", sender: self)
    }
    
    // MARK: -
    // MARK: Helper Methods
    private func loadItems() {
        if let filePath = pathForItems() where NSFileManager.defaultManager().fileExistsAtPath(filePath) {
            if let archivedItems = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? [Item] {
                items = archivedItems
            }
        }
    }
    
    private func saveItems() {
        if let filePath = pathForItems() {
            NSKeyedArchiver.archiveRootObject(items, toFile: filePath)
        }
    }
    
    private func pathForItems() -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        if let documents = paths.first, let documentsURL = NSURL(string: documents) {
            return documentsURL.URLByAppendingPathComponent("items").path
        }
        
        return nil
    }

}
