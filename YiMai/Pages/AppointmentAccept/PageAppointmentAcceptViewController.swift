//
//  PageAppointmentAcceptViewController.swift
//  YiMai
//
//  Created by ios-dev on 16/8/21.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageAppointmentAcceptViewController: PageViewController {
    public var BodyView: PageAppointmentAcceptBodyView? = nil

    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageAppointmentAcceptBodyView(parentView: self.SelfView!, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "约诊请求", navController: self.NavController!)
        
        BodyView!.DrawTransferButton(TopView!.TopViewPanel)
        BodyView!.DrawConfirmButton(self.SelfView!)
    }
    
    override func PagePreRefresh() {
        if(self.isMovingToParentViewController()) {
            BodyView?.Clear()
            BodyView?.GetDetail()
        }
    }
}
