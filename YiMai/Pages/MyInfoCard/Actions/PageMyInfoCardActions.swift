//
//  PageMyInfoCardActions.swift
//  YiMai
//
//  Created by superxing on 16/9/21.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
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
}