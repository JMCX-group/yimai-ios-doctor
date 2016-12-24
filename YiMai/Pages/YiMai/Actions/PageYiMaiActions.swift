//
//  PageYiMaiActions.swift
//  YiMai
//
//  Created by why on 16/5/20.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PageYiMaiActions: PageJumpActions{
    var TargetController: PageYiMaiViewController!
    var ContactApi: YMAPIUtility!
    var DeleteFriend: YMAPIUtility!
    
    var L1RelationApi: YMAPIUtility!
    var L2RelationApi: YMAPIUtility!
    
    override func ExtInit() {
        super.ExtInit()
        TargetController = Target as! PageYiMaiViewController
        ContactApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_RECENTLY_CONTACT,
                                  success: GetRecentContactSuccess,
                                  error: GetRecentContactFailed)
        
        DeleteFriend = YMAPIUtility(key: YMAPIStrings.CS_API_DELETE_FRIEND, success: DeleteFriendSuccess, error: DeleteFriendError)
        
        L1RelationApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_LEVEL1_RELATION + "-yimai-r1",
                                     success: Level1RelationSuccess, error: L1Err)
        
        L2RelationApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_LEVEL2_RELATION + "-yimai-r1",
                                     success: Level2RelationSuccess, error: L2Err)
    }
    
    func YiMaiReload() {
        TargetController.YiMaiR1Body?.Reload()
        TargetController.YiMaiR2Body?.Reload()
        TargetController.YiMaiR1Body?.FullPageLoading.Hide()
    }
    
    func Level1RelationSuccess(data: NSDictionary?) {
        let realData = data!
        let count = realData["count"] as! [String:AnyObject]
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_L1_FRIENDS_COUNT_INFO, data: count)
        
        let friends = realData["friends"] as! [AnyObject]
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_L1_FRIENDS, data: friends)
        
        L2RelationApi.YMGetLevel2Relation()
    }
    
    func Level2RelationSuccess(data: NSDictionary?) {
        let realData = data!
        let count = realData["count"] as! [String:AnyObject]
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_L2_FRIENDS_COUNT_INFO, data: count)
        
        let friends = realData["friends"] as! [AnyObject]
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_L2_FRIENDS, data: friends)
        
        YiMaiReload()
    }
    
    func L1Err(error: NSError){
        YMAPIUtility.PrintErrorInfo(error)
        YMPageModalMessage.ShowErrorInfo("自动更新医脉信息失败，请手动刷新", nav: NavController!)
        YiMaiReload()
    }
    
    func L2Err(error: NSError){
        YMAPIUtility.PrintErrorInfo(error)
        YMPageModalMessage.ShowErrorInfo("自动更新医脉信息失败，请手动刷新", nav: NavController!)
        YiMaiReload()
    }
    
    func DeleteFriendSuccess(data: NSDictionary?) {
        L1RelationApi.YMGetLevel1Relation()
    }
    
    func DeleteFriendError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        TargetController.YiMaiR1Body?.FullPageLoading.Hide()
        YMPageModalMessage.ShowErrorInfo("网络繁忙，请稍后再试", nav: NavController!)
    }
    
    func GetRecentContactSuccess(data: NSDictionary?) {
        let realData = data!["data"] as! [[String: AnyObject]]
        TargetController.RecentContactList.LoadData(realData)
    }
    
    func GetRecentContactFailed(error: NSError) {
        let realData = [[String: AnyObject]]()
        TargetController.RecentContactList.LoadData(realData)
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
    
    public func QRButtonTouched(sender : UITapGestureRecognizer) {
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

    public func FriendCellTouched(sender : UITapGestureRecognizer) {
        let cell = sender.view as? YMScrollCell
        let touchableCell = sender.view as? YMTouchableView
        if(nil != cell) {
            let cellOffset = cell?.contentOffset.x
            if(0 < cellOffset) {
                return
            }
            PageYiMaiDoctorDetailBodyView.DocId = cell!.UserStringData
        }
        
        if(nil != touchableCell) {
            PageYiMaiDoctorDetailBodyView.DocId = touchableCell!.UserStringData
        }
        DoJump(YMCommonStrings.CS_PAGE_YIMAI_DOCTOR_DETAIL_NAME)
    }
    
    public func YiMaiR1TabTouched(sender: YMButton) {
        TargetController.ShowYiMaiR1Page()
    }
    
    public func YiMaiR2TabTouched(sender: YMButton) {
        TargetController.ShowYiMaiR2Page()
    }
    
    public func YiMaiRecentContact(sender: YMButton) {
        TargetController.ShowRecentContactPage()
    }
    
    public func DoSearch(editor: YMTextField) {
        let searchKey = editor.text
        if(YMValueValidator.IsEmptyString(searchKey)) {
            return
        } else {
            PageGlobalSearchViewController.InitSearchKey = editor.text!
            DoJump(YMCommonStrings.CS_PAGE_GLOBAL_SEARCH_NAME)
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
        
        chat.automaticallyAdjustsScrollViewInsets = false
        chat.prefersStatusBarHidden()
        
        //显示聊天会话界面
        self.NavController?.pushViewController(chat, animated: true)
    }
}
























