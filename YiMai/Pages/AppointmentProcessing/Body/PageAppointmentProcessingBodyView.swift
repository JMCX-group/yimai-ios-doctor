//
//  PageAppointmentProcessingBodyView.swift
//  YiMai
//
//  Created by ios-dev on 16/8/21.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon
import ChameleonFramework

public class PageAppointmentProcessingBodyView: PageBodyView {
    private var AcceptActions: PageAppointmentProcessingActions? = nil
    private let DPPanel = UIView()
    private let DocCell = UIView()
    private let PatientCell = UIView()
    private let AppointmentNum = UILabel()
    private let TextInfoPanel = UIView()
    private let ImagePanel = UIView()
    private let TimePanel = UIView()
    private let DescPanel = UIView()
    private let NeedToKnowPanel = UIView()
    
    public var Loading: YMPageLoadingView? = nil
    public static var AppointmentID: String = ""
    public static var TimeInfo: String = ""
    
    private let PickerPanel = UIView()
    private let PickerMask = YMButton()
    let AdmissionDatePicker = UIDatePicker()
    private let TimeSelectBtn = YMButton()
    private let CancelBtn = YMButton()
    
    override func ViewLayout() {
        super.ViewLayout()
        AcceptActions = PageAppointmentProcessingActions(navController: self.NavController!, target: self)
        
        DrawDP()
        DrawAppointmentNum()
        
        Loading = YMPageLoadingView(parentView: ParentView!)
        Loading?.Show()
    }
    
    public func ShowAdmissionTime() {
        PickerPanel.hidden = false
    }
    
    public func HideAdmissionTime() {
        PickerPanel.hidden = true
    }
    
    public func DrawAdmissionDatePicker() {
        let btnPanel = UIView()
        btnPanel.backgroundColor = YMColors.DividerLineGray
        let pickerOptPanel = UIView()
        
        ParentView?.addSubview(PickerPanel)
        PickerPanel.fillSuperview()
        PickerPanel.addSubview(PickerMask)
        PickerPanel.addSubview(pickerOptPanel)
        
        pickerOptPanel.backgroundColor = YMColors.White
        pickerOptPanel.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: 276.LayoutVal())
        
        PickerMask.fillSuperview()
        PickerMask.backgroundColor = HexColor("#000000", 0.7)
        PickerMask.addTarget(AcceptActions!, action: "CancelReschedule:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        
        pickerOptPanel.addSubview(AdmissionDatePicker)
        pickerOptPanel.addSubview(btnPanel)
        AdmissionDatePicker.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: 216.LayoutVal())
        AdmissionDatePicker.locale = NSLocale(localeIdentifier: "zh_CN")
        
        AdmissionDatePicker.minuteInterval = 15
        AdmissionDatePicker.minimumDate = NSDate()
        AdmissionDatePicker.date = NSDate()
        
        btnPanel.align(Align.AboveMatchingLeft, relativeTo: AdmissionDatePicker, padding: 0, width: YMSizes.PageWidth, height: 60.LayoutVal())
        btnPanel.addSubview(CancelBtn)
        btnPanel.addSubview(TimeSelectBtn)
        
        let titleLabel = YMLayout.GetNomalLabel("将接诊时间变更至", textColor: HexColor("#222222"), fontSize: 24.LayoutVal())
        btnPanel.addSubview(titleLabel)
        titleLabel.anchorInCenter(width: titleLabel.width, height: titleLabel.height)

        CancelBtn.setTitle("取消", forState: UIControlState.Normal)
        CancelBtn.titleLabel?.font = YMFonts.YMDefaultFont(24.LayoutVal())
        CancelBtn.setTitleColor(YMColors.FontGray, forState: UIControlState.Normal)
        CancelBtn.sizeToFit()
        CancelBtn.anchorToEdge(Edge.Left, padding: 40.LayoutVal(),
                               width: CancelBtn.width, height: CancelBtn.height)
        
        CancelBtn.addTarget(AcceptActions!, action: "CancelReschedule:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        
        TimeSelectBtn.setTitle("确定", forState: UIControlState.Normal)
        TimeSelectBtn.titleLabel?.font = YMFonts.YMDefaultFont(24.LayoutVal())
        TimeSelectBtn.setTitleColor(YMColors.FontBlue, forState: UIControlState.Normal)
        TimeSelectBtn.sizeToFit()
        TimeSelectBtn.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: TimeSelectBtn.width, height: TimeSelectBtn.height)
        
        TimeSelectBtn.addTarget(AcceptActions!, action: "AdmissionTimeSelected:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        
        PickerPanel.hidden = true
    }

    public func DrawTransferButton(top: UIView) {
        
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

    public func DrawConfirmButton(parent: UIView) {
        let bottomPanel = UIView()
        let denyButton = YMLayout.GetTouchableView(useObject: AcceptActions!,
                                                   useMethod: "AppointmentRescheduleTouched:".Sel())
        let acceptButton = YMButton()
        
        let calendarIcon = YMLayout.GetSuitableImageView("YMIconCalendarGray")
        denyButton.addSubview(calendarIcon)
        
        let titleLabel = YMLayout.GetNomalLabel("改期", textColor: YMColors.FontGray, fontSize: 30.LayoutVal())
        denyButton.addSubview(titleLabel)
        
//        denyButton.setTitle("改期", forState: UIControlState.Normal)
//        denyButton.titleLabel?.font = YMFonts.YMDefaultFont(34.LayoutVal())
//        denyButton.backgroundColor = YMColors.CommonBottomBlue
//        denyButton.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        
        acceptButton.setTitle("面诊已完成", forState: UIControlState.Normal)
        acceptButton.titleLabel?.font = YMFonts.YMDefaultFont(34.LayoutVal())
        acceptButton.backgroundColor = YMColors.CommonBottomBlue
        acceptButton.setTitleColor(YMColors.White, forState: UIControlState.Normal)

        parent.addSubview(bottomPanel)
        bottomPanel.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: 98.LayoutVal())
        
        bottomPanel.addSubview(denyButton)
        bottomPanel.addSubview(acceptButton)
        
        denyButton.anchorToEdge(Edge.Left, padding: 0, width: 300.LayoutVal(), height: 98.LayoutVal())
        acceptButton.alignAndFill(align: Align.ToTheRightCentered, relativeTo: denyButton, padding: 0)
        
        calendarIcon.anchorToEdge(Edge.Left, padding: 100.LayoutVal(),
                                  width: calendarIcon.width, height: calendarIcon.height)
        titleLabel.align(Align.ToTheRightCentered, relativeTo: calendarIcon,
                         padding: 12.LayoutVal(), width: titleLabel.width, height: titleLabel.height)

        acceptButton.addTarget(AcceptActions!, action: "AppointmentCompleteTouched:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func DrawAppointmentNum() {
        BodyView.addSubview(AppointmentNum)
        AppointmentNum.font = YMFonts.YMDefaultFont(20.LayoutVal())
        AppointmentNum.textColor = YMColors.FontBlue
        AppointmentNum.textAlignment = NSTextAlignment.Center
        AppointmentNum.align(Align.UnderMatchingLeft, relativeTo: DPPanel,
                             padding: 0, width: YMSizes.PageWidth, height: 50.LayoutVal())
    }
    
    private func DrawDP() {
        BodyView.addSubview(DPPanel)
        DPPanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 310.LayoutVal())
        
        DocCell.backgroundColor = YMColors.White
        PatientCell.backgroundColor = YMColors.White
        
        DPPanel.addSubview(DocCell)
        DPPanel.addSubview(PatientCell)
        DPPanel.groupAndFill(group: Group.Horizontal, views: [DocCell, PatientCell], padding: 0)
        let divider = UIView()
        DPPanel.addSubview(divider)
        divider.backgroundColor = YMColors.DividerLineGray
        divider.anchorInCenter(width: YMSizes.OnPx, height: DPPanel.height)
    }
    
    private func DrawDoctor(data: [String: AnyObject]) {
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
        
        jobTitle.text = data["job_title"] as? String
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
                        padding: 8.LayoutVal(),
                        width: phoneIcon.width, height: phoneIcon.height)
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
        
        let textContent = YMLayout.GetTouchableView(useObject: AcceptActions!, useMethod: "TextDetailTouched:".Sel())
        TextInfoPanel.addSubview(textContent)
        
        let divider = UIView()
        divider.backgroundColor = YMColors.DividerLineGray
        TextInfoPanel.addSubview(divider)
        divider.anchorInCorner(Corner.TopLeft, xPad: 0, yPad: 60.LayoutVal(), width: YMSizes.PageWidth, height: YMSizes.OnPx)
        
        let hisLabel = UILabel()
//        hisLabel.numberOfLines = 3
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
        
        YMLayout.SetViewHeightByLastSubview(textContent, lastSubView: hisLabel)
        YMLayout.SetViewHeightByLastSubview(TextInfoPanel, lastSubView: textContent, bottomPadding: 20.LayoutVal())
    }
    
    public func ShowImage(list: UIScrollView, imgUrl: String, prev: UIImageView?) -> YMTouchableImageView {
        let img = YMTouchableImageView()
        let url = NSURL(string: "\(YMAPIInterfaceURL.ApiBaseUrl)/\(imgUrl)")
        img.setImageWithURL(url!, placeholderImage: nil)
        img.backgroundColor = YMColors.DividerLineGray
        
        list.addSubview(img)
        if(nil == prev) {
            img.anchorToEdge(Edge.Left, padding: 0, width: list.height, height: list.height)
        } else {
            img.align(Align.ToTheRightCentered, relativeTo: prev!,
                      padding: 20.LayoutVal(),
                      width: list.height, height: list.height)
        }
        
        return img
    }
    
    private func DrawImageList(data: [String: AnyObject]) {
        BodyView.addSubview(ImagePanel)
        ImagePanel.backgroundColor = YMColors.White
        ImagePanel.align(Align.UnderMatchingLeft, relativeTo: TextInfoPanel,
                         padding: 20.LayoutVal(),
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
        let leftButton = YMLayout.GetTouchableView(useObject: AcceptActions!, useMethod: "ImageScrollLeft:".Sel())
        let rightButton = YMLayout.GetTouchableView(useObject: AcceptActions!, useMethod: "ImageScrollRight:".Sel())
        
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
    
    private func DrawTimeInfo() {
        BodyView.addSubview(TimePanel)
        TimePanel.backgroundColor = YMColors.White
        TimePanel.align(Align.UnderMatchingLeft, relativeTo: ImagePanel,
                            padding: 20.LayoutVal(),
                            width: YMSizes.PageWidth, height: 150.LayoutVal())
        
        let titleLabel = UILabel()
        
        TimePanel.addSubview(titleLabel)
        titleLabel.text = "就诊时间"
        titleLabel.textColor = YMColors.FontBlue
        titleLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        titleLabel.sizeToFit()
        titleLabel.anchorInCorner(Corner.TopLeft,
                                  xPad: 40.LayoutVal(), yPad: 20.LayoutVal(),
                                  width: titleLabel.width, height: titleLabel.height)
        
        
        let textContent = YMLayout.GetTouchableView(useObject: AcceptActions!, useMethod: "TextDetailTouched:".Sel())
        TimePanel.addSubview(textContent)
        
        let divider = UIView()
        divider.backgroundColor = YMColors.DividerLineGray
        TimePanel.addSubview(divider)
        divider.anchorInCorner(Corner.TopLeft, xPad: 0, yPad: 60.LayoutVal(), width: YMSizes.PageWidth, height: YMSizes.OnPx)
        
        let timeLabel = UILabel()
        timeLabel.numberOfLines = 3
        timeLabel.text = PageAppointmentProcessingBodyView.TimeInfo
        timeLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        timeLabel.textColor = YMColors.FontGray
        timeLabel.frame = CGRectMake(0, 0, 670.LayoutVal(), 0)
        timeLabel.sizeToFit()
        textContent.align(Align.UnderMatchingLeft, relativeTo: divider,
                          padding: 30.LayoutVal(),
                          width: YMSizes.PageWidth,
                          height: timeLabel.height + 30.LayoutVal())
        textContent.addSubview(timeLabel)
        timeLabel.anchorToEdge(Edge.Top, padding: 0, width: timeLabel.width, height: timeLabel.height)
        timeLabel.anchorInCorner(Corner.TopLeft,
                                xPad: 40.LayoutVal(), yPad: 0, width: timeLabel.width, height: timeLabel.height)
    }
    
    func DataParser(data: NSDictionary) -> [String: String] {
        var desc = ""
        var needToKnow = ""
        
        let otherInfo = data["other_info"] as? [String: AnyObject]
        let timeLine = otherInfo!["time_line"] as? [[String: AnyObject]]
        
        for action in timeLine! {
            let info = action["info"] as? [String: AnyObject]
            let otherInfo = info!["other"] as? [[String: AnyObject]]
            if(nil != otherInfo) {
                for mixedInfo in otherInfo! {
                    let infoName = mixedInfo["name"] as? String
                    
                    if(nil != infoName) {
                        if("补充说明" == infoName!) {
                            desc = mixedInfo["content"] as! String
                        }
                        
                        if("就诊须知" == infoName) {
                            needToKnow = mixedInfo["content"] as! String
                        }
                    }
                }
            }
        }
        
        var ret = [String: String]()
        
        ret["desc"] = desc
        ret["needToKnow"] = needToKnow
        
        return ret
    }
    
    func DrawDesc(text: String?) {
        BodyView.addSubview(DescPanel)
        DescPanel.backgroundColor = YMColors.White
        DescPanel.align(Align.UnderMatchingLeft, relativeTo: TimePanel,
                        padding: 20.LayoutVal(),
                        width: YMSizes.PageWidth, height: 150.LayoutVal())
        
        let titleLabel = UILabel()
        
        DescPanel.addSubview(titleLabel)
        titleLabel.text = "补充说明"
        titleLabel.textColor = YMColors.FontBlue
        titleLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        titleLabel.sizeToFit()
        titleLabel.anchorInCorner(Corner.TopLeft,
                                  xPad: 40.LayoutVal(), yPad: 20.LayoutVal(),
                                  width: titleLabel.width, height: titleLabel.height)
        
        
        let textContent = YMLayout.GetTouchableView(useObject: AcceptActions!, useMethod: "TextDetailTouched:".Sel())
        DescPanel.addSubview(textContent)
        
        let divider = UIView()
        divider.backgroundColor = YMColors.DividerLineGray
        DescPanel.addSubview(divider)
        divider.anchorInCorner(Corner.TopLeft, xPad: 0, yPad: 60.LayoutVal(), width: YMSizes.PageWidth, height: YMSizes.OnPx)
        
        let timeLabel = UILabel()
        timeLabel.numberOfLines = 300
        timeLabel.text = text
        timeLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        timeLabel.textColor = YMColors.FontGray
        timeLabel.frame = CGRectMake(0, 0, 670.LayoutVal(), 0)
        timeLabel.sizeToFit()
        textContent.align(Align.UnderMatchingLeft, relativeTo: divider,
                          padding: 30.LayoutVal(),
                          width: YMSizes.PageWidth,
                          height: timeLabel.height + 30.LayoutVal())
        textContent.addSubview(timeLabel)
        timeLabel.anchorToEdge(Edge.Top, padding: 0, width: timeLabel.width, height: timeLabel.height)
        timeLabel.anchorInCorner(Corner.TopLeft,
                                 xPad: 40.LayoutVal(), yPad: 0, width: timeLabel.width, height: timeLabel.height)
        
        YMLayout.SetViewHeightByLastSubview(DescPanel, lastSubView: textContent)
    }
    
    func DrawNeedToKnow(text: String?) {
        BodyView.addSubview(NeedToKnowPanel)
        NeedToKnowPanel.backgroundColor = YMColors.White
        NeedToKnowPanel.align(Align.UnderMatchingLeft, relativeTo: DescPanel,
                        padding: 20.LayoutVal(),
                        width: YMSizes.PageWidth, height: 150.LayoutVal())
        
        let titleLabel = UILabel()
        
        NeedToKnowPanel.addSubview(titleLabel)
        titleLabel.text = "补充说明"
        titleLabel.textColor = YMColors.FontBlue
        titleLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        titleLabel.sizeToFit()
        titleLabel.anchorInCorner(Corner.TopLeft,
                                  xPad: 40.LayoutVal(), yPad: 20.LayoutVal(),
                                  width: titleLabel.width, height: titleLabel.height)
        
        
        let textContent = YMLayout.GetTouchableView(useObject: AcceptActions!, useMethod: "TextDetailTouched:".Sel())
        NeedToKnowPanel.addSubview(textContent)
        
        let divider = UIView()
        divider.backgroundColor = YMColors.DividerLineGray
        NeedToKnowPanel.addSubview(divider)
        divider.anchorInCorner(Corner.TopLeft, xPad: 0, yPad: 60.LayoutVal(), width: YMSizes.PageWidth, height: YMSizes.OnPx)
        
        let timeLabel = UILabel()
        timeLabel.numberOfLines = 300
        timeLabel.text = text
        timeLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        timeLabel.textColor = YMColors.FontGray
        timeLabel.frame = CGRectMake(0, 0, 670.LayoutVal(), 0)
        timeLabel.sizeToFit()
        textContent.align(Align.UnderMatchingLeft, relativeTo: divider,
                          padding: 30.LayoutVal(),
                          width: YMSizes.PageWidth,
                          height: timeLabel.height + 30.LayoutVal())
        textContent.addSubview(timeLabel)
        timeLabel.anchorToEdge(Edge.Top, padding: 0, width: timeLabel.width, height: timeLabel.height)
        timeLabel.anchorInCorner(Corner.TopLeft,
                                 xPad: 40.LayoutVal(), yPad: 0, width: timeLabel.width, height: timeLabel.height)
        
        YMLayout.SetViewHeightByLastSubview(NeedToKnowPanel, lastSubView: textContent)
    }
    
    public func LoadData(data: NSDictionary) {
        let doc = data["doctor_info"] as! [String: AnyObject]
        let patient = data["patient_info"] as! [String: AnyObject]
        DrawDoctor(doc)
        DrawPatient(patient)
        AppointmentNum.text = "预约号 " + PageAppointmentProcessingBodyView.AppointmentID
        DrawTextInfo(patient)
        DrawImageList(patient)
        DrawTimeInfo()
        
        print(data)
        
        let otherInfo = DataParser(data)
        DrawDesc(otherInfo["desc"])
        DrawNeedToKnow(otherInfo["needToKnow"])
        
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: NeedToKnowPanel, padding: 120.LayoutVal())
        Loading?.Hide()
    }
    
    public func GetDetail() {
        AcceptActions?.GetDetail()
    }
    
    
    public func Clear() {
        YMLayout.ClearView(view: DocCell)
        YMLayout.ClearView(view: PatientCell)
        YMLayout.ClearView(view: TextInfoPanel)
        YMLayout.ClearView(view: ImagePanel)
        YMLayout.ClearView(view: TimePanel)
        YMLayout.ClearView(view: DescPanel)
        YMLayout.ClearView(view: NeedToKnowPanel)
    }
}

























