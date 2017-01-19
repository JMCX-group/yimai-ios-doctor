//
//  PagePersonalViewController.swift
//  YiMai
//
//  Created by why on 16/4/22.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PagePersonalViewController: PageViewController {
    private var PersonalTopView: PagePersonalTopView? = nil
    var PersonalBodyView: PagePersonalBodyView? = nil
    private var Actions: PagePersonalActions? = nil
    private var UserInfo: AnyObject? = nil
    
    override func GestureRecognizerEnable() -> Bool {return false}
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        YMCurrentPage.CurrentPage = YMCommonStrings.CS_PAGE_PERSONAL_NAME
    }
    
    override public func viewWillAppear(animated: Bool) {
        YMCurrentPage.PagePersonalIsAnimatedShow = animated
        UserInfo = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_INFO)
        if(nil == UserInfo) {
            LoadingView?.Show()
            let handler = YMCoreMemDataOnceHandler(handler: self.RefreshUserInfo)
            YMCoreDataEngine.SetDataOnceHandler("PersonalTopViewRefresh", handler: handler)
        } else {
            self.PersonalTopView?.Refresh(self.UserInfo! as! [String : AnyObject])
        }
    }

    override func PageLayout(){
        super.PageLayout()
        if(PageLayoutFlag) {return}
        PageLayoutFlag=true
        
        Actions = PagePersonalActions(navController: self.navigationController!)
        
        PersonalBodyView = PagePersonalBodyView(parentView: self.view, navController: self.navigationController!, pageActions: Actions!)
        PersonalTopView = PagePersonalTopView(parentView: self.view, navController: self.navigationController!, pageActions: Actions!)
        LoadingView = YMPageLoadingView(parentView: self.view)

        BottomView = PageCommonBottomView(parentView: self.view, navController: self.navigationController!)
    }
    
    private func RefreshUserInfo(data: AnyObject?, queue: NSOperationQueue) -> Bool {
        UserInfo = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_INFO)
        if(nil == UserInfo) {
            return false
        } else {
            queue.addOperationWithBlock({
                self.LoadingView?.Hide()
                self.PersonalTopView?.Refresh(self.UserInfo! as! [String : AnyObject])
            })
            
            return true
        }
    }
}













