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
    
    override func ExtInit() {
        super.ExtInit()
        
        DetailApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_APPOINTMENT_DETAIL,
                                 success: DetailGetSuccess, error: DetailGetError)
        TargetView = self.Target as? PageAppointmentAcceptBodyView
    }
    
    private func DetailGetSuccess(data: NSDictionary?) {
        TargetView?.LoadData(data!)
    }
    
    private func DetailGetError(error: NSError) {
        
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

    public func PatientTransferTouched(sender: UIGestureRecognizer) {
        
    }
}