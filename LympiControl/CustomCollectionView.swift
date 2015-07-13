//
//  CustomCollectionView.swift
//  LympiControl
//
//  Created by David Bohn on 13.07.15.
//  Copyright (c) 2015 David Bohn. All rights reserved.
//

import Cocoa

class CustomCollectionView: NSCollectionView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.wantsLayer = true
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
    override func newItemForRepresentedObject(object: AnyObject!) -> NSCollectionViewItem! {
        var item : CollectionViewCell! = super.newItemForRepresentedObject(object) as? CollectionViewCell;
        
        // item.previewImage = PreviewImageView(frame:CGRect(x: 0, y: 0, width: 0, height: 0))
        
        return item
    }
    
}
