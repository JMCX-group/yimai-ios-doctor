//
//  PagePersonalTopView.swift
//  YiMai
//
//  Created by why on 16/4/22.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon
import Kingfisher

public class PagePersonalTopView {
    private var ParentView: UIView? = nil
    private var NavController: UINavigationController? = nil
    private var Actions: PagePersonalActions? = nil
    
    private var TopViewPanel = UIView()
    
    private var TopQRButton: UIImageView? = nil
    private let Username: UILabel = UILabel()
    private let Desc: UILabel = UILabel()
    private var UserHead: YMTouchableImageView? = nil
    private let YiMaiCodeTitle: UILabel = UILabel()
    private let YiMaiCode: UILabel = UILabel()
    
    convenience init(parentView: UIView, navController: UINavigationController, pageActions: PagePersonalActions){
        self.init()
        self.ParentView = parentView
        self.NavController = navController
        self.Actions = pageActions
        
        UserHead = YMLayout.GetTouchableImageView(useObject: Actions!, useMethod: "GoToPersonalDetail:".Sel(), imageName: "PersonalDefaultUserhead")
        let userHeadUrl = YMVar.MyUserInfo["head_url"] as! String
        YMLayout.LoadImageFromServer(UserHead!, url: userHeadUrl, fullUrl: nil, makeItRound: true, refresh: true)
        ViewLayout()
    }
    
    public func Refresh(userInfo: [String: AnyObject]) {
        YiMaiCode.text = userInfo[YMCoreDataKeyStrings.INIT_DATA_USER_CODE] as? String
        Username.text = userInfo[YMCoreDataKeyStrings.INIT_DATA_USER_NAME] as? String
        
        let dept = userInfo[YMCoreDataKeyStrings.INIT_DATA_USER_DEPARTMENT] as? [String: String]
        let jobTitle = userInfo[YMCoreDataKeyStrings.INIT_DATA_USER_JOB_TITLE] as? String
        
        if(nil != dept && nil != jobTitle) {
            Desc.text = "\(dept!["name"]!) | \(jobTitle!)"
        } else if(nil == dept && nil != jobTitle) {
            Desc.text = "\(jobTitle!)"
        } else if(nil != dept && nil == jobTitle) {
            Desc.text = "\(dept!["name"]!)"
        }
    }
    
    private func ViewLayout() {
        ParentView?.addSubview(TopViewPanel)
        TopViewPanel.backgroundColor = YMColors.White
        TopViewPanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: YMSizes.PagePersonalTopHeight)
        
        DrawUserhead()
        DrawQRButton()
        DrawYiMaiCode()
    }
    
    private func DrawYiMaiCode() {
        TopViewPanel.addSubview(YiMaiCodeTitle)
        TopViewPanel.addSubview(YiMaiCode)
        
        YiMaiCodeTitle.text = "医脉码"
        YiMaiCodeTitle.textColor = YMColors.FontBlue
        YiMaiCodeTitle.textAlignment = NSTextAlignment.Center
        YiMaiCodeTitle.font = UIFont.systemFontOfSize(26.LayoutVal())
        
        YiMaiCodeTitle.anchorToEdge(Edge.Bottom, padding: 70.LayoutVal(), width: YMSizes.PageWidth, height: 26.LayoutVal())
        
        YiMaiCode.text = ""
        YiMaiCode.textColor = YMColors.FontBlue
        YiMaiCode.textAlignment = NSTextAlignment.Center
        YiMaiCode.font = UIFont.systemFontOfSize(40.LayoutVal())
        
        YiMaiCode.anchorToEdge(Edge.Bottom, padding: 27.LayoutVal(), width: YMSizes.PageWidth, height: 40.LayoutVal())
    }
    
    private func DrawQRButton() {
        TopQRButton = YMLayout.GetTouchableImageView(useObject: Actions!, useMethod: "QRButtonTouched:".Sel(), imageName: "PersonalQRButton")
        TopViewPanel.addSubview(TopQRButton!)
        
        TopQRButton?.anchorInCorner(Corner.TopRight, xPad: 30.LayoutVal(), yPad: 64.LayoutVal(), width: (TopQRButton?.width)!, height: (TopQRButton?.height)!)
    }
    
    private func DrawUserhead() {
        let topUserheadBackground = YMLayout.GetSuitableImageView("PersonalTopBackground")
        
        TopViewPanel.addSubview(topUserheadBackground)
        topUserheadBackground.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: topUserheadBackground.height)
        
        TopViewPanel.addSubview(UserHead!)
        UserHead!.anchorToEdge(Edge.Top, padding: 165.LayoutVal(), width: UserHead!.width, height: UserHead!.height)
        
        TopViewPanel.addSubview(Username)
        
        Username.text = ""
        Username.textColor = YMColors.White
        Username.textAlignment = NSTextAlignment.Center
        Username.font = UIFont.systemFontOfSize(40.LayoutVal())
        Username.anchorToEdge(Edge.Top, padding: 65.LayoutVal(), width: YMSizes.PageWidth, height: 40.LayoutVal())
        
        TopViewPanel.addSubview(Desc)
        
        Desc.text = ""
        Desc.textColor = YMColors.FontLightBlue
        Desc.textAlignment = NSTextAlignment.Center
        Desc.font = UIFont.systemFontOfSize(20.LayoutVal())
        Desc.anchorToEdge(Edge.Top, padding: 122.LayoutVal(), width: YMSizes.PageWidth, height: 20.LayoutVal())
    }
}