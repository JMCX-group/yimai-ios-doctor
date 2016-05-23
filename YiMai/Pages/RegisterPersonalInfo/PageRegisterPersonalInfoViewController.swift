//
//  PageRegisterPersonalInfoViewController.swift
//  YiMai
//
//  Created by why on 16/4/20.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageRegisterPersonalInfoViewController: PageViewController {
    private var BodyView: PageRegisterPersonalInfoHospitalBodyView? = nil

    override func PageLayout(){
        if(PageLayoutFlag) {return}
        PageLayoutFlag=true
        
        BodyView = PageRegisterPersonalInfoHospitalBodyView(parentView: self.view, navController: self.navigationController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: YMRegisterStrings.CS_REGISTER_PAGE_TITLE, navController: self.navigationController)
    }
}
