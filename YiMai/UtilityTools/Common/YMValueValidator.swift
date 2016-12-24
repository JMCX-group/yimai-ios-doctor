//
//  YMValueValidator.swift
//  YiMai
//
//  Created by why on 16/5/19.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation

public class YMValueValidator {
    private static let MaxCellPhoneNum: Int64 = 19000000000
    private static let MinCellPhoneNum: Int64 = 13000000000

    public static func IsCellPhoneNum(str: String?) -> Bool {
        if (YMValueValidator.IsEmptyString(str)) {
            return false
        }

        let phoneNum = Int64(str!)
        if(phoneNum > 13000000000 && phoneNum < 14000000000) { return true }
        if(phoneNum > 15000000000 && phoneNum < 16000000000) { return true }
        if(phoneNum > 17000000000 && phoneNum < 19000000000) { return true }
        
        return false
    }
    
    public static func IsEmptyString(str: String?) -> Bool {
        return ("" == str) || (nil == str)
    }
    
    public static func IsBlankString(str: String?) -> Bool {
        if(nil == str) {
            return true
        }
        
        let whitespace = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        let cleanStr = str!.stringByTrimmingCharactersInSet(whitespace)
        return YMValueValidator.IsEmptyString(cleanStr)
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