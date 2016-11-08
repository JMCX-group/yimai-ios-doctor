//
//  PageNewFriendActions.swift
//  YiMai
//
//  Created by ios-dev on 16/6/27.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import SwiftyJSON
import Proposer
import UIKit

public class PageNewFriendActions: PageJumpActions {
    private var TargetView: PageNewFriendBodyView? = nil
    private var GetFriendListApi: YMAPIUtility? = nil
    private var AgreeFriendApi: YMAPIUtility? = nil
    
    override func ExtInit() {
        super.ExtInit()
        
        TargetView = self.Target as? PageNewFriendBodyView
        
        GetFriendListApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_NEW_FRIEND,
                                        success: GetNewFriendSuccess, error: GetNewFriendError)
        
        AgreeFriendApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_AGREE_FRIEND_APPLY,
                                      success: AgreeSuccess, error: AgreeError)
        
    }
    
    func JumpToContactPage(sender: YMButton) {
        let contacts: PrivateResource = PrivateResource.Contacts
        
        if(contacts.isNotDeterminedAuthorization) {
            proposeToAccess(contacts, agreed: {
                self.DoJump(YMCommonStrings.CS_PAGE_YIMAI_ADD_CONTCATS_FRIENDS_NAME)
                }, rejected: {
                    let alertController = UIAlertController(title: "系统提示", message: "请去隐私设置里打开通讯录访问权限！", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "好的", style: .Default,
                        handler: {
                            action in
                    })
                    alertController.addAction(okAction)
                    self.NavController!.presentViewController(alertController, animated: true, completion: nil)
            })
        } else {
            if(!contacts.isAuthorized) {
                let alertController = UIAlertController(title: "系统提示", message: "请去隐私设置里打开通讯录访问权限！", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "好的", style: .Default,
                                             handler: {
                                                action in
                })
                alertController.addAction(okAction)
                self.NavController!.presentViewController(alertController, animated: true, completion: nil)
            } else {
                self.DoJump(YMCommonStrings.CS_PAGE_YIMAI_ADD_CONTCATS_FRIENDS_NAME)
            }
        }
    }
    
    public func QRScanSuccess(qrStr: String?) {
        if(nil == qrStr) {
            return
        }
        
        YMQRRecognizer.RecognizFromQRJson(qrStr!, qrRecognizedFunc: QRRecongized, qrUnrecognizedFunc: QRUnrecongized)
    }
    
    public func QRRecongized(data: AnyObject) {
        let dataInfo = data as! [String: AnyObject]
        
        let docId = "\(dataInfo["id"]!)"
        PageAddFriendInfoCardBodyView.DoctorID = docId
        DoJump(YMCommonStrings.CS_PAGE_ADD_FRIEND_QR_CARD)
    }
    
    public func QRUnrecongized(data: AnyObject) {
        YMPageModalMessage.ShowErrorInfo("二维码非医脉信息！", nav: self.NavController!)
    }
    
    func JumpToQRPage(sender: YMButton) {
        var style = LBXScanViewStyle()
        
        style.centerUpOffset = 44
        
        //扫码框周围4个角的类型设置为在框的上面
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.On
        //扫码框周围4个角绘制线宽度
        style.photoframeLineW = 6
        
        //扫码框周围4个角的宽度
        style.photoframeAngleW = 24
        
        //扫码框周围4个角的高度
        style.photoframeAngleH = 24
        
        //显示矩形框
        style.isNeedShowRetangle = true;
        
        //动画类型：网格形式，模仿支付宝
        style.anmiationStyle = LBXScanViewAnimationStyle.LineMove
        
        //网格图片
        //        style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_part_net"]
        
        //码框周围4个角的颜色
        style.colorAngle = YMColors.FontBlue // [UIColor colorWithRed:65./255. green:174./255. blue:57./255. alpha:1.0]
        
        //矩形框颜色
        style.colorRetangleLine = YMColors.FontGray // [UIColor colorWithRed:247/255. green:202./255. blue:15./255. alpha:1.0];
        
        //非矩形框区域颜色
        style.red_notRecoginitonArea = 247.0/255
        style.green_notRecoginitonArea = 202.0/255
        style.blue_notRecoginitonArea = 15.0/255
        style.alpa_notRecoginitonArea = 0.2
        
        let vc = LBXScanViewController()
        //        SubLBXScanViewController *vc = [SubLBXScanViewController new];
        vc.scanStyle = style
        
        //开启只识别矩形框内图像功能
        vc.isOpenInterestRect = true
        
        vc.scanSuccessHandler = QRScanSuccess
        
        self.NavController?.pushViewController(vc, animated: true)
    }
    
    public func GetNewFriendSuccess(data: NSDictionary?) {
        let friends = data?["friends"] as? [[String: AnyObject]]
        if(nil == friends) {
            return
        }
        
        TargetView?.AllFriendsList = friends!
        TargetView?.LoadData(friends!)
    }
    
    public func GetNewFriendError(error: NSError) {
        
    }
    
    public func AgreeSuccess(_: NSDictionary?) {
    }
    
    public func AgreeError(error: NSError) {
        if(nil != error.userInfo["com.alamofire.serialization.response.error.response"]) {
//            YMPageModalMessage.ShowErrorInfo("服务器繁忙，请稍后再试。", nav: self.NavController!)
        } else {
//            YMPageModalMessage.ShowErrorInfo("网络连接异常，请稍后再试。", nav: self.NavController!)
        }
    }
    
    
    public func GetList() {
        GetFriendListApi?.YMGetRelationNewFriends()
    }
    
    public func Agree(button: YMButton) {
        let data = button.UserObjectData as! [String: AnyObject]
        
        let userId = "\(data["id"]!)"
        button.backgroundColor = YMColors.None
        button.enabled = false
        AgreeFriendApi?.YMAgreeFriendById(userId)
    }
    
    func SearchEnd(text: YMTextField) {
        let key = text.text
        
        if(YMValueValidator.IsEmptyString(key)) {
            TargetView?.DrawFriendsList(TargetView!.AllFriendsList)
        } else {
            var friendsFilted = [[String: AnyObject]]()
            for f in TargetView!.FriendsListToShow {
                let name = f["name"] as! String
                if(name.containsString(key!)) {
                    friendsFilted.append(f)
                }
            }
            
            TargetView?.DrawFriendsList(friendsFilted)
        }
//        DrawFriendsList()
    }
}











