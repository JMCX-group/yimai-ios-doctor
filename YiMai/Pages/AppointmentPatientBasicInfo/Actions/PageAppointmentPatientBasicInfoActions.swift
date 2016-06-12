//
//  PageAppointmentPatientBasicInfoActions.swift
//  YiMai
//
//  Created by ios-dev on 16/5/28.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PageAppointmentPatientBasicInfoActions: PageJumpActions {
    public func BasicInfoDone(sender: UIGestureRecognizer) {
        let pageController = self.Target! as! PageAppointmentPatientBasicInfoViewController
        
        let info = pageController.BodyView!.GetPatientInfo()
        
        let name = info["name"]!
        let phone = info["phone"]!
        
        if("" == name) {
            YMPageModalMessage.ShowErrorInfo("请填写姓名！", nav: self.NavController!)
            return
        }
        
        if(!YMValueValidator.IsCellPhoneNum(phone)) {
            YMPageModalMessage.ShowErrorInfo("请填写正确的手机号！", nav: self.NavController!)
            return
        }
        
        PageAppointmentViewController.PatientBasicInfo = info
        self.NavController?.popViewControllerAnimated(true)
    }
}