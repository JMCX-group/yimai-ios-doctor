//
//  PageYiMaiSameHospitalBodyView.swift
//  YiMai
//
//  Created by why on 16/5/27.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageYiMaiSameHospitalBodyView: PageBodyView {
    override func ViewLayout() {
        YMLayout.BodyLayoutWithTop(ParentView!, bodyView: BodyView)
        BodyView.backgroundColor = YMColors.PanelBackgroundGray
        
        DrawBlankContent()
    }
    
    private func DrawBlankContent(){
        let bigIcon = YMLayout.GetSuitableImageView("PageYiMaiSameHospitalBigIcon")
        
        BodyView.addSubview(bigIcon)
        bigIcon.anchorToEdge(Edge.Top, padding: 130.LayoutVal(), width: bigIcon.width, height: bigIcon.height)
        
        let titleLabel = UILabel()
        titleLabel.text = "尚无同医院的医生"
        titleLabel.textColor = YMColors.FontGray
        titleLabel.font = YMFonts.YMDefaultFont(30.LayoutVal())
        titleLabel.sizeToFit()
        
        BodyView.addSubview(titleLabel)
        titleLabel.align(Align.UnderCentered, relativeTo: bigIcon, padding: 50.LayoutVal(), width: titleLabel.width, height: titleLabel.height)
        
        let inviteButton = YMLayout.GetTouchableView(useObject: Actions!,
            useMethod: PageJumpActions.PageJumpToByViewSenderSel,
            userStringData: YMCommonStrings.CS_PAGE_YIMAI_MANUAL_ADD_FRIEND_NAME)
        
        inviteButton.frame = CGRect(x: 0,y: 0,width: 190.LayoutVal(), height: 60.LayoutVal())
        inviteButton.backgroundColor = YMColors.None
        
        let buttonTitle = UILabel()
        buttonTitle.text = "去邀请"
        buttonTitle.textColor = YMColors.FontBlue
        buttonTitle.font = YMFonts.YMDefaultFont(32.LayoutVal())
        buttonTitle.textAlignment = NSTextAlignment.Center
        buttonTitle.backgroundColor = YMColors.BackgroundGray
        
        inviteButton.addSubview(buttonTitle)
        
        BodyView.addSubview(inviteButton)
        inviteButton.align(Align.UnderCentered, relativeTo: titleLabel, padding: 30.LayoutVal(), width: inviteButton.width, height: inviteButton.height)
        buttonTitle.fillSuperview()
        buttonTitle.layer.cornerRadius = buttonTitle.height / 2
        buttonTitle.layer.masksToBounds = true
    }
}