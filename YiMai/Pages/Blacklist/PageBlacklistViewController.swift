//
//  PageBlacklist.swift
//  YiMai
//
//  Created by why on 2016/12/13.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

class PageBlacklistViewController: PageViewController {
    var BodyView: PageBlacklistBodyView!
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageBlacklistBodyView(parentView: self.view, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: "黑名单", navController: self.NavController!)
    }
    
    override func PagePreRefresh() {
        BodyView.Clear()
        let blackList = YMVar.GetStringByKey(YMVar.MyUserInfo, key: "blacklist")
        BodyView.FullPageLoading.Show()
        BodyView.ListActions.DocApi.YMGetRecentContactedDocList(["id_list": blackList])
    }
}




