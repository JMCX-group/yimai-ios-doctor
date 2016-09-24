//
//  PaperCardPreviewViewController.swift
//  YiMai
//
//  Created by Wang Huaiyu on 16/9/24.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

class PaperCardPreviewViewController: PageViewController {
    var BodyView: PaperCardPreviewBodyView!
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PaperCardPreviewBodyView(parentView: self.view,
                                            navController: self.NavController!)
        
        TopView = PageCommonTopView(parentView: self.view, titleString: "", navController: self.NavController!)
    }
    
    override func PagePreRefresh() {
        if(self.isMovingToParentViewController()) {
            BodyView.DrawFullBody()
        }
    }
}
