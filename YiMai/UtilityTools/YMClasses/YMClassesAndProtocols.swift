//
//  YMProtocols.swift
//  YiMai
//
//  Created by why on 16/4/16.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class StoryboardThatExist {
    public static var StoryboardMap: [String:Bool] = [
        YMCommonStrings.CS_PAGE_INDEX_NAME:true,
        YMCommonStrings.CS_PAGE_PERSONAL_NAME:true,
        YMCommonStrings.CS_PAGE_LOGIN_NAME:true,
        YMCommonStrings.CS_PAGE_REGISTER_NAME:true,
        YMCommonStrings.CS_PAGE_REGISTER_PERSONAL_INFO_NAME:true,
        YMCommonStrings.CS_PAGE_REGISTER_INPUT_HOSPITAL_NAME:true,
        YMCommonStrings.CS_PAGE_FACE_2_FACE_INFO_INPUT_NAME:true,
        YMCommonStrings.CS_PAGE_FACE_2_FACE_QR_NAME:true,
        YMCommonStrings.CS_PAGE_MASSAGE_LIST_NAME:true,
        YMCommonStrings.CS_PAGE_MY_ADMISSIONS_LIST_NAME:true,
        YMCommonStrings.CS_PAGE_YIMAI_NAME:true,
        YMCommonStrings.CS_PAGE_YIMAI_ADD_FRIENDS_NAME:true,
        YMCommonStrings.CS_PAGE_YIMAI_ADD_CONTCATS_FRIENDS_NAME:true,
        YMCommonStrings.CS_PAGE_YIMAI_MANUAL_ADD_FRIEND_NAME:true
    ]
}

public protocol PageJumpActionsProtocol {
    var ControllersDict : Dictionary<String, UIViewController> {get set}
    var NavController : UINavigationController? {get set}
    func PageJumpTo(sender:YMButton)
    func PageJumpToByViewSender(sender : UITapGestureRecognizer)
    func PageJumpToByImageViewSender(sender : UITapGestureRecognizer)
}

public class PageJumpActions: NSObject, PageJumpActionsProtocol{
    public var ControllersDict : Dictionary<String, UIViewController> = Dictionary<String, UIViewController>()
    public var NavController : UINavigationController? = nil
    public var JumpWidthAnimate = true
    public var Target: AnyObject? = nil
    
    public static let PageJumToSel: Selector = "PageJumpTo:"
    public static let PageJumpToByViewSenderSel: Selector = "PageJumpToByViewSender:"
    public static let PageJumpToByImageViewSenderSel: Selector = "PageJumpToByImageViewSender:"
    
    convenience init(navController: UINavigationController?) {
        self.init()
        self.NavController = navController
    }
    
    convenience init(navController: UINavigationController?, target: AnyObject) {
        self.init()
        self.NavController = navController
        self.Target = target
    }
    
    public func DoJump(targetPageName: String) {
        var targetPage: UIViewController? = nil
        
        if(nil != self.ControllersDict.indexForKey(targetPageName)){
            targetPage = self.ControllersDict[targetPageName]!
        } else {
            targetPage = YMLayout.GetStoryboardControllerByName(targetPageName)!
            self.ControllersDict[targetPageName] = targetPage
        }
        
        self.NavController!.pushViewController(targetPage!, animated: JumpWidthAnimate)
    }

    public func PageJumpTo(sender:YMButton) {
        if(nil == self.NavController){return}
        let targetPageName = sender.UserStringData
        if((StoryboardThatExist.StoryboardMap[targetPageName]) != nil){
            DoJump(targetPageName)
        }
    }
    
    public func PageJumpToByViewSender(sender : UITapGestureRecognizer) {
        if(nil == self.NavController){return}
        
        let targetView = sender.view!
        
        if(targetView.isKindOfClass(YMTouchableView)){
            let touchableView = targetView as! YMTouchableView
            let targetPageName = touchableView.UserStringData
            if((StoryboardThatExist.StoryboardMap[targetPageName]) != nil){
                DoJump(targetPageName)
            } else {
                print("page \(targetPageName) not exist")
            }
        }
    }
    
    public func PageJumpToByImageViewSender(sender : UITapGestureRecognizer) {
        if(nil == self.NavController){return}
        
        let targetView = sender.view!
        
        if(targetView.isKindOfClass(YMTouchableImageView)){
            let touchableView = targetView as! YMTouchableImageView
            let targetPageName = touchableView.UserStringData
            if((StoryboardThatExist.StoryboardMap[targetPageName]) != nil){
                DoJump(targetPageName)
            } else {
                print("page \(targetPageName) not exist")
            }
        }
    }
}

public class PageViewController: UIViewController, UIGestureRecognizerDelegate{
    internal var PageLayoutFlag = false
    internal var TopView : PageCommonTopView? = nil
    internal var BottomView : PageCommonBottomView? = nil
    internal var NavController: UINavigationController? = nil
    internal var SelfView: UIView? = nil

    internal func GestureRecognizerEnable() -> Bool {return true}

    override public func prefersStatusBarHidden() -> Bool {return false}
    
    override public func viewDidLayoutSubviews() {
        self.PageLayout()
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.enabled = self.GestureRecognizerEnable()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        // Do any additional setup after loading the view.
    }
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer.isKindOfClass(UIScreenEdgePanGestureRecognizer)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func PageLayout() {
        NavController = self.navigationController
        SelfView = self.view
    }
}

public class PageBodyView {
    internal var ParentView: UIView? = nil
    internal var NavController: UINavigationController? = nil
    internal var Actions: AnyObject? = nil
    internal var BodyView: UIScrollView = UIScrollView()
    
    convenience init(parentView: UIView, navController: UINavigationController, pageActions: AnyObject) {
        self.init()
        self.ParentView = parentView
        self.NavController = navController
        self.Actions = pageActions
        
        self.ViewLayout()
    }
    
    internal func ViewLayout(){}
}















