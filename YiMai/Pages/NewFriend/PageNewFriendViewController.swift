//
//  PageNewFriendViewController.swift
//  YiMai
//
//  Created by ios-dev on 16/6/27.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageNewFriendViewController: PageViewController {
    public var BodyView: PageNewFriendBodyView? = nil
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageNewFriendBodyView(parentView: self.SelfView!, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "新朋友", navController: self.NavController)
        
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_NEW_FRIENDS, data: [[String:AnyObject]]())
    }
    
    override func PagePreRefresh() {
        BodyView?.GetList()
    }
    
    override func PageDisapeared() {
        BodyView?.Clear()
    }
}
