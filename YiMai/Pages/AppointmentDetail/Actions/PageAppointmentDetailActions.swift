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

    override func ExtInit() {
        super.ExtInit()
        
        DetailApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_APPOINTMENT_DETAIL + "fromDetail",
                                 success: DetailGetSuccess, error: DetailGetError)
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
}










