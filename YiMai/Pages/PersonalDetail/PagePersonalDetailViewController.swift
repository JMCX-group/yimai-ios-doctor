//
//  PagePersonalDetailViewController.swift
//  YiMai
//
//  Created by why on 16/6/20.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

class PagePersonalDetailViewController: PageViewController {
    private var DetailTop: PagePersonalDetailTopView? = nil
    private var Actions: PagePersonalDetailActions? = nil
    
    override func PageLayout() {
        super.PageLayout()
        Actions = PagePersonalDetailActions(navController: self.NavController!, target: self)
        DetailTop = PagePersonalDetailTopView(parent: self.SelfView!, actions: Actions!)
    }
}
