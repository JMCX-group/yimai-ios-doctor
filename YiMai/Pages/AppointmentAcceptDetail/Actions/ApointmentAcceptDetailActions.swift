//
//  ApointmentAcceptDetailActions.swift
//  YiMai
//
//  Created by superxing on 16/8/31.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class ApointmentAcceptDetailActions: PageJumpActions {
    private var TargetBodyView: ApointmentAcceptDetailBodyView? = nil
    private var SubmitApi: YMAPIUtility? = nil

    public override func ExtInit() {
        super.ExtInit()
        
        self.TargetBodyView = self.Target as? ApointmentAcceptDetailBodyView
        SubmitApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_ACCEPT_APPOINTMENT,
                                 success: self.SubmitSuccess, error: self.SubmitError)
    }
    
    public func SubmitSuccess(data: NSDictionary?) {
        self.DoJump(YMCommonStrings.CS_PAGE_MY_ADMISSIONS_LIST_NAME)
    }
    
    public func SubmitError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        self.DoJump(YMCommonStrings.CS_PAGE_MY_ADMISSIONS_LIST_NAME)
    }
    
    public func SelectTimeCellTouched(sender: UIGestureRecognizer) {
        TargetBodyView?.ShowAdmissionTime()
    }
    
    public func HospitalTouched(sender: UIGestureRecognizer) {
        
    }
    
    public func KeyboardWillShow(aNotification: NSNotification) {
        TargetBodyView?.KeyboardWillShow(aNotification)
    }
    
    public func SubmitTouched(sender: YMButton) {
//        self.DoJump(YMCommonStrings.CS_PAGE_MY_ADMISSIONS_LIST_NAME)
        SubmitApi?.YMAdmissionAgree(["id": PageAppointmentAcceptBodyView.AppointmentID,
            "visit_time": TargetBodyView!.AdmissionTimeString,
            "supplement": TargetBodyView!.DescInput.text,
            "remark": TargetBodyView!.NeedToKnowInput.text])
    }
    
    public func AdmissionTimeSelected(sender: YMButton) {
        TargetBodyView?.SetAdmissionTime()
    }
}