//
//  AppDelegate.swift
//  Homepwner
//
//  Created by John Regner on 9/9/14.
//  Copyright (c) 2014 In Your Dreams Software. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)

        let ivc = ItemsViewController()
        window.rootViewController = ivc
        
        window.backgroundColor = UIColor.whiteColor()
        window.makeKeyAndVisible()
        return true
    }
}

