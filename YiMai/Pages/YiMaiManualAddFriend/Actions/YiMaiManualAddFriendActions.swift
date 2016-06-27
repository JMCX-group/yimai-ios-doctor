//
//  YiMaiManualAddFriendActions.swift
//  YiMai
//
//  Created by why on 16/5/26.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

public class YiMaiManualAddFriendActions: PageJumpActions{
    private var QueryByPhoneApi: YMAPIUtility? = nil
    private var QueryByCodeApi: YMAPIUtility? = nil
    private var AddFriendApi: YMAPIUtility? = nil
    
    private var TargetController: PageYiMaiManualAddFriendViewController? = nil
    
    override func ExtInit() {
        super.ExtInit()
        
        TargetController = self.Target as? PageYiMaiManualAddFriendViewController
        
        QueryByPhoneApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_QUERY_USER_BY_PHONE + "fromManualAdd",
                                       success: QuerySuccess, error: QueryError)
        
        QueryByCodeApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_QUERY_USER_BY_CODE + "fromManualAdd",
                                       success: QuerySuccess, error: QueryError)
        
        AddFriendApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_ADD_FRIEND + "fromManualAdd",
                                    success: AddSuccess, error: AddError)
    }
    
    public func AddSuccess(_: NSDictionary? ){
        
    }
    
    public func AddError(_: NSError) {
        YMPageModalMessage.ShowErrorInfo("服务器繁忙，请稍后再试", nav: self.NavController!)
    }
    
    public func QuerySuccess(data: NSDictionary?) {
        let userInfo = data!["user"] as! [String: AnyObject]
        TargetController?.BodyView?.ShowAddPage(userInfo)
    }
    
    public func QueryError(error: NSError) {
        if(nil != error.userInfo["com.alamofire.serialization.response.error.response"]) {
//            let response = error.userInfo["com.alamofire.serialization.response.error.response"]!
            let errInfo = JSON(data: error.userInfo["com.alamofire.serialization.response.error.data"] as! NSData)
            
            print(errInfo)
        } else {
            YMPageModalMessage.ShowErrorInfo("网络连接异常，请稍后再试。", nav: self.NavController!)
        }
        TargetController?.BodyView?.ClearBody()
    }
    
    public func SearchFriend(sender: UIGestureRecognizer) {
        let viewController = Target as! PageYiMaiManualAddFriendViewController
        
        let code = viewController.BodyView?.GetInputCode()
        
        if(!YMValueValidator.IsCellPhoneNum(code!)) {
            viewController.BodyView?.ShowAlertPage()
        } else {
            QueryByPhoneApi?.YMQueryUserByPhone(code!)
        }
//        if("" == code || code?.characters.count < 6) {
//            viewController.BodyView?.ShowAlertPage()
//        } else if("18012345678" == code) {
//            viewController.BodyView?.ShowInvitePage()
//        } else {
//            viewController.BodyView?.ShowAddPage([
//                YMYiMaiManualAddFriendStrings.CS_DATA_KEY_USERHEAD:"test",
//                YMYiMaiManualAddFriendStrings.CS_DATA_KEY_NAME:"池帅",
//                YMYiMaiManualAddFriendStrings.CS_DATA_KEY_HOSPATIL:"鸡西矿业总医院医疗集团二道河子中心医院",
//                YMYiMaiManualAddFriendStrings.CS_DATA_KEY_DEPARTMENT:"心血管外科",
//                YMYiMaiManualAddFriendStrings.CS_DATA_KEY_JOB_TITLE:"主任医师",
//                YMYiMaiManualAddFriendStrings.CS_DATA_KEY_USER_ID:"1"
//                ])
//        }
    }
    
    public func AddFriend(sender: UIGestureRecognizer) {
        let viewController = self.Target as! PageYiMaiManualAddFriendViewController
        viewController.BodyView?.ClearBody()
        viewController.BodyView?.ClearInput()
        
        let btn = sender.view as! YMTouchableView
        
        let data = btn.UserObjectData as! [String: AnyObject]
        let userId = "\(data["id"])"
        
        AddFriendApi?.YMAddFriendById(userId)

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