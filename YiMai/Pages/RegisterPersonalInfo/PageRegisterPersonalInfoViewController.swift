//
//  PageRegisterPersonalInfoViewController.swift
//  YiMai
//
//  Created by why on 16/4/20.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageRegisterPersonalInfoViewController: PageViewController {
    private var BodyView: PageRegisterPersonalInfoBodyView? = nil

    private static var NavController: UIViewController? = nil
    
    static var NeedInit = false

    override func GestureRecognizerEnable() -> Bool {
        return false
    }
    public static func GetController() -> UIViewController {
        return PageRegisterPersonalInfoViewController.NavController!
    }
    
    override func PagePreRefresh() {
        if(isMovingToParentViewController()) {
            BodyView?.Reset()
            if(!BodyView!.CityPicker.DataLoaded) {
                BodyView?.Loading?.Show()
                BodyView?.Actions!.GetCityInfoApi?.YMGetCityGroupByProvince()
            } else {
                BodyView!.CityPicker.Reload()
            }
            TopView?.TopViewPanel.removeFromSuperview()
            TopView = PageCommonTopView(parentView: self.view,
                                        titleString: YMRegisterInfoStrings.CS_REGISTER_INFO_PAGE_TITLE)
            
            PageHospitalSearchBodyView.HospitalSelected = nil
            PageDepartmentSearchBodyView.DepartmentSelected = nil
            YMCoreDataEngine.RemoveData(YMCoreDataKeyStrings.CS_USER_LOGIN_STATUS)
            PageRegisterPersonalInfoViewController.NeedInit = false
        } else {
            if(PageRegisterPersonalInfoViewController.NeedInit) {
                BodyView?.Reset()
                TopView?.TopViewPanel.removeFromSuperview()
                TopView = PageCommonTopView(parentView: self.view,
                                            titleString: YMRegisterInfoStrings.CS_REGISTER_INFO_PAGE_TITLE)
                
                PageHospitalSearchBodyView.HospitalSelected = nil
                PageDepartmentSearchBodyView.DepartmentSelected = nil
                YMCoreDataEngine.RemoveData(YMCoreDataKeyStrings.CS_USER_LOGIN_STATUS)
                PageRegisterPersonalInfoViewController.NeedInit = false
                
                BodyView?.Reset()
                if(!BodyView!.CityPicker.DataLoaded) {
                    BodyView?.Loading?.Show()
                    BodyView?.Actions!.GetCityInfoApi?.YMGetCityGroupByProvince()
                } else {
                    BodyView!.CityPicker.Reload()
                }
            } else {
                BodyView?.Refesh()
            }
        }
    }
    
    override func PageLayout(){
        super.PageLayout()
        
        PageRegisterPersonalInfoViewController.NavController = self
        
        self.NavController!.interactivePopGestureRecognizer?.delegate = self
        BodyView = PageRegisterPersonalInfoBodyView(parentView: self.view, navController: self.navigationController!)
        TopView = PageCommonTopView(parentView: self.view,
                                    titleString: YMRegisterInfoStrings.CS_REGISTER_INFO_PAGE_TITLE)
    }
}
