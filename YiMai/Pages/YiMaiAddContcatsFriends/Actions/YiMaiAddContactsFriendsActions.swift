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
    private let ActionKey = YMAPIStrings.CS_API_ACTION_UPLOAD_ADDRESS_BOOK + "-indexCommonSearch"
    
    override func ExtInit() {
        super.ExtInit()
        
        GetContactsApi = YMAPIUtility(key: self.ActionKey,
                                  success: self.GetContactsApiSuccessed,
                                  error: self.GetContactsApiError)
    }
    
    private func GetContactsApiError(error: NSError){
        let errInfo = JSON(data: error.userInfo["com.alamofire.serialization.response.error.data"] as! NSData)
        print(errInfo)
        
        print(error)
    }
    
    private func GetContactsApiSuccessed(data: NSDictionary?) {
        if(nil != data) {
            print(JSON(data!))
        } else {
            print("no result!!!")
        }
    }

    public func UploadAddressBook() {
        GetContactsApi?.YMUploadAddressBook(YMAddressBookTools.AllContacts)
    }

    public func PostAddFriends(sender: UIGestureRecognizer) {
        
    }
    
    public func ShowFriendInfo(sender: UIGestureRecognizer) {
        
    }
    
    public func AddAllContactsFriends(sender: UIGestureRecognizer) {
        
    }
}