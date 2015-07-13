//
//  PreviewImageView.swift
//  LympiControl
//
//  Created by David Bohn on 12.07.15.
//  Copyright (c) 2015 David Bohn. All rights reserved.
//

import Cocoa

class PreviewImageView: NSImageView {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
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
                self.image = NSImage(data: data!)
            }
        }
    }
    
}
