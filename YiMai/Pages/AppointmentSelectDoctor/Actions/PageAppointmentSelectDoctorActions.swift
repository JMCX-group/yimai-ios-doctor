//
//  PageAppointmentSelectDoctorActions.swift
//  YiMai
//
//  Created by why on 16/5/31.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

typealias SelectorDoctorCallback = (([String: AnyObject]?) -> Void)

public class PageAppointmentSelectDoctorAcitons: PageJumpActions {
    var TargetCtrl:PageAppointmentSelectDoctorViewController!
    override func ExtInit() {
        super.ExtInit()
        TargetCtrl = Target as! PageAppointmentSelectDoctorViewController
    }
    
    public func DoctorSelect(sender: UIGestureRecognizer) {
        let cell = sender.view! as! YMTouchableView

        let controllers = NavController!.viewControllers
        let prevCtrl = controllers[controllers.count - 2]
        if(prevCtrl.isKindOfClass(PageAppointmentViewController)){
            PageAppointmentViewController.SelectedDoctor = cell.UserObjectData as? [String: AnyObject]
        } else if(prevCtrl.isKindOfClass(PageAppointmentUpdateViewController)) {
            PageAppointmentUpdateViewController.SelectedDoctor = cell.UserObjectData as? [String: AnyObject]
        } else if(prevCtrl.isKindOfClass(PageAppointmentTransferViewController)){
            PageAppointmentTransferViewController.SelectedDoctor = cell.UserObjectData as? [String: AnyObject]
        } else {
            let callback = TargetCtrl.UserData as? SelectorDoctorCallback
            
            callback?(cell.UserObjectData as? [String: AnyObject])
        }
        
        self.NavController?.popViewControllerAnimated(true)
    }
}