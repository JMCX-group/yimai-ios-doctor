//
//  PagePersonalSettingViewController.swift
//  YiMai
//
//  Created by ios-dev on 16/6/19.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

class PagePersonalSettingViewController: PageViewController {
    private var BodyView: PagePersonalSettingBodyView? = nil
    
    override func PageLayout() {
        super.PageLayout()
        BodyView = PagePersonalSettingBodyView(parentView: self.SelfView!,
                                               navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "设置", navController: self.NavController!)
    }
}
