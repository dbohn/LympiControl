//
//  ImageListController.swift
//  LympiControl
//
//  Created by David Bohn on 12.07.15.
//  Copyright (c) 2015 David Bohn. All rights reserved.
//

import Cocoa
import Quartz

class ImageListController: NSObject {

    @IBOutlet weak var arrayController : NSArrayController!
    
    @IBOutlet weak var imgBrowser: IKImageBrowserView!
    
    var images : NSMutableArray = NSMutableArray()
    
    override func awakeFromNib() {
        
        imgBrowser.setCellsStyleMask(IKCellsStyleTitled | IKCellsStyleSubtitled)
        imgBrowser.setDelegate(self)
        
        arrayController.addObserver(self, forKeyPath: "selectionIndexes", options: NSKeyValueObservingOptions.New, context: nil)
        
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        
        arrayController.sortDescriptors = [sortDescriptor]
        
        var dataLoader = FileDataLoader()
        
        dataLoader.loadFileData("http://192.168.0.10", completion: {(files:[FileData]?) in
            dispatch_async(dispatch_get_main_queue()) {
                self.images = NSMutableArray()
                /*for file in files! {
                    self.arrayController.addObject(file)
                }*/
                self.images.addObjectsFromArray(files!)
                let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
                self.images.sortUsingDescriptors([sortDescriptor])
                //self.arrayController.rearrangeObjects()
                self.imgBrowser.reloadData()
            }
        })
        
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "selectionIndexes" {
            //println(arrayController.selectedObjects)
        }
    }
    
    override func numberOfItemsInImageBrowser(aBrowser: IKImageBrowserView!) -> Int {
        return images.count
    }
    
    override func imageBrowser(aBrowser: IKImageBrowserView!, itemAtIndex index: Int) -> AnyObject! {
        return images[index]
    }
    
    override func imageBrowserSelectionDidChange(aBrowser: IKImageBrowserView!) {
        // println(imgBrowser.selectionIndexes().count)
        var notification : NSNotification = NSNotification(name: "ImageSelectionChange", object: imgBrowser.selectionIndexes())
        NSNotificationCenter.defaultCenter().postNotification(notification)
        
    }
    
    func getSelectedImages() -> [FileData] {
        let selection = imgBrowser.selectionIndexes()
        
        var returnArray : [FileData] = []
        
        selection.enumerateIndexesUsingBlock { (idx, stop) -> Void in
            returnArray.append(self.images[idx] as! FileData)
        }
        return returnArray
    }
}
