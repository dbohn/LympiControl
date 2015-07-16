//
//  LCCameraNameReader.swift
//  LympiControl
//
//  Created by David Bohn on 15.07.15.
//  Copyright (c) 2015 David Bohn. All rights reserved.
//

import Cocoa
import SwiftHTTP

protocol LCCameraNameReceiver {
    func cameraNameRead(cameraName: String)
    func cameraNameReadingFailed(error: NSError)
}

class LCCameraNameReader: NSObject, NSXMLParserDelegate {
    
    var readingCamName = false
    var readCamName = ""
    
    var delegate: LCCameraNameReceiver?
    
    func requestCameraName(cameraAdress: String) {
        var request = HTTPTask()
        
        var path = cameraAdress + "/get_caminfo.cgi"
        var parser = NSXMLParser()
        
        request.GET(path, parameters: nil, completionHandler: {(response: HTTPResponse) in
            if let err = response.error {
                dispatch_async(dispatch_get_main_queue(),{
                    if let deleg = self.delegate {
                        deleg.cameraNameReadingFailed(err)
                    }
                })
                return
            }
            
            if let data = response.responseObject as? NSData {
                parser = NSXMLParser(data: data);
                parser.delegate = self;
                parser.parse();
            }
        })
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        readingCamName = (elementName == "model")
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        if (readingCamName) {
            readCamName += string!
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        readingCamName = !(elementName == "model")
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        if let deleg = delegate {
            // camName.stringValue = "Verbunden mit: " + readCamName
            deleg.cameraNameRead(readCamName)
        }
        
    }

}
