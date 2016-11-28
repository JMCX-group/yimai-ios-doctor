//
//  PageYiMaiIntroViewController.swift
//  YiMai
//
//  Created by ios-dev on 16/6/26.
//  Copyright © 2016年 why. All rights reserved.
//

import Neon

class PageYiMaiIntroViewController: PageViewController {
    override func PageLayout() {
        super.PageLayout()
        let introImg = YMLayout.GetSuitableImageView("YMPlatformInfo")
        let bodyView = UIScrollView()
        
        YMLayout.BodyLayoutWithTop(self.view!, bodyView: bodyView)
        bodyView.addSubview(introImg)
        introImg.anchorToEdge(Edge.Top, padding: 0, width: introImg.width, height: introImg.height)
        
        TopView = PageCommonTopView(parentView: self.view, titleString: "医者脉连简介", navController: self.NavController!)
        
        YMLayout.SetVScrollViewContentSize(bodyView, lastSubView: introImg)
    }
}
