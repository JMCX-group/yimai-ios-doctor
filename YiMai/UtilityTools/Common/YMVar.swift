//
//  YMVar.swift
//  YiMai
//
//  Created by why on 16/6/21.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation

public class YMVar:NSObject {
    public static var MyDoctorId: String = ""
    public static var MyUserInfo: [String:AnyObject] = [String:AnyObject]()
    public static var MySysInfo: [String:AnyObject] = [String:AnyObject]()
    
    public static var MyNewBroadcastInfo: [String: AnyObject] = [String: AnyObject]()
    public static var MyNewAdmissionInfo: [String: AnyObject] = [String: AnyObject]()
    public static var MyNewAppointmentInfo: [String: AnyObject] = [String: AnyObject]()
    
    public static var DeviceToken: String = ""
    public static var RCLoginStatus = false
    
    public static func Clear() {
        YMVar.MyUserInfo.removeAll()
        YMVar.MySysInfo.removeAll()
        YMVar.MyDoctorId = ""
        YMVar.RCLoginStatus = false

        YMVar.MyNewBroadcastInfo.removeAll()
        YMVar.MyNewAdmissionInfo.removeAll()
        YMVar.MyNewAppointmentInfo.removeAll()
    }
    
    public static func GetStringByKey(dict: [String: AnyObject]?, key: String, defStr: String = "") -> String {
        if(nil == dict) {
            return defStr
        }
        let ret = dict![key]
        if(nil == ret) {
            return defStr
        }

        if("<null>" == "\(ret!)") {
            return defStr
        }
        
        let retStr = "\(ret!)"
        if(YMValueValidator.IsBlankString(retStr)) {
            return defStr
        }
        
        return "\(ret!)"
    }
    
    public static func GetIntStringByKey(dict: [String: AnyObject], key: String) -> String {
        let ret = dict[key] as? Int
        if(nil == ret) {
            return ""
        }
        
        return "\(ret!)"
    }
    
    static func TryToGetArrayFromJsonStringData(json: String?) -> NSArray? {
        if(nil == json) {
            return nil
        }
        let data = json!.dataUsingEncoding(NSUTF8StringEncoding)
        if(nil == data) { return nil }
        guard let ret = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSArray else { return nil }
        return ret
    }
    
    static func TryToGetDictFromJsonStringData(json: String) -> NSDictionary? {
        let data = json.dataUsingEncoding(NSUTF8StringEncoding)
        if(nil == data) { return nil }
        guard let ret = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary else { return nil }
        return ret
    }
    
    static func TryToGetDictFromJsonData(data: NSData?) -> NSDictionary? {
        if(nil == data) {
            return nil
        }
        
        guard let ret = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary else { return nil }
        return ret
    }
    
    static func TransObjectToString(obj: AnyObject) -> String {
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(obj, options: NSJSONWritingOptions.PrettyPrinted)
        let strJson = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
        
        return strJson
    }
    
    static func IsDocInBlacklist(userId: String) -> Bool {
        let blacklist = YMVar.GetStringByKey(YMVar.MyUserInfo, key: "blacklist").componentsSeparatedByString(",")
        return blacklist.contains(userId)
    }
    
    static func GetLocalUserHeadurl(userId: String) -> String {
        var targetHeadurl: String? = ""
        if(userId == YMVar.MyDoctorId) {
            targetHeadurl = YMVar.GetStringByKey(YMVar.MyUserInfo, key: "head_url")
            print(targetHeadurl)
        } else {
            targetHeadurl = YMLocalData.GetData(YMLocalDataStrings.DOC_HEAD_URL + userId) as? String
            if(nil == targetHeadurl) {
                targetHeadurl = "http://d.medi-link.cn/uploads/avatar/default.jpg"
            }
        }
        
        return targetHeadurl!
    }
}











