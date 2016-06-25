//
//  PageYiMaiContactViewController.swift
//  YiMai
//
//  Created by ios-dev on 16/6/26.
//  Copyright © 2016年 why. All rights reserved.
//

import Neon

class PageYiMaiContactViewController: PageViewController {
    override func PageLayout() {
        super.PageLayout()
        let contactImg = YMLayout.GetSuitableImageView("YMPlatformContact")
        let bodyView = UIScrollView()
        
        YMLayout.BodyLayoutWithTop(self.view!, bodyView: bodyView)
        bodyView.addSubview(contactImg)
        contactImg.anchorToEdge(Edge.Top, padding: 0, width: contactImg.width, height: contactImg.height)
        
        TopView = PageCommonTopView(parentView: self.view, titleString: "联系我们", navController: self.NavController!)
        
        YMLayout.SetVScrollViewContentSize(bodyView, lastSubView: contactImg)
    }
}
