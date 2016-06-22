//
//  PagePersonalDetailActions.swift
//  YiMai
//
//  Created by why on 16/6/20.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PagePersonalDetailActions: PageJumpActions {
    private var GetDetailApi: YMAPIUtility? = nil

    override func ExtInit() {
        GetDetailApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_DOCTOR_BY_ID,
            success: GetUserInfoSuccess,
            error: GetUserInfoError)
    }
    
    private func GetUserInfoSuccess(data: NSDictionary?) {
        let unpackedData = data!
        let user = unpackedData["user"]! as! [String: AnyObject]
        let userId = "\(user["id"]!)"
        
        var userMap = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_INFO_MAP) as? [String: [String: AnyObject]]

        if(nil == userMap) {
            userMap = [String: [String: AnyObject]]()
            userMap![userId] = user
        } else {
            let user = userMap![userId]
            
            if(nil == user) {
                userMap![userId] = user
            }
        }
        
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_USER_INFO_MAP, data: userMap!)
    }
    
    private func GetUserInfoError(error: NSError) {
        print(error.userInfo)
    }
    
    public func TagPanelExpand(_: UIGestureRecognizer) {
        
    }
    
    public func TagPanelCollapse(_: UIGestureRecognizer) {
        
    }
    
    public func GetUserInfo(doctorId: String) {
        GetDetailApi?.YMQueryUserInfoById(doctorId)
    }
    
    public func GoBack(_: UIGestureRecognizer) {
        self.NavController?.popViewControllerAnimated(true)
    }
}