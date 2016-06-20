//
//  PersonalAccountSettingViewController.swift
//  YiMai
//
//  Created by ios-dev on 16/6/19.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

class PagePersonalAccountSettingViewController: PageViewController {
    private var BodyView: PagePersonalAccountSettingBodyView? = nil
    
    override func PageLayout() {
        super.PageLayout()
        BodyView = PagePersonalAccountSettingBodyView(parentView: self.SelfView!, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "账户设置", navController: self.NavController!)
    }
    
    override func PageRefresh() {
        BodyView?.ReloadData()
    }
}
