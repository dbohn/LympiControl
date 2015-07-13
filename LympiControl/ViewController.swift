//
//  ViewController.swift
//  LympiControl
//
//  Created by David Bohn on 10.07.15.
//  Copyright (c) 2015 David Bohn. All rights reserved.
//

import Cocoa
import SwiftHTTP

import Quartz

class ViewController: NSViewController, NSXMLParserDelegate {
    @IBOutlet var imgListController: ImageListController!
    @IBOutlet weak var camName: NSTextField!
    @IBOutlet weak var importTitleLabel: NSTextField!
    @IBOutlet weak var progessBar: NSProgressIndicator!
    @IBOutlet weak var destinationPathControl: NSPathControl!
    
    let cameraAdress = "http://192.168.0.10"
    var readingCamName = false
    var readCamName = ""
    var applicationName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "imageSelectionChanged:", name: "ImageSelectionChange", object: nil)
        
        if let path = NSSearchPathForDirectoriesInDomains(.PicturesDirectory, .UserDomainMask, true).first as? String {
            destinationPathControl.URL = NSURL(string: path)
        }
        
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
            }
        })
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
    
    func imageSelectionChanged(notification: NSNotification) {
        importTitleLabel.stringValue = "Import von \((notification.object as! NSIndexSet).count) Dateien"
    }
    
    @IBAction func pushSelectFolder(sender: AnyObject) {
        var panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.canCreateDirectories = true
        panel.allowsMultipleSelection = false
        
        let clicked = panel.runModal()
        
        if clicked == NSFileHandlingPanelOKButton {
            destinationPathControl.URL = panel.URLs.first as? NSURL
        }
    }
    
    @IBAction func pushStartImport(sender: AnyObject) {
        var imagesToDownload = imgListController.getSelectedImages()
        
        var request = HTTPTask()
        let numOfImages = Double(imagesToDownload.count)
        var n = 0.0
        for image in imagesToDownload {
            let task = request.download(cameraAdress + image.path + "/" + image.filename, parameters: nil, progress: { (complete : Double) -> Void in
                
                let prog = 100.0*n/numOfImages + (complete * 100)/numOfImages
                
                self.progessBar.doubleValue = prog
                if (complete == 1.0) {
                    n = n + 1.0
                }
                println(complete)
                }, completionHandler: { (response: HTTPResponse) -> Void in
                    if let url = response.responseObject as? NSURL {
                        let path : String! = self.destinationPathControl.URL?.absoluteString!
                        if let fileName = response.suggestedFilename {
                            if let newPath = NSURL(string: path+fileName) {
                                let fileManager = NSFileManager.defaultManager()
                                fileManager.removeItemAtURL(newPath, error: nil)
                                fileManager.moveItemAtURL(url, toURL: newPath, error:nil)
                            }
                        }
                    }
            })
        }

    }

}

