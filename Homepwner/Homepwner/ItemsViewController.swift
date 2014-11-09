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

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    @IBAction func addNewItem(sender: AnyObject) {

        let detailController = DetailViewController(newItem: true)
        let newItem = BNRItemStore.sharedStore.createItem()
        detailController.item = newItem
        detailController.dismissPopoverCompletionBlock = { self.tableView.reloadData() }

        let navController = UINavigationController(rootViewController: detailController)
        navController.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        navController.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        self.presentViewController(navController, animated: true, completion: nil)
        let popPC = navController.popoverPresentationController

        popPC?.barButtonItem = self.navigationItem.rightBarButtonItem //if we were using the popover style these would be important
        popPC?.permittedArrowDirections = UIPopoverArrowDirection.Any //but for now they are just here.
        popPC?.delegate = self
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

extension ItemsViewController: UITableViewDataSource {

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

extension ItemsViewController: UITableViewDelegate {

    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        return "Remove"
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailViewController = DetailViewController(newItem: false)

        let selectedItem = BNRItemStore.sharedStore.getAllItems()[indexPath.row]
        detailViewController.item = selectedItem
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension ItemsViewController: UIPopoverPresentationControllerDelegate {

}