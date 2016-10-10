//
//  PageYiMaiViewController.swift
//  YiMai
//
//  Created by why on 16/5/20.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageYiMaiViewController: PageViewController {
    private var YiMaiTopView: PageYiMaiTopView? = nil
    private var YiMaiActions: PageYiMaiActions? = nil
    private var YiMaiR1Body: PageYiMaiR1BodyView? = nil
    private var YiMaiR2Body: PageYiMaiR2BodyView? = nil
    
    var RecentContactList: PageYiMaiRecentContactList!
    
    override func GestureRecognizerEnable() -> Bool {
        return false
    }
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        YMCurrentPage.CurrentPage = YMCommonStrings.CS_PAGE_YIMAI_NAME
    }

    public override func PageLayout(){
        if(PageLayoutFlag) {return}
        PageLayoutFlag=true
        
        super.PageLayout()

        YiMaiActions = PageYiMaiActions(navController: self.NavController, target: self)
        YiMaiR1Body = PageYiMaiR1BodyView(parentView: self.SelfView!, navController: self.NavController!, pageActions: YiMaiActions!)
        YiMaiR2Body = PageYiMaiR2BodyView(parentView: self.SelfView!, navController: self.NavController!, pageActions: YiMaiActions!)
        RecentContactList = PageYiMaiRecentContactList(parentView: self.SelfView!, navController: self.NavController!, pageActions: YiMaiActions!)
        YiMaiTopView = PageYiMaiTopView(parentView: self.SelfView!, navController: self.NavController!, pageActions: YiMaiActions!)
        BottomView = PageCommonBottomView(parentView: self.SelfView!, navController: self.NavController!)
    }
    
    override func PagePreRefresh() {
        if (!RecentContactList!.BodyView.hidden) {
            ShowRecentContactPage()
        } else if (!YiMaiR1Body!.BodyView.hidden) {
            YiMaiR1Body?.Reload()
        } else {
            
        }
    }
    
    public func ShowYiMaiR1Page(){
        YiMaiTopView?.SetSelectedTab(YMYiMaiStrings.CS_TOP_TAB_R1_BUTTON_TITLE)
        RecentContactList?.BodyView.hidden = true
        YiMaiR2Body?.BodyView.hidden = true
        YiMaiR1Body?.BodyView.hidden = false
        
        YiMaiR1Body?.SetBodyScroll()
        YiMaiR2Body?.SetBodyScroll()
//        YiMaiR1Body
    }
    
    public func ShowYiMaiR2Page() {
        YiMaiTopView?.SetSelectedTab(YMYiMaiStrings.CS_TOP_TAB_R2_BUTTON_TITLE)
        RecentContactList?.BodyView.hidden = true
        YiMaiR1Body?.BodyView.hidden = true
        YiMaiR2Body?.BodyView.hidden = false
        
        YiMaiR1Body?.SetBodyScroll()
        YiMaiR2Body?.SetBodyScroll()
    }
    
    public func ShowRecentContactPage() {
        YiMaiTopView?.SetSelectedTab(YMYiMaiStrings.CS_TOP_TAB_COMM_BUTTON_TITLE)
        RecentContactList?.BodyView.hidden = false
        YiMaiR1Body?.BodyView.hidden = true
        YiMaiR2Body?.BodyView.hidden = true
        
        YiMaiR1Body?.SetBodyScroll()
        YiMaiR2Body?.SetBodyScroll()
        
        let docList = YMIMUtility.GetRecentContactDoctorsIdList()
        YiMaiActions?.ContactApi.YMGetRecentContactedDocList(["id_list": docList.joinWithSeparator(",")])
    }
    
    override func PageDisapeared() {
        YiMaiR1Body?.SearchInput?.text = ""
        YiMaiR2Body?.SearchInput?.text = ""
    }
}























