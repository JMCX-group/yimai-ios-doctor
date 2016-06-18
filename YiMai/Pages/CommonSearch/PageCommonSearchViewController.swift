//
//  PageCommonSearchViewController.swift
//  YiMai
//
//  Created by why on 16/6/6.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageCommonSearchViewController: PageViewController {
//    private var Actions: PageAppointmentPatientBasicInfoActions? = nil
    public var CommonTopView: PageCommonSearchTopView? = nil
    
    private var HospitalsSearchActions: PageHospitalSearchActions? = nil
    private var Loading: YMPageLoadingView? = nil
    
    private var CommonSearch: PageCommonSearchBodyView? = nil
    private var HospitalSearch: PageHospitalSearchBodyView? = nil

    public static var SearchPageTypeName: String = ""
    public static var InitSearchKey: String = ""
    public static var InitPageTitle: String = ""
    
    public override func PageLayout() {
        if(PageLayoutFlag) {
            Loading?.MaskBackground.removeFromSuperview()
            TopView?.TopViewPanel.removeFromSuperview()
            
            LayoutBody()
            TopView = PageCommonTopView(parentView: self.SelfView!, titleString: PageCommonSearchViewController.InitPageTitle, navController: self.NavController!)
            return
        }
        PageLayoutFlag=true
        
        super.PageLayout()
        HospitalsSearchActions = PageHospitalSearchActions(navController: self.NavController, target: self)
        LayoutBody()
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: PageCommonSearchViewController.InitPageTitle, navController: self.NavController!)
        
    }

    private func LayoutBody() {
        switch PageCommonSearchViewController.SearchPageTypeName {

        case YMCommonSearchPageStrings.CS_COMMON_SEARCH_PAGE_TYPE:
            if(nil != CommonSearch) {
                
            } else {
                CommonSearch = PageCommonSearchBodyView(parentView: self.SelfView!,
                    navController: self.NavController!, pageActions: HospitalsSearchActions!)
            }
            
            Loading = YMPageLoadingView(parentView: CommonSearch!.BodyView)
        break
            
        case YMCommonSearchPageStrings.CS_HOSPITAL_SEARCH_PAGE_TYPE:
            if(nil != HospitalSearch) {
                
            } else {
                HospitalSearch = PageHospitalSearchBodyView(parentView: self.SelfView!,
                    navController: self.NavController!, pageActions: HospitalsSearchActions)
            }
            
            Loading = YMPageLoadingView(parentView: HospitalSearch!.BodyView)
            Loading?.Show()
            HospitalsSearchActions?.InitHospitalList()
        break
            
        default: break
            
        }
    }
    
    public func DrawHospitals(data: NSDictionary?) {
        let realData = data!["data"]! as! Array<AnyObject>
        Loading?.Hide()
        HospitalSearch!.DrawSearchResult(realData)
    }
    
    public func ShowLoading() {
        Loading?.Show()
    }
    
    public func HideLoading() {
        Loading?.Hide()
    }
    
    public func ClearList() {
        HospitalSearch!.ClearList()
    }
}










