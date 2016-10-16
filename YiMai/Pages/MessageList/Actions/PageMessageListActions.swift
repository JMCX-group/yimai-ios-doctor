//
//  PageMessageListActions.swift
//  YiMai
//
//  Created by why on 16/4/28.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PageMessageListActions: PageJumpActions{
    var ClearBroadcastApi: YMAPIUtility!
    var ClearAdmissionApi: YMAPIUtility!
    var ClearAppoinmentApi: YMAPIUtility!

    override func ExtInit() {
        super.ExtInit()
        
        ClearBroadcastApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_CLEAR_MSG + "-broadcast",
                                         success: IgnoredSuccess, error: IgnoredError)
        
        ClearAdmissionApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_CLEAR_MSG + "-admission",
                                         success: IgnoredSuccess, error: IgnoredError)
        
        ClearAppoinmentApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_CLEAR_MSG + "-appoinment",
                                         success: IgnoredSuccess, error: IgnoredError)
    }
    
    func IgnoredSuccess(_: NSDictionary?){}
    func IgnoredError(_: NSError) {}
    
    func BroadcastTouched(gr: UIGestureRecognizer) {
        ClearBroadcastApi.YMClearAllNewBroadcast()
        YMVar.MyNewBroadcastInfo.removeAll()
        DoJump(YMCommonStrings.CS_PAGE_SYS_BROADCAST)
    }
    
    func AdmissionTouched(gr: UIGestureRecognizer) {
        ClearBroadcastApi.YMClearAllNewAdmission()
        YMVar.MyNewAdmissionInfo.removeAll()
        DoJump(YMCommonStrings.CS_PAGE_MY_ADMISSIONS_LIST_NAME)
    }
    
    func AppointmentTouched(gr: UIGestureRecognizer) {
        ClearBroadcastApi.YMClearAllNewAppointment()
        YMVar.MyNewAppointmentInfo.removeAll()
        //TODO: reply list
    }
}