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
    
    public static func Clear() {
        YMVar.MyUserInfo.removeAll()
        YMVar.MySysInfo.removeAll()
        YMVar.MyDoctorId = ""

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
        
        return "\(ret!)"
    }
    
    public static func GetIntStringByKey(dict: [String: AnyObject], key: String) -> String {
        let ret = dict[key] as? Int
        if(nil == ret) {
            return ""
        }
        
        return "\(ret!)"
    }
    
    static func TryToGetArrayFromJsonStringData(json: String) -> NSArray? {
        let data = json.dataUsingEncoding(NSUTF8StringEncoding)
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
    
    static func TransObjectToString(obj: AnyObject) -> String {
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(obj, options: NSJSONWritingOptions.PrettyPrinted)
        let strJson = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
        
        return strJson
    }
}











