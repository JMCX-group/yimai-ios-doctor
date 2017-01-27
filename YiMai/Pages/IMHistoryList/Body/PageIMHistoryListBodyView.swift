//
//  PageIMHistoryListBodyView.swift
//  YiMai
//
//  Created by why on 2017/1/25.
//  Copyright © 2017年 why. All rights reserved.
//

import Foundation
import Neon

class PageIMHistoryListBodyView: PageBodyView {
    var ListActions: PageIMHistoryListActions!
    
    override func ViewLayout() {
        super.ViewLayout()
        
        ListActions = PageIMHistoryListActions(navController: NavController, target: self)
        FullPageLoading.Show()
    }
    
    func LoadData(data: AnyObject) {
        FullPageLoading.Hide()
    }
    
    func Clear() {
        YMLayout.ClearView(view: BodyView)
    }
}














