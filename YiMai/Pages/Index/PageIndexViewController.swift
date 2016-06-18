//
//  PageIndexViewController.swift
//  YiMai
//
//  Created by why on 16/4/21.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageIndexViewController: PageViewController {
    private var IndexTopView: PageIndexTopView? = nil
    private var BodyView : PageIndexBodyView? = nil
    private var Actions: PageIndexActions? = nil
    
    override func GestureRecognizerEnable() -> Bool {
        return false
    }
    
    override public func viewDidAppear(animated: Bool) {
        YMCurrentPage.CurrentPage = YMCommonStrings.CS_PAGE_INDEX_NAME
    }

    override func PageLayout(){
        if(PageLayoutFlag) {return}
        PageLayoutFlag=true
        
        YMCoreDataEngine.EngineInitialize()

        Actions = PageIndexActions(navController: self.navigationController!)

        BodyView = PageIndexBodyView(parentView: self.view, navController: self.navigationController!, pageActions: Actions!)
        IndexTopView = PageIndexTopView(parentView: self.view, navController: self.navigationController!, pageActions: Actions!)
        BottomView = PageCommonBottomView(parentView: self.view, navController: self.navigationController!)
    }
}
