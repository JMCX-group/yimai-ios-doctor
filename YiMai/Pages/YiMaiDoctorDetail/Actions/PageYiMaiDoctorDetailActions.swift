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
    private var AgreeApi: YMAPIUtility!
    
    var CommonFriendsApi: YMAPIUtility!
    
    override func ExtInit() {
        super.ExtInit()
        GetInfoApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_DOCTOR_DETAIL,
                                  success: GetInfoSuccess, error: GetInfoError)
        
        AddFriendApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_ADD_FRIEND + "fromDoctorDetail",
                                    success: AddFriendSuccess, error: AddFriendError)
        
        AgreeApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_AGREE_FRIEND_APPLY, success: AgreeSuccess, error: AgreeError)
        
        
        CommonFriendsApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_COMMON_FRIENDS_INFO, success: GetCommonFriendsSuccess, error: GetCommonFriendsError)
        self.TargetView = self.Target as? PageYiMaiDoctorDetailBodyView
    }
    
    func GetCommonFriendsSuccess(data: NSDictionary?) {
        let realData = data!["data"] as! [[String: AnyObject]]
        
        TargetView?.UpdateCommonFriendsName(realData)
    }
    
    func GetCommonFriendsError(error: NSError) {
        YMPageModalMessage.ShowErrorInfo("载入共同好友姓名出错", nav: NavController!)
    }
    
    func GetCommonFriendsName(idList: String) {
        CommonFriendsApi.YMGetDoctorsByIdList(idList)
    }
    
    func AgreeSuccess(data: NSDictionary?) {
        TargetView?.FullPageLoading.Hide()
        NavController!.popViewControllerAnimated(true)
    }
    
    func AgreeError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        
        YMPageModalMessage.ShowErrorInfo("网络繁忙，请稍后再试", nav: NavController!)
        TargetView?.FullPageLoading.Hide()
    }
    
    public func GetInfoSuccess(data: NSDictionary?) {
        let userInfo = data!["user"] as! [String: AnyObject]
        
        print("------")
        print(userInfo)
        TargetView?.DoctorInfo = userInfo
        TargetView?.LoadData(userInfo)
        TargetView?.FullPageLoading.Hide()
    }
    
    public func GetInfoError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        TargetView?.FullPageLoading.Hide()
        YMPageModalMessage.ShowErrorInfo("网络错误，请稍后再试", nav: NavController!)
    }
    
    public func AddFriendSuccess(_: NSDictionary?) {
        TargetView?.AddFriendBtn?.setTitleColor(YMColors.FontGray, forState: UIControlState.Disabled)
        TargetView?.AddFriendBtn?.backgroundColor = YMColors.CommonBottomGray
        TargetView?.AddFriendBtn?.enabled = false
        YMPageModalMessage.ShowNormalInfo("添加好友成功，等待对方验证。", nav: self.NavController!)
    }
    
    public func AddFriendError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)

        if(nil != error.userInfo["com.alamofire.serialization.response.error.response"]) {
            TargetView?.AddFriendBtn?.setTitleColor(YMColors.FontGray, forState: UIControlState.Disabled)
            TargetView?.AddFriendBtn?.backgroundColor = YMColors.CommonBottomGray
            TargetView?.AddFriendBtn?.enabled = false
            YMPageModalMessage.ShowNormalInfo("添加好友成功，等待对方验证。", nav: self.NavController!)
        } else {
            YMPageModalMessage.ShowErrorInfo("网络连接异常，请稍后再试。", nav: self.NavController!)
        }
    }
    
    public func GetInfo(id: String? = nil) {
        if(nil == id) {
            GetInfoApi?.YMQueryUserInfoById(PageYiMaiDoctorDetailBodyView.DocId)
        } else {
            GetInfoApi?.YMQueryUserInfoById(id!)
        }
    }
    
    public func AddFriend(sender: YMButton) {
        AddFriendApi?.YMAddFriendById(PageYiMaiDoctorDetailBodyView.DocId)
    }
    
    public func DoAppointment(sender: YMButton) {
        PageAppointmentViewController.DoctorIsPreSelected = true
        PageAppointmentViewController.NewAppointment = true
        PageAppointmentViewController.SelectedDoctor = TargetView?.DoctorInfo
        DoJump(YMCommonStrings.CS_PAGE_APPOINTMENT_NAME)
    }
    
    public func DoChat(sender: YMButton) {
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
        
        chat.automaticallyAdjustsScrollViewInsets = false
        chat.prefersStatusBarHidden()
        
        //显示聊天会话界面
        self.NavController?.pushViewController(chat, animated: true)
    }
    
    func Agree(sender: YMButton) {
        TargetView?.FullPageLoading.Show()
        AgreeApi.YMAgreeFriendById(PageYiMaiDoctorDetailBodyView.DocId)
    }
    
    func CommonFriendsTouched(gr: UIGestureRecognizer) {
        let img = gr.view as! YMTouchableImageView
        DoJump(YMCommonStrings.CS_PAGE_YIMAI_DOCTOR_DETAIL_NAME, ignoreExists: true, userData: img.UserStringData)
    }
}




























