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
    private var ParentView : UIView? = nil
    private var NavController : UINavigationController? = nil
    var Actions: PageIndexActions? = nil
    
    private var BodyView: UIScrollView = UIScrollView()
    
//    private var ScrollImageView: UIView = UIView()
    private var ScrollImageView: YMImageHScrollView = YMImageHScrollView(interval: 5)
    private var OperatorPanel: UIView = UIView()
    
    private var Face2FaceButton: UIView? = nil
    private var DoctorAppointmentButton: UIView? = nil
    private var AdmissionsButton: UIView? = nil
    private var RecordsButton: UIView? = nil
    
    private var DoDoctorAuthPanel = UIView()
    private var DoctorAuthButton: YMTouchableImageView? = nil
    private var DocAuthProcessing: YMLabel? = nil
    
    private var AuthedTitle: ActiveLabel? = nil
    private var AuthedSubTitle: ActiveLabel? = nil
    private let AuthedBkg = YMLayout.GetSuitableImageView("IndexDoctorAuthedBackground")
    
    let AuthHintBkg = UIView()

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

        AuthHintBkg.hidden = true
        AuthHintBkg.backgroundColor = YMColors.None

        

        DrawScrollPanel()
        DrawOperatorPanel()
        
        
        BodyView.addSubview(DoDoctorAuthPanel)
        DoDoctorAuthPanel.backgroundColor = YMColors.White
        DoDoctorAuthPanel.align(Align.UnderMatchingLeft, relativeTo: OperatorPanel,
                                padding: 10.LayoutVal(), width: YMSizes.PageWidth, height: 110.LayoutVal())
        DrawAuthHint()

        DrawDoctorAuthPanel()
        DrawContactPanel()
        
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: ContactPanel, padding: 10.LayoutVal())
    }

    func RefreshScrollImage(data: [[String: String]]?) {
        if(nil == data) {
            return
        }

        let list = data!
        var imageList = [YMTouchableImageView]()
        for banner in list {
            let imgUrl = YMVar.GetStringByKey(banner, key: "focus_img_url")
            let articleUrl = YMVar.GetStringByKey(banner, key: "content_url")
            
            let newImage = YMLayout.GetTouchableImageView(useObject: Actions!, useMethod: "IndexScrollImageTouched:".Sel(), imageName: "IndexScrollPhoto")
            YMLayout.LoadImageFromServer(newImage, url: imgUrl)
            newImage.UserStringData = articleUrl
            imageList.append(newImage)
        }
        
        ScrollImageView.SetImages(imageList).StartAutoScroll()
    }
    
    private func DrawScrollPanel() {
        let tempScrollImage = YMLayout.GetSuitableImageView("IndexScrollPhoto")

        ScrollImageView.removeFromSuperview()
        BodyView.addSubview(ScrollImageView)
        ScrollImageView.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: tempScrollImage.height)
        ScrollImageView.SetImages([YMLayout.GetSuitableImageView("IndexScrollPhoto")]).StartAutoScroll()
//        RefreshScrollImage()
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
    
    func SetAuthPanelGoAuth() {
        AuthedTitle?.hidden = true
        AuthedBkg.hidden = true
        AuthedSubTitle?.hidden = true
        
        DocAuthProcessing?.hidden = true
        DoctorAuthButton?.hidden = false
        AuthHintBkg.hidden = false
    }
    
    func SetAuthPanelProcessing() {
        AuthedTitle?.hidden = true
        AuthedBkg.hidden = true
        AuthedSubTitle?.hidden = true
        
        DocAuthProcessing?.hidden = false
        DoctorAuthButton?.hidden = true
        AuthHintBkg.hidden = false
    }
    
    func SetAuthPanelComplete() {
        AuthedTitle?.hidden = false
        AuthedBkg.hidden = false
        AuthedSubTitle?.hidden = false
        
        DocAuthProcessing?.hidden = true
        DoctorAuthButton?.hidden = true
        AuthHintBkg.hidden = true
    }

    private func DrawDoctorAuthPanel() {
        
        
        let authStatus = YMVar.GetStringByKey(YMVar.MyUserInfo, key: "is_auth")
        if("completed" == authStatus) {
//            DoctorAuthButton = YMLayout.GetTouchableImageView(useObject: Actions!,
//                                                              useMethod: "JumpToAuthPage:".Sel(),
//                                                              imageName: "IndexButtonAuthed")
            
            if(nil == AuthedTitle) {
                AuthedTitle?.removeFromSuperview()
                AuthedTitle = ActiveLabel()
                AuthedTitle?.font = UIFont.systemFontOfSize(24.LayoutVal())
                AuthedTitle?.text = "医脉助力每位医生打造个人品牌"
                AuthedTitle?.textAlignment = NSTextAlignment.Left
                AuthedTitle?.textColor = YMColors.FontLightGray
                
                DoDoctorAuthPanel.addSubview(AuthedBkg)
                DoDoctorAuthPanel.addSubview(AuthedTitle!)
                AuthedBkg.fillSuperview()
                AuthedTitle!.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 25.LayoutVal(), width: YMSizes.PageWidth, height: 24.LayoutVal())
                Actions?.GetYiMaiCountApi.YMGetYiMaiCountInfo()
            }
            
            DrawYiMaiCountInfo([String: AnyObject]())

            SetAuthPanelComplete()
            return
        } else if("processing" == authStatus) {
            DoctorAuthButton = YMLayout.GetTouchableImageView(useObject: Actions!,
                                                              useMethod: "JumpToAuthPage:".Sel(),
                                                              imageName: "IndexButtonAuthing")
            DrawProcessingButton()
            SetAuthPanelProcessing()
        } else {
            DoctorAuthButton = YMLayout.GetTouchableImageView(useObject: Actions!,
                                                              useMethod: "JumpToAuthPage:".Sel(),
                                                              imageName: "IndexButtonGoAuth")
            
            SetAuthPanelGoAuth()
        }

        AuthHintBkg.hidden = false
        
        DoctorAuthButton?.UserStringData = YMCommonStrings.CS_PAGE_PERSONAL_DOCTOR_AUTH_NAME

        
        DoDoctorAuthPanel.addSubview(DoctorAuthButton!)
        DoctorAuthButton?.anchorInCorner(Corner.TopRight, xPad: 30.LayoutVal(), yPad: 30.LayoutVal(), width: (DoctorAuthButton?.width)!, height: (DoctorAuthButton?.height)!)
    }
    
    func DrawAuthHint() {
        DoDoctorAuthPanel.addSubview(AuthHintBkg)
        AuthHintBkg.fillSuperview()

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
        
        AuthHintBkg.addSubview(authHeadline)
        AuthHintBkg.addSubview(authSubline)
        
        authHeadline.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 25.LayoutVal(), width: YMSizes.PageWidth, height: 30.LayoutVal())
        authSubline.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 64.LayoutVal(), width: YMSizes.PageWidth, height: 24.LayoutVal())
    }
    
    func HideAuthInfo() {
        DoctorAuthButton?.hidden = true
    }
    
    func UpdateAuthStatus() {
        let authStatus = YMVar.GetStringByKey(YMVar.MyUserInfo, key: "is_auth")
        DoctorAuthButton?.removeFromSuperview()

        if("completed" == authStatus) {
//            DoctorAuthButton = YMLayout.GetTouchableImageView(useObject: Actions!,
//                                                              useMethod: "JumpToAuthPage:".Sel(),
//                                                              imageName: "IndexButtonAuthed")
            
            if(nil == AuthedTitle) {
                AuthedTitle?.removeFromSuperview()
                AuthedTitle = ActiveLabel()
                AuthedTitle?.font = UIFont.systemFontOfSize(24.LayoutVal())
                AuthedTitle?.text = "医脉助力每位医生打造个人品牌"
                AuthedTitle?.textAlignment = NSTextAlignment.Left
                AuthedTitle?.textColor = YMColors.FontLightGray
                
                DoDoctorAuthPanel.addSubview(AuthedBkg)
                DoDoctorAuthPanel.addSubview(AuthedTitle!)
                AuthedBkg.fillSuperview()
                AuthedTitle!.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 25.LayoutVal(), width: YMSizes.PageWidth, height: 24.LayoutVal())
                Actions?.GetYiMaiCountApi.YMGetYiMaiCountInfo()
                
                DrawYiMaiCountInfo([String: AnyObject]())
            }
            
            SetAuthPanelComplete()
            return

        } else if("processing" == authStatus) {
//            DoctorAuthButton = YMLayout.GetTouchableImageView(useObject: Actions!,
//                                                              useMethod: "JumpToAuthPage:".Sel(),
//                                                              imageName: "IndexButtonAuthing")
            DrawProcessingButton()
            SetAuthPanelProcessing()
            return
        } else {
            DoctorAuthButton = YMLayout.GetTouchableImageView(useObject: Actions!,
                                                              useMethod: "JumpToAuthPage:".Sel(),
                                                              imageName: "IndexButtonGoAuth")
            SetAuthPanelGoAuth()
        }
        
        AuthHintBkg.hidden = false
        DoDoctorAuthPanel.addSubview(DoctorAuthButton!)
        DoctorAuthButton?.anchorInCorner(Corner.TopRight, xPad: 30.LayoutVal(), yPad: 30.LayoutVal(), width: (DoctorAuthButton?.width)!, height: (DoctorAuthButton?.height)!)
    }
    
    func DrawProcessingButton() {
        if(nil == DocAuthProcessing) {
            DocAuthProcessing = YMLabel()
            DoDoctorAuthPanel.addSubview(DocAuthProcessing!)
        } else {
            DocAuthProcessing?.hidden = false
            return
        }

        DocAuthProcessing?.text = "审核中"
        DocAuthProcessing?.textAlignment = NSTextAlignment.Center
        DocAuthProcessing?.textColor = YMColors.FontBlue
        DocAuthProcessing?.font = YMFonts.YMDefaultFont(28.LayoutVal())
        DocAuthProcessing?.sizeToFit()
        
        DocAuthProcessing?.layer.borderWidth = 3.LayoutVal()
        DocAuthProcessing?.layer.borderColor = YMColors.FontBlue.CGColor
        DocAuthProcessing?.layer.cornerRadius = 8.LayoutVal()
        
        DocAuthProcessing?.SetTouchable(withObject: Actions!, useMethod: "JumpToAuthPage:".Sel())
        DocAuthProcessing?.anchorInCorner(Corner.TopRight, xPad: 30.LayoutVal(), yPad: 30.LayoutVal(), width: (DoctorAuthButton?.width)!, height: (DoctorAuthButton?.height)!)
        
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
    
    func ClearContactList() {
        YMLayout.ClearView(view: ContactPanel)
    }
    
    func ClearAuthPanel() {
        AuthedTitle?.hidden = true
        AuthedSubTitle?.hidden = true
        AuthedBkg.hidden = true
        
        AuthHintBkg.hidden = true
        DoctorAuthButton?.hidden = true
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
                print(doc)
                if("\(docImInfo.targetId!)" == "\(doc["id"]!)" || "\(docImInfo.senderUserId!)" == "\(doc["id"]!)") {
                    
                    let img = UIImage(named: "IndexButtonContactBackground")
                    let jobTitle = YMVar.GetStringByKey(doc, key: "job_title", defStr: "医生")
                    let cell = GetContactButton(img!, name: "\(doc["name"]!)", desc: jobTitle, isDoc: true, userData: doc)
                    let cellData = cell.UserObjectData as! [String: AnyObject]
                    let cellImage = cellData["img"] as! YMTouchableImageView
                    let authStatus = YMVar.GetStringByKey(doc, key: "is_auth")

                    if("completed" == authStatus) {
                        YMLayout.SetHeadImageVFlag(cellImage)
                    }
                    
                    let unreadCount = docImInfo.unreadMessageCount as Int
                    if(unreadCount > 0) {
                        let unreadLabel = YMLayout.GetUnreadCountLabel(unreadCount)
                        cellImage.addSubview(unreadLabel)
                        unreadLabel.anchorInCorner(Corner.TopRight, xPad: 0, yPad: 0, width: unreadLabel.width, height: unreadLabel.height)
                    }
                    YMLayout.LoadImageFromServer(cellImage, url: "\(doc["head_url"]!)", fullUrl: nil, makeItRound: true)
                    cell.UserStringData = "\(doc["id"]!)"
                    ContactArray.append(cell)
                    break
                }
            }
        }

        LayoutContactButtons()
    }
    
    func DrawYiMaiCountInfo(data: [String: AnyObject]) {
        let hosCount = YMVar.GetStringByKey(data, key: "hospital_count", defStr: "0")
        let docCount = YMVar.GetStringByKey(data, key: "doctor_count", defStr: "0")
        let appCount = YMVar.GetStringByKey(data, key: "appointment_count", defStr: "0")
        
        let labelTitle = "医院（\(hosCount)） | 医生（\(docCount)） | 预约（\(appCount)）"

        if(nil == AuthedSubTitle) {
            AuthedSubTitle = YMLayout.GetNomalLabel(labelTitle, textColor: YMColors.FontBlue, fontSize: 24.LayoutVal())
            DoDoctorAuthPanel.addSubview(AuthedSubTitle!)
        } else {
            AuthedSubTitle?.text = labelTitle
            AuthedSubTitle?.sizeToFit()
        }
    
        AuthedSubTitle?.align(Align.UnderMatchingLeft, relativeTo: AuthedTitle!, padding: 10.LayoutVal(), width: AuthedSubTitle!.width, height: AuthedSubTitle!.height)
        AuthedSubTitle?.hidden = false
    }
}

























