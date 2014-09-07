//
//  FirstViewController.swift
//  HypnoTime
//
//  Created by John on 8/31/14.
//  Copyright (c) 2014 In Your Dreams Software. All rights reserved.
//

import UIKit

class TimeViewController: UIViewController {
                            
    @IBOutlet weak var timeLabel: UILabel!
    @IBAction func getTime(sender: AnyObject) {
        let now = NSDate()
        let formatter = NSDateFormatter()
        formatter.timeStyle = NSDateFormatterStyle.MediumStyle
        
        timeLabel.text = formatter.stringFromDate(now)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

