//
//  PageAppointmentDetailBodyView.swift
//  YiMai
//
//  Created by ios-dev on 16/6/25.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon
import Toucan
import ImageViewer

public class PageAppointmentDetailBodyView: PageBodyView, ImageProvider {
    private let Breadcrumbs = YMTouchableView()
    private let DPPanel = UIView()

    private let DocCell = UIView()
    private let PatientCell = UIView()
    private let PatientOnlyCell = UIView()

    private let AppointmentNum = UILabel()
    private let TextInfoPanel = UIView()
    private let ImagePanel = UIView()
    private let TimeLinePanel = UIView()
    private let DemandPanel = UIView()
    
    
    private var DenyInfoDlg: YMPageModalDialog? = nil
    
    private let DenyInfoBox = UIView()
    private let DenyTitle = UILabel()
    private let DenyConfirmBtn = YMButton()
    private let CancelDenyBtn = YMButton()
    
    private var DenyBecauseBusy: YMTouchableView!
    private var DenyBecauseTrip: YMTouchableView!
    private var DenyBecauseNotExpertise: YMTouchableView!
    private var DenyBecauseOtherReason: YMTouchableView!
    
    public var SelectedDenyReason: YMTouchableView? = nil
    public let DenyOtherReasonInput = YMTextArea(aDelegate: nil)
    
    private var TimelineIconMap = [String: String]()
    
    let BtnPanel = UIView()
    let AcceptAppointmentBtn = YMButton()
    let DenyAppointmentBtn = YMButton()
    
    var FromAppointmentRecord = false
    
    var ImageList = [YMTouchableImageView]()
    var TachedImageIdx: Int = 0
    public var imageCount: Int { get { return ImageList.count } }
    public func provideImage(completion: UIImage? -> Void) {
        if(0 == ImageList.count) {
            completion(nil)
        } else {
            completion(ImageList[0].UserObjectData as? UIImage)
        }
    }

    public func provideImage(atIndex index: Int, completion: UIImage? -> Void) {
        completion(ImageList[index].UserObjectData as? UIImage)
    }
    
    
    public func ImageTouched(gr: UITapGestureRecognizer) {
        let img = gr.view as! YMTouchableImageView
        let imgIdx = Int(img.UserStringData)
        let galleryViewController = GalleryViewController(imageProvider: self, displacedView: ParentView!,
                                                          imageCount: ImageList.count, startIndex: imgIdx!, configuration: YMLayout.DefaultGalleryConfiguration())
        NavController!.presentImageGallery(galleryViewController)
    }

    private var DetailActions: PageAppointmentDetailActions? = nil

    override func ViewLayout() {
        super.ViewLayout()
        
        DetailActions = PageAppointmentDetailActions(navController: self.NavController!, target: self)
        
        CreateTimelineIconMap()
        DrawBreadcrumbs()
        DrawDP()
        DrawAppointmentNum()
        DrawAcceptBtn()
    }
    
    private func DrawReasonLabel(labelLine: YMTouchableView, labelText: String) {
        let textLabel = UILabel()
        let checkedIcon = YMLayout.GetSuitableImageView("RegisterCheckboxAgreeChecked")
        let uncheckedIcon = YMLayout.GetSuitableImageView("RegisterCheckboxAgreeUnchecked")
        
        YMLayout.ClearView(view: labelLine)
        
        labelLine.addSubview(textLabel)
        labelLine.addSubview(checkedIcon)
        labelLine.addSubview(uncheckedIcon)
        
        textLabel.text = labelText
        textLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        textLabel.textColor = YMColors.FontLightGray
        textLabel.sizeToFit()
        
        checkedIcon.hidden = true
        
        checkedIcon.anchorToEdge(Edge.Left, padding: 30.LayoutVal(), width: checkedIcon.width, height: checkedIcon.height)
        uncheckedIcon.anchorToEdge(Edge.Left, padding: 30.LayoutVal(), width: uncheckedIcon.width, height: uncheckedIcon.height)
        
        textLabel.align(Align.ToTheRightCentered, relativeTo: uncheckedIcon, padding: 20.LayoutVal(), width: textLabel.width, height: textLabel.height)
        
        labelLine.UserObjectData = ["checked": checkedIcon, "unchecked": uncheckedIcon, "label": textLabel]
    }
    
    private func SetDenyReasonLabelUnselected(label: YMTouchableView) {
        let ctrlMap = label.UserObjectData as! [String: AnyObject]
        
        let checkedIcon = ctrlMap["checked"] as? YMTouchableImageView
        let uncheckedIcon = ctrlMap["unchecked"] as? YMTouchableImageView
        let textLabel = ctrlMap["label"] as? UILabel
        
        checkedIcon?.hidden = true
        uncheckedIcon?.hidden = false
        textLabel?.textColor = YMColors.FontLightGray
    }
    
    private func SetDenyReasonLabelSelected(label: YMTouchableView) {
        let ctrlMap = label.UserObjectData as! [String: AnyObject]
        
        let checkedIcon = ctrlMap["checked"] as? YMTouchableImageView
        let uncheckedIcon = ctrlMap["unchecked"] as? YMTouchableImageView
        let textLabel = ctrlMap["label"] as? UILabel
        
        checkedIcon?.hidden = false
        uncheckedIcon?.hidden = true
        textLabel?.textColor = YMColors.FontBlue
        
        SelectedDenyReason = label
    }
    
    private func ResetDenyDlg() {
        SetDenyReasonLabelUnselected(DenyBecauseBusy)
        SetDenyReasonLabelUnselected(DenyBecauseTrip)
        SetDenyReasonLabelUnselected(DenyBecauseNotExpertise)
        SetDenyReasonLabelUnselected(DenyBecauseOtherReason)
        
        DenyOtherReasonInput.editable = false
        DenyOtherReasonInput.backgroundColor = YMColors.BackgroundGray
    }
    
    public func SelectDenyReasonLabel(label: YMTouchableView) {
        ResetDenyDlg()
        SetDenyReasonLabelSelected(label)
        SelectedDenyReason = label
        
        if(label == DenyBecauseOtherReason){
            DenyOtherReasonInput.editable = true
            DenyOtherReasonInput.backgroundColor = YMColors.PanelBackgroundGray
        }
    }
    
    public func SetModalDialog(parent: UIView) {
        self.DenyInfoDlg = YMPageModalDialog(parentView: parent)
        
        DenyInfoBox.frame = CGRect(x: 0, y: 0, width: 560.LayoutVal(), height: 520.LayoutVal())
        DenyInfoBox.layer.cornerRadius = 28.LayoutVal()
        DenyInfoBox.backgroundColor = YMColors.White
        DenyInfoBox.layer.masksToBounds = true
        
        DenyBecauseBusy = YMLayout.GetTouchableView(useObject: DetailActions!, useMethod: "DenyDlgTagTouched:".Sel())
        DenyBecauseTrip = YMLayout.GetTouchableView(useObject: DetailActions!, useMethod: "DenyDlgTagTouched:".Sel())
        DenyBecauseNotExpertise = YMLayout.GetTouchableView(useObject: DetailActions!, useMethod: "DenyDlgTagTouched:".Sel())
        DenyBecauseOtherReason = YMLayout.GetTouchableView(useObject: DetailActions!, useMethod: "DenyDlgTagTouched:".Sel())
        
        DenyInfoBox.addSubview(DenyBecauseBusy)
        DenyInfoBox.addSubview(DenyBecauseTrip)
        DenyInfoBox.addSubview(DenyBecauseNotExpertise)
        DenyInfoBox.addSubview(DenyBecauseOtherReason)
        DenyInfoBox.addSubview(DenyOtherReasonInput)
        DenyInfoBox.addSubview(DenyTitle)
        DenyInfoBox.addSubview(DenyConfirmBtn)
        DenyInfoBox.addSubview(CancelDenyBtn)
        
        DenyTitle.text = "请输入拒绝理由"
        DenyTitle.font = YMFonts.YMDefaultFont(26.LayoutVal())
        DenyTitle.textColor = YMColors.FontGray
        DenyTitle.sizeToFit()
        DenyTitle.anchorToEdge(Edge.Top, padding: 28.LayoutVal(), width: DenyTitle.width, height: DenyTitle.height)
        
        DenyInfoBox.groupAgainstEdge(group: Group.Horizontal, views: [CancelDenyBtn, DenyConfirmBtn], againstEdge: Edge.Bottom,
                                     padding: 0, width: DenyInfoBox.width / 2, height: 80.LayoutVal())
        
        DenyConfirmBtn.setTitle("确认", forState: UIControlState.Normal)
        DenyConfirmBtn.setTitleColor(YMColors.FontGray, forState: UIControlState.Normal)
        DenyConfirmBtn.titleLabel?.font = YMFonts.YMDefaultFont(28.LayoutVal())
        DenyConfirmBtn.addTarget(DetailActions!, action: "DenyConfirmTouched:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        
        CancelDenyBtn.setTitle("取消", forState: UIControlState.Normal)
        CancelDenyBtn.setTitleColor(YMColors.FontGray, forState: UIControlState.Normal)
        CancelDenyBtn.titleLabel?.font = YMFonts.YMDefaultFont(28.LayoutVal())
        CancelDenyBtn.addTarget(DetailActions!, action: "CancelDenyTouched:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        
        DenyBecauseBusy.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 110.LayoutVal(), otherSize: 26.LayoutVal())
        DenyBecauseTrip.align(Align.UnderMatchingLeft, relativeTo: DenyBecauseBusy, padding: 20.LayoutVal(), width: DenyInfoBox.width, height: 26.LayoutVal())
        DenyBecauseNotExpertise.align(Align.UnderMatchingLeft, relativeTo: DenyBecauseTrip, padding: 20.LayoutVal(), width: DenyInfoBox.width, height: 26.LayoutVal())
        DenyBecauseOtherReason.align(Align.UnderMatchingLeft, relativeTo: DenyBecauseNotExpertise, padding: 20.LayoutVal(), width: DenyInfoBox.width, height: 26.LayoutVal())
        
        DenyBecauseBusy?.UserStringData = "1"
        DenyBecauseTrip?.UserStringData = "2"
        DenyBecauseNotExpertise?.UserStringData = "3"
        DenyBecauseOtherReason?.UserStringData = "4"
        
        DrawReasonLabel(DenyBecauseBusy, labelText: "近期比较忙，没有时间")
        DrawReasonLabel(DenyBecauseTrip, labelText: "近期要出差，无法接诊")
        DrawReasonLabel(DenyBecauseNotExpertise, labelText: "这不是我的专长，建议另约其他专家")
        DrawReasonLabel(DenyBecauseOtherReason, labelText: "其他原因")
        
        DenyOtherReasonInput.editable = false
        DenyOtherReasonInput.font = YMFonts.YMDefaultFont(26.LayoutVal())
        DenyOtherReasonInput.MaxCharCount = 50
        DenyOtherReasonInput.backgroundColor = YMColors.BackgroundGray
        DenyOtherReasonInput.anchorToEdge(Edge.Top, padding: 280.LayoutVal(), width: 450.LayoutVal(), height: 130.LayoutVal())
        
        let titleBottom = UIView()
        let btnTop = UIView()
        let btnDivider = UIView()
        
        titleBottom.backgroundColor = YMColors.DividerLineGray
        btnTop.backgroundColor = YMColors.DividerLineGray
        btnDivider.backgroundColor = YMColors.DividerLineGray
        
        DenyInfoBox.addSubview(titleBottom)
        DenyInfoBox.addSubview(btnTop)
        DenyInfoBox.addSubview(btnDivider)
        
        titleBottom.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 80.LayoutVal(), otherSize: YMSizes.OnPx)
        btnTop.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 80.LayoutVal(), otherSize: YMSizes.OnPx)
        btnDivider.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.OnPx, height: 80.LayoutVal())
        
        ResetDenyDlg()
        SetDenyReasonLabelSelected(DenyBecauseBusy)
    }
    
    func DrawAcceptBtn() {
        AcceptAppointmentBtn.setTitle("同意代约", forState: UIControlState.Normal)
        AcceptAppointmentBtn.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        AcceptAppointmentBtn.backgroundColor = YMColors.FontBlue
        AcceptAppointmentBtn.titleLabel?.font = YMFonts.YMDefaultFont(40.LayoutVal())
        
        AcceptAppointmentBtn.addTarget(DetailActions, action: "AcceptAppointment:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        
        DenyAppointmentBtn.setTitle("拒绝代约", forState: UIControlState.Normal)
        DenyAppointmentBtn.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        DenyAppointmentBtn.backgroundColor = YMColors.FontBlue
        DenyAppointmentBtn.titleLabel?.font = YMFonts.YMDefaultFont(40.LayoutVal())
        
        DenyAppointmentBtn.addTarget(DetailActions, action: "DenyAppointmentTouched:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        
        ParentView?.addSubview(BtnPanel)
        BtnPanel.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: 98.LayoutVal())
        
        let divider = UIView()
        divider.backgroundColor = YMColors.White

        BtnPanel.addSubview(DenyAppointmentBtn)
        BtnPanel.addSubview(AcceptAppointmentBtn)
        BtnPanel.addSubview(divider)
        
        BtnPanel.groupAndFill(group: Group.Horizontal, views: [DenyAppointmentBtn, AcceptAppointmentBtn], padding: 0)
        divider.anchorInCenter(width: YMSizes.OnPx, height: 60.LayoutVal())
    }
    
    private func CreateTimelineIconMap() {
        TimelineIconMap["begin"] = "YMIconTimelineBegin"
        TimelineIconMap["close"] = "YMIconTimelineClose"
        TimelineIconMap["completed"] = "YMIconTimelineCompleted"
        TimelineIconMap["no"] = "YMIconTimelineCancel"
        TimelineIconMap["notepad"] = "YMIconTimelineNotepadBlue"
        TimelineIconMap["lastNotepad"] = "YMIconTimelineNotepadYellow"
        TimelineIconMap["pass"] = "YMIconTimelinePass"
        TimelineIconMap["time"] = "YMIconTimelineTime"
        TimelineIconMap["wait"] = "YMIconTimelineWait"
    }
    
    private func DrawBreadcrumbs() {
        BodyView.addSubview(Breadcrumbs)
        Breadcrumbs.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 110.LayoutVal())
        
        func InitLabels(label: UILabel, text: String) {
            label.text = text
            label.textColor = YMColors.FontGray
            label.textAlignment = NSTextAlignment.Center
            label.backgroundColor = YMColors.CommonBottomGray
            label.font = YMFonts.YMDefaultFont(24.LayoutVal())
            label.layer.cornerRadius = 8.LayoutVal()
            label.layer.masksToBounds = true
        }
        
        let start = UILabel()
        let patientConfirm = UILabel()
        let docConfirm = UILabel()
        let end = UILabel()
        let indc = UILabel()
        
        let arr1 = YMLayout.GetSuitableImageView("CommonGrayRightArrowIcon")
        let arr2 = YMLayout.GetSuitableImageView("CommonGrayRightArrowIcon")
        let arr3 = YMLayout.GetSuitableImageView("CommonGrayRightArrowIcon")
        
        Breadcrumbs.addSubview(start)
        Breadcrumbs.addSubview(patientConfirm)
        Breadcrumbs.addSubview(docConfirm)
        Breadcrumbs.addSubview(end)
        Breadcrumbs.addSubview(indc)

        Breadcrumbs.addSubview(arr1)
        Breadcrumbs.addSubview(arr2)
        Breadcrumbs.addSubview(arr3)
        
        InitLabels(start, text: "发起约诊")
        InitLabels(patientConfirm, text: "患者确认")
        InitLabels(docConfirm, text: "医生确认")
        InitLabels(end, text: "面诊完成")
        
        let labelWidth = 140.LayoutVal()
        let labelHeight = 40.LayoutVal()
        let labelPadding = 44.LayoutVal()
        let arrPadding = (labelPadding - arr1.width) / 2
        start.anchorInCorner(Corner.TopLeft, xPad: 30.LayoutVal(), yPad: 20.LayoutVal(),
                             width: labelWidth, height: labelHeight)
        
        patientConfirm.align(Align.ToTheRightCentered, relativeTo: start,
                             padding: labelPadding, width: labelWidth, height: labelHeight)
        
        docConfirm.align(Align.ToTheRightCentered, relativeTo: patientConfirm,
                             padding: labelPadding, width: labelWidth, height: labelHeight)

        
        end.align(Align.ToTheRightCentered, relativeTo: docConfirm,
                             padding: labelPadding, width: labelWidth, height: labelHeight)
        
        arr1.alignBetweenHorizontal(align: Align.ToTheRightCentered,
                                    primaryView: start, secondaryView: patientConfirm,
                                    padding: arrPadding, height: arr1.height)
        
        arr2.alignBetweenHorizontal(align: Align.ToTheRightCentered,
                                    primaryView: patientConfirm, secondaryView: docConfirm,
                                    padding: arrPadding, height: arr1.height)
        
        arr3.alignBetweenHorizontal(align: Align.ToTheRightCentered,
                                    primaryView: docConfirm, secondaryView: end,
                                    padding: arrPadding, height: arr1.height)
        
        indc.textColor = YMColors.FontGray
        indc.font = YMFonts.YMDefaultFont(20.LayoutVal())
        
        Breadcrumbs.UserObjectData = [
            YMAppointmentDetailStrings.BREADCRUMBS_LABEL_START: start,
            YMAppointmentDetailStrings.BREADCRUMBS_LABEL_PATIENT_CONFIRM: patientConfirm,
            YMAppointmentDetailStrings.BREADCRUMBS_LABEL_DOC_CONFIRM: docConfirm,
            YMAppointmentDetailStrings.BREADCRUMBS_LABEL_END: end,

            YMAppointmentDetailStrings.BREADCRUMBS_INDC: indc,

            YMAppointmentDetailStrings.BREADCRUMBS_ARR_1: arr1,
            YMAppointmentDetailStrings.BREADCRUMBS_ARR_2: arr2,
            YMAppointmentDetailStrings.BREADCRUMBS_ARR_3: arr3
        ]
    }

    private func DrawDorctor(data: [String: AnyObject]) {
        let headImage = YMLayout.GetSuitableImageView("CommonHeadImageBorder")
        let docName = UILabel()
        let jobTitle = UILabel()
        let dept = UILabel()
        let hospital = UILabel()
        let divider = UIView()
        
        DocCell.addSubview(headImage)
        DocCell.addSubview(jobTitle)
        DocCell.addSubview(docName)
        DocCell.addSubview(dept)
        DocCell.addSubview(hospital)
        DocCell.addSubview(divider)
        
        headImage.anchorToEdge(Edge.Top, padding: 30.LayoutVal(),
                               width: headImage.width, height: headImage.height)
        
        let head = data["head_url"] as? String
        YMLayout.SetDocfHeadImageVFlag(headImage, docInfo: data)
        if(nil != head) {
            YMLayout.LoadImageFromServer(headImage, url: head!, fullUrl: nil, makeItRound: true)
        }

        divider.backgroundColor = YMColors.FontBlue
        divider.align(Align.UnderCentered, relativeTo: headImage,
                      padding: 20.LayoutVal(), width: YMSizes.OnPx, height: 20.LayoutVal())
        
        docName.text = data["name"] as? String
        docName.textColor = YMColors.FontBlue
        docName.font = YMFonts.YMDefaultFont(30.LayoutVal())
        docName.sizeToFit()
        docName.align(Align.ToTheLeftCentered, relativeTo: divider,
                      padding: 12.LayoutVal(),
                      width: docName.width, height: docName.height)
        
        jobTitle.text = YMVar.GetStringByKey(data, key: "job_title", defStr: "医生")
        jobTitle.textColor = YMColors.FontGray
        jobTitle.font = YMFonts.YMDefaultFont(20.LayoutVal())
        jobTitle.sizeToFit()
        jobTitle.align(Align.ToTheRightCentered, relativeTo: divider,
                       padding: 12.LayoutVal(),
                       width: jobTitle.width, height: jobTitle.height)
        
        dept.text = data["department"] as? String
        dept.textColor = YMColors.FontBlue
        dept.font = YMFonts.YMDefaultFont(20.LayoutVal())
        dept.sizeToFit()
        dept.align(Align.UnderCentered, relativeTo: divider,
                       padding: 12.LayoutVal(),
                       width: dept.width, height: dept.height)
        
        hospital.text = data["hospital"] as? String
        hospital.textColor = YMColors.FontLightGray
        hospital.font = YMFonts.YMDefaultFont(24.LayoutVal())
        hospital.numberOfLines = 2
        hospital.textAlignment = NSTextAlignment.Center
        hospital.frame = CGRectMake(0, 0, 285.LayoutVal(), 0)
        hospital.sizeToFit()
        hospital.align(Align.UnderCentered,
                       relativeTo: dept,
                       padding: 8.LayoutVal(),
                       width: hospital.width, height: hospital.height)
    }
    
    private func DrawPatientOnly(data: [String: AnyObject]) {
        let headImage = YMLayout.GetSuitableImageView("CommonHeadImageBorder")
        let patientName = UILabel()
        let gender = UILabel()
        let age = UILabel()
        let phone = UILabel()
        let divider = UIView()
        let phoneIcon = YMLayout.GetSuitableImageView("YMIconPhone")
        
        PatientOnlyCell.addSubview(headImage)
        PatientOnlyCell.addSubview(patientName)
        PatientOnlyCell.addSubview(gender)
        PatientOnlyCell.addSubview(age)
        PatientOnlyCell.addSubview(phone)
        PatientOnlyCell.addSubview(divider)
        PatientOnlyCell.addSubview(phoneIcon)
        
        headImage.anchorToEdge(Edge.Top, padding: 30.LayoutVal(),
                               width: headImage.width, height: headImage.height)
        let head = data["head_url"] as? String
        if(nil != head) {
            YMLayout.LoadImageFromServer(headImage, url: head!, fullUrl: nil, makeItRound: true)
        }
        
        patientName.text = "\(data["name"]!)"
        patientName.textColor = YMColors.FontBlue
        patientName.font = YMFonts.YMDefaultFont(30.LayoutVal())
        patientName.sizeToFit()
        patientName.align(Align.UnderCentered, relativeTo: headImage,
                          padding: 12.LayoutVal(),
                          width: patientName.width, height: patientName.height)
        
        divider.backgroundColor = YMColors.FontBlue
        divider.align(Align.UnderCentered, relativeTo: patientName,
                      padding: 12.LayoutVal(), width: YMSizes.OnPx, height: 20.LayoutVal())
        
        let genderMap = ["0":"女", "1":"男"]
        gender.text = genderMap["\(data["sex"]!)"]
        gender.textColor = YMColors.FontGray
        gender.font = YMFonts.YMDefaultFont(20.LayoutVal())
        gender.sizeToFit()
        gender.align(Align.ToTheLeftCentered, relativeTo: divider,
                     padding: 12.LayoutVal(),
                     width: gender.width, height: gender.height)
        
        
        
        age.text = "\(data["age"]!) 岁"
        age.textColor = YMColors.FontGray
        age.font = YMFonts.YMDefaultFont(20.LayoutVal())
        age.sizeToFit()
        age.align(Align.ToTheRightCentered, relativeTo: divider,
                  padding: 12.LayoutVal(),
                  width: age.width, height: age.height)
        
        phone.text = data["phone"] as? String
        phone.textColor = YMColors.FontLightGray
        phone.font = YMFonts.YMDefaultFont(20.LayoutVal())
        phone.sizeToFit()
        phone.align(Align.UnderCentered, relativeTo: headImage,
                    padding: 92.LayoutVal(),
                    width: phone.width, height: phone.height)
        
        phoneIcon.align(Align.ToTheLeftCentered, relativeTo: phone,
                        padding: -10.LayoutVal(),
                        width: phoneIcon.width, height: phoneIcon.height)
    
        phone.align(Align.ToTheRightCentered, relativeTo: phoneIcon, padding: 8.LayoutVal(), width: phone.width, height: phone.height)
    }
    
    private func DrawPatient(data: [String: AnyObject]) {
        let headImage = YMLayout.GetSuitableImageView("CommonHeadImageBorder")
        let patientName = UILabel()
        let gender = UILabel()
        let age = UILabel()
        let phone = UILabel()
        let divider = UIView()
        let phoneIcon = YMLayout.GetSuitableImageView("YMIconPhone")
        
        PatientCell.addSubview(headImage)
        PatientCell.addSubview(patientName)
        PatientCell.addSubview(gender)
        PatientCell.addSubview(age)
        PatientCell.addSubview(phone)
        PatientCell.addSubview(divider)
        PatientCell.addSubview(phoneIcon)
        
        headImage.anchorToEdge(Edge.Top, padding: 30.LayoutVal(),
                               width: headImage.width, height: headImage.height)
        
        let head = data["head_url"] as? String
        if(nil != head) {
            YMLayout.LoadImageFromServer(headImage, url: head!, fullUrl: nil, makeItRound: true)
        }
        
        patientName.text = "\(data["name"]!)"
        patientName.textColor = YMColors.FontBlue
        patientName.font = YMFonts.YMDefaultFont(30.LayoutVal())
        patientName.sizeToFit()
        patientName.align(Align.UnderCentered, relativeTo: headImage,
                      padding: 12.LayoutVal(),
                      width: patientName.width, height: patientName.height)
        
        divider.backgroundColor = YMColors.FontBlue
        divider.align(Align.UnderCentered, relativeTo: patientName,
                      padding: 12.LayoutVal(), width: YMSizes.OnPx, height: 20.LayoutVal())
        
        let genderMap = ["0":"女", "1":"男"]
        gender.text = genderMap["\(data["sex"]!)"]
        gender.textColor = YMColors.FontGray
        gender.font = YMFonts.YMDefaultFont(20.LayoutVal())
        gender.sizeToFit()
        gender.align(Align.ToTheLeftCentered, relativeTo: divider,
                      padding: 12.LayoutVal(),
                      width: gender.width, height: gender.height)
        
        
        
        age.text = "\(data["age"]!) 岁"
        age.textColor = YMColors.FontGray
        age.font = YMFonts.YMDefaultFont(20.LayoutVal())
        age.sizeToFit()
        age.align(Align.ToTheRightCentered, relativeTo: divider,
                     padding: 12.LayoutVal(),
                     width: age.width, height: age.height)
        
        phone.text = data["phone"] as? String
        phone.textColor = YMColors.FontLightGray
        phone.font = YMFonts.YMDefaultFont(20.LayoutVal())
        phone.sizeToFit()
        phone.align(Align.UnderCentered, relativeTo: headImage,
                    padding: 92.LayoutVal(),
                    width: phone.width, height: phone.height)
        
        phoneIcon.align(Align.ToTheLeftCentered, relativeTo: phone,
                        padding: -10.LayoutVal(),
                        width: phoneIcon.width, height: phoneIcon.height)
        
        phone.align(Align.ToTheRightCentered, relativeTo: phoneIcon, padding: 8.LayoutVal(), width: phone.width, height: phone.height)
    }
    
    private func DrawDP() {
        BodyView.addSubview(DPPanel)
        DPPanel.align(Align.UnderMatchingLeft, relativeTo: Breadcrumbs,
                      padding: 0, width: YMSizes.PageWidth, height: 310.LayoutVal())
        
        DocCell.backgroundColor = YMColors.White
        PatientCell.backgroundColor = YMColors.White
        PatientOnlyCell.backgroundColor = YMColors.White

        DPPanel.addSubview(DocCell)
        DPPanel.addSubview(PatientCell)
        DPPanel.groupAndFill(group: Group.Horizontal, views: [DocCell, PatientCell], padding: 0)

        let divider = UIView()
        DPPanel.addSubview(divider)
        divider.backgroundColor = YMColors.DividerLineGray
        divider.anchorInCenter(width: YMSizes.OnPx, height: DPPanel.height)
        
        DPPanel.addSubview(PatientOnlyCell)
        PatientOnlyCell.fillSuperview()
    }
    
    private func DrawAppointmentNum() {
        BodyView.addSubview(AppointmentNum)
        AppointmentNum.font = YMFonts.YMDefaultFont(20.LayoutVal())
        AppointmentNum.textColor = YMColors.FontBlue
        AppointmentNum.textAlignment = NSTextAlignment.Center
        AppointmentNum.align(Align.UnderMatchingLeft, relativeTo: DPPanel,
                             padding: 0, width: YMSizes.PageWidth, height: 50.LayoutVal())
    }
    
    private func DrawTextInfo(data: [String: AnyObject]) {
        BodyView.addSubview(TextInfoPanel)
        TextInfoPanel.backgroundColor = YMColors.White
        TextInfoPanel.align(Align.UnderMatchingLeft, relativeTo: AppointmentNum,
                            padding: 0, width: YMSizes.PageWidth, height: 220.LayoutVal())
        
        let titleLabel = UILabel()
        var history = data["history"] as? String
        
        TextInfoPanel.addSubview(titleLabel)
        titleLabel.text = "病情资料"
        titleLabel.textColor = YMColors.FontBlue
        titleLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        titleLabel.sizeToFit()
        titleLabel.anchorInCorner(Corner.TopLeft,
                                  xPad: 40.LayoutVal(), yPad: 20.LayoutVal(),
                                  width: titleLabel.width, height: titleLabel.height)

        if(YMValueValidator.IsEmptyString(history)) {
            history = "无"
        }
        
        let textContent = YMLayout.GetTouchableView(useObject: DetailActions!, useMethod: "TextDetailTouched:".Sel())
        TextInfoPanel.addSubview(textContent)
        
        let divider = UIView()
        divider.backgroundColor = YMColors.DividerLineGray
        TextInfoPanel.addSubview(divider)
        divider.anchorInCorner(Corner.TopLeft, xPad: 0, yPad: 60.LayoutVal(), width: YMSizes.PageWidth, height: YMSizes.OnPx)
        
        let hisLabel = UILabel()
        hisLabel.numberOfLines = 3
        hisLabel.text = history!
        hisLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        hisLabel.textColor = YMColors.FontGray
        hisLabel.frame = CGRectMake(0, 0, 670.LayoutVal(), 0)
        hisLabel.sizeToFit()
        textContent.align(Align.UnderMatchingLeft, relativeTo: divider,
                          padding: 30.LayoutVal(),
                          width: YMSizes.PageWidth,
                          height: hisLabel.height + 30.LayoutVal())
        textContent.addSubview(hisLabel)
        hisLabel.anchorToEdge(Edge.Top, padding: 0, width: hisLabel.width, height: hisLabel.height)
        hisLabel.anchorInCorner(Corner.TopLeft,
                                xPad: 40.LayoutVal(), yPad: 0, width: hisLabel.width, height: hisLabel.height)
    }
    
    public func ShowImage(list: UIScrollView, imgUrl: String, prev: UIImageView?) -> YMTouchableImageView {
        let img = YMTouchableImageView()
        let url = NSURL(string: imgUrl)
//        img.setImageWithURL(url!, placeholderImage: nil)
        img.backgroundColor = YMColors.DividerLineGray
        
        list.addSubview(img)
        if(nil == prev) {
            img.anchorToEdge(Edge.Left, padding: 0, width: list.height, height: list.height)
        } else {
            img.align(Align.ToTheRightCentered, relativeTo: prev!,
                      padding: 20.LayoutVal(),
                      width: list.height, height: list.height)
        }
        
        img.kf_setImageWithURL(url, placeholderImage: nil, optionsInfo: nil, progressBlock: nil,  completionHandler: { (image, error, cacheType, imageURL) in
            if(nil != image) {
                img.UserObjectData = image
                img.image = Toucan(image: image!)
                    .resize(CGSize(width: img.width, height: img.height), fitMode: Toucan.Resize.FitMode.Crop).image
            }
        })
        
        let tapGR = UITapGestureRecognizer(target: self, action: "ImageTouched:".Sel())
        
        img.userInteractionEnabled = true
        img.addGestureRecognizer(tapGR)
        img.UserStringData = "\(ImageList.count)"
        ImageList.append(img)
        
        return img
    }
    
    private func DrawImageList(data: [String: AnyObject]) {
        ImageList.removeAll()

        BodyView.addSubview(ImagePanel)
        ImagePanel.backgroundColor = YMColors.White
        ImagePanel.align(Align.UnderMatchingLeft, relativeTo: TextInfoPanel,
                         padding: YMSizes.OnPx,
                         width: YMSizes.PageWidth, height: 225.LayoutVal())
        let imgUrlList = data["img_url"] as? String
        if(YMValueValidator.IsEmptyString(imgUrlList)) {
            let noImageLabel = UILabel()
            ImagePanel.addSubview(noImageLabel)
            noImageLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
            noImageLabel.textColor = YMColors.FontGray
            noImageLabel.text = "未提供病历图片"
            noImageLabel.sizeToFit()
            noImageLabel.anchorInCenter(width: noImageLabel.width, height: noImageLabel.height)
            return
        }
        
        let leftArr = YMLayout.GetSuitableImageView("PageAppointmentPhotoScrollLeft")
        let rightArr = YMLayout.GetSuitableImageView("PageAppointmentPhotoScrollRight")
        let leftButton = YMLayout.GetTouchableView(useObject: DetailActions!, useMethod: "ImageScrollLeft:".Sel())
        let rightButton = YMLayout.GetTouchableView(useObject: DetailActions!, useMethod: "ImageScrollRight:".Sel())

        ImagePanel.addSubview(leftButton)
        ImagePanel.addSubview(rightButton)
        
        leftButton.anchorToEdge(Edge.Left, padding: 0, width: 58.LayoutVal(), height: ImagePanel.height)
        rightButton.anchorToEdge(Edge.Right, padding: 0, width: 58.LayoutVal(), height: ImagePanel.height)
        
        leftButton.addSubview(leftArr)
        rightButton.addSubview(rightArr)
        
        leftArr.anchorToEdge(Edge.Right, padding: 20.LayoutVal(), width: leftArr.width, height: leftArr.height)
        rightArr.anchorToEdge(Edge.Left, padding: 20.LayoutVal(), width: rightArr.width, height: rightArr.height)

        let imgArr = imgUrlList!.componentsSeparatedByString(",")

        let imgList = UIScrollView()
        ImagePanel.addSubview(imgList)
        imgList.align(Align.ToTheRightCentered, relativeTo: leftButton,
                      padding: 0, width: 634.LayoutVal(), height: 145.LayoutVal())
        
        var prevImg: YMTouchableImageView? = nil
        for imgUrl in imgArr {
            prevImg = ShowImage(imgList, imgUrl: imgUrl, prev: prevImg)
        }
        
        YMLayout.SetHScrollViewContentSize(imgList, lastSubView: prevImg)
    }

    private func DrawTimelineTypeIcon(type: String, prev: UIView?, idx: Int, lastIdx: Int) -> UIImageView {
        var realType = type
        if("notepad" == type) {
            if(idx == lastIdx) {
                realType = "lastNotepad"
            }
        }
        
        let icon = YMLayout.GetSuitableImageView(TimelineIconMap[realType]!)
        
        TimeLinePanel.addSubview(icon)

        if(nil == prev) {
            icon.anchorInCorner(Corner.TopLeft,
                                xPad: 204.LayoutVal(), yPad: 40.LayoutVal(),
                                width: icon.width, height: icon.height)
        } else {
            icon.align(Align.UnderCentered, relativeTo: prev!,
                       padding: 10.LayoutVal(), width: icon.width, height: icon.height)
        }
        
        return icon
    }
    
    private func DrawTimelineTimelabel(time: String, icon: UIImageView) {
        let timeArr = time.componentsSeparatedByString(" ")
        
        
        if(timeArr.count < 2) {
            return
        }
        let day = timeArr[0]
        let time = timeArr[1]
        
        let dayLabel = UILabel()
        let timeLabel = UILabel()
        
        func SetTimelableStyle(text: String, label: UILabel) {
            label.text = text
            label.textColor = YMColors.FontBlue
            label.font = YMFonts.YMDefaultFont(22.LayoutVal())
            label.sizeToFit()
        }
        
        TimeLinePanel.addSubview(dayLabel)
        TimeLinePanel.addSubview(timeLabel)
        
        SetTimelableStyle(day, label: dayLabel)
        SetTimelableStyle(time, label: timeLabel)
        
        dayLabel.align(Align.ToTheLeftCentered, relativeTo: icon,
                       padding: 28.LayoutVal(), width: dayLabel.width, height: dayLabel.height)
        timeLabel.align(Align.UnderMatchingLeft, relativeTo: dayLabel,
                        padding: 4.LayoutVal(), width: timeLabel.width, height: timeLabel.height)
    }
    
    private func DrawTimelineInfoDetail(detail: [String: AnyObject], prev: UIView) -> UIView {
        let detailCell = UIView()
        TimeLinePanel.addSubview(detailCell)
        
        let cellFullWidth = 420.LayoutVal()
        detailCell.align(Align.UnderMatchingLeft,
                         relativeTo: prev, padding: 10.LayoutVal(),
                         width: cellFullWidth, height: 0)
        
        let title = UILabel()
        title.text = detail["name"] as? String
        title.textColor = YMColors.FontLightGray
        title.font = YMFonts.YMDefaultFont(24.LayoutVal())
        title.sizeToFit()
        
        detailCell.addSubview(title)
        title.anchorInCorner(Corner.TopLeft, xPad: 0, yPad: 10.LayoutVal(),
                             width: title.width, height: title.height)
        
        let contentWidth = cellFullWidth - title.width - 16.LayoutVal()
        let contentInnerWidth = contentWidth - 20.LayoutVal()
        
        let content = detail["content"] as? String
        if(nil != content) {
            let contentCell = UIView()
            let contentLabel = UILabel()
            
            detailCell.addSubview(contentCell)
            contentCell.anchorInCorner(Corner.TopRight, xPad: 0, yPad: 0, width: contentWidth, height: 0)
            contentCell.backgroundColor = YMColors.DividerLineGray
            contentCell.addSubview(contentLabel)
            
            contentLabel.text = content!
            contentLabel.textColor = YMColors.FontBlue
            contentLabel.font = YMFonts.YMDefaultFont(24.LayoutVal())
            contentLabel.numberOfLines = 0
            contentLabel.frame = CGRectMake(0, 0, contentInnerWidth, 0)
            contentLabel.sizeToFit()
            
            contentLabel.anchorInCorner(Corner.TopLeft, xPad: 10.LayoutVal(), yPad: 9.LayoutVal(),
                                        width: contentLabel.width, height: contentLabel.height)
            
            YMLayout.SetViewHeightByLastSubview(contentCell, lastSubView: contentLabel, bottomPadding: 10.LayoutVal())
            YMLayout.SetViewHeightByLastSubview(detailCell, lastSubView: contentCell)
        }
        
        return detailCell
    }

    private func DrawTimelineInfo(info: [String: AnyObject], icon: UIImageView) -> UIView {
        let title = info["text"] as! String
        let detailInfo = info["other"] as? [[String: AnyObject]]
        
        var prev: UIView
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = YMColors.FontGray
        titleLabel.font = YMFonts.YMDefaultFont(30.LayoutVal())
        titleLabel.numberOfLines = 0
        titleLabel.frame = CGRectMake(0, 0, 420.LayoutVal(), 0)
        titleLabel.sizeToFit()
        
        TimeLinePanel.addSubview(titleLabel)
        titleLabel.align(Align.ToTheRightCentered, relativeTo: icon,
                         padding: 28.LayoutVal(), width: titleLabel.width, height: titleLabel.height)
        prev = titleLabel

        if(nil != detailInfo) {
            for v in detailInfo! {
                prev = DrawTimelineInfoDetail(v, prev: prev)
            }
        }
        
        return prev
    }
    
    private func DrawLine(detailCell: UIView, icon: UIImageView) -> UIView {
        let line = UIView()
        TimeLinePanel.addSubview(line)
        line.backgroundColor = YMColors.FontBlue
        line.align(Align.UnderCentered, relativeTo: icon, padding: 10.LayoutVal(),
                   width: YMSizes.OnPx, height: detailCell.frame.origin.y - icon.frame.origin.y + 45.LayoutVal())
        return line
    }
    
    private func DrawExpectPanel(data: [String: AnyObject]?) {
        BodyView.addSubview(DemandPanel)
        
        if(nil == data) {
            DemandPanel.align(Align.UnderMatchingLeft, relativeTo: ImagePanel, padding: 0, width: YMSizes.PageWidth, height: 0)
            return
        }

        DemandPanel.align(Align.UnderMatchingLeft, relativeTo: ImagePanel, padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: 0)
        let expectDoc = YMVar.GetStringByKey(data, key: "doctor_name", defStr: "无")
        let expectDept = YMVar.GetStringByKey(data, key: "department", defStr: "无")
        let expectJobtitle = YMVar.GetStringByKey(data, key: "job_title", defStr: "无")
        let expectHos = YMVar.GetStringByKey(data, key: "hospital", defStr: "无")
        
        let expectStr = "期望就诊医院：\(expectHos)\r\n期望就诊科室：\(expectDept)\r\n期望接诊医生职称：\(expectJobtitle)\r\n期望接诊医生姓名：\(expectDoc)"
        
        let label = YMLayout.GetNomalLabel(expectStr, textColor: YMColors.FontGray, fontSize: 26.LayoutVal())
        label.numberOfLines = 0
        label.frame = CGRect(x: 0, y: 0, width: 670.LayoutVal(), height: 0)
        label.sizeToFit()
        
        DemandPanel.addSubview(label)
        DemandPanel.backgroundColor = YMColors.White
        label.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 20.LayoutVal(), width: 670.LayoutVal(), height: label.height)
        
        YMLayout.SetViewHeightByLastSubview(DemandPanel, lastSubView: label, bottomPadding: 20.LayoutVal())
    }

    private func DrawTimeline(data: [[String: AnyObject]]) {
        BodyView.addSubview(TimeLinePanel)
        TimeLinePanel.align(Align.UnderMatchingLeft, relativeTo: DemandPanel,
                            padding: 0, width: YMSizes.PageWidth, height: 0)
        
        if(0 == data.count) {
            return
        }
        
        var prevLine: UIView? = nil
        var detailCell: UIView? = nil
        let lastIdx = data.count - 1
        for (k, v) in data.enumerate() {
            let time = v["time"] as? String
            let type = v["type"] as! String
            let info = v["info"] as! [String: AnyObject]

            let icon = DrawTimelineTypeIcon(type, prev: prevLine, idx: k, lastIdx: lastIdx)

            if(nil != time) {
                DrawTimelineTimelabel(time!, icon: icon)
            }
            
            detailCell = DrawTimelineInfo(info, icon: icon)
            
            if(k != lastIdx) {
                prevLine = DrawLine(detailCell!, icon: icon)
            }
        }
        
        YMLayout.SetViewHeightByLastSubview(TimeLinePanel, lastSubView: detailCell!, bottomPadding: 10.LayoutVal())
    }
    
    private func SetBreadcrumbsEnabel(label: UILabel) {
        label.backgroundColor = YMColors.FontBlue
        label.textColor = YMColors.White
    }
    
    private func SetBreadcrumbsDisable(label: UILabel) {
        label.backgroundColor = YMColors.CommonBottomGray
        label.textColor = YMColors.FontGray
    }
    
    private func ResetBreadcrumbs() {
        let controllerMap = Breadcrumbs.UserObjectData as! [String: AnyObject]
        let start = controllerMap[YMAppointmentDetailStrings.BREADCRUMBS_LABEL_START] as! UILabel
        let patientConfirm = controllerMap[YMAppointmentDetailStrings.BREADCRUMBS_LABEL_PATIENT_CONFIRM] as! UILabel
        let docConfirm = controllerMap[YMAppointmentDetailStrings.BREADCRUMBS_LABEL_DOC_CONFIRM] as! UILabel
        let end = controllerMap[YMAppointmentDetailStrings.BREADCRUMBS_LABEL_END] as! UILabel
        
        let indc = controllerMap[YMAppointmentDetailStrings.BREADCRUMBS_INDC] as! UILabel
        
        SetBreadcrumbsDisable(start)
        SetBreadcrumbsDisable(patientConfirm)
        SetBreadcrumbsDisable(docConfirm)
        SetBreadcrumbsDisable(end)
        
        indc.text = ""
    }
    
    private func SetBreadcrumbs(data: [String: AnyObject]) {
        let milestone = data["milestone"] as? String
        let status = data["status"] as? String

        if(nil == milestone) {
            return
        }
        
        let controllerMap = Breadcrumbs.UserObjectData as! [String: AnyObject]
        let start = controllerMap[YMAppointmentDetailStrings.BREADCRUMBS_LABEL_START] as! UILabel
        let patientConfirm = controllerMap[YMAppointmentDetailStrings.BREADCRUMBS_LABEL_PATIENT_CONFIRM] as! UILabel
        let docConfirm = controllerMap[YMAppointmentDetailStrings.BREADCRUMBS_LABEL_DOC_CONFIRM] as! UILabel
        let end = controllerMap[YMAppointmentDetailStrings.BREADCRUMBS_LABEL_END] as! UILabel
        
        let indc = controllerMap[YMAppointmentDetailStrings.BREADCRUMBS_INDC] as! UILabel

        let arr1 = controllerMap[YMAppointmentDetailStrings.BREADCRUMBS_ARR_1] as! UIImageView
        let arr2 = controllerMap[YMAppointmentDetailStrings.BREADCRUMBS_ARR_2] as! UIImageView
        let arr3 = controllerMap[YMAppointmentDetailStrings.BREADCRUMBS_ARR_3] as! UIImageView
        
        if("发起约诊" == milestone!) {
            SetBreadcrumbsEnabel(start)

            if(nil != status) {
                indc.text = status!
                indc.sizeToFit()
                indc.align(Align.UnderCentered, relativeTo: arr1, padding: 22.LayoutVal(),
                           width: indc.width, height: indc.height)
            }
        } else if("患者确认" == milestone) {
            SetBreadcrumbsEnabel(start)
            SetBreadcrumbsEnabel(patientConfirm)
            
            if(nil != status) {
                indc.text = status!
                indc.sizeToFit()
                indc.align(Align.UnderCentered, relativeTo: arr2, padding: 22.LayoutVal(),
                           width: indc.width, height: indc.height)
            }
        } else if("医生确认" == milestone) {
            SetBreadcrumbsEnabel(start)
            SetBreadcrumbsEnabel(patientConfirm)
            SetBreadcrumbsEnabel(docConfirm)
            
            if(nil != status) {
                indc.text = status!
                indc.sizeToFit()
                indc.align(Align.UnderCentered, relativeTo: arr3, padding: 22.LayoutVal(),
                           width: indc.width, height: indc.height)
            }
        } else {
            SetBreadcrumbsEnabel(start)
            SetBreadcrumbsEnabel(patientConfirm)
            SetBreadcrumbsEnabel(docConfirm)
            SetBreadcrumbsEnabel(end)
        }
    }

    public func LoadData(data: NSDictionary) {
        let otherInfo = data["other_info"] as! [String: AnyObject]
        let progress = otherInfo["progress"] as! [String: AnyObject]
        let timeLine = otherInfo["time_line"] as! [[String: AnyObject]]

        let doc = data["doctor_info"] as! [String: AnyObject]
        let patient = data["patient_info"] as! [String: AnyObject]
        
        let patientDemand = data["patient_demand"] as? [String: AnyObject]

        AcceptAppointmentBtn.UserObjectData = data
        DenyAppointmentBtn.UserObjectData = data
        
        let docId = YMVar.GetStringByKey(doc, key: "id")
        if(YMValueValidator.IsBlankString(docId) || docId == YMVar.MyDoctorId) {
            DrawPatientOnly(patient)

            DocCell.hidden = true
            PatientCell.hidden = true
            PatientOnlyCell.hidden = false
            
            if(FromAppointmentRecord) {
                BtnPanel.hidden = false
            }
        } else {
            DrawDorctor(doc)
            DrawPatient(patient)
            
            DocCell.hidden = false
            PatientCell.hidden = false
            PatientOnlyCell.hidden = true
            BtnPanel.hidden = true
        }
        
        SetBreadcrumbs(progress)
        AppointmentNum.text = PageAppointmentDetailViewController.AppointmentID
        DrawTextInfo(patient)
        DrawImageList(patient)
        if(FromAppointmentRecord) {
            DrawExpectPanel(patientDemand)
        } else {
            DrawExpectPanel(nil)
        }
        DrawTimeline(timeLine)
        
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: TimeLinePanel, padding: 128.LayoutVal())
        FullPageLoading.Hide()
    }
    
    public func GetAdmissionDetail() {
        DetailActions?.GetAdmissionDetailDetail()
    }
    
    public func GetAppointmentDetail() {
        DetailActions?.GetAppointmentDetail()
    }
    
    public func Clear() {
        ResetBreadcrumbs()
        YMLayout.ClearView(view: DocCell)
        YMLayout.ClearView(view: PatientCell)
        YMLayout.ClearView(view: PatientOnlyCell)
        
        DocCell.hidden = true
        PatientCell.hidden = true
        PatientOnlyCell.hidden = true
        BtnPanel.hidden = true
        
        YMLayout.ClearView(view: TextInfoPanel)
        YMLayout.ClearView(view: ImagePanel)
        YMLayout.ClearView(view: TimeLinePanel)
        YMLayout.ClearView(view: DemandPanel)
    }
    
    public func ShowDenyDialog() {
        DenyInfoDlg?.Show(DenyInfoBox)
    }
    
    public func HideDenyDialog() {
        DenyInfoDlg?.Hide()
    }
}




























