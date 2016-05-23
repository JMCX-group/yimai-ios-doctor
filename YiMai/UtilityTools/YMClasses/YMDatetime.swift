//
//  YMDatetime.swift
//  YiMai
//
//  Created by why on 16/4/29.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation

public class YMDatetimeString {
    public static func Today() -> String {
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd"
        return timeFormatter.stringFromDate(NSDate()) as String
    }
    
    public static func Yesterday() -> String {
        let dayBeforeNow: NSDate = NSDate().dateByAddingTimeInterval(-24*60*60)
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd"
        return timeFormatter.stringFromDate(dayBeforeNow) as String
    }
}