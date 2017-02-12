//
//  PageIMSearchConversationsBodyView.swift
//  YiMai
//
//  Created by why on 2017/1/24.
//  Copyright © 2017年 why. All rights reserved.
//

import Foundation
import Neon

class PageIMSearchConversationsBodyView: PageBodyView {
    var SearchActions: PageIMSearchConversationsActions!
    var SearchInput: YMTextField!
    let ResultPanel = UIView()
    let SearchPanel = UIView()
    var CurrentKey = ""

    override func ViewLayout() {
        super.ViewLayout()
        
        SearchActions = PageIMSearchConversationsActions(navController: NavController, target: self)
        DrawFullBody()
    }
    
    func DrawFullBody() {
        YMLayout.ClearView(view: ResultPanel)
        YMLayout.ClearView(view: BodyView)
        let param = TextFieldCreateParam()
        
        param.FontSize = 22.LayoutVal()
        param.Placholder = "搜索"
        param.FontColor = YMColors.FontGray
        SearchInput = YMLayout.GetTextField(param)
        
//        BodyView.addSubview(SearchInput)
//        SearchInput.anchorToEdge(Edge.Top, padding: 40.LayoutVal(), width: 670.LayoutVal(), height: 40.LayoutVal())
//        SearchInput.EditEndCallback = DoSearch
        
        DrawSearchPanel()
        BodyView.addSubview(ResultPanel)
        ResultPanel.backgroundColor = YMColors.White
        ResultPanel.align(Align.UnderCentered, relativeTo: SearchInput, padding: 40.LayoutVal(), width: YMSizes.PageWidth, height: 0)
    }
    
    func DrawSearchPanel()  {
        let searchInputParam = TextFieldCreateParam()
        let searchIconView = UIView(frame: CGRect(x: 0,y: 0,width: 66.LayoutVal(),height: 60.LayoutVal()))
        let searchIcon = YMLayout.GetSuitableImageView("YiMaiGeneralSearchIcon")
        
        searchInputParam.BackgroundImageName = "YiMaiGeneralLongSearchBackground"
        searchInputParam.Placholder = "搜索"
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
        let key = SearchInput.text
        if(!YMValueValidator.IsBlankString(key)) {
            CurrentKey = key!
            let ret = RCIMClient.sharedRCIMClient().searchConversations(
                [RCConversationType.ConversationType_PRIVATE.rawValue,
                RCConversationType.ConversationType_DISCUSSION.rawValue],
                                                              messageType: [RCTextMessage.getObjectName()], keyword: key!)
            
            if(nil != ret) {
                LoadData(ret)
            }
        } else {
            CurrentKey = ""
            SearchInput.text = ""
        }
    }
    
    func CellTouched(gr: UIGestureRecognizer) {
        let cell = gr.view! as! YMTouchableView
        let targetId = cell.UserStringData
        let isDiscussion = cell.UserObjectData as! String
        
        PageJumpActions(navController: NavController!)
            .DoJump(YMCommonStrings.CS_PAGE_IM_MSG_SEARCH,
                    ignoreExists: false, userData: ["id": targetId, "key": CurrentKey, "isDiscussion": isDiscussion])
    }

    func DrawResultCell(data: RCSearchConversationResult, prev: UIView?) -> YMTouchableView {
        let cell = YMLayout.GetTouchableView(useObject: self, useMethod: "CellTouched:".Sel())
        let count = data.matchCount
        let targetId = data.conversation.targetId
        let userHead = YMVar.GetLocalUserHeadurl(targetId)
        
        cell.UserStringData = targetId
        cell.UserObjectData = "0"
        
        ResultPanel.addSubview(cell)
        if(nil != prev) {
            cell.align(Align.UnderMatchingLeft, relativeTo: prev!, padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: 150.LayoutVal())
        } else {
            cell.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 150.LayoutVal())
        }

        let headImg = YMLayout.GetSuitableImageView("YiMaiGeneralHeadImageBorder")
        var userName = YMLocalData.GetData(YMLocalDataStrings.DOC_NAME + targetId) as? String
        
        if (RCConversationType.ConversationType_DISCUSSION == data.conversation.conversationType) {
            headImg.image = UIImage(named: "ContactBackgroundForDiscussion")
            userName = data.conversation.conversationTitle
            cell.UserObjectData = "1"
            
            let idList = YMLocalData.GetData(YMLocalDataStrings.DISCUSSION_ID + data.conversation.targetId)
            
            if(nil != idList) {
                YMLayout.GetDiscussionHeadimg((idList as! [String]).joinWithSeparator(","), panel: headImg)
            }
            
            RCIMClient.sharedRCIMClient().getDiscussion(data.conversation.targetId, success: { (discussion) in
                YMDelay(0.1, closure: {
                    let idList: [String] = discussion.memberIdList.map({($0 as! String)})
                    YMLocalData.SaveData(idList, key: YMLocalDataStrings.DISCUSSION_ID + data.conversation.targetId)
                    YMLayout.GetDiscussionHeadimg(idList.joinWithSeparator(","), panel: headImg)
                })
                }, error: { (error) in
                    //DoNothing
                    print("get discussion failed \(error.rawValue)")
            })
        }
        
        if(nil == userName) {
            userName = " "
        }
        
        let userLabel = YMLayout.GetNomalLabel(userName!, textColor: YMColors.FontGray, fontSize: 24.LayoutVal())
        
        cell.addSubview(headImg)
        cell.addSubview(userLabel)
        headImg.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: headImg.width, height: headImg.height)
        if (RCConversationType.ConversationType_DISCUSSION != data.conversation.conversationType) {
            YMLayout.LoadImageFromServer(headImg, url: userHead, fullUrl: nil, makeItRound: true)
        }
        userLabel.align(Align.ToTheRightMatchingTop, relativeTo: headImg, padding: 20.LayoutVal(), width: userLabel.width, height: userLabel.height)
        
        let countLabel = YMLayout.GetNomalLabel("有\(count)条相关聊天记录", textColor: YMColors.FontLightGray, fontSize: 28.LayoutVal())
        cell.addSubview(countLabel)
        
        countLabel.align(Align.ToTheRightCentered, relativeTo: headImg, padding: 20.LayoutVal(), width: countLabel.width, height: countLabel.height)

        return cell
    }

    func LoadData(data: [RCSearchConversationResult]) {
        var prev:YMTouchableView? = nil

        for conversation in data {
            prev = DrawResultCell(conversation, prev: prev)
        }
        
        YMLayout.SetViewHeightByLastSubview(ResultPanel, lastSubView: prev)
    }
}





















