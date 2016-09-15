//
//  PageGlobalSearchViewController.swift
//  YiMai
//
//  Created by ios-dev on 16/6/27.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageGlobalSearchViewController: PageViewController {
    public var BodyView: PageGlobalSearchBodyView? = nil
    public static var InitSearchKey = ""
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageGlobalSearchBodyView(parentView: self.SelfView!, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "医脉搜索", navController: self.NavController!)
    }
    
    override func PagePreRefresh() {
        BodyView?.InitSearch(PageGlobalSearchViewController.InitSearchKey)
        BodyView?.HighlightWord = ActiveType.Custom(pattern: PageGlobalSearchViewController.InitSearchKey)
    }
    
    override func PageDisapeared() {
    }
}
