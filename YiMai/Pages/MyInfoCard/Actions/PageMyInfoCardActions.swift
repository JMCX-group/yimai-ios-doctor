//
//  PageMyInfoCardActions.swift
//  YiMai
//
//  Created by superxing on 16/9/21.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UShareUI
import UMSocialNetwork
import UIKit

public class PageMyInfoCardActions: PageJumpActions {
    var TargetView: PageMyInfoCardBodyView!
    
    override func ExtInit() {
        super.ExtInit()
        TargetView = Target as! PageMyInfoCardBodyView
    }
    
    func GetDocInfoSuccess(data: NSDictionary?) {
        if(nil == data) {
            YMPageModalMessage.ShowNormalInfo("网络通讯故障，请稍后再试。", nav: self.NavController!, callback: GoBack)
            return
        }
        let data = data!["user"] as! [String: AnyObject]
        
        TargetView.LoadUserInfo(data)
    }
    
    func GoBack(_: UIAlertAction) {
        if(nil == PageMyInfoCardViewController.BacktoController) {
            self.NavController?.popViewControllerAnimated(true)
        } else {
            self.NavController?.popToViewController(PageMyInfoCardViewController.BacktoController!, animated: true)
        }
    }
    
    func GetDocInfoFailed(error: NSError) {
        YMPageModalMessage.ShowNormalInfo("网络通讯故障，请稍后再试。", nav: self.NavController!, callback: GoBack)
    }
    
    func AddSuccess(data: NSDictionary?) {
        if(nil == PageMyInfoCardViewController.BacktoController) {
            self.NavController?.popViewControllerAnimated(true)
        } else {
            self.NavController?.popToViewController(PageMyInfoCardViewController.BacktoController!, animated: true)
        }
    }
    
    func AddFailed(error: NSError) {
        YMPageModalMessage.ShowNormalInfo("网络通讯故障，请稍后再试。", nav: self.NavController!)
    }
    
    func GoToRequirePaperCard(_: YMButton) {
        DoJump(YMCommonStrings.CS_PAGE_REAUIRE_PAPER_CARD)
    }
    
    func ShareTouched(_: YMButton) {
        var plateforms = [AnyObject]()
        
        if(UMSocialManager.defaultManager().isInstall(UMSocialPlatformType.WechatSession)) {
            plateforms.append(UMSocialPlatformType.WechatSession.rawValue)
            plateforms.append(UMSocialPlatformType.WechatTimeLine.rawValue)
        }
        if(UMSocialManager.defaultManager().isInstall(UMSocialPlatformType.Sina)) {
            plateforms.append(UMSocialPlatformType.Sina.rawValue)
        }
        UMSocialUIManager.setPreDefinePlatforms(plateforms)

        UMSocialUIManager.showShareMenuViewInWindowWithPlatformSelectionBlock { (type, data) in
            let msg = UMSocialMessageObject()
            let shareObj = UMShareWebpageObject()
            shareObj.title = "医者脉连"
            shareObj.descr = "请关注我的个人医脉平台，医生找医生、患者看专家更方便。医者仁心脉脉相连。"
            shareObj.thumbImage = self.TargetView.UserHead.image //YMVar.GetStringByKey(YMVar.MyUserInfo, key: "head_url")
            shareObj.webpageUrl = "http://d.medi-link.cn/YMShareiOS/?username=" +
                YMVar.GetStringByKey(YMVar.MyUserInfo, key: "name") +
                "&usercode=" + YMVar.GetStringByKey(YMVar.MyUserInfo, key: "code") +
                "&userid=" + YMVar.MyDoctorId
            msg.shareObject = shareObj
            UMSocialManager.defaultManager().shareToPlatform(type, messageObject: msg, currentViewController: self.NavController!, completion: { (data, error) in
                print(error)
            })
        }
    }
}






