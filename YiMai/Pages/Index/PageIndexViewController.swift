//
//  PageIndexViewController.swift
//  YiMai
//
//  Created by why on 16/4/21.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageIndexViewController: PageViewController {
    private var IndexTopView: PageIndexTopView? = nil
    var BodyView : PageIndexBodyView? = nil
    private var Actions: PageIndexActions? = nil
    
    override func GestureRecognizerEnable() -> Bool {
        return false
    }
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if(!PageLayoutFlag){PageLayoutFlag = true}

        YMCurrentPage.CurrentPage = YMCommonStrings.CS_PAGE_INDEX_NAME
        
        let docList = YMIMUtility.GetRecentContactDoctorsIdList()

        Actions?.ContactApi.YMGetRecentContactedDocList(["id_list": docList.joinWithSeparator(",")])
        
        if(0 == YMVar.MyUserInfo.count) {
            YMVar.MyUserInfo = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_INFO)! as! [String: AnyObject]
        }
        
        if(0 == YMVar.MySysInfo.count) {
            YMVar.MySysInfo = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_SYSTEM_INFO)! as! [String: AnyObject]
        }
        
        YMVar.MyDoctorId = YMVar.GetStringByKey(YMVar.MyUserInfo, key: "id")

        let jobTitle = YMVar.MyUserInfo["job_title"] as? String
        if(nil == jobTitle) {
            YMVar.MyUserInfo["job_title"] = "医生"
        }
        BodyView?.UpdateAuthStatus()
        YMBackgroundRefresh.Start()
    }

    override func PageLayout(){
        if(PageLayoutFlag) {
            return
        }
        super.PageLayout()
        
        if(0 == YMVar.MyUserInfo.count) {
            YMVar.MyUserInfo = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_INFO)! as! [String: AnyObject]
            YMVar.MyDoctorId = "\(YMVar.MyUserInfo["id"]!)"
        }
        
        if(0 == YMVar.MySysInfo.count) {
            YMVar.MySysInfo = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_SYSTEM_INFO)! as! [String: AnyObject]
        }


        Actions = PageIndexActions(navController: self.navigationController!, target: self)

        BodyView = PageIndexBodyView(parentView: self.view, navController: self.navigationController!, pageActions: Actions!)
        IndexTopView = PageIndexTopView(parentView: self.view, navController: self.navigationController!, pageActions: Actions!)
        BottomView = PageCommonBottomView(parentView: self.view, navController: self.navigationController!)
        
        IndexTopView!.ShowNewMsgNotifyPoint()
        
        RefreshAuthInfo()
    }
    
    func RefreshAuthInfo() {
        if(0 != YMVar.MyUserInfo.count) {
            self.BodyView?.UpdateAuthStatus()
            YMDelay(2.0) {
                self.RefreshAuthInfo()
            }
        } else {
            YMDelay(2.0) {
                self.RefreshAuthInfo()
            }
        }
    }

    override func PagePreRefresh() {
        BottomView!.BottomViewPanel.removeFromSuperview()
        IndexTopView?.TopSearchInput?.text = ""
        
        PageCommonBottomView.BottomButtonImage = [
            YMCommonStrings.CS_PAGE_INDEX_NAME:"IndexButtonHomeBlue",
            YMCommonStrings.CS_PAGE_YIMAI_NAME:"IndexButtonYiMaiGray",
            YMCommonStrings.CS_PAGE_PERSONAL_NAME:"IndexButtonPersonalGray"
        ]
        BottomView = PageCommonBottomView(parentView: self.view, navController: self.navigationController!)
        IndexTopView!.UpdateMsgNotifyStatus()
        Actions?.BannerApi.YMGetIndexBanner()
        
        let fromLogin = UserData as? Bool
        if(nil != fromLogin) {
            UserData = nil
            BodyView?.ClearContactList()
        }
        
//        BodyView?.HideAuthInfo()
    }
}












