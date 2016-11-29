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
import Proposer

public class YMChatViewController: RCConversationViewController, RCIMReceiveMessageDelegate {
    var TopView: PageCommonTopView? = nil
    var ViewTitle: String = ""
    var UserData: [String: AnyObject]? = nil
    var ShowAppointment: Bool = true
    
    static var SendMsg: [String: String]? = nil
    
    var JumpAction: PageJumpActions!
    override public func viewDidLoad() {
        super.viewDidLoad()
        TopView = PageCommonTopView(parentView: self.view!, titleString: ViewTitle, navController: self.navigationController!)
        
        let messageListHeight = YMSizes.PageHeight - YMSizes.PageTopHeight - self.chatSessionInputBarControl.height
        self.conversationMessageCollectionView.align(Align.UnderMatchingLeft, relativeTo: TopView!.TopViewPanel,
                                                     padding: 0, width: YMSizes.PageWidth, height: messageListHeight)
        
        RCIM.sharedRCIM().receiveMessageDelegate = self
        
        JumpAction = PageJumpActions(navController: self.navigationController!)
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        PageAppointmentViewController.FromIM = false
        GetLocationAuth()
        
        CheckNeedSendMsg()

    }
    
    override public func pluginBoardView(plug: RCPluginBoardView, clickedItemWithTag tag: Int) {
        super.pluginBoardView(plug, clickedItemWithTag: tag)
        if(2016 == tag) {
            PageAppointmentViewController.DoctorIsPreSelected = true
            PageAppointmentViewController.NewAppointment = true
            PageAppointmentViewController.SelectedDoctor = UserData
            PageAppointmentViewController.FromIM = true
            JumpAction.DoJump(YMCommonStrings.CS_PAGE_APPOINTMENT_NAME)
        }
    }
    
    override public func didTapMessageCell(cellData: RCMessageModel) {
        let textMsg = cellData.content as? RCTextMessage
        
        if(nil != textMsg) {
            let appointmentInfo = YMVar.TryToGetDictFromJsonStringData(textMsg!.extra!)
            if(nil == appointmentInfo) {
                return
            }

            let id = appointmentInfo!["appointmentId"] as? String
            if(nil == id) {
                return
            }
            PageAppointmentDetailViewController.AppointmentID = id!
            JumpAction.DoJump(YMCommonStrings.CS_PAGE_APPOINTMENT_DETAIL_NAME)
        }
    }

    func CheckNeedSendMsg() {
        if(nil == YMChatViewController.SendMsg) {
            return
        }
        
        let data: [String: String]! = YMChatViewController.SendMsg!
        YMChatViewController.SendMsg = nil
        
        // 生成消息内容
        let text = RCTextMessage(content: "我向您发起了一条约诊，点击查看。")
        text.extra = YMVar.TransObjectToString(data)
        self.sendMessage(text, pushContent: text.content)
    }

    func GetLocationAuth() {
        self.pluginBoardView.removeItemWithTag(Int(PLUGIN_BOARD_ITEM_LOCATION_TAG))
        if(ShowAppointment) {
            self.pluginBoardView.removeItemWithTag(Int(2016))
            self.pluginBoardView.insertItemWithImage(UIImage(named: "YMIconAppointmentFromIM")!, title: "发起约诊", tag: 2016)
        }
        
//        let contacts: PrivateResource = PrivateResource.Location(PrivateResource.LocationUsage.WhenInUse)
//        
//        if(contacts.isNotDeterminedAuthorization) {
//            proposeToAccess(contacts, agreed: {
//                print("get location success")
//                }, rejected: {
//                self.pluginBoardView.removeItemWithTag(Int(PLUGIN_BOARD_ITEM_LOCATION_TAG))
//            })
//        } else {
//            if(!contacts.isAuthorized) {
//                proposeToAccess(contacts, agreed: {
//                    print("get location success")
//                    }, rejected: {
//                    self.pluginBoardView.removeItemWithTag(Int(PLUGIN_BOARD_ITEM_LOCATION_TAG))
//                })
//            } else {
//                proposeToAccess(contacts, agreed: {
//                    print("get location success")
//                    }, rejected: {
//                    self.pluginBoardView.removeItemWithTag(Int(PLUGIN_BOARD_ITEM_LOCATION_TAG))
//                })
//            }
//        }
    }
    
    public func onRCIMReceiveMessage(message: RCMessage!, left: Int32) {
    }
    
    
    public func onRCIMCustomLocalNotification(message: RCMessage, withSenderName: String) -> Bool{
        print("onRCIMCustomLocalNotification")
        
        return true
    }
}

