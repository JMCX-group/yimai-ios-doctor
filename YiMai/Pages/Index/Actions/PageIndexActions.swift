//
//  PageIndexActions.swift
//  YiMai
//
//  Created by why on 16/4/21.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

public class PageIndexActions: PageJumpActions {
    private var ApiUtility: YMAPIUtility? = nil
    private let ApiSearchActionKey = YMAPIStrings.CS_API_ACTION_NAME_COMMON_SEARCH + "-indexCommonSearch"
    
    override func ExtInit() {
        ApiUtility = YMAPIUtility(key: self.ApiSearchActionKey,
                                  success: self.SearchSuccessed,
                                  error: self.GotSearchError)
    }
    
    private func GotSearchError(error: NSError){
        let errInfo = JSON(data: error.userInfo["com.alamofire.serialization.response.error.data"] as! NSData)
        print(errInfo)
    }
    
    private func SearchSuccessed(data: NSDictionary?) {
        if(nil != data) {
            print(JSON(data!))
        } else {
            print("no result!!!")
        }
    }
    
    public func JumpToAppointment(sender: UIGestureRecognizer) {
        PageAppointmentViewController.NewAppointment = true
        DoJump(YMCommonStrings.CS_PAGE_APPOINTMENT_NAME)
    }
    
    public func DoSearch(editor: YMTextField) {
        print(ApiUtility)
//        ApiUtility?.YMGetSearchResult(["field":editor.text!], progressHandler: nil)
//        ApiUtility?.YMQueryUserInfo()
//        ApiUtility?.YMQueryUserInfoById("23976")
//        ApiUtility?.YMGetCity()
//        ApiUtility?.YMGetCityGroupByProvince()
//        ApiUtility?.YMGetHospitalById("99")
//        ApiUtility?.YMGetHospitalsByCity("1")
//        ApiUtility?.YMSearchHospital(editor.text!)
//        ApiUtility?.YMGetDept()
//        ApiUtility?.YMGetInitRelation()
//        ApiUtility?.YMGetLevel1Ration()
//        ApiUtility?.YMGetLevel2Ration()
//        ApiUtility?.YMAddFriendByPhone("18612345678") //TODO: need test
        
        ApiUtility?.YMGetRelationCommonFriends("1")  //TODO: need test
//        ApiUtility?.YMGetRelationNewFriends()
//        ApiUtility?.YMGetRelationFriendRemarks("4", remarks: "test user 呵呵")
    }
}











