//
//  YiMaiAddFriendsActions.swift
//  YiMai
//
//  Created by why on 16/5/25.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit
import Proposer

public class YiMaiAddFriendsActions: PageJumpActions{
    public func NextStep(sender : UITapGestureRecognizer) {
        let contacts: PrivateResource = PrivateResource.Contacts
        
        proposeToAccess(contacts, agreed: {
               self.DoJump(YMCommonStrings.CS_PAGE_YIMAI_ADD_CONTCATS_FRIENDS_NAME)
            }, rejected: {
                let alertController = UIAlertController(title: "系统提示", message: "请去隐私设置里打开通讯录访问权限！", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "好的", style: .Default,
                        handler: {
                            action in
                            print("确定")
                        })
                alertController.addAction(okAction)
                self.NavController!.presentViewController(alertController, animated: true, completion: nil)
        })
    }
    
    public func test(sender: YMButton) {
        print("!!")
    }
}