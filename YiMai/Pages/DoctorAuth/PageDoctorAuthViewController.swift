//
//  PageDoctorAtuhViewController.swift
//  YiMai
//
//  Created by superxing on 16/9/29.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

class PageDoctorAuthViewController: PageViewController {
    var BodyView: PageDoctorAuthBodyView? = nil
    
    override func PageLayout() {
        super.PageLayout()
        DrawBody()
    }

    override func PagePreRefresh() {
        if(isMovingToParentViewController()) {
            DrawBody()
        }
        
    }
    
    func DrawBody() {
        let isFailedStatus = UserData as? String
        if(YMValueValidator.IsBlankString(isFailedStatus)) {
            PageDoctorAuthBodyView.IsReAuth = false
        } else {
            PageDoctorAuthBodyView.IsReAuth = true
        }
        
        
        YMLayout.ClearView(view: view)
        
        BodyView = PageDoctorAuthBodyView(parentView: self.view, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: "认证资料", navController: self.NavController!)
    }
}
