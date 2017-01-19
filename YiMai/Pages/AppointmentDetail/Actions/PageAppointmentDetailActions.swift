//
//  PageAppointmentDetailActions.swift
//  YiMai
//
//  Created by ios-dev on 16/6/25.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PageAppointmentDetailActions: PageJumpActions {
    private var TargetView: PageAppointmentDetailBodyView? = nil
    private var DetailApi: YMAPIUtility? = nil
    private var DenyApi: YMAPIUtility? = nil

    override func ExtInit() {
        super.ExtInit()
        
        DetailApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_APPOINTMENT_DETAIL + "fromDetail",
                                 success: DetailGetSuccess, error: DetailGetError)
        
        DenyApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_DENY_APPOINTMENT,
                               success: DenySuccess, error: DenyError)

        TargetView = self.Target as? PageAppointmentDetailBodyView
    }
    
    private func DetailGetSuccess(data: NSDictionary?) {
        TargetView?.LoadData(data!)
        TargetView?.FullPageLoading.Hide()
    }
    
    private func DetailGetError(error: NSError) {
        TargetView?.FullPageLoading.Hide()
        YMAPIUtility.PrintErrorInfo(error)
    }
    
    private func DenySuccess(data: NSDictionary?) {
        TargetView?.HideDenyDialog()
        self.NavController!.popViewControllerAnimated(true)
    }
    
    private func DenyError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        TargetView?.HideDenyDialog()
        self.NavController!.popViewControllerAnimated(true)
    }
    
    public func GetAdmissionDetailDetail() {
        DetailApi?.YMGetAdmissionDetail(PageAppointmentDetailViewController.AppointmentID)
    }
    
    public func GetAppointmentDetail() {
        DetailApi?.YMGetAppointmentDetail(PageAppointmentDetailViewController.AppointmentID)
    }
    
    public func TextDetailTouched(sender: UIGestureRecognizer) {
        
    }
    
    public func ImageScrollLeft (_: UIGestureRecognizer) {
        
    }
    
    public func ImageScrollRight (_: UIGestureRecognizer) {
        
    }
    
    func AcceptAppointment(btn: YMButton) {
        PageAppointmentUpdateViewController.AppointmentData = btn.UserObjectData as? [String: AnyObject]
        DoJump(YMCommonStrings.CS_PAGE_APPOINTMENT_UPDATE_NAME)
    }
    

    public func DenyDlgTagTouched(sender: UIGestureRecognizer) {
        let label = sender.view as! YMTouchableView
        TargetView?.SelectDenyReasonLabel(label)
    }
    
    public func DenyAppointmentTouched(sender: YMButton) {
        TargetView?.ShowDenyDialog()
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
        
        DenyApi?.YMAdmissionRefusal(["id": PageAppointmentDetailViewController.AppointmentID, "reason": reasonStr])
    }
    
    public func CancelDenyTouched(sender: YMButton) {
        TargetView?.HideDenyDialog()
    }
}










