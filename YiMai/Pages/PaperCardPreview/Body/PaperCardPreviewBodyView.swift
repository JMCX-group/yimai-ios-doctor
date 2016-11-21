//
//  PaperCardPreviewBodyView.swift
//  YiMai
//
//  Created by Wang Huaiyu on 16/9/24.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon
import ChameleonFramework

public class PaperCardPreviewBodyView: PageBodyView {
    static var AddressInfo = ""
    
    var PreviewActions: PaperCardPreviewActions!
    var ConfirmButton = YMButton()
    
    override func ViewLayout() {
        super.ViewLayout()
        
        PreviewActions = PaperCardPreviewActions(navController: self.NavController!, target: self)
    }
    
    func DrawFullBody() {
        YMLayout.ClearView(view: BodyView)
        
        let name = YMVar.MyUserInfo["name"] as? String
        let code = "医脉码: \(YMVar.MyUserInfo["code"]!)"
        let jobTitle = YMVar.MyUserInfo["job_title"] as? String
        let hospital = YMVar.MyUserInfo["hospital"] as? [String: AnyObject]
        let dept = YMVar.MyUserInfo["department"] as? [String: AnyObject]
        
        var hosName: String? = nil
        var deptName: String? = nil
        if(nil != hospital) {
            hosName = hospital!["name"] as? String
        }
        
        if(nil != hospital) {
            deptName = dept!["name"] as? String
        }
        
        let nameLabel = YMLayout.GetNomalLabel(name, textColor: HexColor("#000000"), fontSize: 40.LayoutVal())
        let hosLabel = YMLayout.GetNomalLabel(hosName, textColor: HexColor("#000000"), fontSize: 24.LayoutVal())
        let jobTitleLabel = YMLayout.GetNomalLabel(jobTitle, textColor: HexColor("#000000"), fontSize: 24.LayoutVal())
        let deptLabel = YMLayout.GetNomalLabel(deptName, textColor: HexColor("#000000"), fontSize: 24.LayoutVal())
        let codeLabel = YMLayout.GetNomalLabel(code, textColor: HexColor("#40699e"), fontSize: 30.LayoutVal())
        
        let qr1Label = YMLayout.GetNomalLabel("安装 “医脉 - 看专家”", textColor: HexColor("#000000"), fontSize: 18.LayoutVal())
        let qr2Label = YMLayout.GetNomalLabel("使用医脉客户端扫一扫添加", textColor: HexColor("#000000"), fontSize: 18.LayoutVal())

        
        let cardBkg = YMLayout.GetSuitableImageView("PaperCardPreviewBkg")
        
        BodyView.addSubview(cardBkg)
        BodyView.addSubview(nameLabel)
        BodyView.addSubview(hosLabel)
        BodyView.addSubview(jobTitleLabel)
        BodyView.addSubview(deptLabel)
        BodyView.addSubview(codeLabel)
        
        BodyView.addSubview(qr1Label)
        BodyView.addSubview(qr2Label)

        
        cardBkg.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: cardBkg.height)
        
        nameLabel.anchorInCorner(Corner.TopLeft, xPad: 30.LayoutVal(), yPad: 35.LayoutVal(),
                                 width: nameLabel.width, height: nameLabel.height)
        codeLabel.align(Align.UnderMatchingLeft, relativeTo: nameLabel,
                        padding: 30.LayoutVal(), width: codeLabel.width, height: codeLabel.height)
        
        hosLabel.align(Align.ToTheRightMatchingTop, relativeTo: nameLabel,
                       padding: 44.LayoutVal(),
                       width: hosLabel.width, height: hosLabel.height,
                       offset: -10.LayoutVal())
        
        jobTitleLabel.align(Align.UnderMatchingLeft,
                            relativeTo: hosLabel, padding: 10.LayoutVal(),
                            width: jobTitleLabel.width, height: jobTitleLabel.height)

        deptLabel.align(Align.ToTheRightCentered,
                        relativeTo: jobTitleLabel, padding: 35.LayoutVal(),
                        width: deptLabel.width, height: deptLabel.height)
        
        qr1Label.anchorInCorner(Corner.TopLeft,
                                xPad: 270.LayoutVal(), yPad: 390.LayoutVal(),
                                width: qr1Label.width, height: qr1Label.height)
        
        qr2Label.align(Align.ToTheRightCentered,
                       relativeTo: qr1Label, padding: 35.LayoutVal(),
                       width: qr2Label.width, height: qr2Label.height)
        
        let addrTitleLabel = YMLayout.GetNomalLabel("收名片地址", textColor: YMColors.FontGray, fontSize: 28.LayoutVal())
        let titlePanel = UIView()
        titlePanel.backgroundColor = YMColors.White
        BodyView.addSubview(titlePanel)
        titlePanel.align(Align.UnderMatchingLeft, relativeTo: cardBkg,
                         padding: 0, width: YMSizes.PageWidth, height: 80.LayoutVal())
        titlePanel.addSubview(addrTitleLabel)
        addrTitleLabel.anchorToEdge(Edge.Left, padding: 40.LayoutVal(),
                                    width: addrTitleLabel.width, height: addrTitleLabel.height)
        
        let addrPanel = UIView()
        let addrLabel = UILabel()
        
        addrLabel.numberOfLines = 20
        addrLabel.text = PaperCardPreviewBodyView.AddressInfo
        addrLabel.font = YMFonts.YMDefaultFont(28.LayoutVal())
        addrLabel.textColor = YMColors.FontLightGray
        addrLabel.frame = CGRectMake(0, 0, 670.LayoutVal(), 0)
        addrLabel.sizeToFit()
        
        addrPanel.backgroundColor = YMColors.White
        
        BodyView.addSubview(addrPanel)
        addrPanel.align(Align.UnderMatchingLeft, relativeTo: titlePanel,
                        padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: addrLabel.height + 60.LayoutVal())
        
        addrPanel.addSubview(addrLabel)
        addrLabel.anchorToEdge(Edge.Left, padding: 40.LayoutVal(),
                               width: addrLabel.width, height: addrLabel.height)
        
        ParentView?.addSubview(ConfirmButton)
        ConfirmButton.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: 98.LayoutVal())
        ConfirmButton.setTitle("确认制作", forState: UIControlState.Normal)
        ConfirmButton.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        ConfirmButton.backgroundColor = YMColors.CommonBottomBlue
        ConfirmButton.titleLabel?.font = YMFonts.YMDefaultFont(36.LayoutVal())
        
        ConfirmButton.addTarget(PreviewActions, action: "ConfirmTouched:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
    }
}






