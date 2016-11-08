//
//  PageAuthProcessingViewController.swift
//  YiMai
//
//  Created by old-king on 16/11/6.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

class PageAuthProcessingViewController: PageViewController {
    var BodyView: PageAuthProcessingBodyView!
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageAuthProcessingBodyView(parentView: self.view, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: "认证中", navController: self.NavController!)
    }

    override func PagePreRefresh() {
         
    }
}
