//
//  PageMyInfoCardBodyView.swift
//  YiMai
//
//  Created by superxing on 16/9/21.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageMyInfoCardBodyView: PageBodyView {
    
    var AddActions: PageMyInfoCardActions!
    var UserHead = YMLayout.GetSuitableImageView("PersonalDefaultUserhead")
    var UserQR = YMLayout.GetSuitableImageView("Face2FaceTempQR")
    var ShareBtn = YMButton()

    var Loading: YMPageLoadingView!
    
    public static var DoctorID = ""
    
    override func ViewLayout() {
        super.ViewLayout()
        
        AddActions = PageMyInfoCardActions(navController: self.NavController, target: self)
        DrawUserHead()
        DrawRequirePaperCardButton()
        Loading = YMPageLoadingView(parentView: ParentView!)
        Loading.Show()
    }
    
    func DrawShareButton(topView: UIView) {
        if(!UMSocialManager.defaultManager().isInstall(UMSocialPlatformType.WechatSession)
            && !UMSocialManager.defaultManager().isInstall(UMSocialPlatformType.Sina)) {
            return
        }
    
        ShareBtn.setTitle("分享", forState: UIControlState.Normal)
        ShareBtn.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        ShareBtn.titleLabel?.font = YMFonts.YMDefaultFont(26.LayoutVal())
        ShareBtn.sizeToFit()
        
        topView.addSubview(ShareBtn)
        ShareBtn.anchorInCorner(Corner.BottomRight, xPad: 40.LayoutVal(), yPad: 20.LayoutVal(), width: ShareBtn.width, height: ShareBtn.height)
        
        ShareBtn.addTarget(AddActions, action: "ShareTouched:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func DrawRequirePaperCardButton() {
        let button = YMButton()
        
        ParentView?.addSubview(button)
        button.setTitle("纸质名片申请", forState: UIControlState.Normal)
        button.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        button.backgroundColor = YMColors.FontBlue
        button.titleLabel?.font = YMFonts.YMDefaultFont(34.LayoutVal())
        
        button.addTarget(AddActions!, action: "GoToRequirePaperCard:".Sel(),
                         forControlEvents: UIControlEvents.TouchUpInside)
        
        button.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: 98.LayoutVal())
    }
    
    func DrawUserHead() {
        BodyView.addSubview(UserHead)
        UserHead.anchorToEdge(Edge.Top, padding: 50.LayoutVal(), width: UserHead.width, height: UserHead.height)
    }
    
    func LoadUserInfo(userInfo: [String: AnyObject]) {
        let name = userInfo["name"] as? String
        let code = "\(userInfo["code"]!)"
        let head = userInfo["head_url"] as? String
        let jobTitle = userInfo["job_title"] as? String
        let hospital = userInfo["hospital"] as? [String: AnyObject]
        let dept = userInfo["department"] as? [String: AnyObject]
        let id = userInfo["id"] as! String
        
        var hosName: String? = nil
        var deptName: String? = nil
        if(nil != hospital) {
            hosName = hospital!["name"] as? String
        }
        
        if(nil != hospital) {
            deptName = dept!["name"] as? String
        }
        
        let nameLabel = YMLayout.GetNomalLabel(name, textColor: YMColors.FontBlue, fontSize: 40.LayoutVal())
        let jobTitleLabel = YMLayout.GetNomalLabel(jobTitle, textColor: YMColors.FontGray, fontSize: 28.LayoutVal())
        let hosLabel = YMLayout.GetNomalLabel(hosName, textColor: YMColors.FontGray, fontSize: 26.LayoutVal())
        let deptLabel = YMLayout.GetNomalLabel(deptName, textColor: YMColors.FontGray, fontSize: 28.LayoutVal())
        let codeLabel = YMLayout.GetNomalLabel("医脉码 \(code)", textColor: YMColors.FontBlue, fontSize: 32.LayoutVal())
        let divider = UIView()
        divider.backgroundColor = YMColors.FontBlue
        let codeBkg = UIView()
        codeBkg.backgroundColor = YMColors.FontBlue
        
        let codePanel = UIView()
        
        let tipLabel = YMLayout.GetNomalLabel("", textColor: YMColors.FontGray,
                                              fontSize: 28.LayoutVal())
        
        let tipHighLight = ActiveType.Custom(pattern: "医者脉连")
        tipLabel.enabledTypes = [tipHighLight]
        tipLabel.customColor[tipHighLight] = YMColors.FontBlue
        tipLabel.text = "使用医者脉连医生端或患者端扫码添加"
        tipLabel.sizeToFit()
        
        YMLayout.SetSelfHeadImageVFlag(UserHead)
        if(nil != head) {
            YMLayout.LoadImageFromServer(UserHead, url: head!, fullUrl: nil, makeItRound: true)
        }
        
        BodyView.addSubview(nameLabel)
        BodyView.addSubview(jobTitleLabel)
        BodyView.addSubview(hosLabel)
        BodyView.addSubview(deptLabel)
        BodyView.addSubview(divider)

        BodyView.addSubview(codePanel)
        BodyView.addSubview(tipLabel)
        
        codePanel.addSubview(codeBkg)
        codePanel.addSubview(codeLabel)
        
        codeLabel.textAlignment = NSTextAlignment.Center
        codeLabel.backgroundColor = BodyView.backgroundColor
        
        nameLabel.align(Align.UnderCentered, relativeTo: UserHead, padding: 30.LayoutVal(), width: nameLabel.width, height: nameLabel.height)
        divider.align(Align.UnderCentered, relativeTo: nameLabel, padding: 16.LayoutVal(), width: YMSizes.OnPx, height: 26.LayoutVal())
        jobTitleLabel.align(Align.ToTheRightCentered, relativeTo: divider, padding: 14.LayoutVal(), width: jobTitleLabel.width, height: jobTitleLabel.height)
        deptLabel.align(Align.ToTheLeftCentered, relativeTo: divider, padding: 14.LayoutVal(), width: deptLabel.width, height: deptLabel.height)
        hosLabel.align(Align.UnderCentered, relativeTo: divider, padding: 16.LayoutVal(), width: hosLabel.width, height: hosLabel.height)
        codePanel.align(Align.UnderCentered, relativeTo: hosLabel, padding: 40.LayoutVal(), width: YMSizes.PageWidth, height: codeLabel.height)
        
        codeLabel.anchorInCenter(width: codeLabel.width + 48.LayoutVal(), height: codeLabel.height)
        codeBkg.anchorInCenter(width: 566.LayoutVal(), height: YMSizes.OnPx)
        
        let jsonString = YMQRRecognizer.GenQRJsonString(id)
        
        if(nil != jsonString) {
            let img = YMQRCode.generateImage(jsonString!, avatarImage: nil)
            UserQR.image = img
            BodyView.addSubview(UserQR)
            UserQR.align(Align.UnderCentered, relativeTo: codePanel, padding: 30.LayoutVal(), width: UserQR.width, height: UserQR.height)
        }
        
        tipLabel.align(Align.UnderCentered, relativeTo: UserQR, padding: 30.LayoutVal(),
                       width: tipLabel.width, height: tipLabel.height)
        
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: tipLabel, padding: 128.LayoutVal())
        Loading.Hide()
    }
    
    func Clear() {
        YMLayout.ClearView(view: BodyView)
        UserHead = YMLayout.GetSuitableImageView("PersonalDefaultUserhead")
        UserQR = YMLayout.GetSuitableImageView("Face2FaceTempQR")
        DrawUserHead()
        PageMyInfoCardBodyView.DoctorID = ""
        
        Loading.Hide()
    }
}




























