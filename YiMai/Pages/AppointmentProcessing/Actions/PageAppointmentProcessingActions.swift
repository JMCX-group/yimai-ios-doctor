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
    var CancelApi: YMAPIUtility!
    
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
        
        CancelApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_CANCEL_APPOINTMENT, success: CancelSuccess, error: CancelError)
        
        TargetView = self.Target as? PageAppointmentProcessingBodyView
    }
    
    func CancelSuccess(data: NSDictionary?) {
        TargetView?.FullPageLoading.Hide()
        TargetView?.HideDenyDialog()
        NavController?.popViewControllerAnimated(true)
    }
    
    func CancelError(error: NSError) {
        TargetView?.FullPageLoading.Hide()
        TargetView?.HideDenyDialog()
        YMPageModalMessage.ShowErrorInfo("网络故障，请稍后再试。", nav: self.NavController!, callback: GoBack)
    }
    
    private func DetailGetSuccess(data: NSDictionary?) {
        TargetView?.LoadData(data!)
    }
    
    private func DetailGetError(error: NSError) {
        YMPageModalMessage.ShowErrorInfo("网络故障，请稍后再试。", nav: self.NavController!, callback: GoBack)
    }
    
    private func CompleteSuccess(data: NSDictionary?) {
        TargetView?.FullPageLoading?.Hide()
        self.NavController!.popViewControllerAnimated(true)
    }
    
    private func CompleteError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        TargetView?.FullPageLoading?.Hide()
        self.NavController!.popViewControllerAnimated(true)
    }
    
    private func RescheduleSuccess(data: NSDictionary?) {
        TargetView?.FullPageLoading?.Hide()
        self.NavController?.popViewControllerAnimated(true)
    }
    
    private func RescheduleError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        TargetView?.FullPageLoading?.Hide()
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
        TargetView?.FullPageLoading?.Show()
        CompleteApi?.YMAdmissionComplete(["id": PageAppointmentProcessingBodyView.AppointmentID])
    }
    
    public func AdmissionTimeSelected(sender: YMButton) {
        let formatter = NSDateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy-MM-dd hh:00:00"
        let dateStr = formatter.stringFromDate(TargetView!.AdmissionDatePicker.date)
        
        TargetView?.HideAdmissionTime()
        TargetView?.FullPageLoading?.Show()
        
        RescheduleApi?.YMAdmissionRescheduled([
                "id": PageAppointmentProcessingBodyView.AppointmentID,
                "visit_time": dateStr
            ])
    }
    
    public func DenyDlgTagTouched(sender: UIGestureRecognizer) {
        let label = sender.view as! YMTouchableView
        TargetView?.SelectDenyReasonLabel(label)
    }
    
    public func CancelDenyTouched(sender: YMButton) {
        TargetView?.HideDenyDialog()
    }
    
    public func DenyConfirmTouched(sender: YMButton) {
        var reasonStr = "近期比较忙，没时间"
        if("4" == TargetView?.SelectedDenyReason?.UserStringData){
            reasonStr = TargetView!.DenyOtherReasonInput.text
        } else {
            let userData = TargetView!.SelectedDenyReason?.UserObjectData as! [String: AnyObject]
            let label = userData["label"] as! UILabel
            reasonStr = label.text!
        }
        
//        DenyApi?.YMAdmissionRefusal(["id": PageAppointmentAcceptBodyView.AppointmentID, "reason": reasonStr])
        TargetView?.FullPageLoading.Show()
        CancelApi.YMAdmissionCancel(["id": PageAppointmentProcessingBodyView.AppointmentID, "reason": reasonStr])

    }
    
    func CancelTouched(_: AnyObject) {
        TargetView?.ShowDenyDialog()
    }
}




