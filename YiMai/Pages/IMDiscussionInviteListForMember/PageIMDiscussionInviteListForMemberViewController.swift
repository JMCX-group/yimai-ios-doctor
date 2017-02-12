//
//  PageIMDiscussionInviteListForMemberViewController.swift
//  YiMai
//
//  Created by why on 2017/2/2.
//  Copyright © 2017年 why. All rights reserved.
//

import Foundation
import UIKit
typealias InviteSuccessCallBack = (String, String, RCDiscussion) -> Void

class PageIMDiscussionInviteListForMemberViewController: PageViewController {
    var BodyView: PageIMDiscussionInviteListForMemberBodyView!
    static var InvitedList = [String]()
    static var DiscussionId: String = ""

    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageIMDiscussionInviteListForMemberBodyView(parentView: view, navController: NavController!)
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
        if(BodyView!.InviteSuccess) {
            let cb = UserData as? InviteSuccessCallBack
            print("group id is \(BodyView.DiscussionGroupId) and member is \(BodyView.DocSelected)")
            cb?(BodyView!.DiscussionGroupId, "讨论组-(\(BodyView.DocSelected.count + 1)人)", BodyView.Discussion!)
        }
        
        PageIMDiscussionInviteListForMemberViewController.DiscussionId = ""
        PageIMDiscussionInviteListForMemberViewController.InvitedList.removeAll()
    }
}






















