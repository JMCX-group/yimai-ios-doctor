//
//  PagePersonalDetailEditActions.swift
//  YiMai
//
//  Created by why on 16/6/22.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit
import AFNetworking
import Photos
import Toucan
//import ALCameraViewController

public class PagePersonalDetailEditActions: PageJumpActions {
    private var TargetController: PagePersonalDetailEditViewController? = nil
    private var UpdateApi: YMAPIUtility? = nil
    var UploadApi: YMAPIUtility? = nil
    
    var ImageForUpload: UIImage? = nil

    override func ExtInit() {
        UpdateApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_UPDATE_USER,
            success: UpdateSuccess, error: UpdateError)
        UploadApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_UPLOAD_USER_HEAD,
                                 success: UploadSuccess,
                                 error: UploadError)
        
        TargetController = self.Target as? PagePersonalDetailEditViewController
    }

    public func UploadBlockBuilder(formData: AFMultipartFormData) {
        let filename = "head_img.jpg"
        let imgData = YMLayout.GetScaledImageData(ImageForUpload!)
        
        formData.appendPartWithFileData(imgData, name: "head_img", fileName: filename, mimeType: "image/jpeg")
    }

    public func UploadSuccess(data: NSDictionary?) {
        print("upload success")
        TargetController?.BodyView?.UserHeadImg.image = Toucan(image: ImageForUpload!).maskWithEllipse().image
        TargetController?.BodyView?.FullPageLoading.Hide()
    }
    
    public func UploadError(err: NSError) {
        YMAPIUtility.PrintErrorInfo(err)
        TargetController?.BodyView?.FullPageLoading?.Hide()
    }
    
    public func ChangeHeadImage(_: UIGestureRecognizer) {
//        TargetController?.BodyView?.PhotoPikcer?.Show()
        HeadImagesSelected(nil)
    }
    
    public func SelectGender(_: UIGestureRecognizer) {
        let alertController = UIAlertController(title: "选择性别", message: nil, preferredStyle: .Alert)
        let male = UIAlertAction(title: "男", style: .Default,
            handler: {
                action in
                self.UpdateUserInfo(["sex": "1"])
                self.TargetController?.BodyView?.FullPageLoading.Show()
        })
        
        let female = UIAlertAction(title: "女", style: .Default,
            handler: {
                action in
                self.UpdateUserInfo(["sex": "0"])
                self.TargetController?.BodyView?.FullPageLoading.Show()
        })
        
        male.setValue(YMColors.FontBlue, forKey: "titleTextColor")
        female.setValue(YMColors.FontBlue, forKey: "titleTextColor")
        
        alertController.addAction(male)
        alertController.addAction(female)
        self.NavController!.presentViewController(alertController, animated: true, completion: nil)
    }
    
    public func InputName(_: UIGestureRecognizer) {
        
    }
    
    public func SelectHospital(_: UIGestureRecognizer) {
        PageCommonSearchViewController.SearchPageTypeName = YMCommonSearchPageStrings.CS_HOSPITAL_SEARCH_PAGE_TYPE
        PageCommonSearchViewController.InitPageTitle = "选择医院"
        DoJump(YMCommonStrings.CS_PAGE_COMMON_SEARCH_NAME)
    }
    
    public func SelectDepartment(_: UIGestureRecognizer) {
        PageCommonSearchViewController.SearchPageTypeName = YMCommonSearchPageStrings.CS_DEPARTMENT_SEARCH_PAGE_TYPE
        PageCommonSearchViewController.InitPageTitle = "选择科室"
        DoJump(YMCommonStrings.CS_PAGE_COMMON_SEARCH_NAME)
    }
    
    func UpdateJobTitle(act: UIAlertAction) {
        let title = act.title!
        TargetController?.BodyView!.AppendExtInfo(TargetController!.BodyView!.JobTitleLabel,
                                                 parent: TargetController!.BodyView!.JobTitle!,
                                                 title: title)
        
        YMVar.MyUserInfo["job_title"] = title
        UpdateUserInfo(["job_title": title])
    }
    
    public func InputJobTitle(_: UIGestureRecognizer) {
        YMJobtitleSelectModal.ShowSelectModal(self.NavController!, callback: UpdateJobTitle)
    }
    
    public func InputSchool(_: UIGestureRecognizer) {
        DoJump(YMCommonStrings.CS_PAGE_ALL_COLLEGE_LIST)
    }
    
    public func InputIDNum(_: UIGestureRecognizer) {
        
    }
    
    public func UpdateUserInfo(data: AnyObject) {
        UpdateApi?.YMChangeUserInfo(data)
    }
    
    private func UpdateSuccess(data: NSDictionary?) {
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_USER_INFO, data: data!["data"]!)
        YMVar.MyUserInfo = data!["data"]! as! [String : AnyObject]
        print(YMVar.MyUserInfo)
        let jobTitle = YMVar.MyUserInfo["job_title"] as? String
        if(nil == jobTitle) {
            YMVar.MyUserInfo["job_title"] = "医生"
        }
        
        TargetController?.BodyView?.LoadData()
        TargetController?.BodyView?.FullPageLoading?.Hide()
    }
    
    private func UpdateError(error: NSError) {
        TargetController?.BodyView?.FullPageLoading.Hide()
    }
    
    var CamSelect: CameraViewController!
    public func HeadImagesSelected(_: [PHAsset]?) {
        CamSelect = CameraViewController(croppingEnabled: true) {(img, pha) in
            print("abc")
            if(nil != img) {
                self.TargetController?.BodyView?.FullPageLoading.Show()
                self.ImageForUpload = img!
//                self.TargetController?.BodyView?.UpdateUserHead(img!)
                self.UploadApi?.YMUploadUserHead(["head_img": "head_img.jpg"], blockBuilder: self.UploadBlockBuilder)
            }
            
            self.CamSelect!.navigationController?.popViewControllerAnimated(true)
            print("def")

        }
        
        self.NavController!.pushViewController(CamSelect, animated: true)

        
//        ImageForUpload = YMLayout.TransPHAssetToUIImage(selectedPhotos[0])
//        TargetController?.BodyView?.UpdateUserHead(ImageForUpload!)
//        UploadApi?.YMUploadUserHead(["head_img": "head_img.jpg"], blockBuilder: UploadBlockBuilder)
    }
}





