//
//  PageAppointmentProcessingActions.swift
//  YiMai
//
//  Created by ios-dev on 16/8/21.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PageAppointmentProcessingActions: PageJumpActions {
    private var TargetView: PageAppointmentProcessingBodyView? = nil
    private var DetailApi: YMAPIUtility? = nil
    private var CompleteApi: YMAPIUtility? = nil
    private var RescheduleApi: YMAPIUtility? = nil
    
    public func GoBack(_: UIAlertAction) {
        self.NavController?.popViewControllerAnimated(true)
    }
    
    override func ExtInit() {
        super.ExtInit()
        
        DetailApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_APPOINTMENT_DETAIL + "fromProcessing",
                                 success: DetailGetSuccess, error: DetailGetError)
        
        CompleteApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_APPOINTMENT_COMPLETE + "fromProcessing",
                                 success: CompleteSuccess, error: CompleteError)
        
        RescheduleApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_RESCHEDULE_APPOINTMENT + "fromProcessing",
                                   success: RescheduleSuccess, error: RescheduleError)
        
        TargetView = self.Target as? PageAppointmentProcessingBodyView
    }
    
    private func DetailGetSuccess(data: NSDictionary?) {
        TargetView?.LoadData(data!)
    }
    
    private func DetailGetError(error: NSError) {
        YMPageModalMessage.ShowErrorInfo("网络通讯故障，请稍后再试。",
                                         nav: self.NavController!, callback: GoBack)
    }
    
    private func CompleteSuccess(data: NSDictionary?) {
        TargetView?.Loading?.Hide()
        self.NavController!.popViewControllerAnimated(true)
    }
    
    private func CompleteError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        TargetView?.Loading?.Hide()
        self.NavController!.popViewControllerAnimated(true)
    }
    
    private func RescheduleSuccess(data: NSDictionary?) {
        TargetView?.Loading?.Hide()
        self.NavController?.popViewControllerAnimated(true)
    }
    
    private func RescheduleError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        TargetView?.Loading?.Hide()
        self.NavController?.popViewControllerAnimated(true)
    }
    
    public func GetDetail() {
        DetailApi?.YMGetAppointmentDetail(PageAppointmentProcessingBodyView.AppointmentID)
    }
    
    public func TextDetailTouched(sender: UIGestureRecognizer) {
        
    }
    
    public func ImageScrollLeft (_: UIGestureRecognizer) {
        
    }
    
    public func ImageScrollRight (_: UIGestureRecognizer) {
        
    }

    public func PatientTransferTouched(sender: UIGestureRecognizer) {
        
    }
    
    public func CancelReschedule(sender: YMButton) {
        TargetView?.HideAdmissionTime()
    }
    
    public func AppointmentRescheduleTouched(gr: UIGestureRecognizer) {
        TargetView?.ShowAdmissionTime()
    }
    
    public func AppointmentCompleteTouched(sender: YMButton) {
        TargetView?.Loading?.Show()
        CompleteApi?.YMAdmissionComplete(["id": PageAppointmentProcessingBodyView.AppointmentID])
    }
    
    public func AdmissionTimeSelected(sender: YMButton) {
        let formatter = NSDateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy-MM-dd hh:00:00"
        let dateStr = formatter.stringFromDate(TargetView!.AdmissionDatePicker.date)
        
        TargetView?.HideAdmissionTime()
        TargetView?.Loading?.Show()
        
        RescheduleApi?.YMAdmissionRescheduled([
                "id": PageAppointmentProcessingBodyView.AppointmentID,
                "visit_time": dateStr
            ])
    }
}




