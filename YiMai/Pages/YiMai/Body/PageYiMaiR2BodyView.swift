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
    public var SearchInput: YMTextField? = nil
    private let SearchPanel = UIView()
    private let FriendsPanel = UIView()
    private let FriendCellTouched: Selector = "FriendCellTouched:".Sel()
    
    override func ViewLayout() {
        super.ViewLayout()
        YMLayout.BodyLayoutWithTop(ParentView!, bodyView: BodyView)
        BodyView.backgroundColor = YMColors.BackgroundGray
        BodyView.hidden = true
        
        DrawSearchPanel()
        DrawFriendsPanel()
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: FriendsPanel, padding: YMSizes.NormalBottomSize.height)
    }
    
    public func SetBodyScroll() {
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: FriendsPanel, padding: YMSizes.NormalBottomSize.height)
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
        
        let searchActions = Actions! as? PageYiMaiActions
        SearchInput?.EditEndCallback = searchActions?.DoSearch
        
        SearchInput?.anchorInCenter(width: 690.LayoutVal(), height: 60.LayoutVal())
        searchIconView.addSubview(searchIcon)
        searchIcon.anchorInCenter(width: searchIcon.width, height: searchIcon.height)
        SearchInput?.SetLeftPadding(searchIconView)
    }
    
    private func DrawFriendsCell(data: [String: AnyObject], prevCell: YMTouchableView?) -> YMTouchableView {
        let _ = data[YMYiMaiStrings.CS_DATA_KEY_USERHEAD] as! String
        let name = data[YMYiMaiStrings.CS_DATA_KEY_NAME] as! String
        let hospital = data[YMYiMaiStrings.CS_DATA_KEY_HOSPATIL] as! String
        let department = data[YMYiMaiStrings.CS_DATA_KEY_DEPARTMENT] as! String
        let jobTitle = data[YMYiMaiStrings.CS_DATA_KEY_JOB_TITLE] as! String
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
            cell.alignAndFillWidth(align: Align.UnderMatchingLeft, relativeTo: prevCell!, padding: YMSizes.OnPx, height: 151.LayoutVal())
        }
        
        userHeadBackground.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: userHeadBackground.width, height: userHeadBackground.height)
        nameLabel.anchorInCorner(Corner.TopLeft, xPad: 180.LayoutVal(), yPad: 25.LayoutVal(), width: nameLabel.width, height: nameLabel.height)
        divider.align(Align.ToTheRightCentered, relativeTo: nameLabel, padding: 15.LayoutVal(), width: YMSizes.OnPx, height: divider.height)
        jobTitleLabel.align(Align.ToTheRightCentered, relativeTo: divider, padding: 15.LayoutVal(), width: jobTitleLabel.width, height: jobTitleLabel.height)
        deptLabel.align(Align.UnderMatchingLeft, relativeTo: nameLabel, padding: 6.LayoutVal(), width: deptLabel.width, height: deptLabel.height)
        hosLabel.align(Align.UnderMatchingLeft, relativeTo: deptLabel, padding: 6.LayoutVal(), width: 540.LayoutVal(), height: hosLabel.height)
        
        return cell
    }
    
    private func DrawFriendsPanel() {
        BodyView.addSubview(FriendsPanel)
        FriendsPanel.alignAndFillWidth(align: Align.UnderMatchingLeft, relativeTo: SearchPanel, padding: 0, height: 0)
        
        let l2Doc = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_L2_FRIENDS) as! [[String:AnyObject]]
        let l2DocCnt = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_L2_FRIENDS_COUNT_INFO) as! [String: AnyObject]
        
        let titlePanel = UIView()
        let titleLabel = UILabel()
        titleLabel.text = "朋友的朋友（\(l2DocCnt["doctor"]!)名医生 | \(l2DocCnt["hospital"]!)家医院）"
        titleLabel.textColor = YMColors.FontGray
        titleLabel.font = YMFonts.YMDefaultFont(24.LayoutVal())
        titleLabel.sizeToFit()
        
        titlePanel.addSubview(titleLabel)
        FriendsPanel.addSubview(titlePanel)
        titlePanel.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: 50.LayoutVal())
        titlePanel.backgroundColor = YMColors.White
        titleLabel.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 0, width: titleLabel.width, height: 50.LayoutVal())
        
        var cellView:YMTouchableView? = nil
        for doc in l2Doc {
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
        
        if(nil != cellView) {
            YMLayout.SetViewHeightByLastSubview(FriendsPanel, lastSubView: cellView!)
        }
    }

}