//
//  PageIMDiscussionInviteListViewController.swift
//  YiMai
//
//  Created by why on 2017/2/2.
//  Copyright © 2017年 why. All rights reserved.
//

import Foundation
import UIKit
typealias CreateSuccessCallBack = (String, String) -> Void

class PageIMDiscussionInviteListViewController: PageViewController {
    var BodyView: PageIMDiscussionInviteListBodyView!

    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageIMDiscussionInviteListBodyView(parentView: view, navController: NavController!)
        TopView = PageCommonTopView(parentView: view, titleString: "选择群聊成员", navController: NavController)
        
        BodyView.DrawTopConfirmButton(TopView!.TopViewPanel)
    }
    
    override func PagePreRefresh() {
        YMDelay(0.1) {
            self.BodyView.DrawFullBody()
        }
    }
    
    override func PageDisapeared() {
        super.PageDisapeared()
        if(BodyView!.CreateSucess) {
            let cb = UserData as? CreateSuccessCallBack
            print("group id is \(BodyView.DiscussionGroupId) and member is \(BodyView.DocSelected)")
            cb?(BodyView!.DiscussionGroupId, "讨论组-(\(BodyView.DocSelected.count + 1)人)")

        }
    }
}






















