//
//  PageYiMaiManualAddFriendBodyView.swift
//  YiMai
//
//  Created by why on 16/5/26.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageYiMaiManualAddFriendBodyView: PageBodyView {
    private var SearchTextFeild: YMTextField? = nil
    private let SearchPanel: UIView = UIView()
    private var ResultPanel: UIView? = nil

    private var AlreadyButton: YMTouchableView? = nil
    private var AddButton: YMTouchableView? = nil
    private var InviteButton: YMTouchableView? = nil
    private var AlertButton: UIView? = nil
    
    override func ViewLayout() {
        YMLayout.BodyLayoutWithTop(ParentView!, bodyView: BodyView)
        BodyView.backgroundColor = YMColors.PanelBackgroundGray
        
        DrawSearchPanel()
    }
    
    public func DrawSpecialQRButton(topView: UIView) {
        let qrButton = YMLayout.GetTouchableImageView(useObject: Actions!, useMethod: "QRScan:".Sel(), imageName: "TopViewQRButton")
        
        topView.addSubview(qrButton)
        qrButton.anchorInCorner(Corner.BottomRight, xPad: 30.LayoutVal(), yPad: 24.LayoutVal(), width: qrButton.width, height: qrButton.height)
    }
    
    private func DrawSearchPanel() {
        BodyView.addSubview(SearchPanel)
        SearchPanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 130.LayoutVal())
        let createParam = TextFieldCreateParam()
        
        createParam.BackgroundColor = YMColors.White
        createParam.FontSize = 30.LayoutVal()
        createParam.FontColor = YMColors.FontBlue
        createParam.Placholder = "医脉码或手机号"
        SearchTextFeild = YMLayout.GetTextFieldWithMaxCharCount(createParam, maxCharCount: 60)
        SearchTextFeild?.keyboardType = UIKeyboardType.ASCIICapable
        
        let leftPaddingView = UIView(frame: CGRect(x: 0,y: 0,width: 90.LayoutVal(), height: 130.LayoutVal()))
        let searchIcon = YMLayout.GetSuitableImageView("YiMaiGeneralSearchIcon")
        
        leftPaddingView.addSubview(searchIcon)
        searchIcon.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: searchIcon.width, height: searchIcon.height)
        
        SearchTextFeild?.SetLeftPadding(leftPaddingView)
        SearchTextFeild?.SetRightPaddingWidth(170.LayoutVal())
        
        SearchPanel.addSubview(SearchTextFeild!)
        SearchTextFeild?.fillSuperview()
        
        let searchButton = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "SearchFriend:".Sel())
        
        let searchButtonBkg = YMLayout.GetSuitableImageView("YiMaiManualAddFriendSearchButton")
        let searchButtonLabel = UILabel()
        searchButtonLabel.text = "确定"
        searchButtonLabel.textColor = YMColors.White
        searchButtonLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        searchButtonLabel.sizeToFit()

        searchButton.addSubview(searchButtonBkg)
        searchButton.addSubview(searchButtonLabel)
        
        SearchPanel.addSubview(searchButton)
        searchButton.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: 86.LayoutVal(), height: 40.LayoutVal())
        searchButtonLabel.anchorInCenter(width: searchButtonLabel.width, height: searchButtonLabel.height)
    }
    
    private func DrawResultPanel(data: [String: AnyObject]) {
        if(nil != ResultPanel){
            ResultPanel?.hidden = false
            return
        }
        ResultPanel = UIView()
        
        let head = data[YMYiMaiStrings.CS_DATA_KEY_USERHEAD] as! String
        let name = data[YMYiMaiStrings.CS_DATA_KEY_NAME] as! String
        let hospital = data[YMYiMaiStrings.CS_DATA_KEY_HOSPATIL] as? String
        let department = data[YMYiMaiStrings.CS_DATA_KEY_DEPARTMENT] as? String
        let jobTitle = data[YMYiMaiStrings.CS_DATA_KEY_JOB_TITLE] as? String
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
        
        let cell = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "FriendCellTouched:".Sel(), userStringData: userId)
        
        cell.addSubview(userHeadBackground)
        cell.addSubview(nameLabel)
        cell.addSubview(divider)
        cell.addSubview(jobTitleLabel)
        cell.addSubview(deptLabel)
        cell.addSubview(hosLabel)
        
        cell.backgroundColor = YMColors.White
        
        BodyView.addSubview(ResultPanel!)
        ResultPanel!.align(Align.UnderMatchingLeft, relativeTo: SearchPanel, padding: 50.LayoutVal(), width: YMSizes.PageWidth, height: 150.LayoutVal())
        ResultPanel!.addSubview(cell)
        cell.fillSuperview()
        
        userHeadBackground.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: userHeadBackground.width, height: userHeadBackground.height)
        nameLabel.anchorInCorner(Corner.TopLeft, xPad: 180.LayoutVal(), yPad: 25.LayoutVal(), width: nameLabel.width, height: nameLabel.height)
        divider.align(Align.ToTheRightCentered, relativeTo: nameLabel, padding: 15.LayoutVal(), width: YMSizes.OnPx, height: divider.height)
        jobTitleLabel.align(Align.ToTheRightCentered, relativeTo: divider, padding: 15.LayoutVal(), width: jobTitleLabel.width, height: jobTitleLabel.height)
        deptLabel.align(Align.UnderMatchingLeft, relativeTo: nameLabel, padding: 6.LayoutVal(), width: deptLabel.width, height: deptLabel.height)
        hosLabel.align(Align.UnderMatchingLeft, relativeTo: deptLabel, padding: 6.LayoutVal(), width: 540.LayoutVal(), height: hosLabel.height)
        
        YMLayout.LoadImageFromServer(userHeadBackground, url: head, fullUrl: nil, makeItRound: true)
    }
    
    private func DrawAddButton(data: [String: AnyObject]? = nil) {
        if(nil != AddButton){
            AddButton?.UserObjectData = data
            AddButton?.hidden = false
            return
        }
        AddButton = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "AddFriend:".Sel())
        AddButton?.UserObjectData = data

        let buttonBkg = YMLayout.GetSuitableImageView("YiMaiManualAddFriendButton")
        let titleLabel = UILabel()
        
        BodyView.addSubview(AddButton!)
        AddButton?.align(Align.UnderCentered, relativeTo: ResultPanel!, padding: 80.LayoutVal(), width: 670.LayoutVal(), height: 90.LayoutVal())

        AddButton?.addSubview(buttonBkg)
        AddButton?.addSubview(titleLabel)

        buttonBkg.fillSuperview()

        titleLabel.text = "添加"
        titleLabel.textColor = YMColors.White
        titleLabel.font = YMFonts.YMDefaultFont(36.LayoutVal())
        titleLabel.sizeToFit()

        titleLabel.anchorInCenter(width: titleLabel.width, height: titleLabel.height)
    }
    
    private func DrawAlreadyButton() {
        if(nil != AlreadyButton){
            AlreadyButton?.hidden = false
            return
        }
        AlreadyButton = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "AddFriend:".Sel())
        
        let buttonBkg = YMLayout.GetSuitableImageView("YiMaiManualAddFriendInviladNum")
        let titleLabel = UILabel()
        
        BodyView.addSubview(AlreadyButton!)
        AlreadyButton?.align(Align.UnderCentered, relativeTo: ResultPanel!, padding: 80.LayoutVal(), width: 670.LayoutVal(), height: 90.LayoutVal())
        
        AlreadyButton?.addSubview(buttonBkg)
        AlreadyButton?.addSubview(titleLabel)
        
        buttonBkg.fillSuperview()
        
        titleLabel.text = "你们已经是好友了"
        titleLabel.textColor = YMColors.FontGray
        titleLabel.font = YMFonts.YMDefaultFont(36.LayoutVal())
        titleLabel.sizeToFit()
        
        titleLabel.anchorInCenter(width: titleLabel.width, height: titleLabel.height)
    }
    
    private func DrawInviteButton() {
        if(nil != InviteButton){
            InviteButton?.hidden = false
            return
        }
        InviteButton = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "InvitFriend:".Sel())
        
        let buttonBkg = YMLayout.GetSuitableImageView("YiMaiManualAddFriendButton")
        let titleLabel = UILabel()
        
        BodyView.addSubview(InviteButton!)
        InviteButton?.align(Align.UnderCentered, relativeTo: SearchPanel, padding: 80.LayoutVal(), width: 670.LayoutVal(), height: 90.LayoutVal())
        
        InviteButton?.addSubview(buttonBkg)
        InviteButton?.addSubview(titleLabel)
        
        buttonBkg.fillSuperview()
        
        titleLabel.text = "邀请加入医脉"
        titleLabel.textColor = YMColors.White
        titleLabel.font = YMFonts.YMDefaultFont(36.LayoutVal())
        titleLabel.sizeToFit()
        
        titleLabel.anchorInCenter(width: titleLabel.width, height: titleLabel.height)

    }
    
    private func DrawAlertButton() {
        if(nil != AlertButton){
            AlertButton?.hidden = false
            return
        }
        AlertButton = UIView()
        
        let buttonBkg = YMLayout.GetSuitableImageView("YiMaiManualAddFriendInviladNum")
        let titleLabel = UILabel()

        BodyView.addSubview(AlertButton!)
        AlertButton?.align(Align.UnderCentered, relativeTo: SearchPanel, padding: 80.LayoutVal(), width: 670.LayoutVal(), height: 90.LayoutVal())
        
        AlertButton?.addSubview(buttonBkg)
        AlertButton?.addSubview(titleLabel)
        
        buttonBkg.fillSuperview()
        
        titleLabel.text = "无效号码"
        titleLabel.textColor = YMColors.NotifyFlagOrange
        titleLabel.font = YMFonts.YMDefaultFont(36.LayoutVal())
        titleLabel.sizeToFit()
        
        titleLabel.anchorInCenter(width: titleLabel.width, height: titleLabel.height)
    }
    
    public func ClearBody() {
        ResultPanel?.hidden = true
        AddButton?.hidden = true
        InviteButton?.hidden = true
        AlertButton?.hidden = true
        AlreadyButton?.hidden = true
    }
    
    public func ClearInput() {
        SearchTextFeild?.text = ""
    }
    
    public func ShowAddPage(data: [String : AnyObject]) {
        ClearBody()
        DrawResultPanel(data)
        
        let isFriend = data["is_friend"] as? Int
        if(nil != isFriend) {
            if(1 == isFriend) {
                DrawAlertButton()
            } else {
                DrawAddButton(data)
            }
        } else {
            DrawAddButton(data)
        }
    }
    
    public func ShowInvitePage() {
        ClearBody()
        DrawInviteButton()
    }
    
    public func ShowAlertPage() {
        ClearBody()
        DrawAlertButton()
    }
    
    public func GetInputCode() -> String {
        let code = SearchTextFeild?.text
        if(nil == code){return ""}
        return code!
    }
}
























