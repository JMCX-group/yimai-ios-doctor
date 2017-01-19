//
//  PageAppointmentSelectDoctorBodyView.swift
//  YiMai
//
//  Created by why on 16/5/31.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageAppointmentSelectDoctorBodyView: PageBodyView {
    private var SearchInput: YMTextField? = nil
    private var SearchPanel = UIView()
    
    private let Level1FriendsPanel = UIView()
    private let Level2FriendsPanel = UIView()
    
    override func ViewLayout() {
        super.ViewLayout()
        DrawSearchPanel()
        DrawLevel1Friends()
        DrawLevel2Friends()
        
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: Level2FriendsPanel)
    }
    
    private func DrawSearchPanel() {
        let searchInputParam = TextFieldCreateParam()
        let searchIconView = UIView(frame: CGRect(x: 0,y: 0,width: 66.LayoutVal(),height: 60.LayoutVal()))
        let searchIcon = YMLayout.GetSuitableImageView("YiMaiGeneralSearchIcon")
        
        searchInputParam.BackgroundImageName = "YiMaiGeneralLongSearchBackground"
        searchInputParam.Placholder = YMAppointmentStrings.CS_SEARCH_PLACEHOLDER
        searchInputParam.FontSize = 26.LayoutVal()
        searchInputParam.FontColor = YMColors.FontBlue
        
        SearchInput = YMLayout.GetTextFieldWithMaxCharCount(searchInputParam, maxCharCount: 60)
        
        BodyView.addSubview(SearchPanel)
        SearchPanel.addSubview(SearchInput!)
        
        SearchPanel.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: 121.LayoutVal())
        
        SearchInput?.anchorInCenter(width: 690.LayoutVal(), height: 60.LayoutVal())
        searchIconView.addSubview(searchIcon)
        searchIcon.anchorInCenter(width: searchIcon.width, height: searchIcon.height)
        SearchInput?.SetLeftPadding(searchIconView)
        
        let borderBottom = UIView()
        SearchPanel.addSubview(borderBottom)
        borderBottom.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: YMSizes.OnPx)
        borderBottom.backgroundColor = YMColors.DividerLineGray
    }
    
    private func DrawFriendsCell(data: [String: AnyObject], docPanel: UIView, prevCell: UIView?) -> YMTouchableView {
        let head = data[YMYiMaiStrings.CS_DATA_KEY_USERHEAD] as! String
        let name = data[YMYiMaiStrings.CS_DATA_KEY_NAME] as! String
        let hospital = data[YMYiMaiStrings.CS_DATA_KEY_HOSPATIL] as! String
        let department = data[YMYiMaiStrings.CS_DATA_KEY_DEPARTMENT] as! String
        let jobTitle = YMVar.GetStringByKey(data, key: YMYiMaiStrings.CS_DATA_KEY_JOB_TITLE, defStr: "医生")
        let userId = data[YMYiMaiStrings.CS_DATA_KEY_USER_ID] as! String
        
        let nameLabel = UILabel()
        let divider = UIView(frame: CGRect(x: 0,y: 0,width: YMSizes.OnPx,height: 20.LayoutVal()))
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
        
        let cell = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "DoctorSelect:".Sel(), userStringData: userId)
        
        cell.addSubview(userHeadBackground)
        cell.addSubview(nameLabel)
        cell.addSubview(divider)
        cell.addSubview(jobTitleLabel)
        cell.addSubview(deptLabel)
        cell.addSubview(hosLabel)
        
        cell.UserObjectData = data
        
        docPanel.addSubview(cell)
        
        if(nil == prevCell) {
            cell.anchorToEdge(Edge.Top, padding: 50.LayoutVal(), width: YMSizes.PageWidth, height: 151.LayoutVal())
        } else {
            cell.alignAndFillWidth(align: Align.UnderMatchingLeft, relativeTo: prevCell!, padding: YMSizes.OnPx, height: 151.LayoutVal())
        }
        
        userHeadBackground.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: userHeadBackground.width, height: userHeadBackground.height)
        nameLabel.anchorInCorner(Corner.TopLeft, xPad: 180.LayoutVal(), yPad: 25.LayoutVal(), width: nameLabel.width, height: nameLabel.height)
        divider.align(Align.ToTheRightCentered, relativeTo: nameLabel, padding: 15.LayoutVal(), width: YMSizes.OnPx, height: divider.height)
        jobTitleLabel.align(Align.ToTheRightCentered, relativeTo: divider, padding: 15.LayoutVal(), width: jobTitleLabel.width, height: jobTitleLabel.height)
        deptLabel.align(Align.UnderMatchingLeft, relativeTo: nameLabel, padding: 6.LayoutVal(), width: deptLabel.width, height: deptLabel.height)
        hosLabel.align(Align.UnderMatchingLeft, relativeTo: deptLabel, padding: 6.LayoutVal(), width: 540.LayoutVal(), height: hosLabel.height)
        
        YMLayout.SetDocfHeadImageVFlag(userHeadBackground, docInfo: data)
        YMLayout.LoadImageFromServer(userHeadBackground, url: head, fullUrl: nil, makeItRound: true)
        
        return cell
    }
    
    private func DrawListTitle(title: String, panel: UIView) -> UIView {
        let titlePanel = UIView()
        let titleLabel = UILabel()
        
        panel.addSubview(titlePanel)
        titlePanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 50.LayoutVal())
        
        titleLabel.text = title
        titleLabel.textColor = YMColors.FontGray
        titleLabel.font = YMFonts.YMDefaultFont(24.LayoutVal())
        titleLabel.sizeToFit()
        
        titlePanel.addSubview(titleLabel)
        titleLabel.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: titleLabel.width, height: 50.LayoutVal())
        
        return titlePanel
    }
    
    private func DrawLevel1Friends() {
        BodyView.addSubview(Level1FriendsPanel)
        Level1FriendsPanel.align(Align.UnderMatchingLeft, relativeTo: SearchPanel, padding: 0, width: YMSizes.PageWidth, height: 0)
        
        let l1Doc = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_L1_FRIENDS) as! [[String:AnyObject]]
        
        let titlePanel = DrawListTitle("一度医脉", panel: Level1FriendsPanel)
        
        var cellView: UIView? = titlePanel
        for doc in l1Doc {
            cellView = DrawFriendsCell(
                [
                    YMYiMaiStrings.CS_DATA_KEY_USERHEAD:"\(doc["head_url"]!)",
                    YMYiMaiStrings.CS_DATA_KEY_NAME:"\(doc["name"]!)",
                    YMYiMaiStrings.CS_DATA_KEY_HOSPATIL:"\(doc["hospital"]!)",
                    YMYiMaiStrings.CS_DATA_KEY_DEPARTMENT:"\(doc["department"]!)",
                    YMYiMaiStrings.CS_DATA_KEY_JOB_TITLE:"\(doc["job_title"]!)",
                    YMYiMaiStrings.CS_DATA_KEY_USER_ID:"\(doc["id"]!)",
                    "is_auth": YMVar.GetStringByKey(doc, key: "is_auth")
                    
                ],  docPanel: Level1FriendsPanel, prevCell: cellView
            )
        }
        
//        cellView = DrawFriendsCell(
//            [
//                YMYiMaiStrings.CS_DATA_KEY_USERHEAD:"test",
//                YMYiMaiStrings.CS_DATA_KEY_NAME:"池帅",
//                YMYiMaiStrings.CS_DATA_KEY_HOSPATIL:"鸡西矿业总医院医疗集团二道河子中心医院",
//                YMYiMaiStrings.CS_DATA_KEY_DEPARTMENT:"心血管外科",
//                YMYiMaiStrings.CS_DATA_KEY_JOB_TITLE:"主任医师",
//                YMYiMaiStrings.CS_DATA_KEY_USER_ID:"1"
//                
//            ], docPanel: Level1FriendsPanel, prevCell: titlePanel
//        )
//        
//        cellView = DrawFriendsCell(
//            [
//                YMYiMaiStrings.CS_DATA_KEY_USERHEAD:"test",
//                YMYiMaiStrings.CS_DATA_KEY_NAME:"方欣雨",
//                YMYiMaiStrings.CS_DATA_KEY_HOSPATIL:"牡丹江市西安区先锋医院江滨社区第一卫生服务站",
//                YMYiMaiStrings.CS_DATA_KEY_DEPARTMENT:"小儿营养保健科",
//                YMYiMaiStrings.CS_DATA_KEY_JOB_TITLE:"主任医师",
//                YMYiMaiStrings.CS_DATA_KEY_USER_ID:"1"
//                
//            ], docPanel: Level1FriendsPanel, prevCell: cellView
//        )
        
        Level1FriendsPanel.frame = CGRect(
            x: Level1FriendsPanel.frame.origin.x,
            y: Level1FriendsPanel.frame.origin.y,
            width: Level1FriendsPanel.frame.width,
            height: cellView!.frame.origin.y + cellView!.height
        )
    }
    
    private func DrawLevel2Friends() {
        BodyView.addSubview(Level2FriendsPanel)
        Level2FriendsPanel.align(Align.UnderMatchingLeft, relativeTo: Level1FriendsPanel, padding: 0, width: YMSizes.PageWidth, height: 0)
        
        let l2Doc = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_L2_FRIENDS) as! [[String:AnyObject]]

        let titlePanel = DrawListTitle("二度医脉", panel: Level2FriendsPanel)
        
        var cellView: UIView? = titlePanel
        for doc in l2Doc {
            let allowed = YMVar.GetStringByKey(doc, key: "friends_friends_appointment_switch", defStr: "1")
            if(allowed != "1") {
                continue
            }
            cellView = DrawFriendsCell(
                [
                    YMYiMaiStrings.CS_DATA_KEY_USERHEAD:"\(doc["head_url"]!)",
                    YMYiMaiStrings.CS_DATA_KEY_NAME:"\(doc["name"]!)",
                    YMYiMaiStrings.CS_DATA_KEY_HOSPATIL:"\(doc["hospital"]!)",
                    YMYiMaiStrings.CS_DATA_KEY_DEPARTMENT:"\(doc["department"]!)",
                    YMYiMaiStrings.CS_DATA_KEY_JOB_TITLE:"\(doc["job_title"]!)",
                    YMYiMaiStrings.CS_DATA_KEY_USER_ID:"\(doc["id"]!)",
                    "is_auth": YMVar.GetStringByKey(doc, key: "is_auth")
                    
                ],  docPanel: Level2FriendsPanel, prevCell: cellView
            )
        }
        
//        var cellView = DrawFriendsCell(
//            [
//                YMYiMaiStrings.CS_DATA_KEY_USERHEAD:"test",
//                YMYiMaiStrings.CS_DATA_KEY_NAME:"武瑞鑫",
//                YMYiMaiStrings.CS_DATA_KEY_HOSPATIL:"中国医学科学院北京协和医院",
//                YMYiMaiStrings.CS_DATA_KEY_DEPARTMENT:"功能神经外科",
//                YMYiMaiStrings.CS_DATA_KEY_JOB_TITLE:"主任医师",
//                YMYiMaiStrings.CS_DATA_KEY_USER_ID:"1"
//                
//            ], docPanel: Level2FriendsPanel, prevCell: titlePanel
//        )
        
        Level2FriendsPanel.frame = CGRect(
            x: Level2FriendsPanel.frame.origin.x,
            y: Level2FriendsPanel.frame.origin.y,
            width: Level2FriendsPanel.frame.width,
            height: cellView!.frame.origin.y + cellView!.height
        )
    }
}

















