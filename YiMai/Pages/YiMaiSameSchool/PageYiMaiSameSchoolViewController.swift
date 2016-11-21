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
        if(PageLayoutFlag) {return}
        super.PageLayout()
        
        BodyView = PageYiMaiSameSchoolBodyView(parentView: SelfView!, navController: NavController!)
        TopView = PageCommonTopView(parentView: SelfView!, titleString: "同学校", navController: NavController)
    }
    
    
    override func PagePreRefresh() {
        BodyView?.LoadData()
    }
    
    override func PageDisapeared() {
        YMCoreDataEngine.RemoveData(YMCoreDataKeyStrings.CS_SAME_SAMECOLLEGE)
        BodyView?.Clear()
    }
}








