//
//  PageAppointmentRecordViewController.swift
//  YiMai
//
//  Created by why on 16/6/23.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageAppointmentRecordViewController: PageViewController {
    private var Actions: PageAppointmentRecordActions? = nil
    public var BodyView: PageAppointmentRecordBodyView? = nil

    override func PageLayout() {
        super.PageLayout()
        BodyView = PageAppointmentRecordBodyView(parentView: self.SelfView!, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "约诊回复", navController: self.NavController!)
    }
    
    override func PageDisapeared() {
        BodyView?.Clear()
    }
    
    override func PagePreRefresh() {
        BodyView?.GetAppointmentRecord()
    }
}





















