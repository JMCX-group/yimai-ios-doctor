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
        
        if(0 == BodyView.AllTagsFromServer.count) {
            BodyView.FullPageLoading.Show()
            BodyView.FeaturesActions.GetAllTags.YMGetTagGroupList()
        } else {
            BodyView.LoadOtherTags(BodyView.AllTagsFromServer)
        }
    }
    
//    override func viewWillDisappear(animated: Bool) {
//        super.viewWillDisappear(animated)
//        var tags = YMVar.MyUserInfo["tags"] as? String
//        
//        if(nil == tags) {
//            tags = ""
//        }
//        
//        print(YMVar.MyUserInfo["tags"])
//
//        BodyView.FeaturesActions.FeaturesApi.YMChangeUserInfo(["tags": tags!])
//    }
}
