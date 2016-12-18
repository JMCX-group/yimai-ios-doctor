//
//  PageIndexBodyView.swift
//  YiMai
//
//  Created by why on 16/4/21.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageIndexBodyView {
    private weak var ParentView : UIView? = nil
    private weak var NavController : UINavigationController? = nil
    private weak var Actions: PageIndexActions? = nil
    
    private var BodyView: UIScrollView = UIScrollView()
    
    private var ScrollImageView: UIScrollView = UIScrollView()
    private var OperatorPanel: UIView = UIView()
    
    private var Face2FaceButton: UIView? = nil
    private var DoctorAppointmentButton: UIView? = nil
    private var AdmissionsButton: UIView? = nil
    private var RecordsButton: UIView? = nil
    
    private var DoDoctorAuthPanel = UIView()
    private var DoctorAuthButton: YMTouchableImageView? = nil
    
    private var ContactPanel = UIScrollView()
    
    private var ContactArray: [UIView] = [UIView]()
    private var MoreContactButton: UIImageView? = nil
    
    convenience init(parentView: UIView, navController: UINavigationController, pageActions: PageIndexActions){
        self.init()
        self.ParentView = parentView
        self.NavController = navController
        self.Actions = pageActions
        
        ViewLayout()
    }
    
    private func ViewLayout() {
        YMLayout.BodyLayoutWithTopAndBottom(ParentView!, bodyView: BodyView)

        DrawScrollPanel()
        DrawOperatorPanel()
        DrawDoctorAuthPanel()
        DrawContactPanel()
        
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: ContactPanel, padding: 10.LayoutVal())
    }
    
    private func DrawScrollPanel() {
        //TODO: 此处应该显示轮播图
        let tempScrollImage = YMLayout.GetSuitableImageView("IndexScrollPhoto")
//        BodyView.addSubview(tempScrollImage)
//        tempScrollImage.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: tempScrollImage.height)
        
        let scrollView = JMCarouselScrollView(
            frame: CGRect(x: 0, y: 0, width:UIScreen.mainScreen().bounds.width, height: tempScrollImage.height),
            imageArray: [UIImage(named: "IndexScrollPhoto")!, UIImage(named: "IndexScrollPhoto")!],
            pagePointColor: UIColor.whiteColor(),
            stepTime: 3.0)
        BodyView.addSubview(scrollView)
        scrollView.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: tempScrollImage.height)
    }
    
    private func SetOperatorContent(operatorButton: UIView, imageName: String, text: String) {
        let operatorImage = YMLayout.GetSuitableImageView(imageName)
        let operatorText = UILabel()
        
        operatorText.text = text
        operatorText.font = UIFont.systemFontOfSize(28.LayoutVal())
        operatorText.textAlignment = NSTextAlignment.Center
        operatorText.textColor = YMColors.FontBlue
        
        operatorButton.addSubview(operatorImage)
        operatorButton.addSubview(operatorText)
        
        operatorImage.anchorToEdge(Edge.Bottom, padding: 96.LayoutVal(), width: operatorImage.width, height: operatorImage.height)
        operatorText.anchorToEdge(Edge.Bottom, padding: 40.LayoutVal(), width: operatorButton.width, height: 28.LayoutVal())
    }
    
    private func DrawOperatorPanel() {
        BodyView.addSubview(OperatorPanel)
        OperatorPanel.backgroundColor = YMColors.PanelBackgroundGray

        OperatorPanel.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 520.LayoutVal(), otherSize: 200.LayoutVal())
        
        Face2FaceButton = YMLayout.GetTouchableView(useObject: Actions!,
                                                    useMethod: "PageJumpToByViewSender:".Sel(),
                                                    userStringData: YMCommonStrings.CS_PAGE_FACE_2_FACE_INFO_INPUT_NAME)
        
        DoctorAppointmentButton = YMLayout.GetTouchableView(useObject: Actions!,
                                                            useMethod: "JumpToAppointment:".Sel(),
                                                            userStringData: YMCommonStrings.CS_PAGE_APPOINTMENT_NAME)
        
        AdmissionsButton = YMLayout.GetTouchableView(useObject: Actions!,
                                                     useMethod: "PageJumpToByViewSender:".Sel(),
                                                     userStringData: YMCommonStrings.CS_PAGE_MY_ADMISSIONS_LIST_NAME)
        RecordsButton = YMLayout.GetTouchableView(useObject: Actions!,
            useMethod: "PageJumpToByViewSender:".Sel(),
            userStringData: YMCommonStrings.CS_PAGE_APPOINTMENT_RECORD_NAME)
        
//        OperatorPanel.addSubview(Face2FaceButton!)
        OperatorPanel.addSubview(DoctorAppointmentButton!)
        OperatorPanel.addSubview(AdmissionsButton!)
        OperatorPanel.addSubview(RecordsButton!)
        
        OperatorPanel.groupAndFill(group: Group.Horizontal, views: [DoctorAppointmentButton!, AdmissionsButton!, RecordsButton!], padding: 1)
        
//        SetOperatorContent(Face2FaceButton!,imageName:  "IndexButtonFace2Face",text:  "当面咨询")
        SetOperatorContent(DoctorAppointmentButton!,imageName:  "IndexButtonDoctorAppointment",text:  "预约医生")
        SetOperatorContent(AdmissionsButton!,imageName:  "IndexButtonAdmissions",text:  "我的接诊")
        SetOperatorContent(RecordsButton!,imageName:  "IndexButtonRecords",text:  "预约记录")
    }
    
    private func DrawDoctorAuthPanel() {
        BodyView.addSubview(DoDoctorAuthPanel)
        DoDoctorAuthPanel.backgroundColor = YMColors.White
        DoDoctorAuthPanel.align(Align.UnderMatchingLeft, relativeTo: OperatorPanel,
                                padding: 10.LayoutVal(), width: YMSizes.PageWidth, height: 110.LayoutVal())
        
        let authStatus = YMVar.GetStringByKey(YMVar.MyUserInfo, key: "is_auth")
        if("completed" == authStatus) {
            DoctorAuthButton = YMLayout.GetTouchableImageView(useObject: Actions!,
                                                              useMethod: "JumpToAuthPage:".Sel(),
                                                              imageName: "IndexButtonAuthed")
        } else if("processing" == authStatus) {
            DoctorAuthButton = YMLayout.GetTouchableImageView(useObject: Actions!,
                                                              useMethod: "JumpToAuthPage:".Sel(),
                                                              imageName: "IndexButtonAuthing")
        } else {
            DoctorAuthButton = YMLayout.GetTouchableImageView(useObject: Actions!,
                                                              useMethod: "JumpToAuthPage:".Sel(),
                                                              imageName: "IndexButtonGoAuth")
        }

        
        DoctorAuthButton?.UserStringData = YMCommonStrings.CS_PAGE_PERSONAL_DOCTOR_AUTH_NAME

        let authHeadline = UILabel()
        authHeadline.font = UIFont.systemFontOfSize(30.LayoutVal())
        authHeadline.text = "医脉助力每位医生打造个人品牌"
        authHeadline.textAlignment = NSTextAlignment.Left
        authHeadline.textColor = YMColors.FontBlue

        let authSubline = UILabel()
        authSubline.font = UIFont.systemFontOfSize(24.LayoutVal())
        authSubline.text = "添加认证是您专业和信用的标志"
        authSubline.textAlignment = NSTextAlignment.Left
        authSubline.textColor = YMColors.FontGray

        DoDoctorAuthPanel.addSubview(authHeadline)
        DoDoctorAuthPanel.addSubview(authSubline)
        DoDoctorAuthPanel.addSubview(DoctorAuthButton!)
        
        authHeadline.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 25.LayoutVal(), width: YMSizes.PageWidth, height: 30.LayoutVal())
        authSubline.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 64.LayoutVal(), width: YMSizes.PageWidth, height: 24.LayoutVal())
        DoctorAuthButton?.anchorInCorner(Corner.TopRight, xPad: 30.LayoutVal(), yPad: 30.LayoutVal(), width: (DoctorAuthButton?.width)!, height: (DoctorAuthButton?.height)!)
    }
    
    func HideAuthInfo() {
        DoctorAuthButton?.hidden = true
    }
    
    func UpdateAuthStatus() {
        let authStatus = YMVar.GetStringByKey(YMVar.MyUserInfo, key: "is_auth")
        DoctorAuthButton?.removeFromSuperview()

        if("completed" == authStatus) {
            DoctorAuthButton = YMLayout.GetTouchableImageView(useObject: Actions!,
                                                              useMethod: "JumpToAuthPage:".Sel(),
                                                              imageName: "IndexButtonAuthed")
        } else if("processing" == authStatus) {
            DoctorAuthButton = YMLayout.GetTouchableImageView(useObject: Actions!,
                                                              useMethod: "JumpToAuthPage:".Sel(),
                                                              imageName: "IndexButtonAuthing")
        } else {
            DoctorAuthButton = YMLayout.GetTouchableImageView(useObject: Actions!,
                                                              useMethod: "JumpToAuthPage:".Sel(),
                                                              imageName: "IndexButtonGoAuth")
        }
        
        DoDoctorAuthPanel.addSubview(DoctorAuthButton!)
        DoctorAuthButton?.anchorInCorner(Corner.TopRight, xPad: 30.LayoutVal(), yPad: 30.LayoutVal(), width: (DoctorAuthButton?.width)!, height: (DoctorAuthButton?.height)!)
    }
    
    private func GetContactButton(image: UIImage, name: String, desc: String,
                                  isDoc: Bool = false, userData: [String: AnyObject]? = nil) -> YMTouchableView {
        let buttonView = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "DoChat:".Sel())
        buttonView.frame = CGRect(x: 0,y: 0,width: 190.LayoutVal(), height: 260.LayoutVal())
        buttonView.backgroundColor = YMColors.PanelBackgroundGray

        let buttonImage = YMLayout.GetSuitableImageView(image)
        
        let contactName = UILabel()
        contactName.text = name
        contactName.textColor = YMColors.FontBlue
        contactName.textAlignment = NSTextAlignment.Center
        contactName.font = UIFont.systemFontOfSize(26.LayoutVal())
        
        let contactDesc = UILabel()
        contactDesc.text = desc
        contactDesc.textColor = YMColors.FontGray
        contactDesc.textAlignment = NSTextAlignment.Center
        contactDesc.font = UIFont.systemFontOfSize(22.LayoutVal())
        
        buttonView.addSubview(buttonImage)
        buttonView.addSubview(contactName)
        buttonView.addSubview(contactDesc)
        
        buttonImage.anchorInCorner(Corner.TopLeft, xPad: 30.LayoutVal(), yPad: 30.LayoutVal(), width: buttonImage.width, height: buttonImage.height)
        contactName.anchorInCorner(Corner.TopLeft, xPad: 0, yPad: 174.LayoutVal(), width: buttonView.width, height: 26.LayoutVal())
        contactDesc.anchorInCorner(Corner.TopLeft, xPad: 0, yPad: 204.LayoutVal(), width: buttonView.width, height: 22.LayoutVal())
        
        var btnData = userData
        if(nil == btnData) {
            btnData = [String: AnyObject]()
        }
        btnData?["img"] = buttonImage
        btnData?["isDoc"] = isDoc
        if(!isDoc) {
            btnData?["name"] = "小医"
        }
        buttonView.UserObjectData = btnData//["img": buttonImage, "name": name, "isDoc": isDoc]
        
        return buttonView
    }
    
    private func LayoutContactButtons() {
        for buttons in ContactArray {
            ContactPanel.addSubview(buttons)
        }
        
        let baseButton = ContactArray[0]
        let buttonWidth = baseButton.width
        let buttonHeight = baseButton.height
        
        ContactPanel.groupInCorner(group: Group.Horizontal, views: ContactArray.map({$0 as UIView}), inCorner: Corner.TopLeft, padding: 0, width: buttonWidth, height: buttonHeight)
        
        YMLayout.SetHScrollViewContentSize(ContactPanel, lastSubView: ContactArray.last!)
    }

    private func DrawContactPanel() {
        BodyView.addSubview(ContactPanel)
        ContactPanel.backgroundColor = YMColors.PanelBackgroundGray
        ContactPanel.align(Align.UnderMatchingLeft, relativeTo: DoDoctorAuthPanel, padding: 10.LayoutVal(), width: YMSizes.PageWidth, height: 260.LayoutVal())
    }
    
    func LoadContactList(data: [[String: AnyObject]]) {
        let yiImage = UIImage(named: "IndexButtonYi")
//        let maiImage = UIImage(named: "IndexButtonMai")
        
        let yiButton = GetContactButton(yiImage!, name: "小医", desc: "智能客服", isDoc: false)
//        let maiButton = GetContactButton(maiImage!, name: "小脉", desc: "智能客服", isDoc: false)
        
        YMLayout.ClearView(view: ContactPanel)
        ContactArray.removeAll()
        
        ContactArray.append(yiButton)
//        ContactArray.append(maiButton)
        
        let imInfo = RCIMClient.sharedRCIMClient().getConversationList([RCConversationType.ConversationType_PRIVATE.rawValue])

        for docImInfo in imInfo {
            for doc in data {
                if("\(docImInfo.targetId!)" == "\(doc["id"]!)" || "\(docImInfo.senderUserId!)" == "\(doc["id"]!)") {
                    
                    let img = UIImage(named: "IndexButtonContactBackground")
                    let jobTitle = YMVar.GetStringByKey(doc, key: "job_title", defStr: "医生")
                    let cell = GetContactButton(img!, name: "\(doc["name"]!)", desc: jobTitle, isDoc: true, userData: doc)
                    
                    let cellData = cell.UserObjectData as! [String: AnyObject]
                    let cellImage = cellData["img"] as! UIImageView
                    YMLayout.LoadImageFromServer(cellImage, url: "\(doc["head_url"]!)", fullUrl: nil, makeItRound: true)
                    cell.UserStringData = "\(doc["id"]!)"
                    ContactArray.append(cell)
                    break
                }
            }
        }
        
        
        LayoutContactButtons()
    }
}

























