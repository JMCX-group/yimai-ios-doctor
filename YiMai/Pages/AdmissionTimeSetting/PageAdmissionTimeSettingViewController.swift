//
//  PageAdmissionTimeSettingViewController.swift
//  YiMai
//
//  Created by superxing on 16/7/14.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageAdmissionTimeSettingViewController: PageViewController {
    public var FixedSettingBodyView: PageAdmissionFixedTimeSettingBodyView? = nil
    public var FlexibleSettingBodyView: PageAdmissionFlexibleTimeSettingBodyView? = nil
    public var SettingActions: PageAdmissionTimeSettingActions? = nil

    override func PageLayout() {
        super.PageLayout()
        
        SettingActions = PageAdmissionTimeSettingActions(navController: NavController!, target: self)
        FixedSettingBodyView = PageAdmissionFixedTimeSettingBodyView(parentView: self.SelfView!,
                                                                     navController: self.NavController!,
                                                                     pageActions: SettingActions)
        
        FlexibleSettingBodyView = PageAdmissionFlexibleTimeSettingBodyView(parentView: self.SelfView!,
                                                                        navController: self.NavController!,
                                                                        pageActions: SettingActions)
        TopView = PageCommonTopView(parentView: self.SelfView!,
                                    titleString: "",
                                    navController: self.NavController!)
        
        FixedSettingBodyView?.DrawTopTabButton(TopView!.TopViewPanel)
        FixedSettingBodyView?.DrawTopConfirmButton(TopView!.TopViewPanel)
        
        FlexibleSettingBodyView?.BodyView.hidden = true
    }
}
