//
//  PagePersonalNameEditViewController.swift
//  YiMai
//
//  Created by why on 16/6/22.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PagePersonalNameEditViewController: PageViewController {
    private var Actions: PagePersonalNameEditActions? = nil
    public var BodyView: PagePersonalNameEditBodyView? = nil
    
    public static var UserName = ""
    
    override func PageLayout() {
        super.PageLayout()
        Actions = PagePersonalNameEditActions(navController: self.NavController!, target: self)
        BodyView = PagePersonalNameEditBodyView(parentView: self.SelfView!, navController: self.NavController!, pageActions: Actions)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "修改姓名", navController: self.NavController!)
    }
    
    override func PagePreRefresh() {
        if(!PageLayoutFlag){return}
        
        BodyView?.LoadData()
    }
}
