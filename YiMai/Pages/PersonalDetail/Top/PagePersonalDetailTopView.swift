//
//  PagePersonalDetailTop.swift
//  YiMai
//
//  Created by why on 16/6/20.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PagePersonalDetailTopView:NSObject {
    private var ParentView: UIView? = nil
    private var Actions: PagePersonalDetailActions? = nil
    public var TopView = UIView()
    
    private let NameLabel = UILabel()
    private let TitleLabel = UILabel()
    private let YiMaiTitleLabel = UILabel()
    private let YiMaiCodeLabel = UILabel()
    
    private var HeadImage: UIImageView? = nil
    private var EditIcon: YMTouchableImageView? = nil

    init(parent: UIView, actions: PagePersonalDetailActions) {
        super.init()
        self.ParentView = parent
        self.Actions = actions
        
        ViewLayout()
    }
    
    private func ViewLayout() {
        let topBackground = YMLayout.GetSuitableImageView("PagePersonalDetailTop")
        
        ParentView!.addSubview(TopView)
        TopView.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 510.LayoutVal())
        
        TopView.addSubview(topBackground)
        topBackground.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: topBackground.height)
        TopView.backgroundColor = YMColors.White

        TopView.addSubview(NameLabel)
        TopView.addSubview(TitleLabel)
        TopView.addSubview(YiMaiTitleLabel)
        TopView.addSubview(YiMaiCodeLabel)
        
        NameLabel.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 65.LayoutVal(), otherSize: 40.LayoutVal())
        NameLabel.textAlignment = NSTextAlignment.Center
        NameLabel.textColor = YMColors.White
        NameLabel.font = YMFonts.YMDefaultFont(40.LayoutVal())
        
        TitleLabel.align(Align.UnderCentered, relativeTo: NameLabel, padding: 20.LayoutVal(), width: YMSizes.PageWidth, height: 20.LayoutVal())
        TitleLabel.textAlignment = NSTextAlignment.Center
        TitleLabel.textColor = YMColors.White
        TitleLabel.font = YMFonts.YMDefaultFont(20.LayoutVal())
        
        YiMaiTitleLabel.align(Align.UnderCentered, relativeTo: TitleLabel, padding: 273.LayoutVal(), width: YMSizes.PageWidth, height: 26.LayoutVal())
        YiMaiTitleLabel.textAlignment = NSTextAlignment.Center
        YiMaiTitleLabel.textColor = YMColors.FontBlue
        YiMaiTitleLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        YiMaiTitleLabel.text = "医脉码"

        YiMaiCodeLabel.align(Align.UnderCentered, relativeTo: YiMaiTitleLabel, padding: 12.LayoutVal(), width: YMSizes.PageWidth, height: 40.LayoutVal())
        YiMaiCodeLabel.textAlignment = NSTextAlignment.Center
        YiMaiCodeLabel.textColor = YMColors.FontBlue
        YiMaiCodeLabel.font = YMFonts.YMDefaultFont(40.LayoutVal())
        
        HeadImage = YMLayout.GetSuitableImageView("PersonalDefaultUserhead")
        TopView.addSubview(HeadImage!)
        
        HeadImage!.anchorToEdge(Edge.Top, padding: 165.LayoutVal(), width: HeadImage!.width, height: HeadImage!.height)
        
        EditIcon = YMLayout.GetTouchableImageView(useObject: Actions!, useMethod: PageJumpActions.PageJumpToByImageViewSenderSel, imageName: "PagePersonalEditIcon")
        TopView.addSubview(EditIcon!)
        EditIcon!.anchorInCorner(Corner.TopRight, xPad: 30.LayoutVal(), yPad: 65.LayoutVal(), width: EditIcon!.width, height: EditIcon!.height)
    }
    
    public func LoadData(data: [String:AnyObject]) {
        NameLabel.text = YMVar.MyUserInfo["name"] as? String
        
        let dept = YMVar.MyUserInfo["department"] as? String
        let jobTitle = YMVar.MyUserInfo["job_title"] as? String
        if(nil == dept && nil == jobTitle) {
            TitleLabel.text = ""
        } else if(nil == dept && nil != jobTitle) {
            TitleLabel.text = jobTitle!
        } else if (nil != dept && nil == jobTitle) {
            TitleLabel.text = dept!
        } else {
            TitleLabel.text = "\(dept!) | \(jobTitle!)"
        }
        
        YiMaiCodeLabel.text = YMVar.MyUserInfo["code"] as? String
    }
}




















