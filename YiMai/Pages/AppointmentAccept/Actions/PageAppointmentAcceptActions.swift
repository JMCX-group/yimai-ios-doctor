//
//  PageAppointmentAcceptActions.swift
//  YiMai
//
//  Created by ios-dev on 16/8/21.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PageAppointmentAcceptActions: PageJumpActions {
    private var TargetView: PageAppointmentAcceptBodyView? = nil
    private var DetailApi: YMAPIUtility? = nil
    private var DenyApi: YMAPIUtility? = nil
    
    override func ExtInit() {
        super.ExtInit()
        
        DetailApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_APPOINTMENT_DETAIL,
                                 success: DetailGetSuccess, error: DetailGetError)
        
        DenyApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_DENY_APPOINTMENT,
                                 success: DenySuccess, error: DenyError)
        
        TargetView = self.Target as? PageAppointmentAcceptBodyView
    }
    
    private func DetailGetSuccess(data: NSDictionary?) {
        TargetView?.LoadData(data!)
    }
    
    private func DetailGetError(error: NSError) {
        TargetView?.FullPageLoading.Hide()
        YMPageModalMessage.ShowErrorInfo("网络错误，请稍后再试", nav: NavController!)
        
    }
    
    private func DenySuccess(data: NSDictionary?) {
        TargetView?.HideDenyDialog()
        self.NavController!.popViewControllerAnimated(true)
    }
    
    private func DenyError(error: NSError) {
        TargetView?.HideDenyDialog()
        self.NavController!.popViewControllerAnimated(true)
    }
    
    public func GetDetail() {
        DetailApi?.YMGetAppointmentDetail(PageAppointmentAcceptBodyView.AppointmentID)
    }
    
    public func TextDetailTouched(sender: UIGestureRecognizer) {
        
    }
    
    public func ImageScrollLeft (_: UIGestureRecognizer) {
        
    }
    
    public func ImageScrollRight (_: UIGestureRecognizer) {
        
    }

    public func PatientTransferTouched(qr: UIGestureRecognizer) {
        let btn = qr.view as! YMTouchableImageView

        PageAppointmentTransferViewController.AppointmentData = btn.UserObjectData as? [String: AnyObject]
        DoJump(YMCommonStrings.CS_PAGE_APPOINTMENT_TRANSFER)
    }
    
    public func DenyDlgTagTouched(sender: UIGestureRecognizer) {
        let label = sender.view as! YMTouchableView
        TargetView?.SelectDenyReasonLabel(label)
    }
    
    public func DenyAppointmentTouched(sender: YMButton) {
        TargetView?.ShowDenyDialog()
    }
    
    public func AcceptAppointmentTouched(sender: YMButton) {
        DoJump(YMCommonStrings.CS_PAGE_APPOINTMENT_ACCEPT_DETAIL_NAME)
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

        DenyApi?.YMAdmissionRefusal(["id": PageAppointmentAcceptBodyView.AppointmentID, "reason": reasonStr])
    }
    
    public func CancelDenyTouched(sender: YMButton) {
        TargetView?.HideDenyDialog()
    }
}




