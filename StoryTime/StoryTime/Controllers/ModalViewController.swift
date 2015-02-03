//
//  ModalViewController.swift
//  StoryTime
//
//  Created by John Regner on 2/3/15.
//  Copyright (c) 2015 WigglingScholars. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {

    @IBAction func dismiss(sender: UIButton){
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
