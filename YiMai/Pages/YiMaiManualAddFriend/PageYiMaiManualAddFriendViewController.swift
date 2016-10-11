//
//  PageYiMaiManualAddFriendViewController.swift
//  YiMai
//
//  Created by why on 16/5/26.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageYiMaiManualAddFriendViewController: PageViewController {
    private var Actions: YiMaiManualAddFriendActions? = nil
    public var BodyView: PageYiMaiManualAddFriendBodyView? = nil
    
    override func PageLayout() {
        super.PageLayout()
        
        if(PageLayoutFlag) {return}
        PageLayoutFlag=true
        
        Actions = YiMaiManualAddFriendActions(navController: NavController, target: self)
        BodyView = PageYiMaiManualAddFriendBodyView(parentView: SelfView!, navController: NavController!, pageActions: Actions!)
        TopView = PageCommonTopView(parentView: SelfView!, titleString: "添加医生朋友", navController: NavController)
        
        BodyView?.DrawSpecialQRButton(TopView!.TopViewPanel)
    }
    
    override func PagePreRefresh() {
        super.PagePreRefresh()
        BodyView?.ClearInput()
    }
}

