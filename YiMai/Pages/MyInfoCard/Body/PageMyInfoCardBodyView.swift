//
//  PageMyInfoCardBodyView.swift
//  YiMai
//
//  Created by superxing on 16/9/21.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageMyInfoCardBodyView: PageBodyView {
    
    var AddActions: PageMyInfoCardActions!
    var UserHead = YMLayout.GetSuitableImageView("PersonalDefaultUserhead")
    var UserQR = YMLayout.GetSuitableImageView("Face2FaceTempQR")

    var Loading: YMPageLoadingView!
    
    public static var DoctorID = ""
    
    override func ViewLayout() {
        super.ViewLayout()
        
        AddActions = PageMyInfoCardActions(navController: self.NavController, target: self)
        DrawUserHead()
        Loading = YMPageLoadingView(parentView: ParentView!)
        Loading.Show()
    }
    
    func DrawUserHead() {
        BodyView.addSubview(UserHead)
        UserHead.anchorToEdge(Edge.Top, padding: 50.LayoutVal(), width: UserHead.width, height: UserHead.height)
    }
    
    func LoadUserInfo(userInfo: [String: AnyObject]) {
        let name = userInfo["name"] as? String
        let code = "\(userInfo["code"]!)"
        let head = userInfo["head_url"] as? String
        let jobTitle = userInfo["job_title"] as? String
        let hospital = userInfo["hospital"] as? String
        let dept = userInfo["department"] as? String
        let id = userInfo["id"] as! String
        
        let nameLabel = YMLayout.GetNomalLabel(name, textColor: YMColors.FontBlue, fontSize: 40.LayoutVal())
        let jobTitleLabel = YMLayout.GetNomalLabel(jobTitle, textColor: YMColors.FontGray, fontSize: 28.LayoutVal())
        let hosLabel = YMLayout.GetNomalLabel(hospital, textColor: YMColors.FontGray, fontSize: 26.LayoutVal())
        let deptLabel = YMLayout.GetNomalLabel(dept, textColor: YMColors.FontGray, fontSize: 28.LayoutVal())
        let codeLabel = YMLayout.GetNomalLabel("医脉码 \(code)", textColor: YMColors.FontBlue, fontSize: 32.LayoutVal())
        let divider = UIView()
        divider.backgroundColor = YMColors.FontBlue
        let codeBkg = UIView()
        codeBkg.backgroundColor = YMColors.FontBlue
        
        let codePanel = UIView()
        
        
        if(nil != head) {
            YMLayout.LoadImageFromServer(UserHead, url: head!)
        }
        
        BodyView.addSubview(nameLabel)
        BodyView.addSubview(jobTitleLabel)
        BodyView.addSubview(hosLabel)
        BodyView.addSubview(deptLabel)
        BodyView.addSubview(divider)

        BodyView.addSubview(codePanel)
        codePanel.addSubview(codeBkg)
        codePanel.addSubview(codeLabel)
        
        codeLabel.textAlignment = NSTextAlignment.Center
        codeLabel.backgroundColor = BodyView.backgroundColor
        
        nameLabel.align(Align.UnderCentered, relativeTo: UserHead, padding: 30.LayoutVal(), width: nameLabel.width, height: nameLabel.height)
        divider.align(Align.UnderCentered, relativeTo: nameLabel, padding: 16.LayoutVal(), width: YMSizes.OnPx, height: 26.LayoutVal())
        jobTitleLabel.align(Align.ToTheRightCentered, relativeTo: divider, padding: 14.LayoutVal(), width: jobTitleLabel.width, height: jobTitleLabel.height)
        deptLabel.align(Align.ToTheLeftCentered, relativeTo: divider, padding: 14.LayoutVal(), width: deptLabel.width, height: deptLabel.height)
        hosLabel.align(Align.UnderCentered, relativeTo: divider, padding: 16.LayoutVal(), width: hosLabel.width, height: hosLabel.height)
        codePanel.align(Align.UnderCentered, relativeTo: hosLabel, padding: 40.LayoutVal(), width: YMSizes.PageWidth, height: codeLabel.height)
        
        codeLabel.anchorInCenter(width: codeLabel.width + 48.LayoutVal(), height: codeLabel.height)
        codeBkg.anchorInCenter(width: 566.LayoutVal(), height: YMSizes.OnPx)
        
        let jsonString = YMQRRecognizer.GenQRJsonString(["id": id])
        
        if(nil != jsonString) {
            let img = YMQRCode.generateImage(jsonString!, avatarImage: nil)
            UserQR.image = img
            BodyView.addSubview(UserQR)
            UserQR.align(Align.UnderCentered, relativeTo: codePanel, padding: 50.LayoutVal(), width: UserQR.width, height: UserQR.height)
        }
        
        Loading.Hide()
    }
    
    func Clear() {
        YMLayout.ClearView(view: BodyView)
        UserHead = YMLayout.GetSuitableImageView("PersonalDefaultUserhead")
        UserQR = YMLayout.GetSuitableImageView("Face2FaceTempQR")
        DrawUserHead()
        PageMyInfoCardBodyView.DoctorID = ""
        Loading.Hide()
    }
}




























