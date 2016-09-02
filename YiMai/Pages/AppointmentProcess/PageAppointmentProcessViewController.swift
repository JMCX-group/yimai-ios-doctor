//
//  PageAppointmentProcessViewController.swift
//  YiMai
//
//  Created by superxing on 16/9/2.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageAppointmentProcessViewController: PageViewController {
    public var BodyView: PageAppointmentProcessBodyView? = nil

    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageAppointmentProcessBodyView(parentView: self.SelfView!, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "接诊详细信息", navController: self.NavController!)
    }
}
