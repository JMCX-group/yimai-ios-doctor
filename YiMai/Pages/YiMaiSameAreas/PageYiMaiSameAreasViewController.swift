//
//  PageSameAreasViewController.swift
//  YiMai
//
//  Created by why on 16/5/27.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageYiMaiSameAreasViewController: PageViewController{
    public var BodyView: PageYiMaiSameAreasBodyView? = nil
    
    override func PageLayout() {
        if(PageLayoutFlag) {return}

        super.PageLayout()
        
        BodyView = PageYiMaiSameAreasBodyView(parentView: SelfView!, navController: NavController!)
        TopView = PageCommonTopView(parentView: SelfView!, titleString: "同领域", navController: NavController)
    }
    
    override func PagePreRefresh() {
        if(isMovingToParentViewController()) {
            BodyView?.LoadData()
        }
    }

    override func PageDisapeared() {
        if(isMovingFromParentViewController()) {
            BodyView?.Clear()
            BodyView?.ClearFilters()
        }
    }
}
