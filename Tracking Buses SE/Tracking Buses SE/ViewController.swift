//
//  ViewController.swift
//  Tracking Buses SE
//
//  Created by ncprg on 3/1/18.
//  Copyright © 2018 ncprg. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var htmlload: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let htmlpath = Bundle.main.path(forResource: "TrackingBusesTake1", ofType: "html")
        let url = URL(fileURLWithPath: htmlpath!)
        let request = URLRequest(url: url)
        htmlload.load(request)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

