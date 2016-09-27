//
//  PageMyPatientListViewController.swift
//  YiMai
//
//  Created by superxing on 16/9/27.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

class PageMyPatientListViewController: PageViewController {
    var BodyView: PageMyPatientListBodyView!
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageMyPatientListBodyView(parentView: self.view, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: "我的患者", navController: self.NavController!) 
    }
    
    override func PagePreRefresh() {
        BodyView!.Clear()
        BodyView!.PatientActions.GetMyPatientList()
    }
}













