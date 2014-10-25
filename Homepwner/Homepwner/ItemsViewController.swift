//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by John Regner on 9/10/14.
//  Copyright (c) 2014 In Your Dreams Software. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {

    convenience override init() {
        self.init(style: UITableViewStyle.Plain)

        navigationItem.title = "Homepwner"
        //add bar button item
        let newItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("addNewItem:"))
        navigationItem.rightBarButtonItem = newItem
        navigationItem.leftBarButtonItem = editButtonItem()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func addNewItem(sender: AnyObject) {

        // Create a new BNRItem and add it to the store 
        BNRItemStore.sharedStore.createItem()

        let lastRow = BNRItemStore.sharedStore.getAllItems().count - 1
        let ip = NSIndexPath(forRow: lastRow, inSection: 0)
        // Insert this new row into the table. 
        self.tableView.insertRowsAtIndexPaths([ip], withRowAnimation: .Top)
    }
    
    @IBAction func toggleEditingMode(sender: AnyObject) {
        let editingButton = sender as UIButton
        //toggle editing
        if editing {
            editingButton.setTitle("Edit", forState: .Normal)
            self.setEditing(false, animated: true)
        }
        else {
            editingButton.setTitle("Done", forState: .Normal)
            self.setEditing(true, animated: true)
        }
    }
}

extension ItemsViewController : UITableViewDataSource {

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BNRItemStore.sharedStore.getAllItems().count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as UITableViewCell! ?? UITableViewCell(style:.Default, reuseIdentifier: "CELL")

        let p = BNRItemStore.sharedStore.getAllItems()[indexPath.row]
        cell.textLabel.text = p.description
        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // If the table view is asking to commit a delete command...
        if editingStyle == .Delete {
            let items = BNRItemStore.sharedStore.getAllItems()
            let p = items[indexPath.row]
            BNRItemStore.sharedStore.removeItem(p)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        BNRItemStore.sharedStore.moveItem(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
}

extension ItemsViewController : UITableViewDelegate {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        return "Remove"
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailViewController = DetailViewController(nibName: "DetailViewController", bundle: nil)

        let selectedItem = BNRItemStore.sharedStore.getAllItems()[indexPath.row]
        detailViewController.item = selectedItem
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}