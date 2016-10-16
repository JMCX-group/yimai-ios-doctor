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
        
        GetBroadcastFirstPage.YMGetAllRadio("1")
        GetNewAdmissionList.YMGetNewAdmissionList()
        GetNewAppointmentList.YMGetNewAppointmentList()
    }
    
    static func Stop() {
        YMBackgroundRefresh.StartFlag = false
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
}







