//
//  PagePersonalPasswordResetViewController.swift
//  YiMai
//
//  Created by ios-dev on 16/6/19.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

class PagePersonalPasswordResetViewController: PageViewController {
    private var BodyView: PagePersonalPasswordResetBodyView? = nil
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PagePersonalPasswordResetBodyView(parentView: self.SelfView!, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "修改密码", navController: self.NavController!)
    }
    
    override func PageDisapeared() {
        if(!PageLayoutFlag){return}
        
        BodyView?.Clear()
    }
}
