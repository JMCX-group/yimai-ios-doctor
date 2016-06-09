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

    static let APPInit = YMAPIInterfaceURL.ApiBaseUrl + "/init"

    static let RegisterURL = YMAPIInterfaceURL.ApiBaseUrl + "/user/register"
    static let GetUserRegisterVerifyCodeURL = YMAPIInterfaceURL.ApiBaseUrl + "/user/verify-code"
    static let UerLogin = YMAPIInterfaceURL.ApiBaseUrl + "/user/login"
    static let GetSearchResult = YMAPIInterfaceURL.ApiBaseUrl + "/user/search"
    static let QueryUserInfo = YMAPIInterfaceURL.ApiBaseUrl + "/user/me"
    static let QueryUserInfoById = YMAPIInterfaceURL.ApiBaseUrl + "/user"
    
    static let GetCity = YMAPIInterfaceURL.ApiBaseUrl + "/city"
    static let GetCityGrouped = YMAPIInterfaceURL.ApiBaseUrl + "/city/group"
    
    static let SearchHospital = YMAPIInterfaceURL.ApiBaseUrl + "/hospital/search"
    static let GetHospitalById = YMAPIInterfaceURL.ApiBaseUrl + "/hospital"
    static let GetHospitalsByCity = YMAPIInterfaceURL.ApiBaseUrl + "/hospital/city"
    
    static let GetDepartment = YMAPIInterfaceURL.ApiBaseUrl + "/dept"
    
    static let GetInitRelation = YMAPIInterfaceURL.ApiBaseUrl + "/relation"
    static let GetLevel1Relation = YMAPIInterfaceURL.ApiBaseUrl + "/relation/friends"
    static let GetLevel2Relation = YMAPIInterfaceURL.ApiBaseUrl + "/relation/friends-friends"
    static let RelationAddFriend = YMAPIInterfaceURL.ApiBaseUrl + "/relation/add-friend"
    static let RelationCommonFriends = YMAPIInterfaceURL.ApiBaseUrl + "/relation/common-friends"
    static let RelationNewFriends = YMAPIInterfaceURL.ApiBaseUrl + "/relation/new-friends"
    static let RelationRemarks = YMAPIInterfaceURL.ApiBaseUrl + "/relation/remarks"
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
    
    private static func AppendTokenToUrl(url:String, token: String) -> String {
        return url + "?\(YMCommonStrings.CS_API_PARAM_KEY_TOKEN)=\(token)"
    }
    
    private static func AppendRouteParamToUrl(url:String, value: String) -> String {
        let encodedString = value.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        if(nil != encodedString) {
            return url + "/\(encodedString!)"
        } else {
            return url + "/?&"
        }
        
    }
    
    private static func AppendRouteParamToUrl(url:String, value: Int) -> String {
        return url + "/\(value)"
    }
    
    init(key: String) {
        self.Key = key
    }
    
    init(key: String, success: YMAPIJsonCallback, error: YMAPIErrorCallback) {
        self.Key = key
        YMAPICommonVariable.SetJsonCallback(key, callback: success, update: false)
        YMAPICommonVariable.SetErrorCallback(key, callback: error, update: false)
    }
    
    init(key: String, success: YMAPIImageCallback, error: YMAPIErrorCallback) {
        self.Key = key
        YMAPICommonVariable.SetImageCallback(key, callback: success, update: false)
        YMAPICommonVariable.SetErrorCallback(key, callback: error, update: false)
    }
    
    private func JsonResponseSuccessHandler(sessionDataTask: NSURLSessionDataTask, data: AnyObject?) {
        let callback = YMAPICommonVariable.JsonCallbackMap[self.Key]
        var jsonData = data as? NSDictionary
        
        if(nil == jsonData) {
            jsonData = ["arr":data!]
        }
        
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
    
    private func GetRequestConfig(url: String, param: AnyObject?, progressHandler: NetworkProgressHandler?) -> YMNetworkRequestConfig{
        let config = self.GetDefaultConfig(url)
        
        config.ProgressHandler = progressHandler
        config.Param = param

        return config
    }
    
    private func DoPostRequest(url: String, param: AnyObject?, progressHandler: NetworkProgressHandler?) {
        let config = self.GetRequestConfig(url,param: param, progressHandler: progressHandler)
        let network = YMNetwork()
        network.RequestJsonByPost(config)
        
    }
    
    private func DoGetRequest(url: String, param: AnyObject?, progressHandler: NetworkProgressHandler?) {
        let config = self.GetRequestConfig(url,param: param, progressHandler: progressHandler)
        let network = YMNetwork()
        network.RequestJsonByGet(config)
    }
    private func GetDefaultConfig(url: String) -> YMNetworkRequestConfig {
        let config = YMNetworkRequestConfig()
        
        config.URL = url
        config.SuccessHandler = self.JsonResponseSuccessHandler
        config.ErrorHandler = self.JsonResponseErrorHandler
        
        return config
    }
    
    public func RegisterUser(param: AnyObject, progressHandler: NetworkProgressHandler?) {
        DoPostRequest(YMAPIInterfaceURL.RegisterURL, param: param, progressHandler: progressHandler)
    }
    
    public func GetVerifyCode(param: AnyObject, progressHandler: NetworkProgressHandler?) {
        DoPostRequest(YMAPIInterfaceURL.GetUserRegisterVerifyCodeURL, param: param, progressHandler: progressHandler)
    }
    
    public func YMUserLogin(param: AnyObject, progressHandler: NetworkProgressHandler?) {
        DoPostRequest(YMAPIInterfaceURL.UerLogin, param: param, progressHandler: progressHandler)
    }
    
    public func YMGetAPPInitData() -> Bool {
        let token = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_TOKEN)
        if(nil == token) {
            return false
        }
        YMAPICommonVariable.SetJsonCallback(YMAPIStrings.CS_API_ACTION_NAME_INIT_DATA,
                                            callback: YMAPIUtility.YMGetInitDataSuccess, update: false)
        
        YMAPICommonVariable.SetErrorCallback(YMAPIStrings.CS_API_ACTION_NAME_INIT_DATA,
                                             callback: YMAPIUtility.YMGetInitDataError, update: false)
        
        let param = [YMCommonStrings.CS_API_PARAM_KEY_TOKEN: token! as! String]
        
        DoGetRequest(YMAPIInterfaceURL.APPInit, param: param, progressHandler: nil)
        
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
    
    public func YMGetSearchResult(param:[String: AnyObject], progressHandler: NetworkProgressHandler?) {
        let token = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_TOKEN)
        if(nil == token) {
            return
        }
        
        let url = YMAPIUtility.AppendTokenToUrl(YMAPIInterfaceURL.GetSearchResult, token: token! as! String)
        
        DoPostRequest(url, param: param, progressHandler: progressHandler)
    }
    
    public func YMQueryUserInfo() {
        let token = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_TOKEN)
        if(nil == token) {
            return
        }

        let url = YMAPIUtility.AppendTokenToUrl(YMAPIInterfaceURL.QueryUserInfo, token: token! as! String)

        DoGetRequest(url, param: nil, progressHandler: nil)
    }
    
    public func YMQueryUserInfoById(doctorId: String) {
        let token = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_TOKEN)
        if(nil == token) {
            return
        }
        
        var url = YMAPIUtility.AppendRouteParamToUrl(YMAPIInterfaceURL.QueryUserInfoById, value: doctorId)
        url = YMAPIUtility.AppendTokenToUrl(url, token: token! as! String)

        DoGetRequest(url, param: nil, progressHandler: nil)
    }
    
    public func YMGetCity() {
        let token = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_TOKEN)
        if(nil == token) {
            return
        }
        
        let url = YMAPIUtility.AppendTokenToUrl(YMAPIInterfaceURL.GetCity, token: token! as! String)
        DoGetRequest(url, param: nil, progressHandler: nil)
    }
    
    public func YMGetCityGroupByProvince() {
        let token = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_TOKEN)
        if(nil == token) {
            return
        }
        
        let url = YMAPIUtility.AppendTokenToUrl(YMAPIInterfaceURL.GetCityGrouped, token: token! as! String)
        DoGetRequest(url, param: nil, progressHandler: nil)
    }
    
    public func YMSearchHospital(keyWord: String) {
        let token = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_TOKEN)
        if(nil == token) {
            return
        }
        
        var url = YMAPIUtility.AppendRouteParamToUrl(YMAPIInterfaceURL.SearchHospital, value: keyWord)
        url = YMAPIUtility.AppendTokenToUrl(url, token: token! as! String)

        DoGetRequest(url, param: nil, progressHandler: nil)
    }
    
    public func YMGetHospitalById(hospitalId: String) {
        let token = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_TOKEN)
        if(nil == token) {
            return
        }
        
        var url = YMAPIUtility.AppendRouteParamToUrl(YMAPIInterfaceURL.GetHospitalById, value: hospitalId)
        url = YMAPIUtility.AppendTokenToUrl(url, token: token! as! String)
        
        DoGetRequest(url, param: nil, progressHandler: nil)
    }
    
    public func YMGetHospitalsByCity(cityId: String) {
        let token = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_TOKEN)
        if(nil == token) {
            return
        }
        
        var url = YMAPIUtility.AppendRouteParamToUrl(YMAPIInterfaceURL.GetHospitalsByCity, value: cityId)
        url = YMAPIUtility.AppendTokenToUrl(url, token: token! as! String)
        
        DoGetRequest(url, param: nil, progressHandler: nil)
    }
    
    public func YMGetDept() {
        let token = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_TOKEN)
        if(nil == token) {
            return
        }
        
        let url = YMAPIUtility.AppendTokenToUrl(YMAPIInterfaceURL.GetDepartment, token: token! as! String)
        DoGetRequest(url, param: nil, progressHandler: nil)
    }
    
    public func YMGetInitRelation() {
        let token = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_TOKEN)
        if(nil == token) {
            return
        }
        
        let url = YMAPIUtility.AppendTokenToUrl(YMAPIInterfaceURL.GetInitRelation, token: token! as! String)
        DoGetRequest(url, param: nil, progressHandler: nil)
    }
    
    public func YMGetLevel1Relation() {
        let token = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_TOKEN)
        if(nil == token) {
            return
        }
        
        let url = YMAPIUtility.AppendTokenToUrl(YMAPIInterfaceURL.GetLevel1Relation, token: token! as! String)
        DoGetRequest(url, param: nil, progressHandler: nil)
    }
    
    public func YMGetLevel2Relation() {
        let token = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_TOKEN)
        if(nil == token) {
            return
        }
        
        let url = YMAPIUtility.AppendTokenToUrl(YMAPIInterfaceURL.GetLevel2Relation, token: token! as! String)
        DoGetRequest(url, param: nil, progressHandler: nil)
    }
    
    public func YMAddFriendByPhone(phone: String) {
        let token = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_TOKEN)
        if(nil == token) {
            return
        }
        
        let url = YMAPIUtility.AppendTokenToUrl(YMAPIInterfaceURL.RelationAddFriend, token: token! as! String)
        DoPostRequest(url, param: [YMCommonStrings.CS_API_PARAM_KEY_PHONE: phone], progressHandler: nil)
    }
    
    public func YMGetRelationCommonFriends(friendId: String) {
        let token = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_TOKEN)
        if(nil == token) {
            return
        }
        
        var url = YMAPIUtility.AppendRouteParamToUrl(YMAPIInterfaceURL.RelationCommonFriends, value: friendId)
        url = YMAPIUtility.AppendTokenToUrl(url, token: token! as! String)
        print(url)
        DoGetRequest(url, param: nil, progressHandler: nil)
    }
    
    public func YMGetRelationNewFriends() {
        let token = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_TOKEN)
        if(nil == token) {
            return
        }
        
        let url = YMAPIUtility.AppendTokenToUrl(YMAPIInterfaceURL.RelationNewFriends, token: token! as! String)
        DoGetRequest(url, param: nil, progressHandler: nil)
    }
    
    public func YMGetRelationFriendRemarks(friend_id: String, remarks: String) {
        let token = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_TOKEN)
        if(nil == token) {
            return
        }
        
        let url = YMAPIUtility.AppendTokenToUrl(YMAPIInterfaceURL.RelationRemarks, token: token! as! String)
        DoPostRequest(url,
                     param: [YMCommonStrings.CS_API_PARAM_KEY_FRIEND_ID: friend_id,
                        YMCommonStrings.CS_API_PARAM_KEY_REMARKS: remarks],
                     progressHandler: nil)
    }
}





























