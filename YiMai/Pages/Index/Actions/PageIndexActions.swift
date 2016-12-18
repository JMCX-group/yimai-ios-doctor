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
    
    var TargetController: PageIndexViewController!
    
    var ContactApi: YMAPIUtility!
    
    override func ExtInit() {
        ApiUtility = YMAPIUtility(key: self.ApiSearchActionKey,
                                  success: self.SearchSuccessed,
                                  error: self.GotSearchError)
        
        ContactApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_RECENTLY_CONTACT,
                                  success: GetRecentContactSuccess,
                                  error: GetRecentContactFailed)
        
        TargetController = Target as! PageIndexViewController
    }
    
    func GetRecentContactSuccess(data: NSDictionary?) {
        let realData = data!["data"] as! [[String: AnyObject]]
        TargetController.BodyView!.LoadContactList(realData)
    }
    
    func GetRecentContactFailed(error: NSError) {
        let realData = [[String: AnyObject]]()
        TargetController.BodyView!.LoadContactList(realData)
    }
    
    private func GotSearchError(error: NSError){
        YMAPIUtility.PrintErrorInfo(error)
    }
    
    private func SearchSuccessed(data: NSDictionary?) {
        if(nil != data) {
            print(JSON(data!))
        } else {
            print("no result!!!")
        }
    }
    
    public func DoChat(gr: UIGestureRecognizer) {
        let sender = gr.view as! YMTouchableView
        let chat = YMChatViewController()
        //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
        chat.conversationType = RCConversationType.ConversationType_PRIVATE
        //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
        chat.targetId = sender.UserStringData
        //设置聊天会话界面要显示的标题
        chat.title = ""
        
        let userData = sender.UserObjectData as! [String: AnyObject]
        chat.ViewTitle = userData["name"] as! String
        chat.UserData = userData
        chat.ShowAppointment = userData["isDoc"] as! Bool
        
        chat.automaticallyAdjustsScrollViewInsets = false
        chat.prefersStatusBarHidden()
        
        //显示聊天会话界面
        self.NavController?.pushViewController(chat, animated: true)
    }
    
    public func JumpToAppointment(sender: UIGestureRecognizer) {
        if(!PageAppointmentViewController.SavedAppointment) {
            PageAppointmentViewController.NewAppointment = true
        }
        
        DoJump(YMCommonStrings.CS_PAGE_APPOINTMENT_NAME)
    }
    
    func JumpToAuthPage(gr: UIGestureRecognizer) {
        let authStatus = YMVar.GetStringByKey(YMVar.MyUserInfo, key: "is_auth")
        
        if("processing" == authStatus) {
            DoJump(YMCommonStrings.CS_PAGE_AUTH_PROCESSING)
        } else {
            DoJump(YMCommonStrings.CS_PAGE_PERSONAL_DOCTOR_AUTH_NAME)
        }
    }
    
    func IndexScrollImageTouched(sender: UIGestureRecognizer) {
        let img = sender.view! as! YMTouchableImageView

        PageShowWebViewController.TargetUrl = img.UserStringData
        DoJump(YMCommonStrings.CS_PAGE_SHOW_WEB_PAGE)
    }
    
    public func DoSearch(editor: YMTextField) {
        let searchKey = editor.text
        if(YMValueValidator.IsEmptyString(searchKey)) {
            return
        } else {
            PageGlobalSearchViewController.InitSearchKey = editor.text!
            DoJump(YMCommonStrings.CS_PAGE_GLOBAL_SEARCH_NAME)
        }
        
        
        
        
        
        
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
//        ApiUtility?.YMUploadAddressBook([
//            ["name":"187", "phone":"18712345678"],
//            ["name":"187", "phone":"18611175661"]
//        ])
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











