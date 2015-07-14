//
//  LCLiveviewViewController.swift
//  LympiControl
//
//  Created by David Bohn on 14.07.15.
//  Copyright (c) 2015 David Bohn. All rights reserved.
//

import Cocoa

class LCLiveviewViewController: NSViewController, LCLiveviewStreamDelegate {
    @IBOutlet weak var liveviewImage: NSImageView!
    
    var liveview : LCLiveviewStream = LCLiveviewStream()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewDidAppear() {
        liveview.startWatching()
        liveview.delegate = self
    }
    
    func imageUpdated(image: NSImage) {
        liveviewImage.image = image
    }
    
}
