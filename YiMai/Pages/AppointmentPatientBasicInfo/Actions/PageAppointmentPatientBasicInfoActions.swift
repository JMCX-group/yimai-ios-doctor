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
        
        if("" == name || "" == phone){
            let alertController = UIAlertController(title: "请填写姓名和手机号！", message: nil, preferredStyle: .Alert)
            let okBtn = UIAlertAction(title: "确定", style: .Default,
                handler: {
                    action in
            })
            
            
            okBtn.setValue(YMColors.FontBlue, forKey: "titleTextColor")
            
            alertController.addAction(okBtn)
            self.NavController!.presentViewController(alertController, animated: true, completion: nil)
        } else {
            PageAppointmentViewController.PatientBasicInfo = info
            self.NavController?.popViewControllerAnimated(true)
        }
    }
}