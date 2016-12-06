//
//  PageMyAdmissionsListViewController.swift
//  YiMai
//
//  Created by why on 16/4/28.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageMyAdmissionsListViewController: PageViewController {
    private var Actions: PageMyAdmissionsListActions? = nil
    public var BodyView: PageMyAdmissionsListBodyView? = nil
    private var Loading: YMPageLoadingView? = nil
    
    public static var CompletedAdmissions = [[String: AnyObject]]()
    public static var WaitCompletedAdmissions = [[String: AnyObject]]()
    public static var WaitReplyAdmissions = [[String: AnyObject]]()
    
    override func PageLayout() {
        super.PageLayout()
        
        if(PageLayoutFlag) {
            return
        }
        PageLayoutFlag=true
        
        Actions = PageMyAdmissionsListActions(navController: NavController, target: self)
        BodyView = PageMyAdmissionsListBodyView(parentView: SelfView!, navController: NavController!, pageActions: Actions!)
        TopView = PageCommonTopView(parentView: SelfView!, titleString: "我的接诊信息", navController: NavController)
//        BodyView?.DrawSpecialClearButton()
        
        Loading = YMPageLoadingView(parentView: SelfView!)
        Loading?.Show()
        Actions?.GetAdmissionInfo()
    }
    
    override func PagePreRefresh() {
        Loading?.Show()
        BodyView?.Clear()
        Actions?.GetAdmissionInfo()
    }
    
    public func HideLoading() {
        Loading?.Hide()
    }
}
