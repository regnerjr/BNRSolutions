//
//  HeavyViewController.swift
//  HeavyRotation
//
//  Created by John Regner on 9/7/14.
//  Copyright (c) 2014 In Your Dreams Software. All rights reserved.
//

import UIKit

class HeavyViewController: UIViewController {

    override func supportedInterfaceOrientations() -> Int {
        return
            Int(UIInterfaceOrientationMask.Portrait.toRaw()) +
            Int(UIInterfaceOrientationMask.LandscapeLeft.toRaw()) +
            Int(UIInterfaceOrientationMask.LandscapeRight.toRaw()) +
            Int(UIInterfaceOrientationMask.PortraitUpsideDown.toRaw())
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
