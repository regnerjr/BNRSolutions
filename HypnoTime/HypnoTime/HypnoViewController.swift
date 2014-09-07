//
//  SecondViewController.swift
//  HypnoTime
//
//  Created by John on 8/31/14.
//  Copyright (c) 2014 In Your Dreams Software. All rights reserved.
//

import UIKit

class HypnoViewController: UIViewController {
    
    let redGreenBlue = [UIColor.redColor(),UIColor.greenColor(),UIColor.blueColor()]
   
    @IBOutlet weak var HypnoView: HypnosisView!
    
    @IBAction func changeColor(sender: AnyObject) {
        if let segmentedControl = sender as? UISegmentedControl {
            HypnoView.circleColor = redGreenBlue[segmentedControl.selectedSegmentIndex]
            view.setNeedsDisplay()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

