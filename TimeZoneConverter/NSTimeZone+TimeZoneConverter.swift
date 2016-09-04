//
//  NSTimeZone+TimeZoneConverter.swift
//  TimeZoneConverterController
//
//  Created by Yarotsky, Eugene on 11/20/15.
//  Copyright (c) 2015 Yarotsky, Eugene. All rights reserved.
//

import Foundation

extension NSTimeZone {
    
    public class func  sorteredTimeZones() -> [NSTimeZone] {
        
        var timeZones = [String:NSTimeZone]()
        
        for timeZoneId in NSTimeZone.knownTimeZoneNames() {
            if let timeZone = NSTimeZone(name: timeZoneId ) {
                
                if timeZone.abbreviation!.hasPrefix("GMT") {
                    timeZones[String(timeZone.secondsFromGMT)] = timeZone // distincts time zones, because some zones have diff names, but the same offset.
                }
            }
        }
        
        let sorteredTimeZoneKeys = (timeZones as NSDictionary).keysSortedByValueUsingComparator({ (obj1, obj2) -> NSComparisonResult in
            if obj1.secondsFromGMT > obj2.secondsFromGMT {
                return NSComparisonResult.OrderedDescending
            } else if obj1.secondsFromGMT < obj2.secondsFromGMT {
                return NSComparisonResult.OrderedAscending
            } else {
                return NSComparisonResult.OrderedSame
            }
        })
        
        let sorteredDraftTimeZones = (timeZones as NSDictionary).objectsForKeys(sorteredTimeZoneKeys, notFoundMarker: "n.a.")//TODO check (timeZones as NSDictionary)
        
        var sorteredTimeZones = [NSTimeZone]()
        
        for draftZone in sorteredDraftTimeZones {
            if let timeZone = draftZone as? NSTimeZone {
                sorteredTimeZones.append(timeZone)
            }
        }
        return sorteredTimeZones
    }
    
    public class func localizedString(fromDate date: NSDate, andTimeZone timeZone: NSTimeZone? = nil) -> String {
        let format = NSDateFormatter()
        format.formatterBehavior = NSDateFormatter.defaultFormatterBehavior();
        format.dateStyle = NSDateFormatterStyle.MediumStyle
        format.timeStyle = NSDateFormatterStyle.ShortStyle
        
        if let _ = timeZone {
            format.timeZone = timeZone
        }
        
        let dateString = format.stringFromDate(date)
        return dateString
    }
    
    public class func date(fromLocalizedString localizedString: String, andTimeZone timeZone: NSTimeZone) -> NSDate? {
        let format = NSDateFormatter()
        format.formatterBehavior = NSDateFormatter.defaultFormatterBehavior()
        format.dateStyle = NSDateFormatterStyle.MediumStyle
        format.timeStyle = NSDateFormatterStyle.ShortStyle
        format.timeZone = timeZone;
        let date = format.dateFromString(localizedString)
        return date
    }
    
    public class func timeInterval(fromComponents components: NSDateComponents) -> String {
        var days = ""
        var hours = ""
        var minutes = ""
        
        let dayComponent = components.day
        let hourComponent = components.hour
        let minuteComponent = components.minute
        
        if abs(dayComponent) == 1 {
            days = "\(dayComponent) day"
        } else if dayComponent != 0 {
            days = "\(dayComponent) days"
        }
        
        if abs(hourComponent) == 1 {
            hours = "\(hourComponent) hour"
        } else if hourComponent != 0 {
            hours = "\(hourComponent) hours"
        }
        
        if abs(minuteComponent) == 1 {
            minutes = "\(minuteComponent) minute"
        } else if minuteComponent != 0 {
            minutes = "\(minuteComponent) minutes"
        }
        
        
        let intervalSting = "\(days) \(hours) \(minutes)"
        
        var resultString = ""
        
        if dayComponent == 0 && hourComponent == 0 && minuteComponent == 0 {
            resultString = "Now"
        } else if dayComponent < 0 || hourComponent < 0 || minuteComponent < 0  {
            resultString = "Was \(intervalSting) ago"
        } else {
            resultString = "In \(intervalSting)"
        }
        
        return resultString
        
        
    }
    
    
}
