//
//  PageYiMaiDoctorDetailViewController.swift
//  YiMai
//
//  Created by ios-dev on 16/6/26.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageYiMaiDoctorDetailViewController: PageViewController {
    public var BodyView: PageYiMaiDoctorDetailBodyView? = nil
    
    override func PageLayout() {
        super.PageLayout()
        BodyView = PageYiMaiDoctorDetailBodyView(parentView: self.SelfView!, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "详细资料", navController: self.NavController!)
    }
    
    override func PagePreRefresh() {
        BodyView?.FullPageLoading.Show()
        if(nil == self.UserData) {
            BodyView?.GetDocInfo()
        } else {
            BodyView?.FromCommonFriendsBtn = true
            BodyView?.FromCommonFriendsUserId = UserData as! String
            BodyView?.GetDocInfo(BodyView?.FromCommonFriendsUserId)
        }
    }
    
    override func PageDisapeared() {
        BodyView?.Clear()
        if(nil != self.UserData) {
            BodyView?.Actions = nil
            BodyView?.DetailActions = nil
        }
    }
}
