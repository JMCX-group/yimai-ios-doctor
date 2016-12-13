//
//  YMIMUtility.swift
//  YiMai
//
//  Created by superxing on 16/9/28.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

class YMIMUtility: NSObject {
    static func GetRecentContactDoctorsIdList() -> [String] {
        var idList = [String]()
        
        let blacklistStr = YMVar.GetStringByKey(YMVar.MyUserInfo, key: "blacklist")
        let blacklist = blacklistStr.componentsSeparatedByString(",")
        let conversationList = RCIMClient.sharedRCIMClient().getConversationList([RCConversationType.ConversationType_PRIVATE.rawValue])

        var i: Int = 0
        for conversation in conversationList {
            let targetId = "\(conversation.targetId)"
            let fromId = "\(conversation.userId)"
            
            if(targetId == YMVar.MyDoctorId) {
                if(blacklist.contains(fromId)) {
                    continue
                }
                idList.append(fromId)
            } else {
                if(blacklist.contains(targetId)) {
                    continue
                }
                idList.append(targetId)
            }
            
            i += 1
            if(i >= 10) {
                break
            }
        }

        return idList
    }
    
    static func GetLastMessageString(msg: NSDictionary) -> String {
        if (nil == msg["imageUri"] as? String) {
            return "\(msg["content"]!)"
        } else {
            return "【图片】"
        }
    }
    
    static func TimestampToString(timestamp: Double) -> String {
        let fmt = NSDateFormatter()
        fmt.dateFormat="yyyy-MM-dd HH:mm:ss"
        
        let date = NSDate(timeIntervalSince1970: timestamp)
        
        return fmt.stringFromDate(date)
    }
}































