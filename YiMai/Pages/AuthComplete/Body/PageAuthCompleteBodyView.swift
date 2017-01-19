//
//  PageAuthCompleteBodyView.swift
//  YiMai
//
//  Created by old-king on 16/11/6.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon
import Toucan
import ImageViewer

class PageAuthCompleteBodyView: PageBodyView, ImageProvider {
    var ProcessingActions: PageAuthCompleteActions!
    
    var ImageList = [UIImageView]()
    let AuthPanel = UIScrollView()
    
    override func ViewLayout() {
        super.ViewLayout()
        
        ProcessingActions = PageAuthCompleteActions(navController: self.NavController, target: self)
        DrawFullBody()
        DrawBottomButton()
    }
    
    func DrawBottomButton() {
        let panel = UIView()
        panel.backgroundColor = YMColors.CommonBottomGray
        
        ParentView?.addSubview(panel)
        panel.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: 98.LayoutVal())
        
        let label = YMLayout.GetNomalLabel("认证通过", textColor: YMColors.FontGray, fontSize: 34.LayoutVal())
        panel.addSubview(label)
        label.anchorInCenter(width: label.width, height: label.height)
    }

    func DrawLabel() {
        let label = ActiveLabel()
        label.text = "认证成功"
        label.textColor = YMColors.FontBlue
        label.font = YMFonts.YMDefaultFont(30.LayoutVal())
        label.sizeToFit()
        
        label.frame = CGRect(x: 0, y: 0, width: label.width + 40.LayoutVal(), height: 60.LayoutVal())
        label.textAlignment = NSTextAlignment.Center
        label.layer.borderColor = YMColors.FontBlue.CGColor
        label.layer.borderWidth = 2.LayoutVal()
        label.layer.cornerRadius = 10.LayoutVal()
        label.layer.masksToBounds = true
        
        BodyView.addSubview(label)
        label.align(Align.UnderCentered, relativeTo: AuthPanel, padding: 100.LayoutVal(), width: label.width, height: label.height)
    }
    
    func DrawFullBody() {
        YMLayout.ClearView(view: BodyView)
        YMLayout.ClearView(view: AuthPanel)
        
        let example = YMLayout.GetSuitableImageView("YMAuthExample")
        BodyView.addSubview(example)
        example.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 90.LayoutVal(), otherSize: example.height)
        
        BodyView.addSubview(AuthPanel)
        AuthPanel.align(Align.UnderCentered, relativeTo: example, padding: 145.LayoutVal(), width: YMSizes.PageWidth, height: 200.LayoutVal())
        
        let authImg = YMVar.GetStringByKey(YMVar.MyUserInfo, key: "auth_img")
        
        if("" == authImg) {
            return
        }
        
        let authImgList = authImg.componentsSeparatedByString(",")
        
        for imgUrl in authImgList {
            let img = YMTouchableImageView()
            let url = NSURL(string: imgUrl)
            img.setImageWithURL(url!, placeholderImage: nil)
            img.kf_setImageWithURL(url, placeholderImage: nil, optionsInfo: nil, progressBlock: nil,  completionHandler: { (image, error, cacheType, imageURL) in
                if(nil == image){return}
                img.image = Toucan(image: image!)
                    .resize(CGSize(width: img.width, height: img.height), fitMode: Toucan.Resize.FitMode.Crop).image
            })
            
            img.backgroundColor = YMColors.DividerLineGray
            
            AuthPanel.addSubview(img)
            
            let tapGR = UITapGestureRecognizer(target: self, action: "ImageTouched:".Sel())
            
            img.userInteractionEnabled = true
            img.addGestureRecognizer(tapGR)
            img.UserStringData = "\(ImageList.count)"
            ImageList.append(img)
        }
        
        AuthPanel.groupInCenter(group: Group.Horizontal, views: ImageList.map({$0 as UIImageView}), padding: 10.LayoutVal(), width: 180.LayoutVal(), height: 180.LayoutVal())
        YMLayout.SetHScrollViewContentSize(AuthPanel, lastSubView: ImageList.last, padding: 10.LayoutVal())
        
        DrawLabel()
    }
    
    func ImageTouched(gr: UIGestureRecognizer) {
        let img = gr.view as! YMTouchableImageView
        let imgIdx = Int(img.UserStringData)
        let galleryViewController = GalleryViewController(imageProvider: self, displacedView: self.ParentView!,
                                                          imageCount: self.ImageList.count, startIndex: imgIdx!, configuration: DefaultGalleryConfiguration())
        NavController!.presentImageGallery(galleryViewController)
    }
    
    var TachedImageIdx: Int = 0
    var imageCount: Int { get { return self.ImageList.count } }
    func provideImage(completion: UIImage? -> Void) {
        if(0 == self.ImageList.count) {
            completion(nil)
        } else {
            completion(self.ImageList[0].image)
        }
    }
    func provideImage(atIndex index: Int, completion: UIImage? -> Void) {
        completion(self.ImageList[index].image)
    }
    
    func DefaultGalleryConfiguration() -> GalleryConfiguration {
        
        let dividerWidth = GalleryConfigurationItem.ImageDividerWidth(10)
        let spinnerColor = GalleryConfigurationItem.SpinnerColor(UIColor.whiteColor())
        let spinnerStyle = GalleryConfigurationItem.SpinnerStyle(UIActivityIndicatorViewStyle.White)
        
        let closeButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 40.LayoutVal(), height: 40.LayoutVal())))
        closeButton.setImage(UIImage(named: "YMIconCloseBtn"), forState: UIControlState.Normal)
        closeButton.setImage(UIImage(named: "YMIconCloseBtn"), forState: UIControlState.Highlighted)
        let closeButtonConfig = GalleryConfigurationItem.CloseButton(closeButton)
        
        //        let seeAllButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 50)))
        //        seeAllButton.setTitle("显示全部", forState: .Normal)
        //        let seeAllButtonConfig = GalleryConfigurationItem.SeeAllButton(seeAllButton)
        
        let pagingMode = GalleryConfigurationItem.PagingMode(GalleryPagingMode.Standard)
        
        let closeLayout = GalleryConfigurationItem.CloseLayout(ButtonLayout.PinRight(20, 20))
        //        let seeAllLayout = GalleryConfigurationItem.CloseLayout(ButtonLayout.PinLeft(8, 16))
        let headerLayout = GalleryConfigurationItem.HeaderViewLayout(HeaderLayout.Center(25))
        let footerLayout = GalleryConfigurationItem.FooterViewLayout(FooterLayout.Center(25))
        
        let statusBarHidden = GalleryConfigurationItem.StatusBarHidden(true)
        
        let hideDecorationViews = GalleryConfigurationItem.HideDecorationViewsOnLaunch(false)
        
        let backgroundColor = GalleryConfigurationItem.BackgroundColor(YMColors.OpacityBlackMask)
        
        return [dividerWidth, spinnerStyle, spinnerColor, closeButtonConfig, pagingMode, headerLayout, footerLayout, closeLayout, statusBarHidden, hideDecorationViews, backgroundColor]
    }
}


