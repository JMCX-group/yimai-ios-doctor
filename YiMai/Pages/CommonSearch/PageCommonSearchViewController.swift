//
//  PageCommonSearchViewController.swift
//  YiMai
//
//  Created by why on 16/6/6.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageCommonSearchViewController: PageViewController {
    private var Actions: PageAppointmentPatientBasicInfoActions? = nil
    public var CommonTopView: PageCommonSearchTopView? = nil
    
    private var CommonSearch: PageCommonSearchBodyView? = nil
    private var HospitalSearch: PageHospitalSearchBodyView? = nil
    
    public static var SearchPageTypeName: String = ""
    public static var InitSearchKey: String = ""
    public static var InitPageTitle: String = ""
    
    public override func PageLayout() {
        if(PageLayoutFlag) {
            LayoutBody()
            TopView = PageCommonTopView(parentView: self.SelfView!, titleString: PageCommonSearchViewController.InitPageTitle, navController: self.NavController!)
            return
        }
        PageLayoutFlag=true
        
        super.PageLayout()
        Actions = PageAppointmentPatientBasicInfoActions(navController: self.NavController, target: self)
        LayoutBody()
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: PageCommonSearchViewController.InitPageTitle, navController: self.NavController!)
    }
    
    private func LayoutBody() {
        switch PageCommonSearchViewController.SearchPageTypeName {
            
        case YMCommonSearchPageStrings.CS_COMMON_SEARCH_PAGE_TYPE:
            if(nil != CommonSearch) {
                
            } else {
                CommonSearch = PageCommonSearchBodyView(parentView: self.SelfView!,
                    navController: self.NavController!, pageActions: Actions!)
            }
        break
            
        case YMCommonSearchPageStrings.CS_HOSPITAL_SEARCH_PAGE_TYPE:
            if(nil != HospitalSearch) {
                
            } else {
                HospitalSearch = PageHospitalSearchBodyView(parentView: self.SelfView!,
                    navController: self.NavController!)
            }
        break
            
        default: break
            
        }
    }
}
