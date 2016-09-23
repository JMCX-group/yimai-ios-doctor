//
//  PagePersonalDetailEditViewController.swift
//  YiMai
//
//  Created by why on 16/6/22.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PagePersonalDetailEditViewController: PageViewController {
    private var Actions: PagePersonalDetailEditActions? = nil
    public var BodyView: PagePersonalDetailEditBodyView? = nil

    override func PageLayout() {
        super.PageLayout()
        Actions = PagePersonalDetailEditActions(navController: self.NavController!, target: self)
        BodyView = PagePersonalDetailEditBodyView(parentView: self.SelfView!, navController: self.NavController!, pageActions: Actions!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "个人信息编辑", navController: self.NavController!)
    }
    
    override func PagePreRefresh() {
//        if(!PageLayoutFlag) { return }
//        print("isBeingPresented : \(self.isBeingPresented())")
//        print("isBeingDismissed : \(self.isBeingDismissed())")
//        print("isMovingToParentViewController : \(self.isMovingToParentViewController())")
//        print("isMovingFromParentViewController : \(self.isMovingFromParentViewController())")
//
//        if(self.isMovingToParentViewController()) {
//            BodyView!.Reload()
//        }
        BodyView!.Reload()
    }
}
