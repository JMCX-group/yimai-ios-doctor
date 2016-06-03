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
    public func DateSelected(sender: UIGestureRecognizer) {
        let pageController = self.Target as! PageAppointmentSelectTimeViewController
        
        let cell = sender.view! as! YMTouchableView
        pageController.BodyView?.SetSelectedDays(cell)
    }
    
    public func OKButtonTouched(sender: UIGestureRecognizer) {
        let pageController = self.Target as! PageAppointmentSelectTimeViewController

        PageAppointmentViewController.SelectedTime = pageController.BodyView!.GetSelectedDays()
        
        self.NavController?.popViewControllerAnimated(true)
    }
    
    public func AutoButtonTouched(sender: UIGestureRecognizer) {
        PageAppointmentViewController.SelectedTime = "专家决定"
        self.NavController?.popViewControllerAnimated(true)

    }
}