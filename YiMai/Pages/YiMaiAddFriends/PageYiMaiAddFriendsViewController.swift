//
//  PageYiMaiAddFriendsViewController.swift
//  YiMai
//
//  Created by why on 16/5/25.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

class PageYiMaiAddFriendsViewController: PageViewController {
    private var Actions: YiMaiAddFriendsActions? = nil
    private var BodyView: PageYiMaiAddFriendsBodyView? = nil
    
    override func PageLayout() {
        super.PageLayout()
        
        if(PageLayoutFlag) {return}
        PageLayoutFlag=true
        
        Actions = YiMaiAddFriendsActions(navController: NavController)
        BodyView = PageYiMaiAddFriendsBodyView(parentView: SelfView!, navController: NavController!, pageActions: Actions!)
        TopView = PageCommonTopView(parentView: SelfView!, titleString: "添加", navController: NavController)
    }
}
