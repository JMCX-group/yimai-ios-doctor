//
//  YMChatViewController.swift
//  YiMai
//
//  Created by ios-dev on 16/7/24.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon
import SwiftyJSON

public class YMChatViewController: RCConversationViewController, RCIMReceiveMessageDelegate {
    var TopView: PageCommonTopView? = nil
    var ViewTitle: String = ""
    override public func viewDidLoad() {
        super.viewDidLoad()
        TopView = PageCommonTopView(parentView: self.view!, titleString: ViewTitle, navController: self.navigationController!)
        
        let messageListHeight = YMSizes.PageHeight - YMSizes.PageTopHeight - self.chatSessionInputBarControl.height
        self.conversationMessageCollectionView.align(Align.UnderMatchingLeft, relativeTo: TopView!.TopViewPanel,
                                                     padding: 0, width: YMSizes.PageWidth, height: messageListHeight)
        
        RCIM.sharedRCIM().receiveMessageDelegate = self
        
    }
    
    public func onRCIMReceiveMessage(message: RCMessage!, left: Int32) {
    }
    
    
    public func onRCIMCustomLocalNotification(message: RCMessage, withSenderName: String) -> Bool{
        print("onRCIMCustomLocalNotification")
        
        return true
    }
}

