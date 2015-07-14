//
//  LCLiveviewStream.swift
//  LympiControl
//
//  Created by David Bohn on 14.07.15.
//  Copyright (c) 2015 David Bohn. All rights reserved.
//

import Cocoa
import CocoaAsyncSocket

protocol LCLiveviewStreamDelegate {
    func imageUpdated(image: NSImage)
}

class LCLiveviewStream: NSObject, GCDAsyncUdpSocketDelegate {
    
    var socket:GCDAsyncUdpSocket!
    
    var port = 25216
    
    var isCollectingImage = false
    
    var currentImage : NSMutableData = NSMutableData()
    
    var delegate: LCLiveviewStreamDelegate?
    
    override init() {
        super.init()
        
    }
    
    func startWatching() {
        var error : NSError?
        socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        socket.bindToPort(UInt16(self.port), error: &error)
        socket.beginReceiving(&error)
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didReceiveData data: NSData!, fromAddress address: NSData!, withFilterContext filterContext: AnyObject!) {
        
        if (!isCollectingImage) {
            if (isStartFrame(data)) {
                println("Start collecting image")
                isCollectingImage = true
                let startIndex = findJpegSoi(data).location
                currentImage = NSMutableData(data: data.subdataWithRange(NSMakeRange(startIndex, data.length - startIndex)))
            }
        } else {
            if (isEndFrame(data)) {
                isCollectingImage = false
                let imageFrame = data.subdataWithRange(NSMakeRange(12, data.length - 12))
                let endMarkPos = findJpegEoi(imageFrame)
                currentImage.appendData(imageFrame.subdataWithRange(NSMakeRange(0, min(endMarkPos.location, imageFrame.length))))
                println("Stop collecting image")
                
                if let deleg = delegate {
                    deleg.imageUpdated(NSImage(data: currentImage)!)
                }
            } else {
                println("Middle frame")
                currentImage.appendData(data.subdataWithRange(NSMakeRange(12, data.length - 12)))
            }
        }
        //isStartFrame(data)
        println("incoming package of size: \(data.length)")
    }
    
    func isStartFrame(frame : NSData) -> Bool {
        var data = NSData(bytes: [0x90, 0x60] as [UInt8], length: 2)
        
        return frameBeginsWith(data, frame: frame)
    }
    
    func isEndFrame(frame: NSData) -> Bool {
        var data = NSData(bytes: [0x80, 0xe0] as [UInt8], length: 2)
        
        return frameBeginsWith(data, frame: frame)
    }
    
    func frameBeginsWith(data: NSData, frame: NSData) -> Bool {
        return frame.rangeOfData(data, options: NSDataSearchOptions.Anchored, range: NSMakeRange(0, data.length)).location != NSNotFound
    }
    
    func findJpegSoi(frame: NSData) -> NSRange {
        var startMark = NSData(bytes: [0xff, 0xd8] as [UInt8], length: 2)
        
        return frame.rangeOfData(startMark, options: NSDataSearchOptions.allZeros, range: NSMakeRange(0, frame.length))
    }
    
    func findJpegEoi(frame: NSData) -> NSRange {
        var endMark = NSData(bytes: [0xff, 0xd9] as [UInt8], length: 2)
        
        return frame.rangeOfData(endMark, options: NSDataSearchOptions.Backwards, range: NSMakeRange(0, frame.length))
    }
    
}
