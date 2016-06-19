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
    static let RelationFriendRemarks = YMAPIInterfaceURL.ApiBaseUrl + "/relation/remarks"
    static let RelationPushRecentContacts = YMAPIInterfaceURL.ApiBaseUrl + "/relation/push-recent-contacts"
    static let RelationDelFriend = YMAPIInterfaceURL.ApiBaseUrl + "/relation/del"
    
    static let GetAllRadio = YMAPIInterfaceURL.ApiBaseUrl + "/radio"
    static let SetRadioHaveRead = YMAPIInterfaceURL.ApiBaseUrl + "/radio/read"
    
    static let CreateNewAppointment = YMAPIInterfaceURL.ApiBaseUrl + "/appointment/new"
    static let GetAppointmentList = YMAPIInterfaceURL.ApiBaseUrl + "/appointment/list"
    static let GetAppointmentDetail = YMAPIInterfaceURL.ApiBaseUrl + "/appointment/detail"
    
    static let GetAdmissionsList = YMAPIInterfaceURL.ApiBaseUrl + "/admissions/list"
    static let GetAdmissionDetail = YMAPIInterfaceURL.ApiBaseUrl + "/admissions/detail"
    static let AdmissionAgree = YMAPIInterfaceURL.ApiBaseUrl + "/admissions/agree"
    static let AdmissionRefusal = YMAPIInterfaceURL.ApiBaseUrl + "/admissions/refusal"
    static let AdmissionComplete = YMAPIInterfaceURL.ApiBaseUrl + "/admissions/complete"
    static let AdmissionRescheduled = YMAPIInterfaceURL.ApiBaseUrl + "/admissions/rescheduled"
    static let AdmissionCancel = YMAPIInterfaceURL.ApiBaseUrl + "/admissions/cancel"
    
    static let CreateFace2FaceAdvice = YMAPIInterfaceURL.ApiBaseUrl + "/f2f-advice/new"
    
    static let GetPatientInfo = YMAPIInterfaceURL.ApiBaseUrl + "/patient/get-by-phone"
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
    
    private static func YMUrlEncode(str: String) -> String {
        let encodedString = str.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        if(nil != encodedString) {
            return encodedString!
        } else {
            return "?&"
        }
    }
    
    private static func AppendRouteParamToUrl(url:String, value: String) -> String {
        return url + "/" + YMAPIUtility.YMUrlEncode(value)
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
        if(nil == data) {
            let response = sessionDataTask.response as! NSHTTPURLResponse
            print("data is nil and code is :\(response.statusCode)")
            return
        }
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

    private func YMAPIPost(baseUrl: String, param: AnyObject?, progressHandler: NetworkProgressHandler?) {
        let token = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_TOKEN)
        if(nil == token) {
            return
        }
        
        let url = YMAPIUtility.AppendTokenToUrl(baseUrl, token: token! as! String)
        DoPostRequest(url,
                      param: param,
                      progressHandler: progressHandler)
    }
    
    private func YMAPIGet(baseUrl: String, param: AnyObject?, progressHandler: NetworkProgressHandler?) {
        let token = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_TOKEN)
        if(nil == token) {
            return
        }
        
        let url = YMAPIUtility.AppendTokenToUrl(baseUrl, token: token! as! String)
        DoGetRequest(url, param: param, progressHandler: progressHandler)
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
    
    public func YMGetVerifyCode(param: AnyObject, progressHandler: NetworkProgressHandler? = nil) {
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
                                            callback: self.YMGetInitDataSuccess, update: false)
        
        YMAPICommonVariable.SetErrorCallback(YMAPIStrings.CS_API_ACTION_NAME_INIT_DATA,
                                             callback: self.YMGetInitDataError, update: false)
        
        let param = [YMCommonStrings.CS_API_PARAM_KEY_TOKEN: token! as! String]
        
        DoGetRequest(YMAPIInterfaceURL.APPInit, param: param, progressHandler: nil)
        
        return true
    }
    
    private func YMGetInitDataSuccess(data: NSDictionary?) {
        let realData = data!
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_USER_INFO, data: realData[YMCoreDataKeyStrings.INIT_DATA_USER]!)
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_SYSTEM_INFO, data: realData[YMCoreDataKeyStrings.INIT_DATA_SYS_INFO]!)
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_USER_RELATIONS, data: realData[YMCoreDataKeyStrings.INIT_DATA_RELATIONS]!)
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_RECENT_CONTACTS, data: realData[YMCoreDataKeyStrings.INIT_DATA_RECENT_CONTACTS]!)
    }
    
    private func YMGetInitDataError(error: NSError) {
        self.YMGetAPPInitData()
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
        
        let url = YMAPIUtility.AppendTokenToUrl(YMAPIInterfaceURL.RelationFriendRemarks, token: token! as! String)
        DoPostRequest(url,
                     param: [YMCommonStrings.CS_API_PARAM_KEY_FRIEND_ID: friend_id,
                        YMCommonStrings.CS_API_PARAM_KEY_REMARKS: remarks],
                     progressHandler: nil)
    }
    
    public func YMGetRelationFriendRemarks(idList: String) {
        let token = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_TOKEN)
        if(nil == token) {
            return
        }
        
        let url = YMAPIUtility.AppendTokenToUrl(YMAPIInterfaceURL.RelationPushRecentContacts, token: token! as! String)
        DoPostRequest(url,
                      param: [YMCommonStrings.CS_API_PARAM_KEY_ID_LIST: idList],
                      progressHandler: nil)
    }
    
    public func YMRelationDelFriend(friendId: String) {
        let token = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_TOKEN)
        if(nil == token) {
            return
        }
        
        let url = YMAPIUtility.AppendTokenToUrl(YMAPIInterfaceURL.RelationDelFriend, token: token! as! String)
        DoPostRequest(url,
                      param: [YMCommonStrings.CS_API_PARAM_KEY_FRIEND_ID: friendId],
                      progressHandler: nil)
    }

    //TODO: 修改此方法以上的API接口调用方式
    public func YMGetAllRadio(page: String? = nil) {
        if(nil == page){
            YMAPIGet(YMAPIInterfaceURL.GetAllRadio, param: nil, progressHandler: nil)
        } else {
            YMAPIGet(YMAPIInterfaceURL.GetAllRadio, param: [YMCommonStrings.CS_API_PARAM_KEY_PAGE: page!], progressHandler: nil)
        }
    }
    
    public func YMSetRadioHaveRead(id: String) {
        YMAPIPost(YMAPIInterfaceURL.SetRadioHaveRead,
                  param: [YMCommonStrings.CS_API_PARAM_KEY_FRIEND_ID: id],
                  progressHandler: nil)
    }
    
    public func YMCreateNewAppointment(param: AnyObject) {
        YMAPIPost(YMAPIInterfaceURL.CreateNewAppointment, param: param, progressHandler: nil)
    }
    
    public func YMGetAppointmentList() {
        YMAPIGet(YMAPIInterfaceURL.GetAppointmentList, param: nil, progressHandler: nil)
    }
    
    public func YMGetAppointmentDetail(appointmentId: String) {
        let url = YMAPIUtility.AppendRouteParamToUrl(YMAPIInterfaceURL.GetAppointmentDetail, value: appointmentId)
        YMAPIGet(url, param: nil, progressHandler: nil)
    }
    
    public func YMGetAdmissionsList() {
        YMAPIGet(YMAPIInterfaceURL.GetAdmissionsList, param: nil, progressHandler: nil)
    }
    
    public func YMGetAdmissionDetail(appointmentId: String) {
        let url = YMAPIUtility.AppendRouteParamToUrl(YMAPIInterfaceURL.GetAdmissionDetail, value: appointmentId)
        YMAPIGet(url, param: nil, progressHandler: nil)
    }
    
    public func YMAdmissionAgree(param: AnyObject) {
        YMAPIPost(YMAPIInterfaceURL.AdmissionAgree, param: param, progressHandler: nil)
    }
    
    public func YMAdmissionRefusal(param: AnyObject) {
        YMAPIPost(YMAPIInterfaceURL.AdmissionRefusal, param: param, progressHandler: nil)
    }
    
    public func YMAdmissionComplete(param: AnyObject) {
        YMAPIPost(YMAPIInterfaceURL.AdmissionComplete, param: param, progressHandler: nil)
    }
    
    public func YMAdmissionRescheduled(param: AnyObject) {
        YMAPIPost(YMAPIInterfaceURL.AdmissionRescheduled, param: param, progressHandler: nil)
    }
    
    public func YMAdmissionCancel(param: AnyObject) {
        YMAPIPost(YMAPIInterfaceURL.AdmissionCancel, param: param, progressHandler: nil)
    }
    
    public func YMCreateNewFace2FaceAdvice(param: AnyObject) {
        YMAPIPost(YMAPIInterfaceURL.CreateFace2FaceAdvice, param: param, progressHandler: nil)
    }
    
    public func YMGetPatientInfo(phone: String){
        YMAPIGet(YMAPIInterfaceURL.GetPatientInfo,
                 param: [YMCommonStrings.CS_API_PARAM_KEY_PHONE: phone],
                 progressHandler: nil)
    }
}





























