//
//  PageBankCardListViewController.swift
//  YiMai
//
//  Created by why on 2017/1/10.
//  Copyright © 2017年 why. All rights reserved.
//

import Foundation
import UIKit

class PageBankCardListViewController: PageViewController {
    var BodyView: PageBankCardListBodyView!

    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageBankCardListBodyView(parentView: view, navController: NavController!)
        TopView = PageCommonTopView(parentView: view, titleString: "银行卡列表", navController: NavController!, before: nil)
    }
    
    override func PagePreRefresh() {
        BodyView.FullPageLoading.Show()
        BodyView.ListActions.ListApi.YMGetBankcardList()
    }
}


















