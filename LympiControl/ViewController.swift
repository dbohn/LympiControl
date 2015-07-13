//
//  ViewController.swift
//  LympiControl
//
//  Created by David Bohn on 10.07.15.
//  Copyright (c) 2015 David Bohn. All rights reserved.
//

import Cocoa
import SwiftHTTP

class ViewController: NSViewController, NSXMLParserDelegate {
    @IBOutlet weak var camName: NSTextField!
    @IBOutlet weak var collectionView: NSCollectionView!
    
    let cameraAdress = "http://192.168.0.10"
    var readingCamName = false
    var readCamName = ""
    var applicationName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.itemPrototype = self.storyboard?.instantiateControllerWithIdentifier("colView") as? NSCollectionViewItem
        
        camName.stringValue = "Verbindungsaufbau..."
        
        var request = HTTPTask()
        
        var path = cameraAdress + "/get_caminfo.cgi"
        var parser = NSXMLParser()
        
        request.GET(path, parameters: nil, completionHandler: {(response: HTTPResponse) in
            if let err = response.error {
                dispatch_async(dispatch_get_main_queue(),{
                    self.camName.stringValue = "Es gab einen Fehler!"
                })
                return
            }
            
            if let data = response.responseObject as? NSData {
                parser = NSXMLParser(data: data);
                parser.delegate = self;
                parser.parse();
                //let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                //println("response: \(str)") //prints the HTML of the page
            }
        })

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
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
        camName.stringValue = "Verbunden mit: " + readCamName
    }

}

