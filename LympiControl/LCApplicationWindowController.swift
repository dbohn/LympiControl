//
//  LCApplicationWindowController.swift
//  LympiControl
//
//  Created by David Bohn on 15.07.15.
//  Copyright (c) 2015 David Bohn. All rights reserved.
//

import Cocoa

class LCApplicationWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.titleVisibility = .Hidden
        //self.window?.titlebarAppearsTransparent = true
        self.window?.styleMask |= NSFullSizeContentViewWindowMask
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

}
