//
//  PageSameHospitalViewController.swift
//  YiMai
//
//  Created by why on 16/5/27.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageYiMaiSameHospitalViewController: PageViewController {
    private var Actions: PageYiMaiSameHospitalActions? = nil
    public var BodyView: PageYiMaiSameHospitalBodyView? = nil
    
    override func PageLayout() {
        super.PageLayout()
        
        if(PageLayoutFlag) {return}
        PageLayoutFlag=true
        
        Actions = PageYiMaiSameHospitalActions(navController: NavController, target: self)
        BodyView = PageYiMaiSameHospitalBodyView(parentView: SelfView!, navController: NavController!, pageActions: Actions!)
        TopView = PageCommonTopView(parentView: SelfView!, titleString: "同医院", navController: NavController)
    }
}
