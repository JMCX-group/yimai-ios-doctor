//
//  PageRegisterSelectHospitalViewController.swift
//  YiMai
//
//  Created by why on 16/4/20.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageRegisterSelectHospitalViewController: PageViewController {
    private var BodyView : PageRegisterSelectHospitalBodyView? = nil
    public static var HospitalName: String = ""
    
    override func PageLayout(){
        if(PageLayoutFlag) {return}
        PageLayoutFlag=true

        BodyView = PageRegisterSelectHospitalBodyView(parentView: self.view, navController: self.navigationController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: YMRegisterSelectHospitalStrings.CS_REGISTER_SELECT_HOSPITAL_PAGE_TITLE, navController: self.navigationController)
    }
}
