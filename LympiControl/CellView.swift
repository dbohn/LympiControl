//
//  CellView.swift
//  LympiControl
//
//  Created by David Bohn on 13.07.15.
//  Copyright (c) 2015 David Bohn. All rights reserved.
//

import Cocoa

class CellView: NSView {
    
    var tmpSelected : Bool = false
    
    var selected : Bool = false {
        willSet {
            tmpSelected = self.selected
        }
        
        didSet {
            if (tmpSelected != self.selected) {
                self.needsDisplay = true
            }
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        if (selected) {
            // NSColor.blueColor().setFill()
            
            NSColor.controlHighlightColor().setFill()
            
            NSRectFill(dirtyRect)
        }

        // Drawing code here.
    }
    
}
