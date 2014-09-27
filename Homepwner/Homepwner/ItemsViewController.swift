//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by John Regner on 9/10/14.
//  Copyright (c) 2014 In Your Dreams Software. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    let cellIdentifier = "CELL"
    //@IBOutlet var tableView: UITableView?

    // Register the UITableViewCell class with the tableView
//    self.tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)

    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 1..<5 {
            BNRItemStore.sharedStore.createItem()
        }
    }

    
    
    // - MARK: TableViewDelegate
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BNRItemStore.sharedStore.getAllItems().count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        //dequeue a cell or create a new one
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as UITableViewCell! ?? UITableViewCell(style:.Default, reuseIdentifier: "CELL")

        let p = BNRItemStore.sharedStore.getAllItems()[indexPath.row]
        cell.textLabel?.text = p.description
        return cell
    }
    // UITableViewDataSource methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
 
    // UITableViewDelegate methods
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let alert = UIAlertController(title: "Item selected", message: "You selected item \(indexPath.row)", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler: {
                (alert: UIAlertAction!) in println("An alert of type \(alert.style.hashValue) was tapped!")
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
