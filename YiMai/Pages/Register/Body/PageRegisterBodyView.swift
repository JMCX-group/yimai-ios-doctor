//
//  PageRegisterBodyView.swift
//  YiMai
//
//  Created by why on 16/4/19.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageRegisterBodyView: NSObject {
    private var ParentView : UIView? = nil
    private var NavController : UINavigationController? = nil
    private var Actions : PageRegisterActions? = nil

    private var CellPhoneInput : YMTextField? = nil
    private var PasswordInput : YMTextField? = nil
    private var VerifyCodeInput : YMTextField? = nil
    private var InvitedCodeInput : YMTextField? = nil
    
    private var GetVerifyCodeButton : YMButton? = nil
    private var NextStepCodeButton : YMButton? = nil
    
    private var AgreeButton : YMButton? = nil
    private var AgreeCheckbox : UIImageView? = nil
    private var AgreementCheckedImage : UIImage = UIImage(named: "RegisterCheckboxAgreeChecked")!
    private var AgreementUncheckedImage : UIImage = UIImage(named: "RegisterCheckboxAgreeUnchecked")!
    
    private let BodyView : UIScrollView = UIScrollView()
    
    private let InputStartTop = 70.LayoutVal()
    private let InputHeight = 80.LayoutVal()
    private let InputMargin : CGFloat = 1.0
    private let InputLeftPadding : CGFloat = 40.LayoutVal()
    
    private let VerifyButtonFrame = CGRect(x: 550.LayoutVal(), y: 248.LayoutVal(), width: 160.LayoutVal(), height: 50.LayoutVal())
    private let NextStepButtonFrame = CGRect(x: 40.LayoutVal(), y: 463.LayoutVal(), width: 670.LayoutVal(), height: 90.LayoutVal())
    
    private let AgreeButtonFrame = CGRect(x: 84.LayoutVal(), y: 585.LayoutVal(), width: 330.LayoutVal(), height: 24.LayoutVal())
    
    public var AgreeChecked = true
    
    convenience init(parentView: UIView, navController: UINavigationController) {
        self.init()
        self.ParentView = parentView
        self.NavController = navController
        self.Actions = PageRegisterActions(navController: navController, bodyView: self)
        self.ViewLayout()
    }
    
    public func ViewLayout() {
        YMLayout.BodyLayoutWithTop(ParentView!, bodyView: BodyView)
        
        DrawInputGroup()
        DrawButtonGroup()
        DrawAgreeCheckbox()
    }
    
    public func ToggleAgreementStatus() {
        self.AgreeChecked = !self.AgreeChecked
        
        if(self.AgreeChecked){
            AgreeCheckbox?.image = AgreementCheckedImage
        } else {
            AgreeCheckbox?.image = AgreementUncheckedImage
        }
    }
    
    private func GetInputLeftPadding(width: CGFloat) -> UIView {
        return UIView(frame: CGRect(x: 0, y: 0, width: width, height: InputHeight))
    }

    private func DrawInputGroup(){
        let inputParam = TextFieldCreateParam()
        inputParam.FontSize = 28.LayoutVal()
        
        CellPhoneInput = YMLayout.GetCellPhoneField(inputParam)
        CellPhoneInput?.placeholder = YMRegisterStrings.CS_USERNAME_PLACEHOLDER
        
        PasswordInput = YMLayout.GetPasswordField(inputParam)
        PasswordInput?.placeholder = YMRegisterStrings.CS_PASSWORD_PLACEHOLDER
        
        VerifyCodeInput = YMLayout.GetTextFieldWithMaxCharCount(inputParam, maxCharCount: 5)
        VerifyCodeInput?.placeholder = YMRegisterStrings.CS_VERIFY_CODE_PLACEHOLDER

        InvitedCodeInput = YMLayout.GetTextFieldWithMaxCharCount(inputParam, maxCharCount: 20)
        InvitedCodeInput?.placeholder = YMRegisterStrings.CS_INVITED_CODE_PLACEHOLDER

        BodyView.addSubview(CellPhoneInput!)
        BodyView.addSubview(PasswordInput!)
        BodyView.addSubview(VerifyCodeInput!)
        BodyView.addSubview(InvitedCodeInput!)
        
        CellPhoneInput?.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: InputStartTop, otherSize: InputHeight)
        PasswordInput?.alignAndFillWidth(align: Align.UnderMatchingLeft, relativeTo: CellPhoneInput!, padding: InputMargin, height: InputHeight)
        VerifyCodeInput?.alignAndFillWidth(align: Align.UnderMatchingLeft, relativeTo: PasswordInput!, padding: InputMargin, height: InputHeight)
        InvitedCodeInput?.alignAndFillWidth(align: Align.UnderMatchingLeft, relativeTo: VerifyCodeInput!, padding: InputMargin, height: InputHeight)
        
        CellPhoneInput?.SetLeftPadding(GetInputLeftPadding(InputLeftPadding))
        PasswordInput?.SetLeftPadding(GetInputLeftPadding(InputLeftPadding))
        VerifyCodeInput?.SetLeftPadding(GetInputLeftPadding(InputLeftPadding))
        InvitedCodeInput?.SetLeftPadding(GetInputLeftPadding(InputLeftPadding))
    }
    
    private func DrawButtonGroup() {
        GetVerifyCodeButton = YMButton(frame: VerifyButtonFrame)
        NextStepCodeButton = YMButton(frame: NextStepButtonFrame)
        
        NextStepCodeButton?.UserStringData = YMCommonStrings.CS_PAGE_REGISTER_PERSONAL_INFO_NAME
        NextStepCodeButton?.addTarget(self.Actions, action: "PageJumpTo:", forControlEvents: UIControlEvents.TouchUpInside)
        
        BodyView.addSubview(GetVerifyCodeButton!)
        BodyView.addSubview(NextStepCodeButton!)
        
        GetVerifyCodeButton?.setTitle(YMRegisterStrings.CS_VERIFY_CODE_BUTTON, forState: UIControlState.Normal)
        GetVerifyCodeButton?.titleLabel?.font = UIFont.systemFontOfSize(24.LayoutVal())
        GetVerifyCodeButton?.setBackgroundImage(UIImage(named: "RegisterButtonGetVerifyCodeBackground"), forState: UIControlState.Normal)
        GetVerifyCodeButton?.setBackgroundImage(UIImage(named: "RegisterButtonWaitForVerifyCodeBackground"), forState: UIControlState.Disabled)
        
        NextStepCodeButton?.setTitle(YMRegisterStrings.CS_NEXT_STEP_BUTTON, forState: UIControlState.Normal)
        NextStepCodeButton?.titleLabel?.font = UIFont.systemFontOfSize(36.LayoutVal())
        NextStepCodeButton?.setBackgroundImage(UIImage(named: "CommonXLButtonBackgroundGray"), forState: UIControlState.Normal)
        NextStepCodeButton?.setBackgroundImage(UIImage(named: "CommonXLButtonBackgroundBlue"), forState: UIControlState.Highlighted)
    }
    
    private func DrawAgreeCheckbox() {
        AgreeButton = YMButton(frame: AgreeButtonFrame)
        AgreeCheckbox = YMLayout.GetTouchableImageView(useObject: self.Actions!, useMethod: "AgreementImageTouched:", imageName: "RegisterCheckboxAgreeChecked")
        AgreeButton?.addTarget(self.Actions, action: "AgreementButtonTouched:", forControlEvents: UIControlEvents.TouchUpInside)
        AgreeButton?.setTitle(YMRegisterStrings.CS_AGREE_LABEL_BUTTON, forState: UIControlState.Normal)
        AgreeButton?.titleLabel?.font = UIFont.systemFontOfSize(24.LayoutVal())
        AgreeButton?.setTitleColor(YMColors.FontLightGray, forState: UIControlState.Normal)
        AgreeButton?.titleLabel?.textAlignment = NSTextAlignment.Left

        let checkboxFrame = CGRect(x: 40.LayoutVal(), y: 585.LayoutVal(), width: (AgreeCheckbox?.width)!, height: (AgreeCheckbox?.height)!)
        AgreeCheckbox?.frame = checkboxFrame

        BodyView.addSubview(AgreeButton!)
        BodyView.addSubview(AgreeCheckbox!)
    }
}

























