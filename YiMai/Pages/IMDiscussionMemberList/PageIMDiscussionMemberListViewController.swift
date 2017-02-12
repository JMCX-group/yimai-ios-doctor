//
//  PageIMDiscussionMemberListViewController.swift
//  YiMai
//
//  Created by why on 2017/2/3.
//  Copyright © 2017年 why. All rights reserved.
//

import Foundation

class PageIMDiscussionMemberListViewController: PageViewController {
    var BodyView: PageIMDiscussionMemberListBodyView!

    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageIMDiscussionMemberListBodyView(parentView: view, navController: NavController!)
        TopView = PageCommonTopView(parentView: view, titleString: "讨论组成员",
                                    navController: NavController!)
    }
    
    override func PagePreRefresh() {
        super.PagePreRefresh()
        if(isMovingToParentViewController()) {
            let discussion = UserData as! RCDiscussion
            BodyView.Discussion = discussion
            BodyView.DrawFullBody()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if(isMovingFromParentViewController()) {
            UserData = nil
        }
    }
}