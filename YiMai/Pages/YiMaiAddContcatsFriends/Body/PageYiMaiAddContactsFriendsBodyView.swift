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
    private let OthersPanel = UIView()
    
    private let FriendsListPanel = UIView()
    private let OthersListPanel = UIView()
    
    var FullList = [String: AnyObject]()
    
    private var ListType: String = YiMaiAddContactsFriendsStrings.CS_LIST_TYPE_FRIENDS
    
    private let ShowFriendsListBtn = YMButton()
    private let ShowOthersListBtn = YMButton()

    private let DirectAddButton = YMButton()
    
    public var ContactsInYiMaiResult = [String]()
    public var ContactsInOtherResult = [String]()
    
    override func ViewLayout() {
        YMLayout.BodyLayoutWithTop(ParentView!, bodyView: BodyView)
        BodyView.backgroundColor = YMColors.PanelBackgroundGray
        
        DrawLoading()
    }

    public func DrawSpecialManualAddButton(topView: UIView) {
        topView.addSubview(DirectAddButton)
        DirectAddButton.setTitle("直接添加", forState: UIControlState.Normal)
        DirectAddButton.titleLabel?.font = YMFonts.YMDefaultFont(30.LayoutVal())
        DirectAddButton.titleLabel?.textColor = YMColors.White
        DirectAddButton.sizeToFit()
        DirectAddButton.anchorInCorner(Corner.TopRight, xPad: 30.LayoutVal(), yPad: 54.LayoutVal(),
                                       width: DirectAddButton.width, height: DirectAddButton.height)
        DirectAddButton.UserStringData = YMCommonStrings.CS_PAGE_YIMAI_MANUAL_ADD_FRIEND_NAME
        
        DirectAddButton.addTarget(self.Actions!, action: PageJumpActions.PageJumToSel, forControlEvents: UIControlEvents.TouchUpInside)
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
        
        LoadingTextLine1.hidden = true
        LoadingTextLine2.hidden = true
        LoadingTextLine3.hidden = true
        
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
        
        LoadingAniPanel.hidden = true

        BodyView.addSubview(LoadingAniPanel)
        LoadingAniPanel.align(Align.UnderCentered, relativeTo: LoadingTextLine3, padding: 70.LayoutVal(), width: 600.LayoutVal(), height: 16.LayoutVal())
        loadBkg.fillSuperview()
        LoadingProgressBar.anchorAndFillEdge(Edge.Left, xPad: 0.LayoutVal(), yPad: 0.LayoutVal(), otherSize: 16.LayoutVal())
        
        LoadingProgressBar.layer.cornerRadius = LoadingProgressBar.height / 2
        LoadingProgressBar.layer.masksToBounds = true

//        YMAddressBookTools.AllContacts.removeAll()
//        let a = YMAddressBookTools()
//        a.ReadAddressBook()
        
        DirectAddButton.hidden = true
        let prevContact  = YMLocalData.GetData("YMLoaclContactAddressBook") as? [[String: String]]
        if(nil == prevContact) {
            LoadingTextLine1.hidden = false
            LoadingTextLine2.hidden = false
            LoadingTextLine3.hidden = false
            LoadingAniPanel.hidden = false
            
            UIView.animateWithDuration(2.3, animations: { () -> Void in
                self.LoadingProgressBar.frame = CGRect(x: 0,y: 0,width: 600.LayoutVal(), height: self.LoadingProgressBar.height)
                }, completion: self.ClearLoadingAndShowResult)
        } else {
            YMDelay(0.1, closure: { 
                self.ClearLoadingAndShowResult(true)

            })
        }
    }
    
    private func ClearLoadingAndShowResult(ani: Bool) {
        LoadingAniPanel.removeFromSuperview()
        LoadingTextLine1.removeFromSuperview()
        LoadingTextLine2.removeFromSuperview()
        LoadingTextLine3.removeFromSuperview()
        DirectAddButton.hidden = false
        
        let action: YiMaiAddContactsFriendsActions = self.Actions as! YiMaiAddContactsFriendsActions
        let controller: PageYiMaiAddContatsFriendsViewController = action.Target as! PageYiMaiAddContatsFriendsViewController
        
        controller.LoadingView?.Show()
        action.UploadAddressBook()
    }
    
    public func ShowResult(data: [String: AnyObject], drawSearch: Bool = true, listType: String = YiMaiAddContactsFriendsStrings.CS_LIST_TYPE_OTHERS) {
        if(drawSearch) {
            DrawSearchPanel()
        }
        
        let friendsData = data["friends"] as? [[String: AnyObject]]
        let othersData = data["others"] as? [[String: AnyObject]]
        if(nil != friendsData) {
            DrawFriendsList(friendsData!)
        } else {
            DrawFriendsList([[String: AnyObject]]())
            ListType = listType
        }
        
        if(nil != othersData) {
            DrawOtherList(othersData!)
        } else {
            DrawOtherList([[String: AnyObject]]())
        }
        
        if(YiMaiAddContactsFriendsStrings.CS_LIST_TYPE_FRIENDS == ListType) {
            ShowFriendsList()
        } else if(YiMaiAddContactsFriendsStrings.CS_LIST_TYPE_OTHERS == ListType) {
            ShowOthersList()
        }
    }
    
    public func ShowFriendsList() {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)
        
        FriendsListPanel.hidden = false
        OthersListPanel.hidden = true

        ShowFriendsListBtn.hidden = true
        ShowOthersListBtn.hidden = false

        YMLayout.SetViewHeightByLastSubview(FriendsPanel, lastSubView: FriendsListPanel)
        YMLayout.SetViewHeightByLastSubview(OthersPanel, lastSubView: ShowOthersListBtn)
        
        OthersPanel.align(Align.UnderMatchingLeft, relativeTo: FriendsPanel, padding: 10.LayoutVal(), width: OthersPanel.width, height: OthersPanel.height)
//        BodyView.contentOffset = CGPoint()
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
        UIView.commitAnimations()
        
        let action: YiMaiAddContactsFriendsActions = self.Actions as! YiMaiAddContactsFriendsActions
        let controller: PageYiMaiAddContatsFriendsViewController = action.Target as! PageYiMaiAddContatsFriendsViewController
        
        controller.BottomButton?.EnableAddButton()
        
        ListType = YiMaiAddContactsFriendsStrings.CS_LIST_TYPE_FRIENDS
        
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: FriendsListPanel, padding: 128.LayoutVal() + SearchPanel.height)
    }
    
    public func ShowOthersList() {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)
        
        FriendsListPanel.hidden = true
        OthersListPanel.hidden = false
        
        ShowFriendsListBtn.hidden = false
        ShowOthersListBtn.hidden = true
        
        YMLayout.SetViewHeightByLastSubview(OthersPanel, lastSubView: OthersListPanel)
        YMLayout.SetViewHeightByLastSubview(FriendsPanel, lastSubView: ShowFriendsListBtn)

        OthersPanel.align(Align.UnderMatchingLeft, relativeTo: FriendsPanel, padding: 10.LayoutVal(), width: OthersPanel.width, height: OthersPanel.height)
        
//        BodyView.contentOffset = CGPoint()
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
        UIView.commitAnimations()
        
        let action: YiMaiAddContactsFriendsActions = self.Actions as! YiMaiAddContactsFriendsActions
        let controller: PageYiMaiAddContatsFriendsViewController = action.Target as! PageYiMaiAddContatsFriendsViewController
        
        controller.BottomButton?.EnabelInviteButton()
        
        ListType = YiMaiAddContactsFriendsStrings.CS_LIST_TYPE_OTHERS
        
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: OthersListPanel, padding: 128.LayoutVal() + SearchPanel.height)
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
        SearchInput?.EditEndCallback = DoSearch
    }
    
    func DoSearch(_: YMTextField) {
        let searchKey = SearchInput!.text
        
        if(YMValueValidator.IsEmptyString(searchKey)) {
            ShowResult(FullList, drawSearch: false, listType: ListType)
            return
        }
        
        var friendsData = [[String: AnyObject]]()
        var othersData = [[String: AnyObject]]()
        
        let orgFriendsData = FullList["friends"] as? [[String: AnyObject]]
        let orgOthersData = FullList["others"] as? [[String: AnyObject]]
        
        if(nil != orgFriendsData) {
            for docotor in orgFriendsData! {
                var title = docotor["job_title"] as? String
                var hos = docotor["hospital"] as? [String: String]
                var name = docotor["name"] as? String
                var dept = docotor["department"] as? [String: String]
                
                var hosName = ""
                var deptName = ""
                
                if (nil == title) {
                    title = ""
                }
                
                if(nil == name) {
                    name = ""
                }
                
                if(nil != hos) {
                    hosName = hos!["name"]!
                }
                
                if(nil != dept) {
                    deptName = dept!["name"]!
                }
                
                if(name!.containsString(searchKey!)) {
                    friendsData.append(docotor)
                    continue
                }
                
                if(hosName.containsString(searchKey!)) {
                    friendsData.append(docotor)
                    continue
                }
                
                if(deptName.containsString(searchKey!)) {
                    friendsData.append(docotor)
                    continue
                }
            }
        }
        
        if(nil != orgOthersData) {
            for other in orgOthersData! {
                let name = other["name"] as! String
                let phone = other["phone"] as! String
                
                if(name.containsString(searchKey!)) {
                    othersData.append(other)
                    continue
                }
                
                if(phone.containsString(searchKey!)) {
                    othersData.append(other)
                    continue
                }
            }
        }
        
        
        
        ShowResult(["friends": friendsData, "others": othersData], drawSearch: false, listType: ListType)
        
    }
    
    private func DrawOtherList(data: [[String: AnyObject]]) {
        BodyView.addSubview(OthersPanel)
        OthersPanel.align(Align.UnderMatchingLeft, relativeTo: FriendsPanel, padding: 0, width: YMSizes.PageWidth, height: 0)
        
        YMLayout.ClearView(view: OthersPanel)
        if(0 == data.count) {
            return
        }
        
        OthersPanel.addSubview(ShowOthersListBtn)
        ShowOthersListBtn.setTitle("邀请好友加入医脉", forState: UIControlState.Normal)
        ShowOthersListBtn.setTitleColor(YMColors.FontBlue, forState: UIControlState.Normal)
        ShowOthersListBtn.backgroundColor = YMColors.PanelBackgroundGray
        ShowOthersListBtn.titleLabel?.font = YMFonts.YMDefaultFont(30.LayoutVal())
        ShowOthersListBtn.addTarget(self.Actions!, action: "ShowOthersListTouched:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        ShowOthersListBtn.anchorToEdge(Edge.Top, padding: 10.LayoutVal(), width: YMSizes.PageWidth, height: 60.LayoutVal())

        OthersPanel.addSubview(OthersListPanel)
        OthersListPanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 0)
        YMLayout.ClearView(view: OthersListPanel)

        let titleLabel = UILabel()
        
        titleLabel.text = "您可以邀请以下\(data.count)位好友加入医脉"
        titleLabel.font = YMFonts.YMDefaultFont(24.LayoutVal())
        titleLabel.textColor = YMColors.FontGray
        
        let topLine = UIView()
        OthersListPanel.addSubview(topLine)
        topLine.backgroundColor = YMColors.DividerLineGray
        topLine.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: YMSizes.OnPx)

        OthersListPanel.addSubview(titleLabel)
        titleLabel.anchorAndFillEdge(Edge.Top, xPad: 40.LayoutVal(), yPad: YMSizes.OnPx, otherSize: 51.LayoutVal())
        
        ContactsInOtherResult.removeAll()

        var cell: UIView? = nil
        for other in data {
            let name = other["name"] as! String
            let phone = other["phone"] as! String
            
            let smsStatus = other["sms_status"] as! String

            ContactsInOtherResult.append(phone)

            cell = self.DrawOtherCell([
                YiMaiAddContactsFriendsStrings.CS_DATA_KEY_NAME: name,
                YiMaiAddContactsFriendsStrings.CS_DATA_KEY_PHONE: phone,
                YiMaiAddContactsFriendsStrings.CS_DATA_KEY_SMS_STATUS: smsStatus
                ], prevCell: cell)
        }
        
        YMLayout.SetViewHeightByLastSubview(OthersListPanel, lastSubView: cell!)
        YMLayout.SetViewHeightByLastSubview(OthersPanel, lastSubView: OthersListPanel)
    }
    
    private func DrawFriendsList(data: [[String: AnyObject]]) {
        BodyView.addSubview(FriendsPanel)
        FriendsPanel.align(Align.UnderMatchingLeft, relativeTo: SearchPanel, padding: 0, width: YMSizes.PageWidth, height: 0)

        YMLayout.ClearView(view: FriendsPanel)
        if(0 == data.count) {
            ListType = YiMaiAddContactsFriendsStrings.CS_LIST_TYPE_OTHERS
            return
        }
        
        FriendsPanel.addSubview(ShowFriendsListBtn)
        ShowFriendsListBtn.setTitle("显示医脉资源", forState: UIControlState.Normal)
        ShowFriendsListBtn.setTitleColor(YMColors.FontBlue, forState: UIControlState.Normal)
        ShowFriendsListBtn.backgroundColor = YMColors.PanelBackgroundGray
        ShowFriendsListBtn.titleLabel?.font = YMFonts.YMDefaultFont(30.LayoutVal())
        ShowFriendsListBtn.addTarget(self.Actions!, action: "ShowFriendsListTouched:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        ShowFriendsListBtn.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 60.LayoutVal())
        
        FriendsPanel.addSubview(FriendsListPanel)
        FriendsListPanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 0)
        YMLayout.ClearView(view: FriendsListPanel)
        
        let titleLabel = UILabel()

        titleLabel.text = "根据可查询的数据，您在医脉有\(data.count)位好友"
        titleLabel.font = YMFonts.YMDefaultFont(24.LayoutVal())
        titleLabel.textColor = YMColors.FontGray

        let topLine = UIView()
        FriendsListPanel.addSubview(topLine)
        topLine.backgroundColor = YMColors.DividerLineGray
        topLine.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: YMSizes.OnPx)
        
        FriendsListPanel.addSubview(titleLabel)
        titleLabel.anchorAndFillEdge(Edge.Top, xPad: 40.LayoutVal(), yPad: YMSizes.OnPx, otherSize: 51.LayoutVal())
        
        ContactsInYiMaiResult.removeAll()
        var cell: UIView? = nil
        for docotor in data {
            var title = docotor["job_title"] as? String
            var hos = docotor["hospital"] as? [String: String]
            var name = docotor["name"] as? String
            var dept = docotor["department"] as? [String: String]
            let id = docotor["id"] as! String
            let isAdded = "\(docotor["is_add_friend"]!)"
            
            ContactsInYiMaiResult.append(id)
            
            var hosName = ""
            var deptName = ""
            
            if (nil == title) {
                title = ""
            }
            
            if(nil == name) {
                name = ""
            }
            
            if(nil != hos) {
                hosName = hos!["name"]!
            }
            
            if(nil != dept) {
                deptName = dept!["name"]!
            }
            
            cell = self.DrawFriendsCell([
                YiMaiAddContactsFriendsStrings.CS_DATA_KEY_NAME: name!,
                YiMaiAddContactsFriendsStrings.CS_DATA_KEY_HOSPATIL: hosName,
                YiMaiAddContactsFriendsStrings.CS_DATA_KEY_DEPARTMENT: deptName,
                YiMaiAddContactsFriendsStrings.CS_DATA_KEY_JOB_TITLE: title!,
                YiMaiAddContactsFriendsStrings.CS_DATA_KEY_USER_ID: id,
                YiMaiAddContactsFriendsStrings.CS_DATA_KEY_FRIEND_ADDED: isAdded
                ], prevCell: cell)
        }
        
        YMLayout.SetViewHeightByLastSubview(FriendsListPanel, lastSubView: cell!)
        YMLayout.SetViewHeightByLastSubview(FriendsPanel, lastSubView: FriendsListPanel)
    }
    
    private func DrawOtherCell(data: [String: AnyObject], prevCell: UIView?) -> UIView {
        let name = data[YiMaiAddContactsFriendsStrings.CS_DATA_KEY_NAME] as! String
        let phone = data[YiMaiAddContactsFriendsStrings.CS_DATA_KEY_PHONE] as! String
        let smsStatus = data[YiMaiAddContactsFriendsStrings.CS_DATA_KEY_SMS_STATUS] as! String

        let cell = UIView(frame: CGRect(x: 0,y: 0,width: YMSizes.PageWidth,height: 100.LayoutVal()))
        
        let nameLabel = UILabel()
        let phoneLabel = UILabel()
        let phoneIcon = YMLayout.GetSuitableImageView("YMIconPhone")

        let addButton = YMLayout.GetTouchableImageView(useObject: Actions!,
                                                       useMethod: "InviteOthersRegisterYiMai:".Sel(),
                                                       imageName: "YiMaiAddContactsFriendButton")
        
        let invitedLabel = YMLayout.GetNomalLabel("已邀请", textColor: YMColors.FontLightGray, fontSize: 20.LayoutVal())
        
        addButton.UserStringData = phone
        
        let bottomLine = UIView()
        
        bottomLine.backgroundColor = YMColors.DividerLineGray
        
        nameLabel.text = name
        nameLabel.textColor = YMColors.FontBlue
        nameLabel.font = YMFonts.YMDefaultFont(30.LayoutVal())
        nameLabel.sizeToFit()
        
        phoneLabel.text = phone
        phoneLabel.textColor = YMColors.FontGray
        phoneLabel.font = YMFonts.YMDefaultFont(30.LayoutVal())
        phoneLabel.sizeToFit()
        
        let infoCell = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "ShowFriendInfo:".Sel())
        
        infoCell.addSubview(nameLabel)
        infoCell.addSubview(phoneLabel)

        cell.addSubview(infoCell)
        cell.addSubview(addButton)
        cell.addSubview(phoneIcon)
        cell.addSubview(bottomLine)
        cell.addSubview(invitedLabel)
        
        OthersListPanel.addSubview(cell)
        
        if(nil == prevCell) {
            cell.anchorToEdge(Edge.Top, padding: 51.LayoutVal(), width: YMSizes.PageWidth, height: cell.height)
        } else {
            cell.alignAndFillWidth(align: Align.UnderMatchingLeft, relativeTo: prevCell!, padding: YMSizes.OnPx, height: cell.height)
        }
        
        infoCell.fillSuperview()
        
        nameLabel.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: nameLabel.width, height: nameLabel.height)
        phoneIcon.align(Align.ToTheRightCentered, relativeTo: nameLabel, padding: 32.LayoutVal(), width: phoneIcon.width, height: phoneIcon.height)
        phoneLabel.align(Align.ToTheRightCentered, relativeTo: phoneIcon, padding: 10.LayoutVal(), width: phoneLabel.width, height: phoneLabel.height)
        
        addButton.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: addButton.width, height: addButton.height)
        invitedLabel.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: invitedLabel.width, height: invitedLabel.height)
        
        addButton.UserObjectData = invitedLabel
        
        if("false" == smsStatus) {
            invitedLabel.hidden = true
        } else {
            addButton.hidden = true
        }
        
        bottomLine.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: YMSizes.OnPx)
        
        return cell
    }
    
    private func DrawFriendsCell(data: [String: AnyObject], prevCell: UIView?) -> UIView {
        let name = data[YiMaiAddContactsFriendsStrings.CS_DATA_KEY_NAME] as! String
        let hospital = data[YiMaiAddContactsFriendsStrings.CS_DATA_KEY_HOSPATIL] as! String
        let department = data[YiMaiAddContactsFriendsStrings.CS_DATA_KEY_DEPARTMENT] as! String
        let jobTitle = data[YiMaiAddContactsFriendsStrings.CS_DATA_KEY_JOB_TITLE] as! String
        let added = data[YiMaiAddContactsFriendsStrings.CS_DATA_KEY_FRIEND_ADDED] as! String
        
        let id = data[YiMaiAddContactsFriendsStrings.CS_DATA_KEY_USER_ID] as! String
        
        let cell = UIView(frame: CGRect(x: 0,y: 0,width: YMSizes.PageWidth,height: 136.LayoutVal()))
        
        let nameLabel = UILabel()
        let divider = UIView(frame: CGRect(x: 0,y: 0,width: YMSizes.OnPx,height: 20.LayoutVal()))
        let jobTitleLabel = UILabel()
        let deptLabel = UILabel()
        let hosLabel = UILabel()
        let addButton = YMLayout.GetTouchableImageView(useObject: Actions!,
                                                       useMethod: "AddFriend:".Sel(),
                                                       imageName: "YiMaiAddContactsFriendButton")
        
        let addedLabel = YMLayout.GetNomalLabel("已添加", textColor: YMColors.FontLightGray, fontSize: 20.LayoutVal())
        addButton.UserStringData = id

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
        
        let infoCell = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "ShowFriendInfo:".Sel())
        
        infoCell.addSubview(nameLabel)
        infoCell.addSubview(divider)
        infoCell.addSubview(jobTitleLabel)
        infoCell.addSubview(deptLabel)
        infoCell.addSubview(hosLabel)
        cell.addSubview(infoCell)
        cell.addSubview(addButton)
        cell.addSubview(bottomLine)
        cell.addSubview(addedLabel)
        
        addButton.UserObjectData = addedLabel
        
        FriendsListPanel.addSubview(cell)
        
        if(nil == prevCell) {
            cell.anchorToEdge(Edge.Top, padding: 51.LayoutVal(), width: YMSizes.PageWidth, height: cell.height)
        } else {
            cell.alignAndFillWidth(align: Align.UnderMatchingLeft, relativeTo: prevCell!, padding: YMSizes.OnPx, height: cell.height)
        }
        
        infoCell.fillSuperview()
        
        nameLabel.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 20.LayoutVal(), width: nameLabel.width, height: nameLabel.height)
        divider.align(Align.ToTheRightCentered, relativeTo: nameLabel, padding: 15.LayoutVal(), width: YMSizes.OnPx, height: divider.height)
        jobTitleLabel.align(Align.ToTheRightCentered, relativeTo: divider, padding: 15.LayoutVal(), width: jobTitleLabel.width, height: jobTitleLabel.height)
        deptLabel.align(Align.UnderMatchingLeft, relativeTo: nameLabel, padding: 6.LayoutVal(), width: deptLabel.width, height: deptLabel.height)
        hosLabel.align(Align.UnderMatchingLeft, relativeTo: deptLabel, padding: 6.LayoutVal(), width: 540.LayoutVal(), height: hosLabel.height)
        addedLabel.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: addedLabel.width, height: addedLabel.height)
        addButton.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: addButton.width, height: addButton.height)

        if("1" == added) {
            addButton.hidden = true
        } else {
            addedLabel.hidden = true
        }
        
        bottomLine.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: YMSizes.OnPx)
        
        return cell
    }
}


































