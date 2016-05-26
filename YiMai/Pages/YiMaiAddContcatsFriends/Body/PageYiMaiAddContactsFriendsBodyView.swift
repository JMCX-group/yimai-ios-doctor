//
//  PageYiMaiAddContcatsFriendsBodyView.swift
//  YiMai
//
//  Created by why on 16/5/26.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageYiMaiAddContactsFriendsBodyView: PageBodyView {
    private let LoadingProgressBar = UIView()
    private let LoadingAniPanel = UIView()
    private var LoadingTextLine1 = UILabel()
    private var LoadingTextLine2 = UILabel()
    private var LoadingTextLine3 = UILabel()
    
    private var SearchInput: YMTextField? = nil
    private let SearchPanel = UIView()
    private let FriendsPanel = UIView()
    
    override func ViewLayout() {
        YMLayout.BodyLayoutWithTop(ParentView!, bodyView: BodyView)
        BodyView.backgroundColor = YMColors.PanelBackgroundGray
        
        DrawLoading()
    }

    public func DrawSpecialManualAddButton(topView: UIView) {
        let manualAddButton = YMButton()
        
        topView.addSubview(manualAddButton)
        manualAddButton.setTitle("直接添加", forState: UIControlState.Normal)
        manualAddButton.titleLabel?.font = YMFonts.YMDefaultFont(30.LayoutVal())
        manualAddButton.titleLabel?.textColor = YMColors.White
        manualAddButton.sizeToFit()
        manualAddButton.anchorInCorner(Corner.TopRight, xPad: 30.LayoutVal(), yPad: 54.LayoutVal(), width: manualAddButton.width, height: manualAddButton.height)
        manualAddButton.UserStringData = YMCommonStrings.CS_PAGE_YIMAI_MANUAL_ADD_FRIEND_NAME
        
        manualAddButton.addTarget(self.Actions!, action: PageJumpActions.PageJumToSel, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func DrawLoading() {
        func buildTextLine(text: String) -> UILabel {
            let line = UILabel()
            
            line.text = text
            line.font = YMFonts.YMDefaultFont(30.LayoutVal())
            line.textColor = YMColors.FontGray
            line.sizeToFit()
            
            return line
        }
        
        LoadingTextLine1 = buildTextLine("您的医脉资源正在识别中")
        LoadingTextLine2 = buildTextLine("为了更好的与医生好友互动")
        LoadingTextLine3 = buildTextLine("请稍后去完善您的个人资料")
        
        BodyView.addSubview(LoadingTextLine1)
        BodyView.addSubview(LoadingTextLine2)
        BodyView.addSubview(LoadingTextLine3)
        
        LoadingTextLine1.anchorToEdge(Edge.Top, padding: 230.LayoutVal(), width: LoadingTextLine1.width, height: LoadingTextLine1.height)
        LoadingTextLine2.align(Align.UnderCentered, relativeTo: LoadingTextLine1, padding: 20.LayoutVal(), width: LoadingTextLine2.width, height: LoadingTextLine2.height)
        LoadingTextLine3.align(Align.UnderCentered, relativeTo: LoadingTextLine2, padding: 20.LayoutVal(), width: LoadingTextLine3.width, height: LoadingTextLine3.height)
        
        let loadBkg = YMLayout.GetSuitableImageView("YiMaiAddContactsBlueProgressBackground")

        LoadingProgressBar.backgroundColor = YMColors.ProgressBarBlue
        
        LoadingAniPanel.addSubview(loadBkg)
        LoadingAniPanel.addSubview(LoadingProgressBar)

        BodyView.addSubview(LoadingAniPanel)
        LoadingAniPanel.align(Align.UnderCentered, relativeTo: LoadingTextLine3, padding: 70.LayoutVal(), width: 600.LayoutVal(), height: 16.LayoutVal())
        loadBkg.fillSuperview()
        LoadingProgressBar.anchorAndFillEdge(Edge.Left, xPad: 0.LayoutVal(), yPad: 0.LayoutVal(), otherSize: 16.LayoutVal())
        
        LoadingProgressBar.layer.cornerRadius = LoadingProgressBar.height / 2
        LoadingProgressBar.layer.masksToBounds = true

        UIView.animateWithDuration(2.3, animations: { () -> Void in
                self.LoadingProgressBar.frame = CGRect(x: 0,y: 0,width: 600.LayoutVal(), height: self.LoadingProgressBar.height)
            }, completion: self.ClearLoadingAndShowResult)
    }
    
    private func ClearLoadingAndShowResult(ani: Bool) {
        LoadingAniPanel.removeFromSuperview()
        LoadingTextLine1.removeFromSuperview()
        LoadingTextLine2.removeFromSuperview()
        LoadingTextLine3.removeFromSuperview()
        
        ShowResult()
    }
    
    private func ShowResult() {
        DrawSearchPanel()
        DrawFriendsList()
    }
    
    private func DrawSearchPanel() {
        let searchInputParam = TextFieldCreateParam()
        let searchIconView = UIView(frame: CGRect(x: 0,y: 0,width: 66.LayoutVal(),height: 60.LayoutVal()))
        let searchIcon = YMLayout.GetSuitableImageView("YiMaiGeneralSearchIcon")
        
        searchInputParam.BackgroundImageName = "YiMaiGeneralLongSearchBackground"
        searchInputParam.Placholder = YiMaiAddContactsFriendsStrings.CS_SEARCH_PLACEHOLDER
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
    
    private func DrawFriendsList() {
        BodyView.addSubview(FriendsPanel)
        FriendsPanel.align(Align.UnderMatchingLeft, relativeTo: SearchPanel, padding: 0, width: YMSizes.PageWidth, height: 0)
        
        let titleLabel = UILabel()
        
        titleLabel.text = "根据可查询的数据，以下3位联系人可能是医生"
        titleLabel.font = YMFonts.YMDefaultFont(24.LayoutVal())
        titleLabel.textColor = YMColors.FontGray
        
        let topLine = UIView()
        FriendsPanel.addSubview(topLine)
        topLine.backgroundColor = YMColors.DividerLineGray
        topLine.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: 1.LayoutVal())
        
        FriendsPanel.addSubview(titleLabel)
        titleLabel.anchorAndFillEdge(Edge.Top, xPad: 40.LayoutVal(), yPad: 1.LayoutVal(), otherSize: 51.LayoutVal())
        
        var cell = self.DrawFriendsCell([
            YiMaiAddContactsFriendsStrings.CS_DATA_KEY_NAME: "池帅",
            YiMaiAddContactsFriendsStrings.CS_DATA_KEY_HOSPATIL: "鸡西矿业总医院医疗集团二道河子中心医院",
            YiMaiAddContactsFriendsStrings.CS_DATA_KEY_DEPARTMENT: "心血管外科",
            YiMaiAddContactsFriendsStrings.CS_DATA_KEY_JOB_TITLE: "主任医师"
            ], prevCell: nil)
        
        cell = self.DrawFriendsCell([
            YiMaiAddContactsFriendsStrings.CS_DATA_KEY_NAME: "方欣雨",
            YiMaiAddContactsFriendsStrings.CS_DATA_KEY_HOSPATIL: "牡丹江市西安区先锋医院江滨社区第一卫生服务站",
            YiMaiAddContactsFriendsStrings.CS_DATA_KEY_DEPARTMENT: "小儿营养保健科",
            YiMaiAddContactsFriendsStrings.CS_DATA_KEY_JOB_TITLE: "主任医师"
            ], prevCell: cell)
        
        cell = self.DrawFriendsCell([
            YiMaiAddContactsFriendsStrings.CS_DATA_KEY_NAME: "武瑞鑫",
            YiMaiAddContactsFriendsStrings.CS_DATA_KEY_HOSPATIL: "中国医学科学院北京协和医院",
            YiMaiAddContactsFriendsStrings.CS_DATA_KEY_DEPARTMENT: "功能神经外科",
            YiMaiAddContactsFriendsStrings.CS_DATA_KEY_JOB_TITLE: "主任医师"
            ], prevCell: cell)
    }
    
    private func DrawFriendsCell(data: [String: AnyObject], prevCell: UIView?) -> UIView {
        let name = data[YiMaiAddContactsFriendsStrings.CS_DATA_KEY_NAME] as! String
        let hospital = data[YiMaiAddContactsFriendsStrings.CS_DATA_KEY_HOSPATIL] as! String
        let department = data[YiMaiAddContactsFriendsStrings.CS_DATA_KEY_DEPARTMENT] as! String
        let jobTitle = data[YiMaiAddContactsFriendsStrings.CS_DATA_KEY_JOB_TITLE] as! String
        
        let cell = UIView(frame: CGRect(x: 0,y: 0,width: YMSizes.PageWidth,height: 136.LayoutVal()))
        
        let nameLabel = UILabel()
        let divider = UIView(frame: CGRect(x: 0,y: 0,width: 1,height: 20.LayoutVal()))
        let jobTitleLabel = UILabel()
        let deptLabel = UILabel()
        let hosLabel = UILabel()
        let addButton = YMLayout.GetTouchableImageView(useObject: Actions!, useMethod: "PostAddFriends:", imageName: "YiMaiAddContactsFriendButton")
        let bottomLine = UIView()
        
        bottomLine.backgroundColor = YMColors.DividerLineGray
        
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
        
        let infoCell = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "ShowFriendInfo:")
        
        infoCell.addSubview(nameLabel)
        infoCell.addSubview(divider)
        infoCell.addSubview(jobTitleLabel)
        infoCell.addSubview(deptLabel)
        infoCell.addSubview(hosLabel)
        cell.addSubview(infoCell)
        cell.addSubview(addButton)
        cell.addSubview(bottomLine)
        
        FriendsPanel.addSubview(cell)
        
        if(nil == prevCell) {
            cell.anchorToEdge(Edge.Top, padding: 51.LayoutVal(), width: YMSizes.PageWidth, height: cell.height)
        } else {
            cell.alignAndFillWidth(align: Align.UnderMatchingLeft, relativeTo: prevCell!, padding: 1, height: cell.height)
        }
        
        infoCell.fillSuperview()
        
        nameLabel.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 20.LayoutVal(), width: nameLabel.width, height: nameLabel.height)
        divider.align(Align.ToTheRightCentered, relativeTo: nameLabel, padding: 15.LayoutVal(), width: 1, height: divider.height)
        jobTitleLabel.align(Align.ToTheRightCentered, relativeTo: divider, padding: 15.LayoutVal(), width: jobTitleLabel.width, height: jobTitleLabel.height)
        deptLabel.align(Align.UnderMatchingLeft, relativeTo: nameLabel, padding: 6.LayoutVal(), width: deptLabel.width, height: deptLabel.height)
        hosLabel.align(Align.UnderMatchingLeft, relativeTo: deptLabel, padding: 6.LayoutVal(), width: 540.LayoutVal(), height: hosLabel.height)
        
        addButton.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: addButton.width, height: addButton.height)
        
        bottomLine.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: 1.LayoutVal())
        
        return cell
    }
}


































