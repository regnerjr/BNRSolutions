//
//  WebViewController.swift
//  Quiz
//
//  Created by John Regner on 7/28/14.
//  Copyright (c) 2014 In Your Dreams Software. All rights reserved.
//

import UIKit
import Foundation

class WebViewController: UIViewController{
    let url:NSURL = NSURL(string: "http://marriage.johnregner.com")
    @IBOutlet weak var webView: UIWebView!

    init(){
        var myRequest: NSURLRequest = NSURLRequest(URL: url)
        webView.loadRequest(myRequest)
    }

}
