//
//  PageYiMaiSameSchoolViewController.swift
//  YiMai
//
//  Created by why on 16/5/27.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageYiMaiSameSchoolViewController: PageViewController {
    private var Actions: PageYiMaiSameSchoolActions? = nil
    public var BodyView: PageYiMaiSameSchoolBodyView? = nil
    
    override func PageLayout() {
        super.PageLayout()
        
        if(PageLayoutFlag) {return}
        PageLayoutFlag=true
        
        Actions = PageYiMaiSameSchoolActions(navController: NavController, target: self)
        BodyView = PageYiMaiSameSchoolBodyView(parentView: SelfView!, navController: NavController!, pageActions: Actions!)
        TopView = PageCommonTopView(parentView: SelfView!, titleString: "同学校", navController: NavController)
    }
}
