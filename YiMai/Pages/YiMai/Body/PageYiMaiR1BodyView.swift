//
//  PageYiMaiR1BodyView.swift
//  YiMai
//
//  Created by why on 16/5/24.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageYiMaiR1BodyView: PageBodyView {
    private var SearchInput: YMTextField? = nil
    private var SameHopitalButton: YMTouchableView? = nil
    private var SameSchoolButton: YMTouchableView? = nil
    private var SameAreasButton: YMTouchableView? = nil
    
    private let SearchPanel = UIView()
    private let OperationPanel = UIView()
    private let NewFriendsPanel = UIView()
    private let FriendsPanel = UIView()
    
    private let OperationSelector:Selector = "PageJumpToByViewSender:".Sel()
    private let FriendCellTouched: Selector = "FriendButtonTouched:".Sel()

    override func ViewLayout() {
        YMLayout.BodyLayoutWithTop(ParentView!, bodyView: BodyView)
        BodyView.backgroundColor = YMColors.BackgroundGray
        
        DrawSearchPanel()
        DrawOptPanel()
        DrawNewFriendsPanel()
        DrawFriendsPanel()
    }

    private func DrawOptPanel() {
        BodyView.addSubview(OperationPanel)
        
        OperationPanel.alignAndFillWidth(align: Align.UnderMatchingLeft, relativeTo: SearchPanel, padding: 0, height: 200.LayoutVal())
        
        func BuildOpertorCell(cell: YMTouchableView, imageName: String, targetPage: String, title: String, count: String?) {
            let icon = YMLayout.GetSuitableImageView(imageName)
            let titleLabel = UILabel()
            
            
            cell.addSubview(icon)
            cell.addSubview(titleLabel)
            
            icon.anchorToEdge(Edge.Top, padding: 0, width: icon.width, height: icon.height)
            titleLabel.alignAndFillWidth(align: Align.UnderCentered, relativeTo: icon, padding: -100.LayoutVal(), height: 30.LayoutVal())
            
            titleLabel.text = title
            titleLabel.font = YMFonts.YMDefaultFont(30.LayoutVal())
            titleLabel.textColor = YMColors.FontBlue
            titleLabel.textAlignment = NSTextAlignment.Center
            
            
            if(nil != count && "" != count) {
                let countLabel = UILabel()
                cell.addSubview(countLabel)
                
                countLabel.text = count
                countLabel.font = YMFonts.YMDefaultFont(20.LayoutVal())
                countLabel.textColor = YMColors.FontGray
                countLabel.textAlignment = NSTextAlignment.Center
                countLabel.backgroundColor = YMColors.BackgroundGray
                countLabel.sizeToFit()
                
                countLabel.align(Align.UnderCentered, relativeTo: titleLabel, padding: 18.LayoutVal(), width: countLabel.width+40.LayoutVal(), height: 28.LayoutVal())
                
                countLabel.layer.cornerRadius = countLabel.bounds.height / 2
                countLabel.layer.masksToBounds = true;
            }
        }
        
        SameHopitalButton = YMLayout.GetTouchableView(useObject: Actions!, useMethod: OperationSelector, userStringData: YMCommonStrings.CS_PAGE_YIMAI_SAME_HOSPITAL_NAME)
        SameSchoolButton = YMLayout.GetTouchableView(useObject: Actions!, useMethod: OperationSelector, userStringData: YMCommonStrings.CS_PAGE_YIMAI_SAME_SCHOOL_NAME)
        SameAreasButton = YMLayout.GetTouchableView(useObject: Actions!, useMethod: OperationSelector, userStringData: YMCommonStrings.CS_PAGE_YIMAI_SAME_AREAS_NAME)
        
        OperationPanel.addSubview(SameHopitalButton!)
        OperationPanel.addSubview(SameAreasButton!)
        OperationPanel.addSubview(SameSchoolButton!)

        OperationPanel.groupAndFill(group: Group.Horizontal, views: [SameHopitalButton!, SameAreasButton!, SameSchoolButton!], padding: 1)
        
        let same = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_SAME_INFO) as! [String: AnyObject]
        
        BuildOpertorCell(SameHopitalButton!, imageName: "YiMaiR1SameHospital", targetPage: "", title: "同医院", count: "\(same["hospital"]!)人")
        BuildOpertorCell(SameAreasButton!, imageName: "YiMaiR1SameAreas", targetPage: "", title: "同领域", count: "\(same["department"]!)人")
        BuildOpertorCell(SameSchoolButton!, imageName: "YiMaiR1SameSchool", targetPage: "", title: "同学校", count: "\(same["college"]!)人")
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
    
    private func DrawNewFriendsPanel() {
        BodyView.addSubview(NewFriendsPanel)
        NewFriendsPanel.alignAndFillWidth(align: Align.UnderMatchingLeft, relativeTo: OperationPanel, padding: 0, height: 130.LayoutVal())

        let newFriends = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_NEW_FRIENDS) as! [[String:AnyObject]]
        
        var i = 0
        for f in newFriends {
            let status = "\(f["status"]!)"
            
            if("isFriend" == status){
                i += 1
            }
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "我的新朋友（新增\(i)人）"
        titleLabel.textColor = YMColors.FontGray
        titleLabel.font = YMFonts.YMDefaultFont(24.LayoutVal())
        titleLabel.sizeToFit()
        
        NewFriendsPanel.addSubview(titleLabel)
        titleLabel.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 0, width: titleLabel.width, height: 50.LayoutVal())
        
        let newFriendsButton = YMLayout.GetTouchableView(useObject: Actions!, useMethod: OperationSelector)
        
        let icon = YMLayout.GetSuitableImageView("YiMaiR1NewFriendsIcon")
        newFriendsButton.addSubview(icon)
        
        let dividerLine = UIView()
        dividerLine.backgroundColor = YMColors.FontBlue
        newFriendsButton.addSubview(dividerLine)
        
        let buttonText = UILabel()
        buttonText.text = "新朋友"
        buttonText.font = YMFonts.YMDefaultFont(30.LayoutVal())
        buttonText.textColor = YMColors.FontBlue
        buttonText.sizeToFit()
        newFriendsButton.addSubview(buttonText)
        
        let notifyPoint = UIView()
        notifyPoint.backgroundColor = YMColors.NotifyFlagOrange
        notifyPoint.frame = CGRect(x: 0,y: 0,width: 10.LayoutVal(),height: 10.LayoutVal())
        notifyPoint.layer.cornerRadius = notifyPoint.bounds.width / 2
        notifyPoint.layer.masksToBounds = true
        newFriendsButton.addSubview(notifyPoint)
        
        NewFriendsPanel.addSubview(newFriendsButton)
        
        newFriendsButton.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: 80.LayoutVal())
        
        icon.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: icon.width, height: icon.height)
        dividerLine.anchorToEdge(Edge.Left, padding: 102.LayoutVal(), width: 1, height: 30.LayoutVal())
        buttonText.anchorToEdge(Edge.Left, padding: 124.LayoutVal(), width: buttonText.width, height: buttonText.height)
        notifyPoint.anchorToEdge(Edge.Left, padding: 225.LayoutVal(), width: notifyPoint.width, height: notifyPoint.height)
    }
    
    private func DrawFriendsCell(data: [String: AnyObject], prevCell: YMTouchableView?) -> YMTouchableView {
        let _ = data[YMYiMaiStrings.CS_DATA_KEY_USERHEAD] as! String
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
            cell.anchorToEdge(Edge.Top, padding: 50.LayoutVal(), width: YMSizes.PageWidth, height: 151.LayoutVal())
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
        FriendsPanel.alignAndFillWidth(align: Align.UnderMatchingLeft, relativeTo: NewFriendsPanel, padding: 0, height: 0)
        
        let l1Doc = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_L1_FRIENDS) as! [[String:AnyObject]]
        let l1DocCnt = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_L1_FRIENDS_COUNT_INFO) as! [String: AnyObject]
        
        let  titleLabel = UILabel()
        titleLabel.text = "我的朋友（\(l1DocCnt["doctor"]!)名医生 | \(l1DocCnt["hospital"]!)家医院）"
        titleLabel.textColor = YMColors.FontGray
        titleLabel.font = YMFonts.YMDefaultFont(24.LayoutVal())
        titleLabel.sizeToFit()
        
        FriendsPanel.addSubview(titleLabel)
        titleLabel.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 0, width: titleLabel.width, height: 50.LayoutVal())
        
        var cellView:YMTouchableView? = nil
        for doc in l1Doc {
            cellView = DrawFriendsCell(
                [
                    YMYiMaiStrings.CS_DATA_KEY_USERHEAD:"test",
                    YMYiMaiStrings.CS_DATA_KEY_NAME:"\(doc["name"]!)",
                    YMYiMaiStrings.CS_DATA_KEY_HOSPATIL:"\(doc["hospital"]!)",
                    YMYiMaiStrings.CS_DATA_KEY_DEPARTMENT:"\(doc["department"]!)",
                    YMYiMaiStrings.CS_DATA_KEY_JOB_TITLE:"\(doc["job_title"]!)",
                    YMYiMaiStrings.CS_DATA_KEY_USER_ID:"\(doc["id"]!)"
                    
                ], prevCell: cellView
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
//            ], prevCell: nil
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
//            ], prevCell: cellView
//        )
//        
//        cellView = DrawFriendsCell(
//            [
//                YMYiMaiStrings.CS_DATA_KEY_USERHEAD:"test",
//                YMYiMaiStrings.CS_DATA_KEY_NAME:"武瑞鑫",
//                YMYiMaiStrings.CS_DATA_KEY_HOSPATIL:"中国医学科学院北京协和医院",
//                YMYiMaiStrings.CS_DATA_KEY_DEPARTMENT:"功能神经外科",
//                YMYiMaiStrings.CS_DATA_KEY_JOB_TITLE:"主任医师",
//                YMYiMaiStrings.CS_DATA_KEY_USER_ID:"1"
//                
//            ], prevCell: cellView
//        )
    }
}

















































