//
//  PageYiMaiDoctorDetailBodyView.swift
//  YiMai
//
//  Created by ios-dev on 16/6/26.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageYiMaiDoctorDetailBodyView: PageBodyView {
    var DetailActions: PageYiMaiDoctorDetailActions? = nil
    public var Loading: YMPageLoadingView? = nil
    public var AddFriendBtn: YMButton? = nil
    public var AgreeFriendBtn: YMButton? = nil
    public static var DocId: String = ""
    public static var IsFromNewFriendToAgree: Bool = false
    
    var FromCommonFriendsBtn = false
    var FromCommonFriendsUserId = ""
    var ButtonPanel = UIView()
    var DoctorInfo: [String: AnyObject]? = nil
    var CommonFriendNameLabelArr = [String: YMLabel]()
    
    override func ViewLayout() {
        super.ViewLayout()
        DetailActions = PageYiMaiDoctorDetailActions(navController: self.NavController, target: self)
    }
    
    public func GetDocInfo(id: String? = nil){
        DetailActions!.GetInfo(id)
    }
    
    public func LoadData(data: [String: AnyObject]) {
        var prev: UIView? = nil
        prev = DrawBasicPanel(data)
        prev = DrawButtonGroup(data, prev: prev!)
        prev = DrawTagPanel(data, prev: prev!)

        prev = DrawCommonFriends(data, prev: prev!)
        prev = DrawDoctorIntroduction(data, prev: prev!)
        prev = DrawCollege(data, prev: prev!)

        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: prev)
    }
    
    public func Clear() {
        YMLayout.ClearView(view: BodyView)
    }
    
    public func DrawBasicPanel(data: [String: AnyObject]) -> UIView {
        let basicPanel = UIView()
        BodyView.addSubview(basicPanel)
        basicPanel.anchorToEdge(Edge.Top, padding: 0.LayoutVal(), width: YMSizes.PageWidth, height: 150.LayoutVal())
        basicPanel.backgroundColor = YMColors.PanelBackgroundGray
        
        let userHead = YMLayout.GetSuitableImageView("CommonHeadImageBorder")
        let name = UILabel()
        let jobTitle = UILabel()
        let dept = UILabel()
        let hos = UILabel()
        let divider = UIView()
        
        basicPanel.addSubview(userHead)
        basicPanel.addSubview(name)
        basicPanel.addSubview(jobTitle)
        basicPanel.addSubview(dept)
        basicPanel.addSubview(hos)
        basicPanel.addSubview(divider)
        
        userHead.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: userHead.width, height: userHead.height)
        let head = data["head_url"] as! String
        YMLayout.LoadImageFromServer(userHead, url: head, fullUrl: nil, makeItRound: true)
        
        name.text = data["name"] as? String
        name.textColor = YMColors.FontBlue
        name.font = YMFonts.YMDefaultFont(30.LayoutVal())
        name.sizeToFit()
        
        name.anchorInCorner(Corner.TopLeft, xPad: 180.LayoutVal(), yPad: 30.LayoutVal(),
                            width: name.width, height: name.height)
        
        divider.backgroundColor = YMColors.FontBlue
        divider.align(Align.ToTheRightCentered, relativeTo: name,
                      padding: 12.LayoutVal(), width: YMSizes.OnPx, height: 20.LayoutVal())
        
        jobTitle.text = YMVar.GetStringByKey(data, key: "job_title", defStr: "医生")
        jobTitle.textColor = YMColors.FontGray
        jobTitle.font = YMFonts.YMDefaultFont(20.LayoutVal())
        jobTitle.sizeToFit()
        jobTitle.align(Align.ToTheRightCentered, relativeTo: divider, padding: 12.LayoutVal(),
                       width: jobTitle.width, height: jobTitle.height)
        

        dept.text = data["department"] as? String
        dept.textColor = YMColors.FontBlue
        dept.font = YMFonts.YMDefaultFont(20.LayoutVal())
        dept.sizeToFit()
        dept.align(Align.UnderMatchingLeft, relativeTo: name,
                   padding: 8.LayoutVal(), width: dept.width, height: dept.height)
        
        hos.text = data["hospital"] as? String
        hos.textColor = YMColors.FontGray
        hos.font = YMFonts.YMDefaultFont(24.LayoutVal())
        hos.sizeToFit()
        hos.align(Align.UnderMatchingLeft, relativeTo: name,
                  padding: 36.LayoutVal(), width: hos.width, height: hos.height)
        
        return basicPanel
    }
    
    private func DrawButtonGroup(data: [String: AnyObject], prev: UIView) -> UIView {
        BodyView.addSubview(ButtonPanel)
        if(!FromCommonFriendsBtn) {
            ButtonPanel.align(Align.UnderMatchingLeft, relativeTo: prev, padding: 0, width: YMSizes.PageWidth, height: 140.LayoutVal())
        } else {
            ButtonPanel.align(Align.UnderMatchingLeft, relativeTo: prev, padding: 0, width: YMSizes.PageWidth, height: 0.LayoutVal())
            return ButtonPanel
        }
        
        let friendFlag = data["is_friend"] as! Int
        
        let addFirendBtn = YMButton()
        let appointmentBtn = YMButton()
        let chatBtn = YMButton()
        let agreeBtn = YMButton()
        
        agreeBtn.backgroundColor = YMColors.FontBlue
        agreeBtn.layer.cornerRadius = 10.LayoutVal()
        agreeBtn.layer.masksToBounds = true
        agreeBtn.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        agreeBtn.setTitle("通过验证", forState: UIControlState.Normal)
        agreeBtn.titleLabel?.font = YMFonts.YMDefaultFont(32.LayoutVal())
        
        addFirendBtn.backgroundColor = YMColors.FontBlue
        addFirendBtn.layer.cornerRadius = 10.LayoutVal()
        addFirendBtn.layer.masksToBounds = true
        addFirendBtn.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        addFirendBtn.setTitle("加为好友", forState: UIControlState.Normal)
        addFirendBtn.titleLabel?.font = YMFonts.YMDefaultFont(32.LayoutVal())
        
        appointmentBtn.backgroundColor = YMColors.FontBlue
        appointmentBtn.layer.cornerRadius = 10.LayoutVal()
        appointmentBtn.layer.masksToBounds = true
        appointmentBtn.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        appointmentBtn.setTitleColor(YMColors.FontGray, forState: UIControlState.Disabled)
        appointmentBtn.setTitle("约诊", forState: UIControlState.Normal)
        appointmentBtn.titleLabel?.font = YMFonts.YMDefaultFont(32.LayoutVal())
        
        chatBtn.backgroundColor = YMColors.FontBlue
        chatBtn.layer.cornerRadius = 10.LayoutVal()
        chatBtn.layer.masksToBounds = true
        chatBtn.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        chatBtn.setTitle("聊天", forState: UIControlState.Normal)
        chatBtn.titleLabel?.font = YMFonts.YMDefaultFont(32.LayoutVal())
        
        AddFriendBtn = addFirendBtn
        AgreeFriendBtn = agreeBtn
        
        if(PageYiMaiDoctorDetailBodyView.IsFromNewFriendToAgree) {
            PageYiMaiDoctorDetailBodyView.IsFromNewFriendToAgree = false
            ButtonPanel.align(Align.UnderMatchingLeft, relativeTo: prev, padding: 0, width: YMSizes.PageWidth, height: 0)

//            buttonPanel.addSubview(agreeBtn)
//            buttonPanel.addSubview(appointmentBtn)
//            
//            agreeBtn.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: 320.LayoutVal(), height: 70.LayoutVal())
//            appointmentBtn.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: 320.LayoutVal(), height: 70.LayoutVal())
//            appointmentBtn.backgroundColor = YMColors.CommonBottomGray
//            appointmentBtn.enabled = false
//            
//            agreeBtn.addTarget(DetailActions!, action: "Agree:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        } else if(0 == friendFlag) {
            ButtonPanel.addSubview(addFirendBtn)
            ButtonPanel.addSubview(appointmentBtn)
            
            addFirendBtn.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: 320.LayoutVal(), height: 70.LayoutVal())
            appointmentBtn.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: 320.LayoutVal(), height: 70.LayoutVal())
            appointmentBtn.backgroundColor = YMColors.CommonBottomGray
            appointmentBtn.enabled = false
            
            addFirendBtn.addTarget(DetailActions!, action: "AddFriend:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        } else {
            ButtonPanel.addSubview(chatBtn)
            ButtonPanel.addSubview(appointmentBtn)
            
            chatBtn.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: 320.LayoutVal(), height: 70.LayoutVal())
            appointmentBtn.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: 320.LayoutVal(), height: 70.LayoutVal())
            
            appointmentBtn.addTarget(DetailActions!, action: "DoAppointment:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
            
            chatBtn.UserStringData = "\(data["id"]!)"
            chatBtn.UserObjectData = data
            chatBtn.addTarget(DetailActions!, action: "DoChat:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        }
        return ButtonPanel
    }
    
    private func DrawTagPanel(data: [String: AnyObject], prev: UIView) -> UIView {
        let tags = data["tags"] as? String
        if(YMValueValidator.IsEmptyString(tags)) {
            return prev
        }
        
        let tagPanel = UIView()
        BodyView.addSubview(tagPanel)
        tagPanel.align(Align.UnderMatchingLeft, relativeTo: prev,
                       padding: 0, width: YMSizes.PageWidth, height: 130.LayoutVal())
        
        

        tagPanel.backgroundColor = YMColors.White
        tagPanel.layer.masksToBounds = true
        
        let title = UILabel()
        title.text = "特长"
        title.textColor = YMColors.FontBlue
        title.font = YMFonts.YMDefaultFont(30.LayoutVal())
        title.sizeToFit()
        
        tagPanel.addSubview(title)
        title.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 20.LayoutVal(), width: title.width, height: title.height)
        
        DrawTagList(tags!, tagTitle: title, panel: tagPanel)
        
        return tagPanel
        //        TagExpandArrow = YMLayout.GetTouchableImageView(useObject: Actions!, useMethod: "TagPanelExpand:".Sel(), imageName: "PagePersonalDetailArrowDownIcon")
        //        TagCollapseArrow = YMLayout.GetTouchableImageView(useObject: Actions!, useMethod: "TagPanelCollapse:".Sel(), imageName: "PagePersonalDetailArrowUpIcon")
    }
    
    private func DrawTagList(tags: String, tagTitle: UIView, panel: UIView) {
        func GetTagFullWidth(tagLabel: UILabel) -> CGFloat{
            return tagLabel.width + 50.LayoutVal()
        }
        
        let tagArray = tags.componentsSeparatedByString(",")
        
        var labelArray = [UILabel]()
        var widthArray = [CGFloat]()
        var lineArray = [[Int]]()
        var lineViewArray = [UIView]()
        
        let listLineWidth = 610.LayoutVal()
        let listLineHeight = 42.LayoutVal()
        
        if(0 == tagArray.count) {
            return
        }
        
        let tagSorted = tagArray.sort { (a, b) -> Bool in
            return a.characters.count > b.characters.count
        }
        
        for tag in tagSorted {
            let tagLabel = GetTagLabel(tag)
            labelArray.append(tagLabel)
            widthArray.append(GetTagFullWidth(tagLabel))
        }
        
        for (idx, val) in widthArray.enumerate() {
            var newLineFlag = true
            
            for (lIdx, lVal) in lineArray.enumerate() {
                var allTagWidth:CGFloat = 0
                for tagIdx in lVal {
                    allTagWidth += widthArray[tagIdx]
                }
                
                if((allTagWidth + val) < listLineWidth) {
                    newLineFlag = false
                    lineArray[lIdx].append(idx)
                }
            }
            
            if(newLineFlag) {
                var newLine = [Int]()
                newLine.append(idx)
                lineArray.append(newLine)
            }
        }
        
        for (lIdx, lVal) in lineArray.enumerate() {
            let lineView = UIView()
            lineViewArray.append(lineView)
            panel.addSubview(lineView)
            if(0 == lIdx) {
                lineView.anchorInCorner(Corner.TopLeft, xPad: 120.LayoutVal(), yPad: 20.LayoutVal(), width: listLineWidth, height: listLineHeight)
            } else {
                let prevLine = lineViewArray[lIdx - 1]
                lineView.align(Align.UnderMatchingLeft, relativeTo: prevLine, padding: 10.LayoutVal(), width: listLineWidth, height: listLineHeight)
            }
            
            var prevLabel: UILabel? = nil
            for (idx, val) in lVal.enumerate() {
                let tagLabel = labelArray[val]
                lineView.addSubview(tagLabel)
                if(0 == idx) {
                    tagLabel.anchorToEdge(Edge.Left, padding: 0, width: widthArray[val] - 10.LayoutVal(), height: listLineHeight)
                } else {
                    tagLabel.align(Align.ToTheRightCentered, relativeTo: prevLabel!, padding: 10.LayoutVal(), width: widthArray[val] - 10.LayoutVal(), height: listLineHeight)
                }
                prevLabel = tagLabel
            }
            
            YMLayout.SetViewHeightByLastSubview(panel, lastSubView: lineView, bottomPadding: 20.LayoutVal())
        }
        return
    }
    
    private func GetTagLabel(tagText: String) -> UILabel {
        let tag = UILabel()
        
        tag.text = tagText
        tag.font = YMFonts.YMDefaultFont(26.LayoutVal())
        tag.textAlignment = NSTextAlignment.Center
        tag.textColor = YMColors.FontGray
        tag.layer.cornerRadius = 6.LayoutVal()
        tag.layer.masksToBounds = true
        tag.sizeToFit()
        
        tag.layer.borderColor = YMColors.FontGray.CGColor
        tag.layer.borderWidth = 1
        
        return tag
    }
    
    func UpdateCommonFriendsName(firendsInfo: [[String: AnyObject]]) {
        for doc in firendsInfo {
            let docName = YMVar.GetStringByKey(doc, key: "name")
            let docId = YMVar.GetStringByKey(doc, key: "id")
            let label = CommonFriendNameLabelArr[docId]
            
            if(nil != label) {
                let userData = label!.UserObjectData as! [String: AnyObject]
                let headImg = userData["headimg"] as! UIImageView
                
                label?.text = docName
                label?.sizeToFit()
                label?.align(Align.UnderCentered, relativeTo: headImg, padding: 10.LayoutVal(), width: label!.width, height: label!.height)
            }
        }
    }
    
    private func DrawCommonFriends(data: [String: AnyObject], prev: UIView) -> UIView {
        let commonFriendList = data["common_friend_list"] as? [[String: AnyObject]]
        print(commonFriendList)
        CommonFriendNameLabelArr.removeAll()
        if(nil == commonFriendList) {
            return prev
        }
        
        if(0 == commonFriendList!.count) {
            return prev
        }
        
        let commonFriendPanel = UIView()
        BodyView.addSubview(commonFriendPanel)
        commonFriendPanel.backgroundColor = YMColors.White
        commonFriendPanel.align(Align.UnderMatchingLeft, relativeTo: prev, padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: 240.LayoutVal())
        
        let label = UILabel()
        label.text = "共同好友（\(commonFriendList!.count)个）"
        label.textColor = YMColors.FontBlue
        label.font = YMFonts.YMDefaultFont(28.LayoutVal())
        label.sizeToFit()
        
        commonFriendPanel.addSubview(label)
        label.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 20.LayoutVal(), width: label.width, height: label.height)
        
        let friendsList = UIScrollView()
        commonFriendPanel.addSubview(friendsList)
        friendsList.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: 170.LayoutVal())
        
        var lastHeadImg: UIImageView? = nil
        var lastNameLabel: YMLabel? = nil
        var idList = [String]()
        for friend in commonFriendList! {
            let head = YMVar.GetStringByKey(friend, key: "head_url")
            let userId = YMVar.GetStringByKey(friend, key: "id")

            let headImg = YMLayout.GetTouchableImageView(useObject: DetailActions!, useMethod: "CommonFriendsTouched:".Sel(), imageName: "CommonHeadImageBorder")
            let name = YMLayout.GetNomalLabel("", textColor: YMColors.FontGray, fontSize: 20.LayoutVal())
            
            headImg.UserStringData = userId
            idList.append(userId)

            name.textAlignment = NSTextAlignment.Center
            name.UserObjectData = ["headimg": headImg]
            friendsList.addSubview(headImg)
            friendsList.addSubview(name)
            if(nil == lastHeadImg) {
                headImg.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 0, width: headImg.width, height: headImg.height)
            } else {
                headImg.align(Align.ToTheRightCentered, relativeTo: lastHeadImg!, padding: 40.LayoutVal(), width: headImg.width, height: headImg.height)
            }
            
            name.align(Align.UnderCentered, relativeTo: headImg, padding: 10.LayoutVal(), width: name.width, height: name.height)

            YMLayout.LoadImageFromServer(headImg, url: head, fullUrl: nil, makeItRound: true)
            
            CommonFriendNameLabelArr[userId] = name
            lastHeadImg = headImg
            lastNameLabel = name
        }
        
        YMLayout.SetHScrollViewContentSize(friendsList, lastSubView: lastNameLabel)
        
        DetailActions?.GetCommonFriendsName(idList.joinWithSeparator(","))
        return commonFriendPanel
    }
    
    private func DrawDoctorIntroduction(data: [String: AnyObject], prev: UIView) -> UIView {
        let introPanel = UIView()
        BodyView.addSubview(introPanel)
        introPanel.backgroundColor = YMColors.White
        
        let title = UILabel()
        title.text = "医生简介："
        title.textColor = YMColors.FontBlue
        title.font = YMFonts.YMDefaultFont(30.LayoutVal())
        title.sizeToFit()
        
        introPanel.addSubview(title)
        
        let introLabel = UILabel()
        introLabel.text = data["personal_introduction"] as? String
        introLabel.textColor = YMColors.FontGray
        introLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        introLabel.numberOfLines = 0
        introLabel.lineBreakMode = NSLineBreakMode.ByCharWrapping
        introLabel.preferredMaxLayoutWidth = 690.LayoutVal()
        introLabel.sizeToFit()
        
        introPanel.addSubview(introLabel)

        introPanel.align(Align.UnderMatchingLeft, relativeTo: prev, padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: introLabel.height + 90.LayoutVal())

        title.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 20.LayoutVal(), width: title.width, height: title.height)
        introLabel.align(Align.UnderMatchingLeft, relativeTo: title, padding: 20.LayoutVal(), width: introLabel.width, height: introLabel.height)
        
        return introPanel
    }
    
    private func DrawCollege(data: [String: AnyObject], prev: UIView) -> UIView{
        let collegePanel = UIView()
        BodyView.addSubview(collegePanel)
        collegePanel.align(Align.UnderMatchingLeft, relativeTo: prev, padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: 68.LayoutVal())
        collegePanel.backgroundColor = YMColors.White
        
        let title = UILabel()
        title.text = "毕业院校："
        title.textColor = YMColors.FontBlue
        title.font = YMFonts.YMDefaultFont(30.LayoutVal())
        title.sizeToFit()
        
        collegePanel.addSubview(title)
        title.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: title.width, height: title.height)
        
        let label = UILabel()
        collegePanel.addSubview(label)
        label.text = data["college"] as? String
        label.textColor = YMColors.FontGray
        label.font = YMFonts.YMDefaultFont(26.LayoutVal())
        label.sizeToFit()
        
        label.align(Align.ToTheRightCentered, relativeTo: title, padding: 20.LayoutVal(), width: label.width, height: label.height)
        
        return collegePanel
    }
}























