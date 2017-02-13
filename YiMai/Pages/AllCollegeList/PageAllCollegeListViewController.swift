//
//  PageAllCollegeListViewController.swift
//  YiMai
//
//  Created by old-king on 16/10/6.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

class PageAllCollegeListViewController: PageViewController {
    var BodyView: PageAllCollegeListBodyView!
    
    override func PageLayout() {
        super.PageLayout()
        BodyView = PageAllCollegeListBodyView(parentView: self.view, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.view,
                                    titleString: "毕业院校",
                                    navController: self.NavController)
    }
    
    override func PagePreRefresh() {
        super.PagePreRefresh()
        if(0 == BodyView.CollegeData.count) {
            BodyView.FullPageLoading.Show()
            BodyView.CollegeActions.CollegeApi.YMGetAllCollegeList()
        } else {
            self.BodyView.FullPageLoading.Show()
            YMDelay(0.01, closure: {
                self.BodyView.LoadData(self.BodyView.CollegeData, fromSearch: false)
            })
        }
    }
    
    override func PageDisapeared() {
        BodyView.Clear()
    }
}
