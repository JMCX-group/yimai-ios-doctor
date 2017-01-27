//
//  YMBackgroundRefresh.swift
//  YiMai
//
//  Created by Wang Huaiyu on 16/10/16.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit
import Proposer
import AudioToolbox

class YMBackgroundRefresh: NSObject {
    static var ShowNewFriendFlag = false
    static var ShowNewFriendCount: Int = 0
    static var ContactNew = [String: AnyObject]()
    static var IsGetContactNewFailed = false
    static var BroadcastFirstPage = [[String: AnyObject]]()
    
    static var LastNewFriends = [String: [String:AnyObject]]()
    
    static func CheckHasUnreadNewFriends() {
        var newFriends = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_NEW_FRIENDS) as? [[String:AnyObject]]
        
        if(nil == newFriends) {
            newFriends = [[String:AnyObject]]()
        }

        for f in newFriends! {
            let status = "\(f["status"]!)"
            let readStatus = "\(f["unread"]!)"
            let friendId = "\(f["id"]!)"

            if("1" != readStatus) {
//                let docName = YMVar.GetStringByKey(f, key: "name")

//                if("waitForSure" == status) {
//                    YMNotification.DoLocalNotification("医生\(docName)申请加您为好友", userData: YMNotificationType.NewFriendApply)
//                } else if ("isFriend" == status) {
//                    YMNotification.DoLocalNotification("医生\(docName)通过了您的好友申请", userData: YMNotificationType.YiMaiR1Changed)
//                }
            }
            
            let last = LastNewFriends[friendId]
            if(nil == last) {
                if("1" != readStatus && "isFriend" == status) {
                    ShowNewFriendCount += 1
                }
            }
            
            LastNewFriends[friendId] = f
            if("1" != readStatus){
                ShowNewFriendFlag = true
            }
        }
    }
    
    private static var StartFlag = false
    private static var GetBroadcastFirstPage: YMAPIUtility!
    private static var GetNewAdmissionList: YMAPIUtility!
    private static var GetNewAppointmentList: YMAPIUtility!
    
    private static var L1RelationApi: YMAPIUtility!
    private static var L2RelationApi: YMAPIUtility!
//    private static var NewFriendsRelationApi: YMAPIUtility!
    
    private static var MyInfoApi: YMAPIUtility!

    private static let SuccessDelay: Double = 1.0
    private static let ErrorDelay: Double = 10.0

    private static var GetContactsApi: YMAPIUtility! = nil

    private static let BackgroundQueue = dispatch_queue_create("com.YiMai.Background.Queue", DISPATCH_QUEUE_SERIAL)

    static func Start() {
        if(YMBackgroundRefresh.StartFlag) {
            return
        }
        YMBackgroundRefresh.StartFlag = true
        
        GetBroadcastFirstPage = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_BACKGROUND_REFRESH + "-broadcast",
                                             success: GetBroadcastSuccess, error: GetBroadcastError)
        
        GetNewAdmissionList = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_BACKGROUND_REFRESH + "-admission",
                                             success: GetAdmissionSuccess, error: GetAdmissionError)

        GetNewAppointmentList = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_BACKGROUND_REFRESH + "-appointment",
                                             success: GetAppointmentSuccess, error: GetAppointmentError)
        
        L1RelationApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_LEVEL1_RELATION + "-l1",
                                          success: Level1RelationSuccess, error: L1Err)
        
        L2RelationApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_LEVEL2_RELATION + "-l2",
                                          success: Level2RelationSuccess, error: L2Err)
        
//        NewFriendsRelationApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_NEW_FRIENDS + "-newf",
//                                                  success: NewFriendsSuccess, error: NFErr)
        
        GetContactsApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_NEW_FRIENDS + "-gct",
                                      success: GetContactsApiSuccessed, error: GetContactsApiError)
        
        MyInfoApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_QUERY_USER_BY_ID + "-me", success: MESuccess, error: MEError)
        
        DoApi()
    }
    
    static func DoContactCompare(prev: [[String: String]], cur: [[String: String]]) -> [[String: String]] {
        var ret = [[String: String]]()
        
        for curV in cur {
            var isNewPhone = true
            let phone = curV["phone"]!
            let name = curV["name"]!
            for prevV in prev {
                let prevPhone = prevV["phone"]!
                if(prevPhone == phone) {
                   isNewPhone = false
                    break
                }
            }
            
            if(isNewPhone) {
                ret.append(["phone": phone, "name": name])
            }
        }
        
        return ret
    }
    
    static private func GetContactsApiError(error: NSError){
        YMAPIUtility.PrintErrorInfo(error)
        IsGetContactNewFailed = true
        
        ReCompareContactBook(0.5)
    }
    
    static private func GetContactsApiSuccessed(data: NSDictionary?) {
        if(nil == data) {
            print("no result!!!")
        } else {
            ContactNew = data!["data"] as! [String: AnyObject]
        }
        
        IsGetContactNewFailed = false
        
        ReCompareContactBook()
        YMLocalData.SaveData(YMAddressBookTools.AllContacts, key: "YMLoaclContactAddressBook")
    }
    
    static func ReCompareContactBook(sec: Double = 10) {
        dispatch_after(dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(sec * Double(NSEC_PER_SEC))
        ), YMBackgroundRefresh.BackgroundQueue) {
            YMBackgroundRefresh.CompareContactBook()
        }
    }
    
    static func CompareContactBook() {
        let contacts: PrivateResource = PrivateResource.Contacts
//        YMAddressBookTools
        
        if(!contacts.isNotDeterminedAuthorization) {
            if(contacts.isAuthorized) {
//                let prevContact  = YMLocalData.GetData("YMLoaclContactAddressBook") as? [[String: String]]
                YMAddressBookTools().ReadAddressBook()

                if(0 != YMAddressBookTools.AllContacts.count) {
                    GetContactsApi.YMUploadAddressBook(YMAddressBookTools.AllContacts)
                } else {
                    ReCompareContactBook(0.5)
                }
//                if(nil != prevContact) {
//                    if(0 != prevContact!.count) {
//                        let someOneNew = DoContactCompare(prevContact!, cur: YMAddressBookTools.AllContacts)
//                        if(0 != someOneNew.count) {
//                            GetContactsApi.YMUploadAddressBook(YMAddressBookTools.AllContacts)
//                        }
//                    }
//                }
            } else {
                ReCompareContactBook()
            }
        } else  {
            ReCompareContactBook()
        }
    }
    
    
    static func DoApi() {
        GetBroadcastFirstPage.YMGetAllRadio()
        GetNewAdmissionList.YMGetNewAdmissionList()
        GetNewAppointmentList.YMGetNewAppointmentList()
        L1RelationApi.YMGetLevel1Relation()
        L2RelationApi.YMGetLevel2Relation()
//        NewFriendsRelationApi.YMGetRelationNewFriends()
        MyInfoApi.YMQueryUserInfoById(YMVar.MyDoctorId)
        CompareContactBook()
    }
    
    static func Stop() {
        YMBackgroundRefresh.StartFlag = false
    }
    
    static func Level1RelationSuccess(data: NSDictionary?) {
        let realData = data!
        let count = realData["count"] as! [String:AnyObject]
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_L1_FRIENDS_COUNT_INFO, data: count)
        
        let friends = realData["friends"] as! [AnyObject]
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_L1_FRIENDS, data: friends)
        
        YMDelay(YMBackgroundRefresh.SuccessDelay) {
            L1RelationApi.YMGetLevel1Relation()
        }
    }
    
    static func Level2RelationSuccess(data: NSDictionary?) {
        let realData = data!
        let count = realData["count"] as! [String:AnyObject]
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_L2_FRIENDS_COUNT_INFO, data: count)
        
        let friends = realData["friends"] as! [AnyObject]
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_L2_FRIENDS, data: friends)
        
        YMDelay(YMBackgroundRefresh.SuccessDelay) {
            L2RelationApi.YMGetLevel2Relation()
        }
    }
    
    static func NewFriendsSuccess(data: NSDictionary?) {
        if(nil == data) {
            YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_NEW_FRIENDS, data: [[String:AnyObject]]())
        } else {
            let realData = data!
            YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_NEW_FRIENDS, data: realData["friends"]!)
            CheckHasUnreadNewFriends()
        }
        
        YMBackgroundRefresh.CheckHasUnreadNewFriends()
        
        YMDelay(YMBackgroundRefresh.SuccessDelay) {
//            NewFriendsRelationApi.YMGetRelationNewFriends()
        }
    }

    static func GetAdmissionSuccess(data: NSDictionary?) {
        YMDelay(YMBackgroundRefresh.SuccessDelay) {
            GetNewAdmissionList.YMGetNewAdmissionList()
        }

        if(nil == data) {
            return
        }
        let admissionArr = data!["data"] as! [[String: AnyObject]]
        if(0 == admissionArr.count) {
            YMVar.MyNewAdmissionInfo.removeAll()
        } else {
            let prevId = YMVar.GetStringByKey(YMVar.MyNewAdmissionInfo, key: "id")
            let curId = YMVar.GetStringByKey(admissionArr[0], key: "id")
            if(prevId != curId) {
                AudioServicesPlaySystemSound(1003)
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                
//                YMNotification.DoLocalNotification("您有一条新的约诊请求", userData: YMNotificationType.NewAddmission)
            }
            YMVar.MyNewAdmissionInfo = admissionArr[0]
        }
    }

    static func GetAppointmentSuccess(data: NSDictionary?) {
        YMDelay(YMBackgroundRefresh.SuccessDelay) {
            GetNewAppointmentList.YMGetNewAppointmentList()
        }
        
        if(nil == data) {
            return
        }
        let appointmentArr = data!["data"] as! [[String: AnyObject]]
        if(0 == appointmentArr.count) {
            YMVar.MyNewAppointmentInfo.removeAll()
        } else {
            let prevId = YMVar.GetStringByKey(YMVar.MyNewAppointmentInfo, key: "id")
            let curId = YMVar.GetStringByKey(appointmentArr[0], key: "id")
            if(prevId != curId) {
                YMNotification.DoLocalNotification("您有一条新的约诊请求", userData: YMNotificationType.NewAppointment)
            }
            
            YMVar.MyNewAppointmentInfo = appointmentArr[0]
        }
    }
    
    static func GetBroadcastSuccess(data: NSDictionary?) {
        YMDelay(YMBackgroundRefresh.SuccessDelay) {
            GetBroadcastFirstPage.YMGetAllRadio()
        }
        
        if(nil == data) {
            return
        }
        let broadcastArr = data!["data"] as! [[String: AnyObject]]
        BroadcastFirstPage = broadcastArr
        if(0 == broadcastArr.count) {
            YMVar.MyNewBroadcastInfo.removeAll()
        } else {
            let newestBroadcast = broadcastArr[0]
            let readFlag = newestBroadcast["unread"] as? String
            if(nil != readFlag) {
                YMVar.MyNewBroadcastInfo = broadcastArr[0]
            } else {
                YMVar.MyNewBroadcastInfo.removeAll()
            }
        }
    }
    
    static func GetAdmissionError(_: NSError) {
        YMDelay(YMBackgroundRefresh.ErrorDelay) {
            GetNewAdmissionList.YMGetNewAdmissionList()
        }
    }

    static func GetAppointmentError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        YMDelay(YMBackgroundRefresh.ErrorDelay) {
            GetNewAppointmentList.YMGetNewAppointmentList()
        }
    }

    static func GetBroadcastError(_: NSError) {
        YMDelay(YMBackgroundRefresh.ErrorDelay) {
            GetBroadcastFirstPage.YMGetAllRadio()
        }
    }
    
    static func L1Err(error: NSError){
        YMDelay(YMBackgroundRefresh.ErrorDelay) {
            L1RelationApi.YMGetLevel1Relation()
        }
    }
    
    static func L2Err(error: NSError){
        YMDelay(YMBackgroundRefresh.ErrorDelay) {
            L2RelationApi.YMGetLevel2Relation()
        }
    }
    
    static func NFErr(error: NSError){
        YMDelay(YMBackgroundRefresh.ErrorDelay) {
//            NewFriendsRelationApi.YMGetRelationNewFriends()
        }
    }
    
    static func MESuccess(data: NSDictionary?) {
        let userInfo = data?["user"] as? [String: AnyObject]
        if(1 < YMVar.MyUserInfo.count) {
            YMVar.MyUserInfo["is_auth"] = YMVar.GetStringByKey(userInfo, key: "is_auth")
        }
        YMDelay(2.0) {
            MyInfoApi.YMQueryUserInfoById(YMVar.MyDoctorId)
        }
    }
    
    static func MEError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        YMDelay(2.0) {
            MyInfoApi.YMQueryUserInfoById(YMVar.MyDoctorId)
        }
    }
}









//typealias YMBackgroundRefreshCallback = (AnyObject?, Bool) -> Void
//
//enum YMBackgroundCallbackFor {
//    case SystemMessage
//    case Relation
//    case MyInfo
//    
//    static let AllType = [SystemMessage, Relation, MyInfo]
//}
//
//class YMBkgRefreshRunner: NSObject {
//        private var L1RelationApi: YMAPIUtility!
//        private var L2RelationApi: YMAPIUtility!
//        private var MyInfoApi: YMAPIUtility!
//        private var GetContactsApi: YMAPIUtility! = nil
//        private let BackgroundQueue = dispatch_queue_create("com.YiMai.Background.Queue", DISPATCH_QUEUE_SERIAL)
//    
//
//    var CallbackList = [YMBackgroundCallbackFor: [YMBackgroundRefreshCallback]]()
//    var RunningFlags = [String: Bool]()
//    
//    override init() {
//        super.init()
//        
//        for type in YMBackgroundCallbackFor.AllType {
//            CallbackList[type] = [YMBackgroundRefreshCallback]()
//        }
//        
//        let keyPrefix = "BackgroundRefreshApi"
//        
//        L1RelationApi = YMAPIUtility(key: keyPrefix + "GetR1", success: GetR1Success, error: GetR1Error)
//        L2RelationApi = YMAPIUtility(key: keyPrefix + "GetR2", success: GetR2Success, error: GetR2Error)
//        MyInfoApi = YMAPIUtility(key: keyPrefix + "GetMyInfo", success: GetMyInfoSuccess, error: GetMyInfoError)
//        GetContactsApi = YMAPIUtility(key: keyPrefix + "GetContact", success: GetContactSuccess, error: GetContactError)
//
//        
//        InitRunningFlags()
//    }
//
//    func InitRunningFlags() {
//        RunningFlags[L1RelationApi.Key] = false
//        RunningFlags[L2RelationApi.Key] = false
//        RunningFlags[MyInfoApi.Key] = false
//        RunningFlags[GetContactsApi.Key] = false
//    }
//    
//    func CallHandler(type: YMBackgroundCallbackFor, data: AnyObject?, isSuccess: Bool) {
//        let callbacks = CallbackList[type]
//        for cb in callbacks! {
//            cb(data, isSuccess)
//        }
//    }
//    
//    func CallMyInfoHandler(data: AnyObject?, isSuccess: Bool) {
//        CallHandler(YMBackgroundCallbackFor.MyInfo, data: data, isSuccess: isSuccess)
//    }
//    
//    func CallRelationHandler(data: AnyObject?, isSuccess: Bool) {
//        CallHandler(YMBackgroundCallbackFor.Relation, data: data, isSuccess: isSuccess)
//    }
//    
//    func CallSystemMessageHandler(data: AnyObject?, isSuccess: Bool) {
//        CallHandler(YMBackgroundCallbackFor.SystemMessage, data: data, isSuccess: isSuccess)
//    }
//    
//    func GetNewMsgSuccess(data: NSDictionary?) {
//        CallSystemMessageHandler(data, isSuccess: true)
//    }
//    
//    func GetNewMsgError(error: NSError) {
//        CallSystemMessageHandler(error, isSuccess: false)
//    }
//    
//    func GetR1Success(data: NSDictionary?) {
//        CallSystemMessageHandler(data, isSuccess: true)
//    }
//    
//    func GetR1Error(error: NSError) {
//        CallSystemMessageHandler(error, isSuccess: false)
//    }
//    
//    func GetR2Success(data: NSDictionary?) {
//        CallSystemMessageHandler(data, isSuccess: true)
//    }
//    
//    func GetR2Error(error: NSError) {
//        CallSystemMessageHandler(error, isSuccess: false)
//    }
//    
//    func GetMyInfoSuccess(data: NSDictionary?) {
//        CallSystemMessageHandler(data, isSuccess: true)
//    }
//    
//    func GetMyInfoError(error: NSError) {
//        CallSystemMessageHandler(error, isSuccess: false)
//    }
//    
//    func GetContactSuccess(data: NSDictionary?) {
//        CallSystemMessageHandler(data, isSuccess: true)
//    }
//    
//    func GetContactError(error: NSError) {
//        CallSystemMessageHandler(error, isSuccess: false)
//    }
//    
//    func DoRefresh() {
//    }
//    
//    func RegisterCallback(type: YMBackgroundCallbackFor, cb: YMBackgroundRefreshCallback) {
//        CallbackList[type]?.append(cb)
//    }
//    
//    deinit {
//        CallbackList.removeAll()
//    }
//}
//
//class YMBackgroundRefresh: NSObject {
//    private static var RefreshTimer: NSTimer? = nil
//    private static var Runner: YMBkgRefreshRunner!
//    private static var Running = false
//    
//    static func Start() {
//        if(YMBackgroundRefresh.Running) {
//            return
//        }
//        YMBackgroundRefresh.Running = true
//        Runner = YMBkgRefreshRunner()
//        YMBackgroundRefresh.RefreshTimer = NSTimer.scheduledTimerWithTimeInterval(2.0,
//                                                                                  target: YMBackgroundRefresh.Runner,
//                                                                                  selector: "DoRefresh".Sel(),
//                                                                                  userInfo: nil, repeats: true)
//        let runloop = NSRunLoop.currentRunLoop()
//        runloop.addTimer(YMBackgroundRefresh.RefreshTimer!, forMode: NSRunLoopCommonModes)
//    }
//    
//    static func Stop() {
//        YMBackgroundRefresh.Running = false
//        YMBackgroundRefresh.RefreshTimer?.invalidate()
//        YMBackgroundRefresh.RefreshTimer = nil
//        Runner = nil
//    }
//    
//    static func Now() {
//        YMBackgroundRefresh.RefreshTimer?.fire()
//    }
//    
//    static func RegisterCallback(type: YMBackgroundCallbackFor, cb: YMBackgroundRefreshCallback) {
//        if(!YMBackgroundRefresh.Running) {
//            return
//        }
//        
//        YMBackgroundRefresh.Runner.RegisterCallback(type, cb: cb)
//    }
//}







