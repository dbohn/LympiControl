//
//  CollectionViewCell.swift
//  LympiControl
//
//  Created by David Bohn on 13.07.15.
//  Copyright (c) 2015 David Bohn. All rights reserved.
//

import Cocoa

class CollectionViewCell: NSCollectionViewItem {
    @IBOutlet weak var previewImage: PreviewImageView!
    
    var previewNSImage : NSImage!
    
    override var representedObject : AnyObject? {
        didSet {
            updateImage()
        }
    }
    
    override var selected : Bool {
        didSet {
            updateSelection()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.wantsLayer = true;
        // Do view setup here.
    }
    
    func updateImage() {
        if let ro = (representedObject as? FileData) {
            downloadImage(ro.thumbnailUrl.absoluteString!)
        }
        
        //previewImage.downloadImage((representedObject as! FileData).thumbnailUrl.absoluteString!)
    }
    
    func updateSelection() {
        //(self.view as! CellView).selected = self.selected
        
        /*if (self.selected)
        {
            self.view.layer!.backgroundColor = NSColor.alternateSelectedControlColor().CGColor;
        }
        else
        {
            self.view.layer!.backgroundColor = NSColor.clearColor().CGColor;
        }*/
    }
    
    func getDataFromUrl(url:String, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { (data, response, error) in
            completion(data: NSData(data: data))
            }.resume()
    }
    
    func downloadImage(url:String){
        getDataFromUrl(url) { data in
            dispatch_async(dispatch_get_main_queue()) {
                // self.contentMode = UIViewContentMode.ScaleAspectFill
                self.willChangeValueForKey("previewNSImage")
                self.previewNSImage = NSImage(data: data!)
                self.didChangeValueForKey("previewNSImage")
            }
        }
    }
    
}
