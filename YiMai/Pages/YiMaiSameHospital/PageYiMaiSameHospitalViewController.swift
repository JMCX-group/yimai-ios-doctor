//
//  PageSameHospitalViewController.swift
//  YiMai
//
//  Created by why on 16/5/27.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageYiMaiSameHospitalViewController: PageViewController {
    public var BodyView: PageYiMaiSameHospitalBodyView? = nil
    
    override func PageLayout() {
        if(PageLayoutFlag) {return}
        super.PageLayout()

        BodyView = PageYiMaiSameHospitalBodyView(parentView: SelfView!, navController: NavController!)
        TopView = PageCommonTopView(parentView: SelfView!, titleString: "同医院", navController: NavController)
    }
    
    override func PagePreRefresh() {
        if(isMovingToParentViewController()) {
            BodyView?.LoadData()
        }
    }
    
    override func PageDisapeared() {
        if(isMovingFromParentViewController()) {
            BodyView?.Clear()
        }
    }
}
