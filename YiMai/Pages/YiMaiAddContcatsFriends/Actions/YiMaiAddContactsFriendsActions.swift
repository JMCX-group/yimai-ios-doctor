//
//  YiMaiAddContcatsFriendsActions.swift
//  YiMai
//
//  Created by why on 16/5/26.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

public class YiMaiAddContactsFriendsActions: PageJumpActions{
    private var GetContactsApi: YMAPIUtility? = nil
    private var TargetController: PageYiMaiAddContatsFriendsViewController? = nil
    
    private var AddFriendApi: YMAPIUtility? = nil
    private var InviteOtherApi: YMAPIUtility? = nil
    private var AddAllFriendsApi: YMAPIUtility? = nil
    private var InviteAllOtherApi: YMAPIUtility? = nil

    private func InviteOtherError(error: NSError){
        YMAPIUtility.PrintErrorInfo(error)

//        TargetController!.LoadingView?.Hide()
    }
    
    private func InviteOtherSuccessed(data: NSDictionary?) {
        if(nil != data) {
            print(JSON(data!))
        } else {
            print("no result!!!")
        }
        
        TargetController?.LoadingView?.Hide()
    }
    
    private func AddFriendError(error: NSError){
        YMAPIUtility.PrintErrorInfo(error)
        TargetController?.LoadingView?.Hide()
    }
    
    private func AddFriendSuccessed(data: NSDictionary?) {
        if(nil != data) {
            print(JSON(data!))
        } else {
            print("no result!!!")
        }
        TargetController?.LoadingView?.Hide()
    }
    
    private func AddAllFriendsError(error: NSError){
        YMAPIUtility.PrintErrorInfo(error)
        TargetController?.LoadingView?.Hide()
    }
    
    private func AddAllFriendsSuccessed(data: NSDictionary?) {
        if(nil != data) {
            print(JSON(data!))
        } else {
            print("no result!!!")
        }
        TargetController?.LoadingView?.Hide()
    }
    
    private func InviteAllOthersError(error: NSError){
        YMAPIUtility.PrintErrorInfo(error)
        TargetController?.LoadingView?.Hide()
    }
    
    private func InviteAllOthersSuccessed(data: NSDictionary?) {
        if(nil != data) {
            print(JSON(data!))
        } else {
            print("no result!!!")
        }
        TargetController?.LoadingView?.Hide()
    }
    
    override func ExtInit() {
        super.ExtInit()
        
        GetContactsApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_UPLOAD_ADDRESS_BOOK + "-addContactsFriends",
                                  success: self.GetContactsApiSuccessed,
                                  error: self.GetContactsApiError)
        
        
        AddFriendApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_ADD_FRIEND + "-addContactsFriends",
                                            success: self.AddFriendSuccessed, error: self.AddFriendError)
        
        InviteOtherApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_INVITE_OTHERS_REGISTER_YIMAI + "-addContactsFriends",
                                      success: self.InviteOtherSuccessed, error: self.InviteOtherError)
        
        AddAllFriendsApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_ADD_ALL_CONTACTS_FRIEND + "-addContactsFriends",
                                      success: self.AddAllFriendsSuccessed, error: self.AddAllFriendsError)
        
        InviteAllOtherApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_INVITE_OTHERS_REGISTER_YIMAI + "-addContactsFriends-inviteAllOthers",
                                      success: self.InviteAllOthersSuccessed, error: self.InviteAllOthersError)
        
        TargetController = self.Target as? PageYiMaiAddContatsFriendsViewController
    }
    
    private func GetContactsApiError(error: NSError){
        YMAPIUtility.PrintErrorInfo(error)
        TargetController!.LoadingView?.Hide()
    }
    
    private func GetContactsApiSuccessed(data: NSDictionary?) {
        if(nil != data) {
            print(JSON(data!))
        } else {
            print("no result!!!")
        }
        
        TargetController!.LoadingView?.Hide()
        
        let resultData = data!["data"] as! [String: AnyObject]
        TargetController!.BodyView!.FullList = resultData
        TargetController!.BodyView!.ShowResult(resultData)
    }

    var ReTryCount: Int = 0
    public func UploadAddressBook() {
//        GetContactsApi?.YMUploadAddressBook(YMAddressBookTools.AllContacts)
        TargetController!.LoadingView?.Show()
        if(0 == YMBackgroundRefresh.ContactNew.count) {
            if(ReTryCount < 3) {
                YMDelay(1.0, closure: {
                    self.UploadAddressBook()
                })
                ReTryCount += 1
            } else {
                ReTryCount = 0
                TargetController!.BodyView!.ShowResult(YMBackgroundRefresh.ContactNew)
                TargetController!.LoadingView?.Hide()
            }
            
        } else {
            TargetController!.BodyView!.ShowResult(YMBackgroundRefresh.ContactNew)
            TargetController!.LoadingView?.Hide()
        }
    }
    
    public func ShowFriendInfo(sender: UIGestureRecognizer) {
        
    }

    public func AddFriend(sender: UIGestureRecognizer) {
        let addBtn = sender.view as! YMTouchableImageView
        let id = addBtn.UserStringData
        AddFriendApi?.YMAddFriendById(id)
        
        let addLabel = addBtn.UserObjectData as! UILabel
        addBtn.hidden = true
        addLabel.hidden = false
        addBtn.UserObjectData = nil
//        TargetController?.LoadingView?.Show()
    }
    
    public func AddAllContactsFriends(sender: UIGestureRecognizer) {
        
        let allFriendsList = TargetController?.BodyView!.ContactsInYiMaiResult.joinWithSeparator(",")
        AddAllFriendsApi?.YMAddMultiFriends(allFriendsList!)
        TargetController?.LoadingView?.Show()
    }
    
    public func InviteOthersRegisterYiMai(sender: UIGestureRecognizer) {
        let addBtn = sender.view as! YMTouchableImageView
        let id = addBtn.UserStringData
        InviteOtherApi?.YMInviteOthers(id)
        
        let invitedLabel = addBtn.UserObjectData as! UILabel
        invitedLabel.hidden = false
        addBtn.hidden = true
        
//        TargetController?.LoadingView?.Show()

    }
    
    public func InviteAllOthersRegisterYiMai(sender: UIGestureRecognizer) {

        let allOthersList = TargetController?.BodyView!.ContactsInOtherResult.joinWithSeparator(",")
        InviteAllOtherApi?.YMInviteOthers(allOthersList!)
        
        TargetController?.LoadingView?.Show()

    }
    
    public func ShowOthersListTouched(sender: YMButton) {
        TargetController?.BodyView?.ShowOthersList()
    }
    
    public func ShowFriendsListTouched(sender: YMButton) {
        TargetController?.BodyView?.ShowFriendsList()
    }
}





























