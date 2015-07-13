//
//  FileData.swift
//  LympiControl
//
//  Created by David Bohn on 12.07.15.
//  Copyright (c) 2015 David Bohn. All rights reserved.
//

import Cocoa
import Quartz

class FileData: NSObject {
    var path : String
    var filename : String
    var filesize : Int
    
    var createdDate : Int
    var createdTime : Int
    
    var creationDate : NSDate? {
        get {
            return self.getCreationDate()
        }
    }
    
    var thumbnailUrl : NSURL {
        get {
            // println("http://192.168.0.10/get_thumbnail.cgi?DIR=" + path + "/" + filename)
            return NSURL(string: "http://192.168.0.10/get_thumbnail.cgi?DIR=" + path + "/" + filename)!
        }
    }
    
    override init() {
        path = ""
        filename = ""
        filesize = 0
        createdDate = 0
        createdTime = 0
    }
    
    init(path: String, filename: String, filesize: Int, createdDate : Int, createdTime : Int) {
        self.path = path
        self.filename = filename
        self.filesize = filesize
        self.createdDate = createdDate
        self.createdTime = createdTime
    }
    
    func getCreationDate() -> NSDate? {
        let secondMask = 0x001F
        let minuteMask = 0x07E0
        let hourMask = 0xF800
        
        var minute = (createdTime & minuteMask) >> 5
        var second = (createdTime & secondMask) * 2
        var hour = (createdTime & hourMask) >> 11
        
        let dayMask = 0x001F
        let monthMask = 0x01E0
        let yearMask = 0xFE00
        
        var day = (createdDate & dayMask)
        var month = (createdDate & monthMask) >> 5
        var year = ((createdDate & yearMask) >> 9)+1980
        
        var components = NSDateComponents()
        components.second = second
        components.minute = minute
        components.hour = hour
        components.day = day
        components.month = month
        components.year = year
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        
        //println("Minute: \(minute)")
        //println("Stunde: \(hour)")
        return calendar?.dateFromComponents(components)
    }
    
    override func imageRepresentationType() -> String! {
        return IKImageBrowserNSURLRepresentationType;
    }
    
    override func imageRepresentation() -> AnyObject! {
        return self.thumbnailUrl
    }
    
    override func imageUID() -> String! {
        return self.thumbnailUrl.absoluteString
    }
    
    override func imageTitle() -> String! {
        return self.filename
    }
    
    override func imageSubtitle() -> String! {
        let byteformatter = NSByteCountFormatter()
        let dateformatter = NSDateFormatter()
        dateformatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateformatter.timeStyle = NSDateFormatterStyle.ShortStyle
        return byteformatter.stringFromByteCount(Int64(self.filesize)) + ", " + dateformatter.stringFromDate(self.creationDate!)
    }

}
