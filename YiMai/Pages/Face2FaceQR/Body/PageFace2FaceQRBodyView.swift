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

    
    override func ViewLayout() {
        YMLayout.BodyLayoutWithTop(ParentView!, bodyView: BodyView)
        BodyView.backgroundColor = YMColors.BackgroundGray

        DrawUserHead()
        DrawUserTextLines()
        DrawYiMaiCode()
        DrawYiMaiQR()
        DrawChargesTip()
    }
    
    private func DrawUserHead() {
        BodyView.addSubview(Userhead)
        Userhead.anchorToEdge(Edge.Top, padding: 50.LayoutVal(), width: Userhead.width, height: Userhead.height)
    }
    
    private func DrawUserTextLines() {
        let userNameLine = UILabel()

        BodyView.addSubview(userNameLine)
        BodyView.addSubview(UserDescLine)
        
        userNameLine.text = "华佗"
        userNameLine.textAlignment = NSTextAlignment.Center
        userNameLine.textColor = YMColors.FontBlue
        userNameLine.font = YMFonts.YMDefaultFont(UsernameFontSize)
        
        UserDescLine.text = "麻醉科 | 主任医师"
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
        
        let yiMaiCode = "123abc"
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
        QRCode.align(Align.UnderCentered, relativeTo: YiMaiCodePanel, padding: 53.LayoutVal(), width: QRCode.width, height: QRCode.height)
    }
    
    private func DrawChargesTip() {
        let backLine = UIView()
        backLine.backgroundColor = YMColors.FontBlue
        
        let tipFontSize = 30.LayoutVal()
        
        BodyView.addSubview(backLine)
        backLine.align(Align.UnderCentered, relativeTo: QRCode, padding: 85.LayoutVal(), width: 567.LayoutVal(), height: 1)
        
        let tipFirstLine = UILabel()
        let tipSecondLine = UILabel()
        
        tipFirstLine.text = "本平台将在您诊费的基础上"
        tipSecondLine.text = "额外向患者收取少量服务费"
        
        tipFirstLine.textColor = YMColors.FontBlue
        tipSecondLine.textColor = YMColors.FontBlue
        
        tipFirstLine.font = YMFonts.YMDefaultFont(tipFontSize)
        tipSecondLine.font = YMFonts.YMDefaultFont(tipFontSize)
        
        tipFirstLine.textAlignment = NSTextAlignment.Center
        tipSecondLine.textAlignment = NSTextAlignment.Center
        
        ChargesTipPanel.addSubview(tipFirstLine)
        ChargesTipPanel.addSubview(tipSecondLine)
        
        BodyView.addSubview(ChargesTipPanel)
        ChargesTipPanel.backgroundColor = YMColors.BackgroundGray
        
        let chargesTipPanelWidth = 405.LayoutVal()
        let chargesTipPanelHeight = 64.LayoutVal()
        
        ChargesTipPanel.align(Align.UnderCentered, relativeTo: QRCode, padding: 54.LayoutVal(), width: chargesTipPanelWidth, height: chargesTipPanelHeight)
        tipFirstLine.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: tipFontSize)
        tipSecondLine.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: tipFontSize)
    }
}































