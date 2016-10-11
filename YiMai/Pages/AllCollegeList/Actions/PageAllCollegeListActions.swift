//
//  PageAllCollegeListActions.swift
//  YiMai
//
//  Created by old-king on 16/10/6.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

class PageAllCollegeListActions: PageJumpActions {
    var TargetView: PageAllCollegeListBodyView!
    var CollegeApi: YMAPIUtility!
    var UpdateApi: YMAPIUtility!
    
    override func ExtInit() {
        super.ExtInit()
        
        TargetView = Target as! PageAllCollegeListBodyView
        CollegeApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_COLLEGE_LIST,
                                  success: GetCollegeSuccess, error: GetCollegeError)
        
        UpdateApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_UPDATE_USER + "-forCollege",
                                 success: UpdateSuccess, error: UpdateError)
    }
    
    func UpdateSuccess(data: NSDictionary?) {
        TargetView.FullPageLoading.Hide()
        print(data)
    }
    
    func UpdateError(error: NSError) {
        TargetView.FullPageLoading.Hide()
        YMAPIUtility.PrintErrorInfo(error)
    }
    
    func GetCollegeSuccess(data: NSDictionary?) {
        if(nil == data) {
            return
        }
        
        let list = data!["data"] as! [[String: AnyObject]]
        TargetView.CollegeData = list
        TargetView.LoadData(list)
    }
    
    func GetCollegeError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
    }
    
    func StartSearch(text: YMTextField) {
        var result = [[String: AnyObject]]()
        let searchKey = text.text!
        
        if(YMValueValidator.IsEmptyString(searchKey)) {
            TargetView.LoadData(TargetView.CollegeData)
        } else {
            for v in TargetView.CollegeData {
                let name = v["name"] as! String
                if(name.containsString(searchKey)) {
                    result.append(["id": v["id"]!, "name": v["name"]!])
                }
            }
            
            TargetView.LoadData(result)
        }
    }
    
    func CollegeSelect(gr: UIGestureRecognizer) {
        let cell = gr.view as! YMTouchableView
        let data = cell.UserObjectData as! [String:AnyObject]
        PageAllCollegeListBodyView.SelectedCollege = data
        YMVar.MyUserInfo["college"] = data

        self.NavController?.popViewControllerAnimated(true)
        UpdateApi.YMChangeUserInfo(["college": data["id"]!])
    }
}
























