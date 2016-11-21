//
//  PageDoctorAtuhBodyView.swift
//  YiMai
//
//  Created by superxing on 16/9/29.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon
import ChameleonFramework
import Photos

class PageDoctorAuthBodyView: PageBodyView {
    var AuthActions: PageDoctorAuthActions!
    
    var PhotoImagePanel = UIScrollView()
    var PhotoPikcer: YMPhotoSelector? = nil
    var PhotoArray = [UIImage]()
    var PhotoViewArray = [YMTouchableView]()
    var PhotoCellToChange: UIImageView? = nil
    
    let SubmitButton = YMButton()
    
    func ImagesSelected(selectedPhotos: [PHAsset]) {
//        let photo = selectedPhotos[0]
        

        for photo in selectedPhotos {
            let asset = YMLayout.TransPHAssetToUIImage(photo)
            PhotoArray.append(asset)
            PhotoLayout()
        }
        
        SubmitButton.backgroundColor = YMColors.CommonBottomBlue
        SubmitButton.enabled = true
    }
    
    override func ViewLayout() {
        super.ViewLayout()
        AuthActions = PageDoctorAuthActions(navController: self.NavController!, target: self)
        PhotoPikcer = YMPhotoSelector(nav: self.NavController!, maxSelection: 5)
        PhotoPikcer?.SelectedCallback = ImagesSelected
        DrawFullBody()
    }
    
    func ShowPhotoPicker(imgView: UIImageView) {
        PhotoCellToChange = imgView
        PhotoPikcer?.Show()
    }
    
    func DrawFullBody() {
        YMLayout.ClearView(view: BodyView)
        
        let example = YMLayout.GetSuitableImageView("YMAuthExample")
        BodyView.addSubview(example)
        example.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 90.LayoutVal(), otherSize: example.height)
        
        BodyView.addSubview(PhotoImagePanel)
        PhotoImagePanel.align(Align.UnderCentered, relativeTo: example, padding: 145.LayoutVal(), width: 550.LayoutVal(), height: 170.LayoutVal())

        func DrawUploadButton(prev: YMTouchableView?) -> YMTouchableView {
            let btnView = YMTouchableView()
            let img = YMLayout.GetTouchableImageView(useObject: AuthActions, useMethod: "AddImageTouched:".Sel(), imageName: "PageAuthAddImageButton")
            let removeBtn = YMLayout.GetTouchableView(useObject: AuthActions, useMethod: "RemoveImageTouched:".Sel())
            let removeIcon = YMLayout.GetSuitableImageView("CommonButtonClearInput")
            removeBtn.backgroundColor = HexColor("#ffffff", 0.7)
            
            PhotoImagePanel.addSubview(btnView)
            if(nil == prev) {
                btnView.anchorToEdge(Edge.Left, padding: 0, width: 170.LayoutVal(), height: 170.LayoutVal())
            } else {
                btnView.align(Align.ToTheRightCentered, relativeTo: prev!, padding: 20.LayoutVal(), width: 170.LayoutVal(), height: 170.LayoutVal())
                btnView.hidden = true
            }
            
            btnView.addSubview(img)
            btnView.addSubview(removeBtn)
            
            img.fillSuperview()
            removeBtn.anchorInCorner(Corner.TopRight, xPad: 0, yPad: 0, width: 44.LayoutVal(), height: 44.LayoutVal())
            removeBtn.layer.cornerRadius = 22.LayoutVal()
            removeBtn.layer.masksToBounds = true

            removeBtn.addSubview(removeIcon)
            removeIcon.anchorInCenter(width: removeIcon.width, height: removeIcon.height)

            removeBtn.hidden = true
            
            btnView.UserObjectData = ["img": img, "rmBtn": removeBtn]
            
            return btnView
        }
        
        var uploadBtn: YMTouchableView? = nil
        for _ in 1...5 {
            uploadBtn = DrawUploadButton(uploadBtn)
            PhotoViewArray.append(uploadBtn!)
        }
        
        PhotoLayout()
        
        let leftArrow = YMLayout.GetSuitableImageView("CommonGrayLeftArrowIcon")
        let rightArrow = YMLayout.GetSuitableImageView("CommonGrayRightArrowIcon")
        
        BodyView.addSubview(leftArrow)
        BodyView.addSubview(rightArrow)
        
        leftArrow.align(Align.ToTheLeftCentered, relativeTo: PhotoImagePanel, padding: 50.LayoutVal(), width: leftArrow.width, height: leftArrow.height)
        rightArrow.align(Align.ToTheRightCentered, relativeTo: PhotoImagePanel, padding: 50.LayoutVal(), width: rightArrow.width, height: rightArrow.height)
        
        let tipLabel = YMLayout.GetNomalLabel("最多上传五张", textColor: YMColors.FontGray, fontSize: 22.LayoutVal())
        BodyView.addSubview(tipLabel)
        tipLabel.align(Align.UnderCentered, relativeTo: PhotoImagePanel, padding: 30.LayoutVal(), width: tipLabel.width, height: tipLabel.height)
        
        let tooltipImg = YMLayout.GetSuitableImageView("YMAuthTooltip")
        BodyView.addSubview(tooltipImg)
        tooltipImg.align(Align.UnderCentered, relativeTo: tipLabel, padding: 80.LayoutVal(), width: tooltipImg.width, height: tooltipImg.height)
        
        ParentView?.addSubview(SubmitButton)
        SubmitButton.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: 98.LayoutVal())
        
        SubmitButton.setTitle("提交", forState: UIControlState.Normal)
        SubmitButton.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        SubmitButton.backgroundColor = YMColors.CommonBottomGray
        SubmitButton.titleLabel?.font = YMFonts.YMDefaultFont(34.LayoutVal())
        SubmitButton.enabled = false
        
        SubmitButton.addTarget(AuthActions, action: "DoSubmit:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
    }

    func PhotoLayout() {
        var i = 0
        for photoView in PhotoViewArray {
            photoView.hidden = true
        }
        
        var lastView: YMTouchableView? = nil
        for photo in PhotoArray {
            lastView = PhotoViewArray[i]
            let viewData = PhotoViewArray[i].UserObjectData as! [String: AnyObject]
            let imgView = viewData["img"] as! YMTouchableImageView
            imgView.image = photo
            lastView?.hidden = false
            i += 1
        }
        
        if(i < PhotoViewArray.count) {
            lastView = PhotoViewArray[i]
            let viewData = PhotoViewArray[i].UserObjectData as! [String: AnyObject]
            let imgView = viewData["img"] as! YMTouchableImageView
            imgView.image = UIImage(named: "PageAuthAddImageButton")
            lastView?.hidden = false
            
            i += 1
        }
        
        YMLayout.SetHScrollViewContentSize(PhotoImagePanel, lastSubView: lastView!)
        
//        let x = CGFloat(i - 1) * (lastView!.width + 20.LayoutVal())
//        let pos = CGPointMake(x, lastView!.frame.origin.y)
//        PhotoImagePanel.setContentOffset(pos, animated: true)
    }
}









