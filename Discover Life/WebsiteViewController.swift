//
//  WebsiteViewController.swift
//  Discover Life
//
//  Created by Vince Zhang on 2015-07-13.
//  Copyright (c) 2015 AkhalTech. All rights reserved.
//

import UIKit

class WebsiteViewController: UIViewController {
    
    @IBOutlet weak var titleNavigationItem: UINavigationItem!
    @IBOutlet weak var webView: UIWebView!
    
    var placeName = ""
    var url: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleNavigationItem.title = self.placeName
        webView.loadRequest(NSURLRequest(URL: url!))
    }
    
    @IBAction func back(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
