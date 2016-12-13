//
//  PageDoctorAtuhActions.swift
//  YiMai
//
//  Created by superxing on 16/9/29.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit
import AFNetworking
import Photos

class PageDoctorAuthActions: PageJumpActions {
    var TargetView: PageDoctorAuthBodyView!
    var UploadApi: YMAPIUtility? = nil
    
//    var PhotoIndex = 0
//    var ImageForUpload: UIImage? = nil

    override func ExtInit() {
        super.ExtInit()
        TargetView = Target as! PageDoctorAuthBodyView
        UploadApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_UPLOAD_PHOTO_APPOINTMENT,
                                 success: UploadSuccess,
                                 error: UploadError)
    }
    
    func UploadBlockBuilder(formData: AFMultipartFormData) {
        var i: Int = 1
        for photo in TargetView.PhotoArray {
            let paramName = "img-\(i)"
            let filename = "img-\(i).jpg"
            let imgData = YMLayout.GetScaledImageData(photo)
            formData.appendPartWithFileData(imgData, name: paramName, fileName: filename, mimeType: "image/jpeg")
            i += 1
        }
    }
    
    func UploadSuccess(data: NSDictionary?) {
        print(data)
        TargetView.FullPageLoading.Hide()
        self.NavController!.popViewControllerAnimated(true)
    }
    
    func UploadError(err: NSError) {
        YMAPIUtility.PrintErrorInfo(err)
        TargetView.FullPageLoading.Hide()
        YMPageModalMessage.ShowErrorInfo("网络错误，请稍后再试！", nav: self.NavController!)
        //        self.NavController!.popViewControllerAnimated(true)
        
    }
    
    func AddImageTouched(gr: UIGestureRecognizer) {
        let imgView = gr.view as! UIImageView
        TargetView.ShowPhotoPicker(imgView)
    }
    
    func RemoveImageTouched(gr: UIGestureRecognizer) {
        
    }
    
    func DoSubmit(sender: YMButton) {
        if(0 == TargetView.PhotoArray.count) {
            YMPageModalMessage.ShowErrorInfo("请至少上传一张照片", nav: self.NavController!)
            return
        }
        
        TargetView.FullPageLoading.Show()
        UploadApi?.YMUploadAuthPhotos(nil, blockBuilder: UploadBlockBuilder)
//        self.NavController!.popViewControllerAnimated(true)
    }
}












