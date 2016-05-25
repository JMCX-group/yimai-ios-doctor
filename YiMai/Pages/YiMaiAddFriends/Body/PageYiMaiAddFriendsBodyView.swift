//
//  PageYiMaiAddFriendsBodyView.swift
//  YiMai
//
//  Created by why on 16/5/25.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageYiMaiAddFriendsBodyView: PageBodyView {
    override func ViewLayout() {
        YMLayout.BodyLayoutWithTop(ParentView!, bodyView: BodyView)
        BodyView.backgroundColor = YMColors.PanelBackgroundGray
        
        DrawSpecialManualAddButton()
        DrawContent()
    }
    
    private func DrawSpecialManualAddButton() {
        let manualAddButton = YMButton()
        
        ParentView?.addSubview(manualAddButton)
        manualAddButton.setTitle("直接添加", forState: UIControlState.Normal)
        manualAddButton.titleLabel?.font = YMFonts.YMDefaultFont(30.LayoutVal())
        manualAddButton.titleLabel?.textColor = YMColors.White
        manualAddButton.sizeToFit()
        manualAddButton.anchorInCorner(Corner.TopRight, xPad: 30.LayoutVal(), yPad: 70.LayoutVal(), width: manualAddButton.width, height: manualAddButton.height)
        
        manualAddButton.layer.zPosition = 1.0
    }
    
    private func DrawContent() {
        let icon = YMLayout.GetSuitableImageView("YiMaiAddFriendsBigIcon")
        
        BodyView.addSubview(icon)
        icon.anchorToEdge(Edge.Top, padding: 150.LayoutVal(), width: icon.width, height: icon.height)
        
        let textLabel = UILabel()
        textLabel.text = "看看您的医脉资源中有多少位医生"
        textLabel.font = YMFonts.YMDefaultFont(30.LayoutVal())
        textLabel.textColor = YMColors.FontGray
        textLabel.sizeToFit()
        
        BodyView.addSubview(textLabel)
        textLabel.align(Align.UnderCentered, relativeTo: icon, padding: 42.LayoutVal(), width: textLabel.width, height: textLabel.height)
        
        let tooltipLabel = UILabel()
        tooltipLabel.text = "将读取您的通讯录"
        tooltipLabel.font = YMFonts.YMDefaultFont(36.LayoutVal())
        tooltipLabel.textColor = YMColors.FontGray
        tooltipLabel.sizeToFit()
        
        BodyView.addSubview(tooltipLabel)
        tooltipLabel.align(Align.UnderCentered, relativeTo: textLabel, padding: 30.LayoutVal(), width: tooltipLabel.width, height: tooltipLabel.height)
        
        let nextButton = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "NextStep:")
        nextButton.backgroundColor = YMColors.None
        let title = UILabel(frame: CGRect(x: 0,y: 0,width: 230.LayoutVal(),height: 60.LayoutVal()))
        title.text = "下一步"
        title.textColor = YMColors.FontBlue
        title.backgroundColor = YMColors.BackgroundGray
        title.font = YMFonts.YMDefaultFont(34.LayoutVal())
        title.textAlignment = NSTextAlignment.Center
        title.layer.cornerRadius = title.height / 2
        title.layer.masksToBounds = true;
        
        nextButton.addSubview(title)

        BodyView.addSubview(nextButton)
        nextButton.align(Align.UnderCentered, relativeTo: tooltipLabel, padding: 40.LayoutVal(), width: title.width, height: title.height)

    }
}




























