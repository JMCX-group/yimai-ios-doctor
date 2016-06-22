//
//  PagePersonalTagsEditViewController.swift
//  YiMai
//
//  Created by why on 16/6/22.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PagePersonalTagsEditViewController: PageViewController {
    private var BodyView: PagePersonalTagsEditBodyView? = nil
    public var Actions: PagePersonalTagsEditActions? = nil
    
    override func PageLayout() {
        super.PageLayout()
        Actions = PagePersonalTagsEditActions(navController: self.NavController!, target: self)
        BodyView = PagePersonalTagsEditBodyView(parentView: self.SelfView!, navController: self.NavController!, pageActions: Actions!)
    }
}















