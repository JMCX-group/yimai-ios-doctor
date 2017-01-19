//
//  PageAddBankcardViewController.swift
//  YiMai
//
//  Created by why on 2017/1/10.
//  Copyright © 2017年 why. All rights reserved.
//

import Foundation
import Neon


class PageAddBankcardViewController: PageViewController {
    var BodyView: PageAddBankcardBodyView!
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageAddBankcardBodyView(parentView: view, navController: NavController!)
        TopView = PageCommonTopView(parentView: view, titleString: "添加银行卡", navController: NavController!, before: nil)
    }
    
    override func PagePreRefresh() {
        BodyView.ClearBody()
    }
}










































