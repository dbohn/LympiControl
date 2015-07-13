//
//  ImageListController.swift
//  LympiControl
//
//  Created by David Bohn on 12.07.15.
//  Copyright (c) 2015 David Bohn. All rights reserved.
//

import Cocoa

class ImageListController: NSObject {

    @IBOutlet weak var arrayController : NSArrayController!
    
    var images : NSMutableArray = NSMutableArray()
    
    override func awakeFromNib() {
        
        arrayController.addObserver(self, forKeyPath: "selectionIndexes", options: NSKeyValueObservingOptions.New, context: nil)
        
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        
        arrayController.sortDescriptors = [sortDescriptor]
        
        var dataLoader = FileDataLoader()
        
        dataLoader.loadFileData("http://192.168.0.10", completion: {(files:[FileData]?) in
            dispatch_async(dispatch_get_main_queue()) {
                for file in files! {
                    self.arrayController.addObject(file)
                }
                //self.arrayController.rearrangeObjects()
            }
        })
        
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "selectionIndexes" {
            //println(arrayController.selectedObjects)
        }
    }
}
