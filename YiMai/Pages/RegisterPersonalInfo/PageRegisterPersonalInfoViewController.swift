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

    public static var HospitalInfo: AnyObject? = nil
    public static var DepartmentInfo: AnyObject? = nil
    
    private static var NavController: UIViewController? = nil

    override func GestureRecognizerEnable() -> Bool {
        return false
    }
    public static func GetController() -> UIViewController {
        return PageRegisterPersonalInfoViewController.NavController!
    }
    
    override func PageLayout(){
        if(PageLayoutFlag) {
            return
        }
        PageLayoutFlag=true
        
        super.PageLayout()
        
        PageRegisterPersonalInfoViewController.NavController = self
        
        self.NavController!.interactivePopGestureRecognizer?.delegate = self
        BodyView = PageRegisterPersonalInfoHospitalBodyView(parentView: self.view, navController: self.navigationController!)
        TopView = PageCommonTopView(parentView: self.view,
                                    titleString: YMRegisterInfoStrings.CS_REGISTER_INFO_PAGE_TITLE)
    }
}
