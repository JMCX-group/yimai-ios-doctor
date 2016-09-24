//
//  RequirePaperCardViewController.swift
//  YiMai
//
//  Created by Wang Huaiyu on 16/9/24.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

class RequirePaperCardViewController: PageViewController {
    var BodyView: RequirePaperCardBodyView!
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = RequirePaperCardBodyView(parentView: self.view, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.view,
                                    titleString: "纸质名片申请",
                                    navController: self.NavController)
    }
    
    override func PagePreRefresh() {
        if(self.isMovingToParentViewController()) {
            BodyView.DrawFullBody()
        }
    }
}
