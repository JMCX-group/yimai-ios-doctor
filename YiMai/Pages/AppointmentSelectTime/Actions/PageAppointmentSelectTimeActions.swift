//
//  PageAppointmentSelectTimeActions.swift
//  YiMai
//
//  Created by ios-dev on 16/6/2.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PageAppointmentSelectTimeActions: PageJumpActions {
    var DocInfoApi: YMAPIUtility!
    var TargetCtrl: PageAppointmentSelectTimeViewController!
    
    override func ExtInit() {
        super.ExtInit()
        
        TargetCtrl = Target as! PageAppointmentSelectTimeViewController
        DocInfoApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_DOCTOR_BY_ID+"-fromAppointment",
                                  success: GetInfoSuccess, error: GetInfoError)
    }
    
    func GetInfoSuccess(data: NSDictionary?) {
        let schedulingInfo = data!["data"] as? [[String: AnyObject]]
        if(nil == schedulingInfo) {
            TargetCtrl.BodyView?.FullPageLoading.Hide()
            return
        }
        
        if(0 == schedulingInfo!.count) {
            TargetCtrl.BodyView?.FullPageLoading.Hide()
            return
        }
//        PageAppointmentSelectTimeViewController.SelectedDoctor = docs![0]
        
        TargetCtrl.BodyView?.DocScheduling = schedulingInfo
        TargetCtrl.BodyView?.FullPageLoading.Hide()
        TargetCtrl.BodyView?.Reload()
    }
    
    func GetInfoError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        TargetCtrl.BodyView?.FullPageLoading.Hide()
    }
    
    public func DateSelected(sender: UIGestureRecognizer) {
        let pageController = self.Target as! PageAppointmentSelectTimeViewController
        
        let cell = sender.view! as! YMTouchableView
        pageController.BodyView?.SetSelectedDays(cell)
    }
    
    public func OKButtonTouched(sender: UIGestureRecognizer) {
        let pageController = self.Target as! PageAppointmentSelectTimeViewController

        PageAppointmentViewController.SelectedTime = pageController.BodyView!.GetSelectedDays()
        PageAppointmentViewController.SelectedTimeForUpload = pageController.BodyView!.GetSelectedDaysForUpload()
        
        self.NavController?.popViewControllerAnimated(true)
    }
    
    public func AutoButtonTouched(sender: UIGestureRecognizer) {
        PageAppointmentViewController.SelectedTime = "专家决定"
        PageAppointmentViewController.SelectedTimeForUpload = []
        self.NavController?.popViewControllerAnimated(true)

    }
}







