//
//  PageYiMaiDoctorDetailActions.swift
//  YiMai
//
//  Created by ios-dev on 16/6/26.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

public class PageYiMaiDoctorDetailActions: PageJumpActions {
    private var TargetView: PageYiMaiDoctorDetailBodyView? = nil
    private var GetInfoApi: YMAPIUtility? = nil
    private var AddFriendApi: YMAPIUtility? = nil
    
    override func ExtInit() {
        super.ExtInit()
        GetInfoApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_DOCTOR_DETAIL,
                                  success: GetInfoSuccess, error: GetInfoError)
        
        AddFriendApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_ADD_FRIEND + "fromDoctorDetail",
                                    success: AddFriendSuccess, error: AddFriendError)
        
        
        self.TargetView = self.Target as? PageYiMaiDoctorDetailBodyView
    }
    
    public func GetInfoSuccess(data: NSDictionary?) {
        let userInfo = data!["user"] as! [String: AnyObject]
        TargetView?.LoadData(userInfo)
    }
    
    public func GetInfoError(error: NSError) {
        print(error)
    }
    
    public func AddFriendSuccess(_: NSDictionary?) {
        TargetView?.AddFriendBtn?.setTitleColor(YMColors.FontGray, forState: UIControlState.Disabled)
        TargetView?.AddFriendBtn?.backgroundColor = YMColors.CommonBottomGray
        TargetView?.AddFriendBtn?.enabled = false
        YMPageModalMessage.ShowNormalInfo("添加好友成功，等待对方验证。", nav: self.NavController!)
    }
    
    public func AddFriendError(error: NSError) {
        if(nil != error.userInfo["com.alamofire.serialization.response.error.response"]) {
//            let response = error.userInfo["com.alamofire.serialization.response.error.response"]!
//            let errInfo = JSON(data: error.userInfo["com.alamofire.serialization.response.error.data"] as! NSData)
            TargetView?.AddFriendBtn?.setTitleColor(YMColors.FontGray, forState: UIControlState.Disabled)
            TargetView?.AddFriendBtn?.backgroundColor = YMColors.CommonBottomGray
            TargetView?.AddFriendBtn?.enabled = false
            YMPageModalMessage.ShowNormalInfo("添加好友成功，等待对方验证。", nav: self.NavController!)
        } else {
            YMPageModalMessage.ShowErrorInfo("网络连接异常，请稍后再试。", nav: self.NavController!)
        }
    }
    
    public func GetInfo() {
        GetInfoApi?.YMQueryUserInfoById(PageYiMaiDoctorDetailBodyView.DocId)
    }
    
    public func AddFriend(sender: YMButton) {
        AddFriendApi?.YMAddFriendById(PageYiMaiDoctorDetailBodyView.DocId)
    }
    
    public func DoAppointment(sender: YMButton) {
        
    }
    
    public func DoChat(sender: YMButton) {
        let chat = RCConversationViewController()
        //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
        chat.conversationType = RCConversationType.ConversationType_PRIVATE
        //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
        chat.targetId = sender.UserStringData
        //设置聊天会话界面要显示的标题
        chat.title = ""
        
        print("chat to " + sender.UserStringData)
        //显示聊天会话界面
        self.NavController?.pushViewController(chat, animated: true)
    }
}