//
//  FileDataLoader.swift
//  LympiControl
//
//  Created by David Bohn on 13.07.15.
//  Copyright (c) 2015 David Bohn. All rights reserved.
//

import Cocoa
import SwiftHTTP

class FileDataLoader: NSObject {
    
    func loadFileData(baseUrl : String,  completion: ((data: [FileData]?) -> Void)) -> Void {
        
        var request = HTTPTask()
        
        request.GET(baseUrl + "/get_imglist.cgi?DIR=/DCIM/100OLYMP", parameters: nil, completionHandler: {(response: HTTPResponse) in
            if let data = response.responseObject as? NSData {
                var linereader = BRLineReader(data: data, encoding: NSUTF8StringEncoding)
                
                var result = [FileData]()
                
                while let line = linereader.readLine() {
                    if line.hasPrefix("VER_100") {
                        continue
                    }
                    
                    var splitLine = split(line) {$0 == ","}
                    
                    let time = splitLine[5].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).toInt()!
                    
                    // println(splitLine)
                    
                    result.append(FileData(path: splitLine[0], filename: splitLine[1], filesize: splitLine[2].toInt()!, createdDate: splitLine[4].toInt()!, createdTime: time))
                }
                
                completion(data: result)
            }
        })
    }
}
