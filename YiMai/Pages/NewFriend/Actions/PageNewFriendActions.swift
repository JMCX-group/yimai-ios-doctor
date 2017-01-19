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
    private var AddFriendApi: YMAPIUtility!
    
    var AgreeBtn: YMButton? = nil
    var AddBtn: YMButton? = nil
    
    override func ExtInit() {
        super.ExtInit()
        
        TargetView = self.Target as? PageNewFriendBodyView
        
        GetFriendListApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_NEW_FRIEND,
                                        success: GetNewFriendSuccess, error: GetNewFriendError)
        
        AgreeFriendApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_AGREE_FRIEND_APPLY,
                                      success: AgreeSuccess, error: AgreeError)
        
        AddFriendApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_ADD_FRIEND + "fromDoctorDetail",
                                    success: AddFriendSuccess, error: AddFriendError)
        
    }
    
    public func AddFriendSuccess(_: NSDictionary?) {
        AddBtn?.backgroundColor = YMColors.None
        AddBtn?.enabled = false
        AddBtn?.sizeToFit()
        TargetView?.FullPageLoading.Hide()
        //YMPageModalMessage.ShowNormalInfo("添加好友成功，等待对方验证。", nav: self.NavController!)
        
    }
    
    public func AddFriendError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        
        if(nil != error.userInfo["com.alamofire.serialization.response.error.response"]) {
//            YMPageModalMessage.ShowNormalInfo("添加好友成功，等待对方验证。", nav: self.NavController!)
        } else {
            YMPageModalMessage.ShowErrorInfo("网络连接异常，请稍后再试。", nav: self.NavController!)
        }
        
        YMPageModalMessage.ShowErrorInfo("网络连接异常，请稍后再试。", nav: self.NavController!)
        TargetView?.FullPageLoading.Hide()

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
        
        let docId = YMVar.GetStringByKey(dataInfo, key: "data") //"\(dataInfo["id"]!)"
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
            TargetView?.FullPageLoading.Hide()
            TargetView?.LoadData([[String: AnyObject]]())
            return
        }
        
        TargetView?.FullPageLoading.Hide()

        TargetView?.AllFriendsList = friends!
        TargetView?.LoadData(friends!)
    }
    
    public func GetNewFriendError(error: NSError) {
        TargetView?.FullPageLoading.Hide()
        TargetView?.LoadData([[String: AnyObject]]())
    }
    
    public func AgreeSuccess(_: NSDictionary?) {
        AgreeBtn?.backgroundColor = YMColors.None
        AgreeBtn?.enabled = false
        AgreeBtn?.sizeToFit()
        TargetView?.FullPageLoading.Hide()

    }
    
    public func AgreeError(error: NSError) {
        TargetView?.FullPageLoading.Hide()

        if(nil != error.userInfo["com.alamofire.serialization.response.error.response"]) {
            YMPageModalMessage.ShowErrorInfo("服务器繁忙，请稍后再试。", nav: self.NavController!)
        } else {
            YMPageModalMessage.ShowErrorInfo("网络连接异常，请稍后再试。", nav: self.NavController!)
        }
        
        YMAPIUtility.PrintErrorInfo(error)
//        AgreeBtn?.backgroundColor = YMColors.None
//        AgreeBtn?.enabled = false
        TargetView?.FullPageLoading.Hide()
    }
    
    
    public func GetList() {
        TargetView?.FullPageLoading.Show()
        YMBackgroundRefresh.ShowNewFriendFlag = false
        YMBackgroundRefresh.LastNewFriends.removeAll()
        YMBackgroundRefresh.ShowNewFriendCount = 0
        GetFriendListApi?.YMGetRelationNewFriends()
    }
    
    public func Agree(button: YMButton) {
        let data = button.UserObjectData as! [String: AnyObject]
        
        let userId = "\(data["id"]!)"
        print(userId)
        AgreeBtn = button
        TargetView?.FullPageLoading.Show()
        AgreeFriendApi?.YMAgreeFriendById(userId)
    }
    
    func SearchEnd(text: YMTextField) {
        let key = text.text
        
        if(YMValueValidator.IsEmptyString(key)) {
            TargetView?.DrawFriendsList(TargetView!.AllFriendsList)
            TargetView?.Searching = false
        } else {
            TargetView?.Searching = true
            var friendsFilted = [[String: AnyObject]]()
            for f in TargetView!.FriendsListToShow {
                let name = f["name"] as! String
                if(name.containsString(key!)) {
                    friendsFilted.append(f)
                }
            }
            
            TargetView?.DrawFriendsList(friendsFilted, key: key!, highlight: ActiveType.Custom(pattern: key!))
        }
    }
    
    
    func Apply(sender: YMButton) {
        let data = sender.UserObjectData as! [String: AnyObject]
        
        let userId = "\(data["id"]!)"
        TargetView?.FullPageLoading.Show()
        AddBtn = sender
        AddFriendApi?.YMAddFriendById(userId)
    }
    
    func GoToFriendCardInfoPanel(sender: UIGestureRecognizer) {
        let cell = sender.view as! YMTouchableView
        let docInfo = cell.UserObjectData as! [String: AnyObject]
        PageYiMaiDoctorDetailBodyView.IsFromNewFriendToAgree = true
        PageYiMaiDoctorDetailBodyView.DocId = "\(docInfo["id"]!)"
        DoJump(YMCommonStrings.CS_PAGE_YIMAI_DOCTOR_DETAIL_NAME)
    }
}











