//
//  PagePersonalIntroEditViewController.swift
//  YiMai
//
//  Created by why on 16/6/22.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PagePersonalIntroEditViewController: PageViewController {
    private var Actions: PagePersonalIntroEditActions? = nil
    public var BodyView: PagePersonalIntroEditBodyView? = nil

    public static var IntroText = ""

    override func PageLayout() {
        super.PageLayout()
        
        Actions = PagePersonalIntroEditActions(navController: self.NavController!, target: self)
        BodyView = PagePersonalIntroEditBodyView(parentView: self.SelfView!, navController: self.NavController!, pageActions: Actions)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "个人简介编辑", navController: self.NavController!)
    }
    
    override func PagePreRefresh() {
        if(!PageLayoutFlag){return}
        
        BodyView?.LoadData()
    }
}
