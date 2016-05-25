//
//  PageYiMaiViewController.swift
//  YiMai
//
//  Created by why on 16/5/20.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageYiMaiViewController: PageViewController {
    private var YiMaiTopView: PageYiMaiTopView? = nil
    private var YiMaiActions: PageYiMaiActions? = nil
    private var YiMaiR1Body: PageYiMaiR1BodyView? = nil
    private var YiMaiR2Body: PageYiMaiR2BodyView? = nil
    
    override func GestureRecognizerEnable() -> Bool {return false}

    public override func PageLayout(){
        if(PageLayoutFlag) {return}
        PageLayoutFlag=true
        
        super.PageLayout()

        YiMaiActions = PageYiMaiActions(navController: self.NavController, target: self)
        YiMaiR1Body = PageYiMaiR1BodyView(parentView: self.SelfView!, navController: self.NavController!, pageActions: YiMaiActions!)
        YiMaiR2Body = PageYiMaiR2BodyView(parentView: self.SelfView!, navController: self.NavController!, pageActions: YiMaiActions!)
        YiMaiTopView = PageYiMaiTopView(parentView: self.SelfView!, navController: self.NavController!, pageActions: YiMaiActions!)
        BottomView = PageCommonBottomView(parentView: self.SelfView!, navController: self.NavController!)
    }
    
    public func ShowYiMaiR1Page(){
        YiMaiTopView?.SetSelectedTab(YMYiMaiStrings.CS_TOP_TAB_R1_BUTTON_TITLE)
        YiMaiR2Body?.BodyView.hidden = true
        YiMaiR1Body?.BodyView.hidden = false
    }
    
    public func ShowYiMaiR2Page() {
        YiMaiTopView?.SetSelectedTab(YMYiMaiStrings.CS_TOP_TAB_R2_BUTTON_TITLE)
        YiMaiR1Body?.BodyView.hidden = true
        YiMaiR2Body?.BodyView.hidden = false
    }
}
