//
//  PageMyAdmissionSettingViewController.swift
//  YiMai
//
//  Created by superxing on 16/7/14.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageMyAdmissionSettingViewController: PageViewController {
    public var BodyView: PageMyAdmissionSettingBodyView? = nil
    
    override func PageLayout() {
        super.PageLayout()

        BodyView = PageMyAdmissionSettingBodyView(parentView: self.SelfView!, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "我的接诊设置", navController: self.NavController!)

    }
}
