//
//  PageLawyerInfoViewController.swift
//  YiMai
//
//  Created by superxing on 16/9/26.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit
import Neon

class PageLawyerInfoViewController: PageViewController {
    var BodyView: PageLawyerInfoBodyView!
    
    override func PageLayout() {
        super.PageLayout()
        BodyView = PageLawyerInfoBodyView(parentView: self.view, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: "律师咨询热线", navController: self.NavController!)
    }

}
