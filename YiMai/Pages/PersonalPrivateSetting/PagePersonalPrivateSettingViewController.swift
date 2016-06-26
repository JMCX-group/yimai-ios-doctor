//
//  PagePersonalPrivateSettingViewController.swift
//  YiMai
//
//  Created by ios-dev on 16/6/26.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PagePersonalPrivateSettingViewController: PageViewController {
    public var BodyView: PagePersonalPrivateSettingBodyView? = nil
    
    override func PageLayout() {
        super.PageLayout()
        BodyView = PagePersonalPrivateSettingBodyView(parentView: self.SelfView!, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "隐私设置", navController: self.NavController!)
    }
    
    override func PagePreRefresh() {
        BodyView?.LoadData()
    }
}
