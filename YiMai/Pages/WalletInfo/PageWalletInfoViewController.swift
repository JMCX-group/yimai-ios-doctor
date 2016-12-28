//
//  PageWalletInfoViewController.swift
//  YiMai
//
//  Created by superxing on 16/11/8.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

class PageWalletInfoViewController: PageViewController {
    var BodyView: PageWalletInfoBodyView!
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageWalletInfoBodyView(parentView: self.view, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: "余额", navController: self.NavController!)
        BodyView.DrawRecordButton(TopView!.TopViewPanel)
    }
    
    override func PagePreRefresh() {
        BodyView.Clear()
        BodyView.FullPageLoading.Show()
        BodyView.WalletActions.InfoApi.YMGetWalletInfo()
    }
}






