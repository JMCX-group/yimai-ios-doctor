//
//  YMAPIUtility.swift
//  storyboard-try
//
//  Created by why on 16/5/5.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import AFNetworking

public typealias YMAPIJsonCallback = ((NSDictionary?) -> Void)
public typealias YMAPIImageCallback = ((UIImage?) -> Void)
public typealias YMAPIErrorCallback = ((NSError) -> Void)

class YMAPIInterfaceURL {
    static let ApiBaseUrl = "http://101.201.40.220/api"
    static let RegisterURL = YMAPIInterfaceURL.ApiBaseUrl + "/user/register"
    static let GetUserRegisterVerifyCodeURL = YMAPIInterfaceURL.ApiBaseUrl + "/user/verify-code"
    static let UerLogin = YMAPIInterfaceURL.ApiBaseUrl + "/user/login"
    static let APPInit = YMAPIInterfaceURL.ApiBaseUrl + "/init"
}

public class YMAPICommonVariable {
    private static var JsonCallbackMap = Dictionary<String, YMAPIJsonCallback>()
    private static var ImageCallbackMap = Dictionary<String, YMAPIImageCallback>()
    private static var ErrorCallbackMap = Dictionary<String, YMAPIErrorCallback>()
    private static var Token = ""
    
    public static func SetJsonCallback(key:String, callback: YMAPIJsonCallback, update: Bool) {
        let preCallback = YMAPICommonVariable.JsonCallbackMap[key]
        if(nil != preCallback && update) {
            YMAPICommonVariable.JsonCallbackMap[key] = callback
        } else if(nil == preCallback) {
            YMAPICommonVariable.JsonCallbackMap[key] = callback
        }
    }
    
    public static func SetImageCallback(key:String, callback: YMAPIImageCallback, update: Bool){
        let preCallback = YMAPICommonVariable.ImageCallbackMap[key]
        if(nil != preCallback && update) {
            YMAPICommonVariable.ImageCallbackMap[key] = callback
        } else if(nil == preCallback) {
            YMAPICommonVariable.ImageCallbackMap[key] = callback
        }
    }
    
    public static func SetErrorCallback(key:String, callback: YMAPIErrorCallback, update: Bool){
        let preCallback = YMAPICommonVariable.ErrorCallbackMap[key]
        if(nil != preCallback && update) {
            YMAPICommonVariable.ErrorCallbackMap[key] = callback
        } else if(nil == preCallback) {
            YMAPICommonVariable.ErrorCallbackMap[key] = callback
        }
    }
    
    public static func SetToken(token: String) {
        YMAPICommonVariable.Token = token
    }
    
    public static func GetToken() -> String {
        return YMAPICommonVariable.Token
    }
    
    public static func AddTokenToUrl(URL: String) -> String {
        return URL+"&token="+YMAPICommonVariable.Token
    }
}

public class YMAPIUtility {

    private var Key: String = ""
    
    init(key: String) {
        self.Key = key
    }
    
    private func JsonResponseSuccessHandler(sessionDataTask: NSURLSessionDataTask, data: AnyObject?) {
        let callback = YMAPICommonVariable.JsonCallbackMap[self.Key]
        let jsonData = data as? NSDictionary
        
        if(nil != callback) {
            callback!(jsonData)
        }
    }
    
    private func JsonResponseErrorHandler(sessionDataTask: NSURLSessionDataTask?, errInfo: NSError){
        let callback = YMAPICommonVariable.ErrorCallbackMap[self.Key]
        
        if(nil != callback) {
            callback!(errInfo)
        }
    }
    
    private func GetDefaultConfig(url: String) -> YMNetworkRequestConfig {
        let config = YMNetworkRequestConfig()
        
        config.URL = url
        config.SuccessHandler = self.JsonResponseSuccessHandler
        config.ErrorHandler = self.JsonResponseErrorHandler
        
        return config
    }
    
    public func RegisterUser(param: AnyObject, progressHandler: NetworkProgressHandler?) {
        let config = self.GetDefaultConfig(YMAPIInterfaceURL.RegisterURL)
        let network = YMNetwork()

        config.ProgressHandler = progressHandler
        config.Param = param

        network.RequestJsonByPost(config)
    }
    
    public func GetVerifyCode(param: AnyObject, progressHandler: NetworkProgressHandler?) {
        let config = self.GetDefaultConfig(YMAPIInterfaceURL.GetUserRegisterVerifyCodeURL)
        let network = YMNetwork()

        config.ProgressHandler = progressHandler
        config.Param = param
        
        network.RequestJsonByPost(config)
    }
    
    public func YMUserLogin(param: AnyObject, progressHandler: NetworkProgressHandler?) {
        let config = self.GetDefaultConfig(YMAPIInterfaceURL.UerLogin)
        let network = YMNetwork()
        
        config.ProgressHandler = progressHandler
        config.Param = param
        
        network.RequestJsonByPost(config)
    }
    
    public func YMGetAPPInitData() -> Bool {
        let token = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_TOKEN)
        if(nil == token) {
            return false
        }
        
        let config = self.GetDefaultConfig(YMAPIInterfaceURL.APPInit)
        let network = YMNetwork()
        
        config.ProgressHandler = nil
        config.Param = [YMCommonStrings.CS_API_PARAM_KEY_TOKEN: token! as! String]
        
        YMAPICommonVariable.SetJsonCallback(YMAPIStrings.CS_API_ACTION_NAME_INIT_DATA,
            callback: YMAPIUtility.YMGetInitDataSuccess, update: false)
        
        YMAPICommonVariable.SetErrorCallback(YMAPIStrings.CS_API_ACTION_NAME_INIT_DATA,
                callback: YMAPIUtility.YMGetInitDataError, update: false)
        
        network.RequestJsonByGet(config)
        
        return true
    }
    
    private static func YMGetInitDataSuccess(data: NSDictionary?) {
        let realData = data!
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_USER_INFO, data: realData["user"]!)
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_SYSTEM_INFO, data: realData["sys_info"]!)
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_USER_RELATIONS, data: realData["relations"]!)
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_RECENT_CONTACTS, data: realData["recent_contacts"]!)
    }
    
    private static func YMGetInitDataError(error: NSError) {
        print(error)
    }
}





























