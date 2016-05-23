//
//  YMTextInput.swift
//  YiMai
//
//  Created by why on 16/4/16.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class YMTextFieldDelegate : NSObject, UITextFieldDelegate {
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if(!textField.isKindOfClass(YMTextField)) { return true }
        
        let realTextField = textField as! YMTextField
        let curTextCount = textField.text?.characters.count
        let maxCharactersCount : Int = realTextField.MaxCharCount

        if(0 == maxCharactersCount){
            return true
        } else {
            return (curTextCount < maxCharactersCount)
        }
    }
    
    public func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if(!textField.isKindOfClass(YMTextField)) { return true }
        
        let realTextField = textField as! YMTextField
        
        print("text touched!")
        
        return realTextField.Editable
    }
}

public class YMTextField : UITextField {
    public var MaxCharCount : Int = 0
    public var Editable : Bool = true
    private var YMDelegate = YMTextFieldDelegate()
    
    public func SetLeftPaddingWidth(leftPadding: CGFloat, paddingMode: UITextFieldViewMode = UITextFieldViewMode.Always) {
        self.leftViewMode = paddingMode
        let leftPaddingFrame = CGRect(x: 0,y: 0,width: leftPadding,height: self.height)
        self.leftView = UIView(frame: leftPaddingFrame)
    }
    
    public func SetRightPaddingWidth(rightPadding: CGFloat, paddingMode: UITextFieldViewMode = UITextFieldViewMode.Always) {
        self.rightViewMode = paddingMode
        let rightPaddingFrame = CGRect(x: 0,y: 0,width: rightPadding,height: self.height)
        self.rightView = UIView(frame: rightPaddingFrame)
    }
    
    public func SetLeftPadding(leftPadding: UIView, paddingMode: UITextFieldViewMode = UITextFieldViewMode.Always) {
        self.leftViewMode = paddingMode
        self.leftView = leftPadding
    }
    
    public func SetRightPadding(rightPadding: UIView, paddingMode: UITextFieldViewMode = UITextFieldViewMode.Always) {
        self.rightViewMode = paddingMode
        self.rightView = rightPadding
    }
    
    public func SetBothPadding(leftPadding: UIView, rightPadding: UIView, paddingMode: UITextFieldViewMode = UITextFieldViewMode.Always) {
        self.leftViewMode = paddingMode
        self.rightViewMode = paddingMode
        
        self.leftView = leftPadding
        self.rightView = rightPadding
    }
    
    init(aDelegate : UITextFieldDelegate?) {
        super.init(frame: CGRect())
        if(nil != aDelegate) {
            self.delegate = aDelegate
        } else {
            self.delegate = YMDelegate
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


















