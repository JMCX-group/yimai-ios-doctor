//
//  PageSameAreasViewController.swift
//  YiMai
//
//  Created by why on 16/5/27.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageYiMaiSameAreasViewController: PageViewController{
    private var Actions: PageYiMaiSameAreasActions? = nil
    public var BodyView: PageYiMaiSameAreasBodyView? = nil
    
    override func PageLayout() {
        super.PageLayout()
        
        if(PageLayoutFlag) {return}
        PageLayoutFlag=true
        
        Actions = PageYiMaiSameAreasActions(navController: NavController, target: self)
        BodyView = PageYiMaiSameAreasBodyView(parentView: SelfView!, navController: NavController!, pageActions: Actions!)
        TopView = PageCommonTopView(parentView: SelfView!, titleString: "同领域", navController: NavController)
    }
}
