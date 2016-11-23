//
//  YMValueValidator.swift
//  YiMai
//
//  Created by why on 16/5/19.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation

public class YMValueValidator {
    private static let MaxCellPhoneNum: Int64 = 20000000000
    private static let MinCellPhoneNum: Int64 = 10000000000

    public static func IsCellPhoneNum(str: String?) -> Bool {
        if (YMValueValidator.IsEmptyString(str)) {
            return false
        }
        
        let phoneNum = Int64(str!)
        return (phoneNum < MaxCellPhoneNum && phoneNum > MinCellPhoneNum)
    }
    
    public static func IsEmptyString(str: String?) -> Bool {
        return ("" == str) || (nil == str)
    }
    
    
    static func IsEmail(email:String) -> Bool {
        if email.characters.count == 0 {
            return false
        }
        if email.rangeOfString("@") == nil || email.rangeOfString(".") == nil{
            return false
        }
        
        let invalidCharSet = NSCharacterSet.alphanumericCharacterSet().invertedSet.mutableCopy()
        invalidCharSet.removeCharactersInString("_-")
        
        let range1 = email.rangeOfString("@")
        let index = range1?.startIndex
        
        let usernamePart = email.substringToIndex(index!)
        let stringsArray1 = usernamePart.componentsSeparatedByString(".")
        
        for  string1 in stringsArray1
        {
            let rangeOfInavlidChars = string1.rangeOfCharacterFromSet(invalidCharSet as! NSCharacterSet)
            if rangeOfInavlidChars != nil || string1.characters.count == 0  {
                return false
            }
        }
        
        let domainPart = email.substringFromIndex((index?.advancedBy(1))!)
        let stringsArray2 = domainPart.componentsSeparatedByString(".")
        
        for  string1 in stringsArray2
        {
            let rangeOfInavlidChars = string1.rangeOfCharacterFromSet(invalidCharSet as! NSCharacterSet)
            if rangeOfInavlidChars != nil || string1.characters.count == 0  {
                return false
            }
        }
        
        return true
    }
}