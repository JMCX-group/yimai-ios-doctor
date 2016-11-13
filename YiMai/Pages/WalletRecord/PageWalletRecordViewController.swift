//
//  PageWalletRecordViewController.swift
//  YiMai
//
//  Created by old-king on 16/11/13.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

class PageWalletRecordViewController: PageViewController {
    var BodyView: PageWalletRecordBodyView!
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageWalletRecordBodyView(parentView: self.view, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: "明细", navController: self.NavController!)
    }
    
    override func PagePreRefresh() {
        BodyView.FullPageLoading.Show()
        BodyView.RecordActions.RecordApi.YMGetWalletRecord()
    }
}
