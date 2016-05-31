//
//  PageAppointmentSelectDoctorViewController.swift
//  YiMai
//
//  Created by why on 16/5/31.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageAppointmentSelectDoctorViewController: PageViewController {
    private var Actions: PageAppointmentSelectDoctorAcitons? = nil
    private var BodyView: PageAppointmentSelectDoctorBodyView? = nil
    
    public override func PageLayout() {
        if(PageLayoutFlag) {return}
        PageLayoutFlag=true
        
        super.PageLayout()
        Actions = PageAppointmentSelectDoctorAcitons(navController: self.NavController, target: self)
        BodyView = PageAppointmentSelectDoctorBodyView(parentView: self.SelfView!, navController: self.NavController!, pageActions: Actions!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "选择医生", navController: self.NavController!)
    }
}
