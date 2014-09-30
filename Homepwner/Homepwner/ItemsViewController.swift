//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by John Regner on 9/10/14.
//  Copyright (c) 2014 In Your Dreams Software. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {

    let cellIdentifier = "CELL"
    
    convenience override init() {
        self.init(style: .Grouped)
        self.title = "Grouped"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 1...8 {
            BNRItemStore.sharedStore.createItem()
        }
    }
}

extension ItemsViewController : UITableViewDataSource {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionMethod = section == 0 ? BNRItemStore.getUnder50DollarItems : BNRItemStore.getOver50DollarItems
        return sectionMethod(BNRItemStore.sharedStore)().count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //dequeue a cell or create a new one
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as UITableViewCell! ?? UITableViewCell(style:.Default, reuseIdentifier: "CELL")
        //set text to 20 pt
        cell.textLabel?.font = UIFont.systemFontOfSize(20)
        cell.backgroundView = nil
        cell.backgroundColor = UIColor.clearColor()
        let sectionMethod =  indexPath.section == 0 ? BNRItemStore.getUnder50DollarItems : BNRItemStore.getOver50DollarItems
        
        let p = sectionMethod(BNRItemStore.sharedStore)()[indexPath.row]
        cell.textLabel?.text = p.description
        return cell
    }
}

extension ItemsViewController : UITableViewDelegate {
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 44
    }
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        let label =  UILabel(frame: CGRect(x: 0, y: 10, width: 200, height: 44))
        label.text = "No more items"
        return label
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
}