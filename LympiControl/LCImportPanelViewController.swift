//
//  LCImportPanelViewController.swift
//  LympiControl
//
//  Created by David Bohn on 15.07.15.
//  Copyright (c) 2015 David Bohn. All rights reserved.
//

import Cocoa
import SwiftHTTP

class LCImportPanelViewController: NSViewController, LCCameraNameReceiver {
    
    @IBOutlet weak var camName: NSTextField!
    @IBOutlet weak var importTitleLabel: NSTextField!
    @IBOutlet weak var progessBar: NSProgressIndicator!
    @IBOutlet weak var destinationPathControl: NSPathControl!
    
    var selectedImages : [FileData]?
    var cameraNameReader : LCCameraNameReader = LCCameraNameReader()
    
    let cameraAdress = "http://192.168.0.10"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        cameraNameReader.delegate = self
        cameraNameReader.requestCameraName(cameraAdress)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "imageSelectionChanged:", name: "ImageSelectionChange", object: nil)
        
        if let path = NSSearchPathForDirectoriesInDomains(.PicturesDirectory, .UserDomainMask, true).first as? String {
            destinationPathControl.URL = NSURL(string: path)
        }
        
        camName.stringValue = "Verbindungsaufbau..."
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
        var imagesToDownload = selectedImages!
        
        var request = HTTPTask()
        let numOfImages = Double(imagesToDownload.count)
        var n = 0.0
        for image in imagesToDownload {
            let task = request.download(cameraAdress + image.path + "/" + image.filename, parameters: nil, progress: { (complete : Double) -> Void in
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let prog = 100.0*n/numOfImages + (complete * 100)/numOfImages
                    self.progessBar.doubleValue = prog
                    if (complete == 1.0) {
                        n = n + 1.0
                    }
                })
                
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
    
    func imageSelectionChanged(notification: NSNotification) {
        selectedImages = notification.object as? [FileData]
        importTitleLabel.stringValue = "Import von \((notification.object as! NSArray).count) Dateien"
    }
    
    func cameraNameRead(cameraName: String) {
        self.camName.stringValue = "Verbunden mit " + cameraName
    }
    
    func cameraNameReadingFailed(error: NSError) {
        self.camName.stringValue = "Verbindungsfehler!"
    }
    
}
