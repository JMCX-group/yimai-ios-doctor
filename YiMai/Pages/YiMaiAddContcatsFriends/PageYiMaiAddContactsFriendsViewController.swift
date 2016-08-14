//
//  PageYiMaiAddContcatsFriendsViewController.swift
//  YiMai
//
//  Created by why on 16/5/26.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageYiMaiAddContatsFriendsViewController: PageViewController {
    private var Actions: YiMaiAddContactsFriendsActions? = nil
    private var BodyView: PageYiMaiAddContactsFriendsBodyView? = nil
    private var BottomButton: PageYiMaiAddContactsFriendsBootomView? = nil
    public var LoadingView: YMPageLoadingView? = nil
    
    override func PageLayout() {
        super.PageLayout()
        Actions = YiMaiAddContactsFriendsActions(navController: NavController, target: self)
    }
    
    override func PagePreRefresh() {
        if(self.isMovingToParentViewController()) {
            DrawViews()
        }
    }
    
    private func DrawViews() {
        YMLayout.ClearView(view: self.SelfView!)

        BodyView = PageYiMaiAddContactsFriendsBodyView(parentView: SelfView!, navController: NavController!, pageActions: Actions!)
        TopView = PageCommonTopView(parentView: SelfView!, titleString: "添加", navController: NavController)
        BottomButton = PageYiMaiAddContactsFriendsBootomView(action: Actions!, parent: self.SelfView!)
        
        BodyView?.DrawSpecialManualAddButton(TopView!.TopViewPanel)
        
        LoadingView = YMPageLoadingView(parentView: self.SelfView!)
    }
}
