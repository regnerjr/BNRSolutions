//
//  HypnosisViewController.swift
//  HypnoTime
//
//  Created by John Regner on 8/30/14.
//  Copyright (c) 2014 In Your Dreams Software. All rights reserved.
//

import UIKit

class HypnosisViewController: UIViewController {

    override func loadView() {
        //create a view
        let frame = UIScreen().bounds
        let v = HypnosisView(frame: frame)
        self.view = v
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
