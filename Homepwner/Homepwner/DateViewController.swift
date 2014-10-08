//
//  DateViewController.swift
//  Homepwner
//
//  Created by John Regner on 10/7/14.
//  Copyright (c) 2014 In Your Dreams Software. All rights reserved.
//

import UIKit

class DateViewController: UIViewController {

    var item: BNRItem!

    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBAction func dateChanged(sender: AnyObject) {
        let chosenDate = sender as UIDatePicker
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.date = item.dateCreated
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(animated: Bool) {
        item.dateCreated = datePicker.date
    }
}
