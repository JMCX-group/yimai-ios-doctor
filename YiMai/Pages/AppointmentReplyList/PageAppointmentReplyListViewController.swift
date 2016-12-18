//
//  PageAppointmentReplyListViewController.swift
//  YiMai
//
//  Created by superxing on 16/11/23.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

class PageAppointmentReplyListViewController: PageViewController {
    var BodyView: PageAppointmentReplyListBodyView!
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageAppointmentReplyListBodyView(parentView: self.view, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: "约诊回复列表", navController: self.NavController!)
    }
    
    override func PagePreRefresh() {
        BodyView.ListActions.ClearListApi.YMClearAllNewAppointment()
        if(self.isMovingToParentViewController()) {
            YMLayout.ClearView(view: BodyView.BodyView)
            BodyView.FullPageLoading.Show()
            BodyView.ListActions.GetListApi.YMGetAllNewAppointmentMsg()
        }
    }
}