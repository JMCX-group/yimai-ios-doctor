//
//  PageAppointmentProcessingViewController.swift
//  YiMai
//
//  Created by ios-dev on 16/8/21.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageAppointmentProcessingViewController: PageViewController {
    public var BodyView: PageAppointmentProcessingBodyView? = nil

    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageAppointmentProcessingBodyView(parentView: self.SelfView!, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "约诊请求", navController: self.NavController!)
        
        BodyView!.DrawTransferButton(TopView!.TopViewPanel)
        BodyView!.DrawConfirmButton(self.SelfView!)
        BodyView!.DrawAdmissionDatePicker()
    }
    
    override func PagePreRefresh() {
        if(self.isMovingToParentViewController()) {
            BodyView?.Clear()
            BodyView?.GetDetail()
        }
    }
}
