//
//  DetailViewController.swift
//  Homepwner
//
//  Created by John Regner on 10/5/14.
//  Copyright (c) 2014 In Your Dreams Software. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var serialField: UITextField!
    @IBOutlet weak var valueField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!

    var item: BNRItem! {  //will be loaded when this view is pushed onto the view controller
        didSet{
            navigationItem.title = self.item.itemName
            }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.groupTableViewBackgroundColor()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        nameField.text = item.itemName
        serialField.text = item.serialNumber
        valueField.text = "\(item.valueInDollars)"
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        formatter.timeStyle = NSDateFormatterStyle.NoStyle
        dateLabel.text = formatter.stringFromDate(item.dateCreated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)

        item.itemName = nameField.text
        item.serialNumber = serialField.text
        item.valueInDollars = valueField.text.toInt() ?? 0 //default to 0 dollars if the price is messed up
    }

    @IBAction func numberPadResignFirstResponder(sender: AnyObject) {
        if (valueField.editing){
            valueField.endEditing(true)
        }
    }
}
