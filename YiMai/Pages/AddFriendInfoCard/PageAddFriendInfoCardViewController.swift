//
//  PageAddFriendInfoCardViewController.swift
//  YiMai
//
//  Created by superxing on 16/9/21.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageAddFriendInfoCardViewController: PageViewController {
    var BodyView: PageAddFriendInfoCardBodyView!
    
    public static var BacktoController: UIViewController? = nil
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageAddFriendInfoCardBodyView(parentView: self.view, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: "添加医生朋友", navController: self.NavController)
    }

    override func PagePreRefresh() {
        BodyView.Loading.Show()
        BodyView.AddActions.GetDocApi.YMQueryUserInfoById(PageAddFriendInfoCardBodyView.DoctorID)
    }
    
    override func PageDisapeared() {
        BodyView.Clear()
        PageAddFriendInfoCardViewController.BacktoController = nil
    }
}
