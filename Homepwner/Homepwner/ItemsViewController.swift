//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by John Regner on 9/10/14.
//  Copyright (c) 2014 In Your Dreams Software. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {

    @IBOutlet var headerView: UIView!

    convenience override init() {
        self.init(style: .Grouped)
        self.title = "Grouped"
    }

    override func viewDidLoad() {
        headerView = NSBundle.mainBundle().loadNibNamed("HeaderView", owner: self, options: nil)[0] as UIView
        super.viewDidLoad()
        for i in 1..<5 {
            BNRItemStore.sharedStore.createItem()
        }
    }
    @IBAction func addNewItem(sender: AnyObject) {
        println("Pushed add button")
    }
    @IBAction func toggleEditingMode(sender: AnyObject) {
        println("Edit button")
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
        cell.textLabel?.text = p.description
        return cell
    }
 

}

extension ItemsViewController : UITableViewDelegate {

     override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        println("loading header view")
        return self.headerView
    }

    override func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        println("returning height = \(self.headerView.bounds.height)")
        return self.headerView.bounds.size.height
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.headerView.bounds.size.height
    }
}