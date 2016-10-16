//
//  PageMessageListViewController.swift
//  YiMai
//
//  Created by why on 16/4/28.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

class PageMessageListViewController: PageViewController {
    private var Actions: PageMessageListActions? = nil
    private var BodyView: PageMessageListBodyView? = nil
    
    override func PageLayout() {
        super.PageLayout()
        
        if(PageLayoutFlag) {return}
        PageLayoutFlag=true
        
        Actions = PageMessageListActions(navController: NavController)
        BodyView = PageMessageListBodyView(parentView: SelfView!, navController: NavController!, pageActions: Actions!)
        TopView = PageCommonTopView(parentView: SelfView!, titleString: "消息", navController: NavController)
    }
    
    override func PageRefresh() {
        
    }
}
