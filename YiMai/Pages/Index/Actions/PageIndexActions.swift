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
        
        print(error)
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
//        let searchKey = editor.text
//        if(YMValueValidator.IsEmptyString(searchKey)) {
//            return
//        } else {
//            PageGlobalSearchViewController.InitSearchKey = editor.text!
//            DoJump(YMCommonStrings.CS_PAGE_GLOBAL_SEARCH_NAME)
//        }
        
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
//        ApiUtility?.YMGetLevel1Relation()
//        ApiUtility?.YMGetLevel2Relation()
//        ApiUtility?.YMAddFriendByPhone("18612345678") //TODO: need test
        
//        ApiUtility?.YMGetRelationCommonFriends("1")  //TODO: need test
//        ApiUtility?.YMGetRelationNewFriends()
//        ApiUtility?.YMGetRelationFriendRemarks("4", remarks: "test user 呵呵")
//        ApiUtility?.YMGetRelationFriendRemarks("1,3")
//        ApiUtility?.YMRelationDelFriend("4")
//        ApiUtility?.YMGetAllRadio()
//        ApiUtility?.YMSetRadioHaveRead("1")
//        ApiUtility?.YMCreateNewAppointment(
//            [
//                "name": "张三",
//                "phone": "13312345678",
//                "sex": "1",
//                "age": "22",
//                "history": "",
//                "doctor": "2",
//                "date": "2016-05-01,2016-05-02",
//                "am_or_pm": "am,pm"
//            ])
        
//        ApiUtility?.YMGetAppointmentList()
        ApiUtility?.YMUploadAddressBook([
            ["name":"187", "phone":"18712345678"],
            ["name":"186", "phone":"18612345678"]
        ])
//        ApiUtility?.YMGetAdmissionsList()
//        ApiUtility?.YMGetAdmissionDetail("011605150006")
//        ApiUtility?.YMAdmissionAgree(
//            [
//                "id": "011605260002",
//                "visit_time": "2016-07-01",
//                "supplement": "附加信息; test",
//                "remark": "补充说明; test"
//            ])
    }
}











