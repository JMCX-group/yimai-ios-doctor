//
//  PageFace2FaceInfoInputBodyView.swift
//  YiMai
//
//  Created by why on 16/4/26.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageFace2FaceInfoInputBodyView: PageBodyView {
    private var UserCellPhone: YMTextField? = nil
    private var UserName: YMTextField? = nil
    private let TitleHeight = 70.LayoutVal()
    private let InputHeight = 80.LayoutVal()
    private let PaddingLeft = 40.LayoutVal()
    
    override func ViewLayout() {
        YMLayout.BodyLayoutWithTop(ParentView!, bodyView: BodyView)
        BodyView.backgroundColor = YMColors.BackgroundGray
        
        DrawTitle()
        DrawInputPanel()
        DrawFace2FacePayButton()
    }
    
    private func DrawTitle() {
        let titlePanel = UIView()
        let titleLabel = UILabel()
        
        let titleFontSize = 22.LayoutVal()
        let titlePaddingTop = 25.LayoutVal()
        
        BodyView.addSubview(titlePanel)
        titlePanel.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: TitleHeight)
        
        titlePanel.addSubview(titleLabel)
        titleLabel.anchorAndFillEdge(Edge.Top, xPad: PaddingLeft, yPad: titlePaddingTop, otherSize: titleFontSize)
        titleLabel.font = YMFonts.YMDefaultFont(titleFontSize)
        titleLabel.textColor = YMColors.FontGray
        titleLabel.text = "为方便长期管理患者，请输入以下信息"
    }
    
    private func DrawInputPanel() {
        let inputParam = TextFieldCreateParam()
        let dividerLine = UIView()
        dividerLine.backgroundColor = YMColors.DividerLineGray
        
        inputParam.FontColor = YMColors.FontBlue
        inputParam.FontSize = 28.LayoutVal()
        inputParam.Placholder = "手机号"
        UserCellPhone = YMLayout.GetCellPhoneField(inputParam)

        inputParam.Placholder = "患者姓名"
        UserName = YMLayout.GetTextFieldWithMaxCharCount(inputParam, maxCharCount: 20)
        
        UserCellPhone?.SetLeftPaddingWidth(PaddingLeft)
        UserName?.SetLeftPaddingWidth(PaddingLeft)
        
        BodyView.addSubview(UserCellPhone!)
        BodyView.addSubview(dividerLine)
        BodyView.addSubview(UserName!)
        
        UserCellPhone?.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: TitleHeight, otherSize: InputHeight)
        dividerLine.align(Align.UnderMatchingLeft, relativeTo: UserCellPhone!, padding: 0, width: YMSizes.PageWidth, height: 1)
        UserName!.align(Align.UnderMatchingLeft, relativeTo: dividerLine, padding: 0, width: YMSizes.PageWidth, height: InputHeight)
    }
    
    private func DrawFace2FacePayButton(){
        let payButton = YMLayout.GetTouchableImageView(useObject: Actions!, useMethod: YMSelectors.PageJumpByImageView, imageName: "Face2FaceInfoInputButtonFace2FacePay")
        payButton.UserStringData = YMCommonStrings.CS_PAGE_FACE_2_FACE_QR_NAME
        BodyView.addSubview(payButton)
        payButton.align(Align.UnderCentered, relativeTo: UserName!, padding: 465.LayoutVal(), width: payButton.width, height: payButton.height)
        
        let descFirstLine = UILabel()
        let descSecondLine = UILabel()
        
        let descFontSize = 26.LayoutVal()
        
        descFirstLine.text = "本平台将在您诊费的基础上"
        descSecondLine.text = "额外向患者收取少量服务费"
        
        descFirstLine.textColor = YMColors.FontBlue
        descSecondLine.textColor = YMColors.FontBlue
        
        descFirstLine.font = YMFonts.YMDefaultFont(descFontSize)
        descSecondLine.font = YMFonts.YMDefaultFont(descFontSize)
        
        descFirstLine.textAlignment = NSTextAlignment.Center
        descSecondLine.textAlignment = NSTextAlignment.Center
        
        BodyView.addSubview(descFirstLine)
        BodyView.addSubview(descSecondLine)
        
        descFirstLine.align(Align.UnderCentered, relativeTo: payButton, padding: 46.LayoutVal(), width: YMSizes.PageWidth, height: descFontSize)
        descSecondLine.align(Align.UnderCentered, relativeTo: descFirstLine, padding: 8.LayoutVal(), width: YMSizes.PageWidth, height: descFontSize)
    }
}


























