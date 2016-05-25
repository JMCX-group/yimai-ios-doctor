//
//  PageYiMaiR2BodyView.swift
//  YiMai
//
//  Created by why on 16/5/25.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageYiMaiR2BodyView: PageBodyView {
    private var SearchInput: YMTextField? = nil
    private let SearchPanel = UIView()
    private let FriendsPanel = UIView()
    private let FriendCellTouched: Selector = "FriendButtonTouched:"
    
    override func ViewLayout() {
        YMLayout.BodyLayoutWithTop(ParentView!, bodyView: BodyView)
        BodyView.backgroundColor = YMColors.BackgroundGray
        BodyView.hidden = true
        
        DrawSearchPanel()
        DrawFriendsPanel()
    }
    
    private func DrawSearchPanel() {
        let searchInputParam = TextFieldCreateParam()
        let searchIconView = UIView(frame: CGRect(x: 0,y: 0,width: 66.LayoutVal(),height: 60.LayoutVal()))
        let searchIcon = YMLayout.GetSuitableImageView("YiMaiGeneralSearchIcon")
        
        searchInputParam.BackgroundImageName = "YiMaiGeneralLongSearchBackground"
        searchInputParam.Placholder = YMYiMaiStrings.CS_SEARCH_PLACEHOLDER
        searchInputParam.FontSize = 26.LayoutVal()
        searchInputParam.FontColor = YMColors.FontBlue
        
        SearchInput = YMLayout.GetTextFieldWithMaxCharCount(searchInputParam, maxCharCount: 60)
        
        BodyView.addSubview(SearchPanel)
        SearchPanel.addSubview(SearchInput!)
        
        SearchPanel.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: 120.LayoutVal())
        
        SearchInput?.anchorInCenter(width: 690.LayoutVal(), height: 60.LayoutVal())
        searchIconView.addSubview(searchIcon)
        searchIcon.anchorInCenter(width: searchIcon.width, height: searchIcon.height)
        SearchInput?.SetLeftPadding(searchIconView)
    }
    
    private func DrawFriendsCell(data: [String: AnyObject], prevCell: YMTouchableView?) -> YMTouchableView {
        let headUrl = data[YMYiMaiStrings.CS_DATA_KEY_USERHEAD] as! String
        let name = data[YMYiMaiStrings.CS_DATA_KEY_NAME] as! String
        let hospital = data[YMYiMaiStrings.CS_DATA_KEY_HOSPATIL] as! String
        let department = data[YMYiMaiStrings.CS_DATA_KEY_DEPARTMENT] as! String
        let jobTitle = data[YMYiMaiStrings.CS_DATA_KEY_JOB_TITLE] as! String
        let userId = data[YMYiMaiStrings.CS_DATA_KEY_USER_ID] as! String
        
        let nameLabel = UILabel()
        let divider = UIView(frame: CGRect(x: 0,y: 0,width: 1,height: 20.LayoutVal()))
        let jobTitleLabel = UILabel()
        let deptLabel = UILabel()
        let hosLabel = UILabel()
        let userHeadBackground = YMLayout.GetSuitableImageView("YiMaiGeneralHeadImageBorder")
        
        nameLabel.text = name
        nameLabel.textColor = YMColors.FontBlue
        nameLabel.font = YMFonts.YMDefaultFont(30.LayoutVal())
        nameLabel.sizeToFit()
        
        divider.backgroundColor = YMColors.FontBlue
        
        jobTitleLabel.text = jobTitle
        jobTitleLabel.textColor = YMColors.FontGray
        jobTitleLabel.font = YMFonts.YMDefaultFont(22.LayoutVal())
        jobTitleLabel.sizeToFit()
        
        deptLabel.text = department
        deptLabel.textColor = YMColors.FontBlue
        deptLabel.font = YMFonts.YMDefaultFont(22.LayoutVal())
        deptLabel.sizeToFit()
        
        hosLabel.text = hospital
        hosLabel.textColor = YMColors.FontGray
        hosLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        hosLabel.sizeToFit()
        hosLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        
        let cell = YMLayout.GetTouchableView(useObject: Actions!, useMethod: FriendCellTouched, userStringData: userId)
        
        cell.addSubview(userHeadBackground)
        cell.addSubview(nameLabel)
        cell.addSubview(divider)
        cell.addSubview(jobTitleLabel)
        cell.addSubview(deptLabel)
        cell.addSubview(hosLabel)
        
        FriendsPanel.addSubview(cell)
        
        if(nil == prevCell) {
            cell.anchorToEdge(Edge.Top, padding: 51.LayoutVal(), width: YMSizes.PageWidth, height: 151.LayoutVal())
        } else {
            cell.alignAndFillWidth(align: Align.UnderMatchingLeft, relativeTo: prevCell!, padding: 1, height: 151.LayoutVal())
        }
        
        userHeadBackground.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: userHeadBackground.width, height: userHeadBackground.height)
        nameLabel.anchorInCorner(Corner.TopLeft, xPad: 180.LayoutVal(), yPad: 25.LayoutVal(), width: nameLabel.width, height: nameLabel.height)
        divider.align(Align.ToTheRightCentered, relativeTo: nameLabel, padding: 15.LayoutVal(), width: 1, height: divider.height)
        jobTitleLabel.align(Align.ToTheRightCentered, relativeTo: divider, padding: 15.LayoutVal(), width: jobTitleLabel.width, height: jobTitleLabel.height)
        deptLabel.align(Align.UnderMatchingLeft, relativeTo: nameLabel, padding: 6.LayoutVal(), width: deptLabel.width, height: deptLabel.height)
        hosLabel.align(Align.UnderMatchingLeft, relativeTo: deptLabel, padding: 6.LayoutVal(), width: 540.LayoutVal(), height: hosLabel.height)
        
        return cell
    }
    
    private func DrawFriendsPanel() {
        BodyView.addSubview(FriendsPanel)
        FriendsPanel.alignAndFillWidth(align: Align.UnderMatchingLeft, relativeTo: SearchPanel, padding: 0, height: 0)
        
        let titlePanel = UIView()
        let titleLabel = UILabel()
        titleLabel.text = "朋友的朋友（20名医生 | 5家医院）"
        titleLabel.textColor = YMColors.FontGray
        titleLabel.font = YMFonts.YMDefaultFont(24.LayoutVal())
        titleLabel.sizeToFit()
        
        titlePanel.addSubview(titleLabel)
        FriendsPanel.addSubview(titlePanel)
        titlePanel.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: 50.LayoutVal())
        titlePanel.backgroundColor = YMColors.White
        titleLabel.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 0, width: titleLabel.width, height: 50.LayoutVal())
        
        var cellView = DrawFriendsCell(
            [
                YMYiMaiStrings.CS_DATA_KEY_USERHEAD:"test",
                YMYiMaiStrings.CS_DATA_KEY_NAME:"池帅",
                YMYiMaiStrings.CS_DATA_KEY_HOSPATIL:"鸡西矿业总医院医疗集团二道河子中心医院",
                YMYiMaiStrings.CS_DATA_KEY_DEPARTMENT:"心血管外科",
                YMYiMaiStrings.CS_DATA_KEY_JOB_TITLE:"主任医师",
                YMYiMaiStrings.CS_DATA_KEY_USER_ID:"1"
                
            ], prevCell: nil
        )
        
        cellView = DrawFriendsCell(
            [
                YMYiMaiStrings.CS_DATA_KEY_USERHEAD:"test",
                YMYiMaiStrings.CS_DATA_KEY_NAME:"方欣雨",
                YMYiMaiStrings.CS_DATA_KEY_HOSPATIL:"牡丹江市西安区先锋医院江滨社区第一卫生服务站",
                YMYiMaiStrings.CS_DATA_KEY_DEPARTMENT:"小儿营养保健科",
                YMYiMaiStrings.CS_DATA_KEY_JOB_TITLE:"主任医师",
                YMYiMaiStrings.CS_DATA_KEY_USER_ID:"1"
                
            ], prevCell: cellView
        )
        
        cellView = DrawFriendsCell(
            [
                YMYiMaiStrings.CS_DATA_KEY_USERHEAD:"test",
                YMYiMaiStrings.CS_DATA_KEY_NAME:"武瑞鑫",
                YMYiMaiStrings.CS_DATA_KEY_HOSPATIL:"中国医学科学院北京协和医院",
                YMYiMaiStrings.CS_DATA_KEY_DEPARTMENT:"功能神经外科",
                YMYiMaiStrings.CS_DATA_KEY_JOB_TITLE:"主任医师",
                YMYiMaiStrings.CS_DATA_KEY_USER_ID:"1"
                
            ], prevCell: cellView
        )
    }

}