//
//  PageInputMyFeaturesViewController.swift
//  YiMai
//
//  Created by superxing on 16/10/10.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

class PageInputMyFeaturesViewController: PageViewController {
    var BodyView: PageInputMyFeaturesBodyView!

    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageInputMyFeaturesBodyView(parentView: self.view, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: "特长", navController: self.NavController!)
        
        BodyView.DrawTopAddButton(TopView!.TopViewPanel)
    }

    override func PagePreRefresh() {
        BodyView.Clear()
        BodyView.DrawFullBody()
        BodyView.SwapDelBtnStatus()
    }
    
    override func PageDisapeared() {
        var tags = YMVar.MyUserInfo["tags"] as? String
        
        if(nil == tags) {
            tags = ""
        }

        BodyView.FeaturesActions.FeaturesApi.YMChangeUserInfo(["tags": tags!])
    }
}
