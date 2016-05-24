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
    
    public override func PageLayout(){
        if(PageLayoutFlag) {return}
        PageLayoutFlag=true
        
        super.PageLayout()

        YiMaiActions = PageYiMaiActions(navController: self.NavController)
        YiMaiR1Body = PageYiMaiR1BodyView(parentView: self.SelfView!, navController: self.NavController!, pageActions: YiMaiActions!)
        YiMaiTopView = PageYiMaiTopView(parentView: self.SelfView!, navController: self.NavController!, pageActions: YiMaiActions!)
    }
}
