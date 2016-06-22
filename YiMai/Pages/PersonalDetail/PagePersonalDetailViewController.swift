//
//  PagePersonalDetailViewController.swift
//  YiMai
//
//  Created by why on 16/6/20.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PagePersonalDetailViewController: PageViewController {
    private var DetailTop: PagePersonalDetailTopView? = nil
    private var BodyView: PagePersonalDetailBodyView? = nil
    private var Actions: PagePersonalDetailActions? = nil
    private var Loading: YMPageLoadingView? = nil
    
    public static var DoctorId: String = ""
    
    override func PageLayout() {
        super.PageLayout()
        Actions = PagePersonalDetailActions(navController: self.NavController!, target: self)
        BodyView = PagePersonalDetailBodyView(parent: self.SelfView!, actions: Actions!)
        DetailTop = PagePersonalDetailTopView(parent: self.SelfView!, actions: Actions!)
        
        Loading = YMPageLoadingView(parentView: self.SelfView!)
        Loading?.MaskBackground.layer.zPosition = 10.0
        
        LoadData()
    }
    
    private func LoadData() {
        if(YMVar.MyDoctorId == PagePersonalDetailViewController.DoctorId) {
            LoadViews(YMVar.MyUserInfo)
        } else {
            let handler = YMCoreMemDataOnceHandler(handler: LoadDataTask)
            Loading?.Show()
            YMCoreDataEngine.SetDataOnceHandler(YMModuleStrings.MODULE_NAME_PERSONAL_INFO_DETAIL, handler: handler)
        }
    }
    
    public func LoadDataTask(_: AnyObject?, queue: NSOperationQueue) -> Bool {
        var userInfo: [String:AnyObject]? = nil
        let userInfoMap = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_INFO_MAP)
        if("" == PagePersonalDetailViewController.DoctorId){
            self.NavController?.popViewControllerAnimated(true)
            return true
        }

        if(nil != userInfoMap) {
            let unpackedMap = userInfoMap as? [String: [String: AnyObject]]
            if(nil == unpackedMap) {
                Actions?.GetUserInfo(PagePersonalDetailViewController.DoctorId)
                return false
            }
            
            userInfo = unpackedMap![PagePersonalDetailViewController.DoctorId]
            
            if(nil == userInfo) {
                Actions?.GetUserInfo(PagePersonalDetailViewController.DoctorId)
                return false
            }
        } else {
            Actions?.GetUserInfo(PagePersonalDetailViewController.DoctorId)
            return false
        }
        
        queue.addOperationWithBlock { () -> Void in
            self.LoadViews(userInfo!)
        }
        
        return true
    }
    
    private func LoadViews(userInfo: [String: AnyObject]) {
        self.DetailTop!.LoadData(userInfo)
        self.BodyView!.LoadData(userInfo)
        self.Loading?.Hide()
    }
    
    override func PagePreRefresh() {
        if(!PageLayoutFlag){return}
        
        BodyView = PagePersonalDetailBodyView(parent: self.SelfView!, actions: Actions!)
        DetailTop = PagePersonalDetailTopView(parent: self.SelfView!, actions: Actions!)

        LoadData()
    }
    
    override func PageDisapeared() {
        Loading?.Hide()
        BodyView?.BodyView.removeFromSuperview()
        DetailTop?.TopView.removeFromSuperview()
    }
}




