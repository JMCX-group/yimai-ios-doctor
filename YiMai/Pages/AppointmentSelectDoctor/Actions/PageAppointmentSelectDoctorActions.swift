//
//  PageAppointmentSelectDoctorActions.swift
//  YiMai
//
//  Created by why on 16/5/31.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PageAppointmentSelectDoctorAcitons: PageJumpActions {
    public func DoctorSelect(sender: UIGestureRecognizer) {
        let cell = sender.view! as! YMTouchableView

        PageAppointmentViewController.SelectedDoctor = cell.UserObjectData as? [String: AnyObject]
        
        self.NavController?.popViewControllerAnimated(true)
    }
}