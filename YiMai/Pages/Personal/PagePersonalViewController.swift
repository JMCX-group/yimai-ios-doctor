//
//  PagePersonalViewController.swift
//  YiMai
//
//  Created by why on 16/4/22.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PagePersonalViewController: PageViewController {
    private var PersonalTopView: PagePersonalTopView? = nil
    private var PersonalBodyView: PagePersonalBodyView? = nil
    private var Actions: PagePersonalActions? = nil

    override func GestureRecognizerEnable() -> Bool {return false}
    
    override public func viewWillAppear(animated: Bool) {
        YMCurrentPage.PagePersonalIsAnimatedShow = animated
    }
    
    override func PageLayout(){
        if(PageLayoutFlag) {return}
        PageLayoutFlag=true
        
        Actions = PagePersonalActions(navController: self.navigationController!)
        
        PersonalBodyView = PagePersonalBodyView(parentView: self.view, navController: self.navigationController!, pageActions: Actions!)
        PersonalTopView = PagePersonalTopView(parentView: self.view, navController: self.navigationController!, pageActions: Actions!)
        BottomView = PageCommonBottomView(parentView: self.view, navController: self.navigationController!)
        
    }
}
