//
//  PageMyAdmissionsListViewController.swift
//  YiMai
//
//  Created by why on 16/4/28.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

class PageMyAdmissionsListViewController: PageViewController {
    private var Actions: PageMyAdmissionsListActions? = nil
    private var BodyView: PageMyAdmissionsListBodyView? = nil
    
    override func PageLayout() {
        super.PageLayout()
        
        if(PageLayoutFlag) {return}
        PageLayoutFlag=true
        
        Actions = PageMyAdmissionsListActions(navController: NavController)
        BodyView = PageMyAdmissionsListBodyView(parentView: SelfView!, navController: NavController!, pageActions: Actions!)
        TopView = PageCommonTopView(parentView: SelfView!, titleString: "我的接诊信息", navController: NavController)
    }
}
