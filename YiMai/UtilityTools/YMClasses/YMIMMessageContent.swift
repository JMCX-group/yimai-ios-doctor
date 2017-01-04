//
//  YMIMCell.swift
//  YiMai
//
//  Created by why on 2017/1/3.
//  Copyright © 2017年 why. All rights reserved.
//

import Foundation
import Neon

class YMIMMessageContent: RCMessageContent {
    var SenderHeadimgUrl: String = ""
    var HeadimgUrl: String = ""
    var DoctorName: String = ""
    var DoctorId: String = ""
    var Hospital: String = ""
    var Department: String = ""
    var Jobtitle: String = "医生"
    
    override func encode() -> NSData! {
        let info: [String: String] = [
            "SenderHeadimgUrl": SenderHeadimgUrl,
            "HeadimgUrl": HeadimgUrl,
            "DoctorName": DoctorName,
            "DoctorId": DoctorId,
            "Hospital": Hospital,
            "Department": Department,
            "Jobtitle": Jobtitle
        ]
        
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(info, options: NSJSONWritingOptions.PrettyPrinted)
        return jsonData
    }
    
    override func decodeWithData(data: NSData) {
        let userData = YMVar.TryToGetDictFromJsonData(data)
        
        if(nil != userData) {
            let dict = userData as! [String: String]
            SenderHeadimgUrl = YMVar.GetStringByKey(dict, key: "SenderHeadimgUrl")
            HeadimgUrl = YMVar.GetStringByKey(dict, key: "HeadimgUrl")
            DoctorName = YMVar.GetStringByKey(dict, key: "DoctorName")
            DoctorId = YMVar.GetStringByKey(dict, key: "DoctorId")
            Hospital = YMVar.GetStringByKey(dict, key: "Hospital")
            Department = YMVar.GetStringByKey(dict, key: "Department")
            Jobtitle = YMVar.GetStringByKey(dict, key: "Jobtitle", defStr: "医生")
        }
    }
    
    func getObjectName() -> String! {
        return "YMIMMessageContent"
    }
    
    func persistentFlag() -> RCMessagePersistent! {
        return RCMessagePersistent.MessagePersistent_ISCOUNTED
    }
    
    override func conversationDigest() -> String! {
        return ""
    }
}






