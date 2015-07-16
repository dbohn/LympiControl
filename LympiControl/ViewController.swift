//
//  ViewController.swift
//  LympiControl
//
//  Created by David Bohn on 10.07.15.
//  Copyright (c) 2015 David Bohn. All rights reserved.
//

import Cocoa
import SwiftHTTP

class ViewController: NSViewController {
    @IBOutlet var imgListController: ImageListController!
    
    let cameraAdress = "http://192.168.0.10"
    
    var applicationName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.parentViewController?.view.window?.titleVisibility = NSWindowTitleVisibility.Hidden
        
        // liveview = LCLiveviewStream()
        
        
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    
    
    
    

}

