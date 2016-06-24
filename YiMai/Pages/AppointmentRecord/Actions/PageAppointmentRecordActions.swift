//
//  PageAppointmentRecordActions.swift
//  YiMai
//
//  Created by why on 16/6/23.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PageAppointmentRecordActions: PageJumpActions {
    private var AppointmentListApi: YMAPIUtility? = nil
    private var TargetView: PageAppointmentRecordBodyView? = nil
    
    override func ExtInit() {
        TargetView = self.Target as? PageAppointmentRecordBodyView
        AppointmentListApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_APPOINTMENT_LIST,
            success: GetAppointmentListSuccess, error: GetAppointmentListError)
    }
    
    private func GetAppointmentListSuccess(data: NSDictionary?) {
        TargetView?.LoadData(data!["data"] as? NSDictionary)
    }
    
    private func GetAppointmentListError(error: NSError) {
        
    }
    
    public func RecordSelected(sender: UIGestureRecognizer) {
        
    }
    
    public func GetAppointmentList() {
        AppointmentListApi?.YMGetAppointmentList()
    }
    
    public func WaitTabTouched(_: UIGestureRecognizer) {
        TargetView!.ShowList(YMAppointmentRecordStrings.RECORD_WAIT_STATUS)
    }
    
    public func AlreadyTabTouched(_: UIGestureRecognizer) {
        TargetView!.ShowList(YMAppointmentRecordStrings.RECORD_ALREAD_STATUS)
    }
}