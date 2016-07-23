//
//  PageAdmissionTimeSettingViewController.swift
//  YiMai
//
//  Created by superxing on 16/7/14.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageAdmissionTimeSettingViewController: PageViewController {
    public var BodyView: PageAdmissionFixedTimeSettingBodyView? = nil
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageAdmissionFixedTimeSettingBodyView(parentView: self.SelfView!, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.SelfView!,
                                    titleString: "",
                                    navController: self.NavController!)
        
        BodyView?.DrawTopTabButton(TopView!.TopViewPanel)
    }
}
