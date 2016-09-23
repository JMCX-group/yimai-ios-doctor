//
//  PageAddFriendInfoCardViewController.swift
//  YiMai
//
//  Created by superxing on 16/9/21.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageMyInfoCardViewController: PageViewController {
    var BodyView: PageMyInfoCardBodyView!
    
    public static var BacktoController: UIViewController? = nil
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageMyInfoCardBodyView(parentView: self.view, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: "我的名片", navController: self.NavController)
    }

    override func PagePreRefresh() {
        BodyView.LoadUserInfo(YMVar.MyUserInfo)
    }
    
    override func PageDisapeared() {
        BodyView.Clear()
        PageMyInfoCardViewController.BacktoController = nil
    }
}
