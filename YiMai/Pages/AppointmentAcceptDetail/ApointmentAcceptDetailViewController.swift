//
//  ApointmentAcceptDetailViewController.swift
//  YiMai
//
//  Created by superxing on 16/8/31.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class ApointmentAcceptDetailViewController: PageViewController {
    public var BodyView: ApointmentAcceptDetailBodyView? = nil
    
    public override func PageLayout() {
        super.PageLayout()

        BodyView = ApointmentAcceptDetailBodyView(parentView: self.SelfView!, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "接受约诊请求", navController: self.NavController!)
    }
    
    override func PagePreRefresh() {
        if(isMovingToParentViewController()) {
            BodyView?.BodyView.removeFromSuperview()
            TopView?.TopViewPanel.removeFromSuperview()
            
            BodyView = ApointmentAcceptDetailBodyView(parentView: self.SelfView!, navController: self.NavController!)
            TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "接受约诊请求", navController: self.NavController!)
        }
    }
}










