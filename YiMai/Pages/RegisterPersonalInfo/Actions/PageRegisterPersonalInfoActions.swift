//
//  PageRegisterPersonalInfoActions.swift
//  YiMai
//
//  Created by why on 16/4/20.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

public class PageRegisterPersonalInfoActions: PageJumpActions {
    private var TargetView: PageRegisterPersonalInfoBodyView? = nil
    private var CompleteInfoApi: YMAPIUtility? = nil
    private var GetUserInfoApi: YMAPIUtility? = nil
    private var BackEndApi: LoginBackendProgress = LoginBackendProgress(key: "fromCompleteInfo")
    
    convenience public init(navController: UINavigationController, bodyView: PageRegisterPersonalInfoBodyView) {
        self.init()
        self.NavController = navController
        TargetView = bodyView
        CompleteInfoApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_UPDATE_USER + "fromRegister",
                                       success: UpdateSuccess, error: UpdateError)
    }
    
    public func UpdateSuccess(_: NSDictionary?) {
        
        YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_NAME_INIT_DATA+"fromRegister").YMGetAPPInitData("fromRegister")
        BackEndApi.DoApi()
        
        let handler = YMCoreMemDataOnceHandler(handler: StartLogin)
        YMCoreDataEngine.SetDataOnceHandler(YMModuleStrings.MODULE_NAME_REGISTER_COMPLETE_INFO, handler: handler)

    }
    
    private func StartLogin(_: AnyObject?, queue: NSOperationQueue) -> Bool {
        let loginStatus = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_LOGIN_STATUS) as? Bool
        
        if(nil == loginStatus) {
            return false
        }
        
        let unpackedStatus = loginStatus!
        if(!unpackedStatus) {
            queue.addOperationWithBlock({ () -> Void in
                YMPageModalMessage.ShowErrorInfo("网络连接异常，请稍后再试。", nav: self.NavController!)
                self.TargetView?.Loading?.Hide()
            })
        } else {
            queue.addOperationWithBlock({ () -> Void in
                self.TargetView?.Loading?.Hide()
                self.DoJump(YMCommonStrings.CS_PAGE_INDEX_NAME)
            })
        }
        
        return true
    }
    
    public func UpdateError(error: NSError) {
        let errInfo = JSON(data: error.userInfo["com.alamofire.serialization.response.error.data"] as! NSData)
        print(errInfo)
        YMPageModalMessage.ShowErrorInfo("网络连接异常，请稍后再试。", nav: self.NavController!)
        TargetView?.Loading?.Hide()
    }
    
    public func ShowHospital(sender: UIGestureRecognizer) {
        PageCommonSearchViewController.SearchPageTypeName = YMCommonSearchPageStrings.CS_HOSPITAL_SEARCH_PAGE_TYPE
        PageCommonSearchViewController.InitPageTitle = "选择医院"
        PageCommonSearchViewController.InitSearchKey = ""
        DoJump(YMCommonStrings.CS_PAGE_COMMON_SEARCH_NAME)
    }
    
    public func ShowCity(sender: UIGestureRecognizer) {
        PageCommonSearchViewController.SearchPageTypeName = YMCommonSearchPageStrings.CS_DEPARTMENT_SEARCH_PAGE_TYPE
        PageCommonSearchViewController.InitPageTitle = "选择科室"
        PageCommonSearchViewController.InitSearchKey = ""
        DoJump(YMCommonStrings.CS_PAGE_COMMON_SEARCH_NAME)
    }
    
    public func CheckWhenNameChanged(_: YMTextField) {
        TargetView?.CheckInfoComplete()
    }
    
    public func UpdateUserInfo(_: YMButton) {
        TargetView?.Loading?.Show()
        CompleteInfoApi?.YMChangeUserInfo(
            [
                "name": TargetView!.UserRealnameInput!.text!,
                "hospital": TargetView!.HospitalId,
                "department": TargetView!.HospitalDepartmentId,
            ]
        )
    }
}