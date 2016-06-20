//
//  PageCommonSearchViewController.swift
//  YiMai
//
//  Created by why on 16/6/6.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageCommonSearchViewController: PageViewController {
    public var CommonTopView: PageCommonSearchTopView? = nil
    
    private var CommonSearch: PageCommonSearchBodyView? = nil
    private var HospitalSearch: PageHospitalSearchBodyView? = nil
    private var DepartmentSearch: PageDepartmentSearchBodyView? = nil

    public static var SearchPageTypeName: String = ""
    public static var InitSearchKey: String = ""
    public static var InitPageTitle: String = ""
    
    public override func PageLayout() {
        super.PageLayout()
        LayoutBody()
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: PageCommonSearchViewController.InitPageTitle, navController: self.NavController!)
        
    }

    private func LayoutBody() {
        switch PageCommonSearchViewController.SearchPageTypeName {

        case YMCommonSearchPageStrings.CS_COMMON_SEARCH_PAGE_TYPE:
            CommonSearch = PageCommonSearchBodyView(parentView: self.SelfView!,
                                                    navController: self.NavController!)
        break
            
        case YMCommonSearchPageStrings.CS_HOSPITAL_SEARCH_PAGE_TYPE:
            HospitalSearch = PageHospitalSearchBodyView(parentView: self.SelfView!,
                                                        navController: self.NavController!)
        break

        case YMCommonSearchPageStrings.CS_DEPARTMENT_SEARCH_PAGE_TYPE:
            DepartmentSearch = PageDepartmentSearchBodyView(parentView: self.SelfView!,
                                                          navController: self.NavController!)
            
        break
            
        default: break
            
        }
    }
    
    override func PageRefresh() {
        if(!PageLayoutFlag) {
            PageLayoutFlag=true
            return
        }

        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: PageCommonSearchViewController.InitPageTitle, navController: self.NavController!)

        switch PageCommonSearchViewController.SearchPageTypeName {
            
        case YMCommonSearchPageStrings.CS_COMMON_SEARCH_PAGE_TYPE:
            break
            
        case YMCommonSearchPageStrings.CS_HOSPITAL_SEARCH_PAGE_TYPE:
            HospitalSearch?.ShowInitHospitals()
            break
            
        case YMCommonSearchPageStrings.CS_DEPARTMENT_SEARCH_PAGE_TYPE:
            DepartmentSearch?.ShowDepartments()
            break
            
        default: break
            
        }
    }

    override func PageDisapeared() {
        if(!PageLayoutFlag){return}
        
        TopView?.TopViewPanel.removeFromSuperview()
        
        switch PageCommonSearchViewController.SearchPageTypeName {
            
        case YMCommonSearchPageStrings.CS_COMMON_SEARCH_PAGE_TYPE:
            break
            
        case YMCommonSearchPageStrings.CS_HOSPITAL_SEARCH_PAGE_TYPE:
            HospitalSearch?.ClearList()
            break
            
        case YMCommonSearchPageStrings.CS_DEPARTMENT_SEARCH_PAGE_TYPE:
            DepartmentSearch?.ClearList()
            break
            
        default: break
            
        }
    }
}










