//
//  PageIMSearchConversationsViewController.swift
//  YiMai
//
//  Created by why on 2017/1/24.
//  Copyright © 2017年 why. All rights reserved.
//

import UIKit

class PageIMSearchConversationsViewController: PageViewController {
    var BodyView: PageIMSearchConversationsBodyView!
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageIMSearchConversationsBodyView(parentView: view, navController: NavController!)
        TopView = PageCommonTopView(parentView: view, titleString: "会话搜索", navController: NavController!, before: nil)
    }
    
    override func PageDisapeared() {
        if(isMovingFromParentViewController()) {
            BodyView.SearchInput.text = ""
            BodyView.DrawFullBody()
        }
    }
}
