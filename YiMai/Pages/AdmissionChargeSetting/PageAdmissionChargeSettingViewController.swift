//
//  PageAdmissionChargeSettingViewController.swift
//  YiMai
//
//  Created by superxing on 16/8/19.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageAdmissionChargeSettingViewController: PageViewController {
    public var BodyView: PageAdmissionChargeSettingBodyView? = nil

    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageAdmissionChargeSettingBodyView(parentView: self.SelfView!, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "接诊收费", navController: self.NavController)
    }
}
