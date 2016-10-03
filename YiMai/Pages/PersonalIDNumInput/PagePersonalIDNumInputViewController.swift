//
//  PagePersonalIDNumInputViewController.swift
//  YiMai
//
//  Created by why on 16/6/20.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

class PagePersonalIDNumInputViewController: PageViewController {
    private var BodyView: PagePersonalIDNumInputBodyView? = nil
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PagePersonalIDNumInputBodyView(parentView: self.SelfView!, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "身份证号码", navController: self.NavController!)
    }
}
