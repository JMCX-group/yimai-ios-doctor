//
//  PageAppointmentAcceptBodyView.swift
//  YiMai
//
//  Created by ios-dev on 16/8/21.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageAppointmentAcceptBodyView: PageBodyView {
    private var AcceptActions: PageAppointmentAcceptActions? = nil
    private let DPPanel = UIView()
    private let DocCell = UIView()
    private let PatientCell = UIView()
    private let AppointmentNum = UILabel()
    private let TextInfoPanel = UIView()
    private let ImagePanel = UIView()
    private let TimePanel = UIView()
    
    public var Loading: YMPageLoadingView? = nil
    public static var AppointmentID: String = ""
    public static var TimeInfo: String = ""
    
    override func ViewLayout() {
        super.ViewLayout()
        AcceptActions = PageAppointmentAcceptActions(navController: self.NavController!, target: self)
        
        DrawDP()
        DrawAppointmentNum()
        
        Loading = YMPageLoadingView(parentView: self.BodyView)
        Loading?.Show()
    }

    public func DrawTransferButton(top: UIView) {
        let transferBtn = YMLayout.GetTouchableImageView(useObject: AcceptActions!,
                                                         useMethod: "PatientTransferTouched:".Sel(),
                                                         imageName: "AppointmentAcceptForTransferIcon")
        
        top.addSubview(transferBtn)
        transferBtn.anchorInCorner(Corner.BottomRight, xPad: 30.LayoutVal(), yPad: 24.LayoutVal(), width: transferBtn.width, height: transferBtn.height)
    }
    
    public func DrawConfirmButton(parent: UIView) {
        let bottomPanel = UIView()
        let denyButton = YMButton()
        let acceptButton = YMButton()
        let dividerLine = UIView()
        
        denyButton.setTitle("拒绝", forState: UIControlState.Normal)
        denyButton.titleLabel?.font = YMFonts.YMDefaultFont(34.LayoutVal())
        denyButton.backgroundColor = YMColors.CommonBottomBlue
        denyButton.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        
        acceptButton.setTitle("同意接诊", forState: UIControlState.Normal)
        acceptButton.titleLabel?.font = YMFonts.YMDefaultFont(34.LayoutVal())
        acceptButton.backgroundColor = YMColors.CommonBottomBlue
        acceptButton.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        
        dividerLine.backgroundColor = YMColors.White
        
        parent.addSubview(bottomPanel)
        bottomPanel.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: 98.LayoutVal())
        
        bottomPanel.addSubview(denyButton)
        bottomPanel.addSubview(acceptButton)
        bottomPanel.addSubview(dividerLine)
        
        bottomPanel.groupAndFill(group: Group.Horizontal, views: [denyButton, acceptButton], padding: 0)
        dividerLine.anchorInCenter(width: YMSizes.OnPx, height: 34.LayoutVal())
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
        TimePanel.align(Align.UnderMatchingLeft, relativeTo: TextInfoPanel,
                            padding: 20.LayoutVal(),
                            width: YMSizes.PageWidth, height: 220.LayoutVal())
        
        let titleLabel = UILabel()
        
        TimePanel.addSubview(titleLabel)
        titleLabel.text = "期望就诊时间"
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
        timeLabel.text = PageAppointmentAcceptBodyView.TimeInfo
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
    
    public func LoadData(data: NSDictionary) {
        let doc = data["doctor_info"] as! [String: AnyObject]
        let patient = data["patient_info"] as! [String: AnyObject]
        DrawDorctor(doc)
        DrawPatient(patient)
        AppointmentNum.text = PageAppointmentAcceptBodyView.AppointmentID
        DrawTextInfo(patient)
        DrawImageList(patient)
        DrawTimeInfo()
        
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: ImagePanel)
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
    }
}

























