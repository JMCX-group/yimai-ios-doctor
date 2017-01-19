//
//  PageCommonTextAreaViewController.swift
//  YiMai
//
//  Created by why on 2017/1/5.
//  Copyright © 2017年 why. All rights reserved.
//

import Foundation
import Neon

class PageCommonTextAreaViewController: PageViewController {
    var titleStr: String = ""
    var placeholderStr: String = ""
    let textArea = YMTextArea(aDelegate: nil)

    
    override func PageLayout() {
        super.PageLayout()
    }
    
    override func PageRefresh() {
        YMLayout.ClearView(view: view)
        
        let strInfoGetter = UserData as? (() -> [String: Any])
        
        var strInfo: [String:Any]! = [String:Any]()

        if(nil != strInfoGetter) {
            strInfo = strInfoGetter!()
        }
        
        titleStr = (strInfo["title"] as? String) ?? ""
        placeholderStr = (strInfo["placeholder"] as? String) ?? ""
        TopView = PageCommonTopView(parentView: view, titleString: titleStr, navController: NavController!, before: { () -> Bool in
            if(!YMValueValidator.IsBlankString(self.textArea.text)) {
                let cb = strInfo?["callback"] as? ((String) -> Void)
                cb?(self.textArea.text)
            }
            return true
        })
        DrawFullBody()
        
    }
    
    override func PageDisapeared() {
        textArea.text = ""
    }
    
    func DrawFullBody() {
        textArea.text = ""
        textArea.placeholder = placeholderStr
        view.addSubview(textArea)
        
        textArea.align(Align.UnderMatchingLeft, relativeTo: TopView!.TopViewPanel, padding: 0,
                       width: YMSizes.PageWidth, height: YMSizes.PageHeight / 2)
        textArea.SetPadding(40.LayoutVal(), right: 40.LayoutVal(), top: 10.LayoutVal(), bottom: 10.LayoutVal())
    }
}





