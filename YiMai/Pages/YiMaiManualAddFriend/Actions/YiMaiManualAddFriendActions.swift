//
//  YiMaiManualAddFriendActions.swift
//  YiMai
//
//  Created by why on 16/5/26.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class YiMaiManualAddFriendActions: PageJumpActions{
    public func SearchFriend(sender: UIGestureRecognizer) {
        let viewController = Target as! PageYiMaiManualAddFriendViewController
        
        let code = viewController.BodyView?.GetInputCode()
        if("" == code || code?.characters.count < 6) {
            viewController.BodyView?.ShowAlertPage()
        } else if("18012345678" == code) {
            viewController.BodyView?.ShowInvitePage()
        } else {
            viewController.BodyView?.ShowAddPage([
                YMYiMaiManualAddFriendStrings.CS_DATA_KEY_USERHEAD:"test",
                YMYiMaiManualAddFriendStrings.CS_DATA_KEY_NAME:"池帅",
                YMYiMaiManualAddFriendStrings.CS_DATA_KEY_HOSPATIL:"鸡西矿业总医院医疗集团二道河子中心医院",
                YMYiMaiManualAddFriendStrings.CS_DATA_KEY_DEPARTMENT:"心血管外科",
                YMYiMaiManualAddFriendStrings.CS_DATA_KEY_JOB_TITLE:"主任医师",
                YMYiMaiManualAddFriendStrings.CS_DATA_KEY_USER_ID:"1"
                ])
        }
    }
    
    public func AddFriend(sender: UIGestureRecognizer) {
        let viewController = self.Target as! PageYiMaiManualAddFriendViewController
        viewController.BodyView?.ClearBody()
        viewController.BodyView?.ClearInput()

        let alertController = UIAlertController(title: "添加成功", message: "等待对方验证", preferredStyle: .Alert)
        let goBack = UIAlertAction(title: "返回", style: .Default,
            handler: {
                action in
                self.NavController?.popViewControllerAnimated(true)
        })
        
        let goOn = UIAlertAction(title: "继续添加", style: .Default,
            handler: {
                action in
        })
        
        goBack.setValue(YMColors.FontGray, forKey: "titleTextColor")
        goOn.setValue(YMColors.FontBlue, forKey: "titleTextColor")
        
        alertController.addAction(goBack)
        alertController.addAction(goOn)
        self.NavController!.presentViewController(alertController, animated: true, completion: nil)
    }
    
    public func InvitFriend(sender: UIGestureRecognizer) {
        let viewController = self.Target as! PageYiMaiManualAddFriendViewController
        viewController.BodyView?.ClearBody()
        viewController.BodyView?.ClearInput()
        
        let alertController = UIAlertController(title: "已经邀请", message: "等待对方同意", preferredStyle: .Alert)
        let goBack = UIAlertAction(title: "返回", style: .Default,
            handler: {
                action in
                self.NavController?.popViewControllerAnimated(true)
        })
        
        let goOn = UIAlertAction(title: "继续添加", style: .Default,
            handler: {
                action in
        })
        
        goBack.setValue(YMColors.FontGray, forKey: "titleTextColor")
        goOn.setValue(YMColors.FontBlue, forKey: "titleTextColor")
        
        alertController.addAction(goBack)
        alertController.addAction(goOn)
        self.NavController!.presentViewController(alertController, animated: true, completion: nil)
    }
    
    public func QRScan(sender: UIGestureRecognizer) {
        
    }
    
    public func FriendCellTouched(sender: UIGestureRecognizer) {
        
    }
}