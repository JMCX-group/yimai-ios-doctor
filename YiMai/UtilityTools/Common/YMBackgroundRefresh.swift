//
//  YMBackgroundRefresh.swift
//  YiMai
//
//  Created by Wang Huaiyu on 16/10/16.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

class YMBackgroundRefresh: NSObject {
    private static var StartFlag = false
    private static var GetBroadcastFirstPage: YMAPIUtility!
    private static var GetNewAdmissionList: YMAPIUtility!
    private static var GetNewAppointmentList: YMAPIUtility!
    
    private static var L1RelationApi: YMAPIUtility!
    private static var L2RelationApi: YMAPIUtility!
    private static var NewFriendsRelationApi: YMAPIUtility!

    private static let SuccessDelay: Double = 30.0
    private static let ErrorDelay: Double = 10.0
    
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
                                          success: self.Level1RelationSuccess, error: L1Err)
        
        L2RelationApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_LEVEL2_RELATION + "-l2",
                                          success: self.Level2RelationSuccess, error: L2Err)
        
        NewFriendsRelationApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_NEW_FRIENDS + "newf",
                                                  success: self.NewFriendsSuccess, error: NFErr)
        
        DoApi()
    }
    
    
    static func DoApi() {
        GetBroadcastFirstPage.YMGetAllRadio("1")
        GetNewAdmissionList.YMGetNewAdmissionList()
        GetNewAppointmentList.YMGetNewAppointmentList()
        L1RelationApi.YMGetLevel2Relation()
        L2RelationApi.YMGetLevel2Relation()
        NewFriendsRelationApi.YMGetRelationNewFriends()
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
        }
        
        YMDelay(YMBackgroundRefresh.SuccessDelay) {
            NewFriendsRelationApi.YMGetRelationNewFriends()
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
            YMVar.MyNewAppointmentInfo = appointmentArr[0]
        }
    }
    
    static func GetBroadcastSuccess(data: NSDictionary?) {
        YMDelay(YMBackgroundRefresh.SuccessDelay) {
            GetBroadcastFirstPage.YMGetAllRadio("1")
        }
        
        if(nil == data) {
            return
        }
        let broadcastArr = data!["data"] as! [[String: AnyObject]]
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
            GetBroadcastFirstPage.YMGetAllRadio("1")
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
            NewFriendsRelationApi.YMGetRelationNewFriends()
        }
    }
}







