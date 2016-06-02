//
//  PageAppointmentViewController.swift
//  YiMai
//
//  Created by why on 16/5/27.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageAppointmentViewController: PageViewController {
    private var Actions: PageAppointmentActions? = nil
    private var BodyView: PageAppointmentBodyView? = nil
    
    public static var SelectedDoctor:[String: AnyObject]? = nil
    
    public override func PageLayout() {
        if(nil != BodyView) {
            BodyView?.Reload()
            return
        }
        
        if(PageLayoutFlag) {return}
        PageLayoutFlag=true
        
        super.PageLayout()
        Actions = PageAppointmentActions(navController: self.NavController, target: self)
        BodyView = PageAppointmentBodyView(parentView: self.SelfView!, navController: self.NavController!, pageActions: Actions!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "预约", navController: self.NavController!)
    }
}
