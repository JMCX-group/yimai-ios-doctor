//
//  PagePersonalDetailEditActions.swift
//  YiMai
//
//  Created by why on 16/6/22.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PagePersonalDetailEditActions: PageJumpActions {
    private var TargetController: PagePersonalDetailEditViewController? = nil
    private var UpdateApi: YMAPIUtility? = nil

    override func ExtInit() {
        UpdateApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_UPDATE_USER,
            success: UpdateSuccess, error: UpdateError)
        TargetController = self.Target as? PagePersonalDetailEditViewController
    }
    
    public func ChangeHeadImage(_: UIGestureRecognizer) {
        
    }
    
    public func SelectGender(_: UIGestureRecognizer) {
        let alertController = UIAlertController(title: "选择性别", message: nil, preferredStyle: .Alert)
        let goBack = UIAlertAction(title: "男", style: .Default,
            handler: {
                action in
                self.UpdateUserInfo(["sex": "1"])
                self.TargetController?.BodyView?.Loading?.Show()
        })
        
        let goOn = UIAlertAction(title: "女", style: .Default,
            handler: {
                action in
                self.UpdateUserInfo(["sex": "0"])
                self.TargetController?.BodyView?.Loading?.Show()
        })
        
        goBack.setValue(YMColors.FontBlue, forKey: "titleTextColor")
        goOn.setValue(YMColors.FontBlue, forKey: "titleTextColor")
        
        alertController.addAction(goBack)
        alertController.addAction(goOn)
        self.NavController!.presentViewController(alertController, animated: true, completion: nil)
    }
    
    public func InputName(_: UIGestureRecognizer) {
        
    }
    
    public func SelectHospital(_: UIGestureRecognizer) {
        PageCommonSearchViewController.SearchPageTypeName = YMCommonSearchPageStrings.CS_HOSPITAL_SEARCH_PAGE_TYPE
        PageCommonSearchViewController.InitPageTitle = "选择医院"
        DoJump(YMCommonStrings.CS_PAGE_COMMON_SEARCH_NAME)
    }
    
    public func SelectDepartment(_: UIGestureRecognizer) {
        PageCommonSearchViewController.SearchPageTypeName = YMCommonSearchPageStrings.CS_DEPARTMENT_SEARCH_PAGE_TYPE
        PageCommonSearchViewController.InitPageTitle = "选择科室"
        DoJump(YMCommonStrings.CS_PAGE_COMMON_SEARCH_NAME)
    }
    
    public func InputJobTitle(_: UIGestureRecognizer) {
        
    }
    
    public func InputSchool(_: UIGestureRecognizer) {
        
    }
    
    public func InputIDNum(_: UIGestureRecognizer) {
        
    }
    
    public func UpdateUserInfo(data: AnyObject) {
        UpdateApi?.YMChangeUserInfo(data)
    }
    
    private func UpdateSuccess(data: NSDictionary?) {
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_USER_INFO, data: data!["data"]!)
        YMVar.MyUserInfo = data!["data"]! as! [String : AnyObject]
        TargetController?.BodyView?.LoadData()
        TargetController?.BodyView?.Loading?.Hide()
    }
    
    private func UpdateError(error: NSError) {
        TargetController?.BodyView?.Loading?.Hide()
    }
}





