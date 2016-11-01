//
//  PageDoctorAtuhViewController.swift
//  YiMai
//
//  Created by superxing on 16/9/29.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

class PageDoctorAuthViewController: PageViewController {
    var BodyView: PageDoctorAuthBodyView!
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageDoctorAuthBodyView(parentView: self.view, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: "认证资料", navController: self.NavController!)
    }

    override func PagePreRefresh() {
        let authFlag = YMVar.GetStringByKey(YMVar.MyUserInfo, key: "is_auth")
        if("1" == authFlag) {
            //TODO: Show
        } else {
            
        }
    }
}
