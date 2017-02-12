//
//  PageIMDiscussionSettingViewController.swift
//  YiMai
//
//  Created by why on 2017/2/3.
//  Copyright © 2017年 why. All rights reserved.
//

import Foundation
import UIKit



class PageIMDiscussionSettingViewController: PageViewController {
    var BodyView: PageIMDiscussionSettingBodyView!
    var TargetChat: YMDiscussionViewController? = nil
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageIMDiscussionSettingBodyView(parentView: view, navController: NavController!)
        TopView = PageCommonTopView(parentView: view, titleString: "讨论组管理", navController: NavController)
    }
    
    override func PagePreRefresh() {
        super.PagePreRefresh()
        if(isMovingToParentViewController()) {
            TargetChat = UserData as? YMDiscussionViewController
            BodyView.Discussion = TargetChat!.Discussion!
            BodyView.DiscussionId = TargetChat!.targetId
            BodyView.DiscussionName = TargetChat!.ViewTitle
            BodyView.DiscussionNameLabel.text = TargetChat!.ViewTitle
            BodyView.DiscussionNameLabel.sizeToFit()
            
            BodyView.DrawFullBody()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        if(isMovingFromParentViewController()) {
            TargetChat?.TopView?.TopTitle.text = BodyView.DiscussionName
            TargetChat?.DrawSilentIcon()
            TargetChat = nil
        }
        
        UserData = nil
    }
}
























