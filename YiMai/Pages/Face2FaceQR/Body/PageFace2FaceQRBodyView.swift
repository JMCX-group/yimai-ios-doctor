//
//  PageFace2FaceQRBodyView.swift
//  YiMai
//
//  Created by why on 16/4/27.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageFace2FaceQRBodyView: PageBodyView {
    private let UsernameFontSize = 40.LayoutVal()
    private let UserDescFontSize = 30.LayoutVal()
    private let UserYiMaiCodeFontSize = 42.LayoutVal()
    
    private let Userhead = YMLayout.GetSuitableImageView("PersonalDefaultUserhead")
    private let UserDescLine = UILabel()
    private let YiMaiCodePanel = UIView()
    private let QRCode = YMLayout.GetSuitableImageView("Face2FaceTempQR")
    private let ChargesTipPanel = UIView()

    private let Fee = "\(YMVar.MyUserInfo["fee_face_to_face"]!)"

    
    override func ViewLayout() {
        YMLayout.BodyLayoutWithTop(ParentView!, bodyView: BodyView)
        BodyView.backgroundColor = YMColors.BackgroundGray
    }
    
    func LoadData() {
        YMLayout.ClearView(view: BodyView)
        YMLayout.ClearView(view: YiMaiCodePanel)
        YMLayout.ClearView(view: ChargesTipPanel)
        DrawUserHead()
        DrawUserTextLines()
        DrawYiMaiCode()
        DrawYiMaiQR()
        DrawChargesTip()
    }
    
    public func DrawFastSettingBtn(topView: UIView) {
        let btn = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "GoToF2FSetting:".Sel(), userStringData: "", backgroundColor: YMColors.None)
        
        topView.addSubview(btn)
        btn.anchorToEdge(Edge.Right, padding: 10.LayoutVal(), width: 60.LayoutVal(), height: YMSizes.PageTopHeight)
        
        let icon = YMLayout.GetSuitableImageView("YMIconSettingWhite")
        
        btn.addSubview(icon)
        icon.anchorToEdge(Edge.Bottom, padding: 26.LayoutVal(), width: icon.width, height: icon.height)
    }
    
    private func DrawUserHead() {
        BodyView.addSubview(Userhead)
        Userhead.anchorToEdge(Edge.Top, padding: 50.LayoutVal(), width: Userhead.width, height: Userhead.height)
        let userHeadUrl = YMVar.MyUserInfo["head_url"] as! String
        YMLayout.LoadImageFromServer(Userhead, url: userHeadUrl, fullUrl: nil, makeItRound: true)
    }
    
    private func DrawUserTextLines() {
        let userNameLine = UILabel()

        BodyView.addSubview(userNameLine)
        BodyView.addSubview(UserDescLine)

        userNameLine.text = YMVar.MyUserInfo["name"] as? String
        userNameLine.textAlignment = NSTextAlignment.Center
        userNameLine.textColor = YMColors.FontBlue
        userNameLine.font = YMFonts.YMDefaultFont(UsernameFontSize)
        
        var deptStr = ""
        var jobTitleStr = ""
        let deptInfo = YMVar.MyUserInfo["department"] as? [String: AnyObject]
        let jobTitle = YMVar.MyUserInfo["job_title"] as? String
        if(nil != deptInfo) {
            deptStr = deptInfo!["name"] as! String
        }
        
        if(nil != jobTitle) {
            jobTitleStr = jobTitle!
        }

        UserDescLine.text = "\(deptStr) | \(jobTitleStr)"
        UserDescLine.textAlignment = NSTextAlignment.Center
        UserDescLine.textColor = YMColors.FontGray
        UserDescLine.font = YMFonts.YMDefaultFont(UserDescFontSize)
        
        userNameLine.align(Align.UnderCentered, relativeTo: Userhead, padding: 30.LayoutVal(), width: YMSizes.PageWidth, height: UsernameFontSize)
        UserDescLine.align(Align.UnderCentered, relativeTo: userNameLine, padding: 15.LayoutVal(), width: YMSizes.PageWidth, height: UserDescFontSize)
    }
    
    private func DrawYiMaiCode() {
        let yiMaiBackLine = UIView()
        yiMaiBackLine.backgroundColor = YMColors.FontBlue
        
        BodyView.addSubview(yiMaiBackLine)
        
        yiMaiBackLine.align(Align.UnderCentered, relativeTo: UserDescLine, padding: 60.LayoutVal(), width: 567.LayoutVal(), height: 1)
        
        let yiMaiCode = YMVar.MyUserInfo["code"] as! String
        let yiMaiTitle = "医脉码"

        YiMaiCodePanel.backgroundColor = YMColors.BackgroundGray

        let yiMaiTitleLine = UILabel()
        let yiMaiCodeLine = UILabel()
        
        yiMaiTitleLine.text = yiMaiTitle
        yiMaiCodeLine.text = yiMaiCode
        
        yiMaiTitleLine.font = YMFonts.YMDefaultFont(UserYiMaiCodeFontSize)
        yiMaiCodeLine.font = YMFonts.YMDefaultFont(UserYiMaiCodeFontSize)
        
        yiMaiTitleLine.textColor = YMColors.FontBlue
        yiMaiCodeLine.textColor = YMColors.FontBlue
        
        yiMaiTitleLine.sizeToFit()
        yiMaiCodeLine.sizeToFit()
        
        YiMaiCodePanel.addSubview(yiMaiTitleLine)
        YiMaiCodePanel.addSubview(yiMaiCodeLine)
        
        let yiMaiPanelWidth = (30.LayoutVal() * 2) + 24.LayoutVal() + yiMaiTitleLine.width + yiMaiCodeLine.width
        BodyView.addSubview(YiMaiCodePanel)
        
        YiMaiCodePanel.align(Align.UnderCentered, relativeTo: UserDescLine, padding: 42.LayoutVal(), width: yiMaiPanelWidth, height: UserYiMaiCodeFontSize)
        yiMaiTitleLine.anchorToEdge(Edge.Left, padding: 30.LayoutVal(), width: yiMaiTitleLine.width, height: yiMaiTitleLine.height)
        yiMaiCodeLine.align(Align.ToTheRightMatchingTop, relativeTo: yiMaiTitleLine, padding: 24.LayoutVal(), width: yiMaiCodeLine.width, height: yiMaiCodeLine.height)
    }
    
    private func DrawYiMaiQR() {
        BodyView.addSubview(QRCode)
        let qrImage = YMQRCode.generateImage(Fee, avatarImage: nil)
        QRCode.image = qrImage
        QRCode.align(Align.UnderCentered, relativeTo: YiMaiCodePanel, padding: 40.LayoutVal(), width: QRCode.width, height: QRCode.height)
    }
    
    private func DrawChargesTip() {
        let backLine = UIView()
        backLine.backgroundColor = YMColors.FontBlue
        
        let tipFontSize = 26.LayoutVal()
        
        BodyView.addSubview(backLine)
        backLine.align(Align.UnderCentered, relativeTo: QRCode, padding: 85.LayoutVal(), width: 567.LayoutVal(), height: 1)
        

        let tipTitleLine = UILabel()
        let tipFirstLine = UILabel()
        let tipSecondLine = ActiveLabel()
        
        tipTitleLine.text = "微信扫码支付"
        tipTitleLine.textColor = YMColors.FontBlue
        tipTitleLine.font = YMFonts.YMDefaultFont(34.LayoutVal())
        
        let fee = "\(YMVar.MyUserInfo["fee_face_to_face"]!)"
        tipFirstLine.text = "医脉平台为您提供预约咨询及相关支付服务"
  
        tipFirstLine.textColor = YMColors.FontGray
        tipSecondLine.textColor = YMColors.FontGray
        
        let customType = ActiveType.Custom(pattern: "\(fee)")
        tipSecondLine.enabledTypes = [customType]
        tipSecondLine.customColor[customType] = YMColors.FontBlue
        tipSecondLine.text = "本次约诊费：\(fee) 元"
        

        
        tipFirstLine.font = YMFonts.YMDefaultFont(tipFontSize)
        tipSecondLine.font = YMFonts.YMDefaultFont(tipFontSize)
        
        tipFirstLine.textAlignment = NSTextAlignment.Center
        tipSecondLine.textAlignment = NSTextAlignment.Center
        
        ChargesTipPanel.addSubview(tipTitleLine)
        ChargesTipPanel.addSubview(tipFirstLine)
        ChargesTipPanel.addSubview(tipSecondLine)
        
        tipTitleLine.sizeToFit()
        tipFirstLine.sizeToFit()
        tipSecondLine.sizeToFit()
        
        BodyView.addSubview(ChargesTipPanel)
        ChargesTipPanel.backgroundColor = YMColors.BackgroundGray
        
        let chargesTipPanelWidth = tipTitleLine.width + 140.LayoutVal()
        let chargesTipPanelHeight = 64.LayoutVal()
        
        ChargesTipPanel.align(Align.UnderCentered, relativeTo: QRCode, padding: 54.LayoutVal(), width: chargesTipPanelWidth, height: chargesTipPanelHeight)
        tipTitleLine.anchorInCenter(width: tipTitleLine.width, height: tipTitleLine.height)
        tipFirstLine.align(Align.UnderCentered, relativeTo: tipTitleLine, padding: 20.LayoutVal(), width: tipFirstLine.width, height: tipFirstLine.height)
        tipSecondLine.align(Align.UnderCentered, relativeTo: tipFirstLine, padding: 6.LayoutVal(), width: tipSecondLine.width, height: tipSecondLine.height)
    }
}































