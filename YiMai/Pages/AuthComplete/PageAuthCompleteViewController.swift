//
//  PageAuthCompleteViewController.swift
//  YiMai
//
//  Created by old-king on 16/11/6.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

class PageAuthCompleteViewController: PageViewController {
    var BodyView: PageAuthCompleteBodyView!
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageAuthCompleteBodyView(parentView: self.view, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: "已认证", navController: self.NavController!)
    }

    override func PagePreRefresh() {
    }
}
