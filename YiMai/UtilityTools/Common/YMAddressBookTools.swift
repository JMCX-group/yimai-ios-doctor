//
//  YMAddressBookTools.swift
//  YiMai
//
//  Created by ios-dev on 16/8/14.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import APAddressBook

public typealias ReadAddressbookCallback = (Void) -> Void

public class YMAddressBookTools: NSObject {
    private let APAB = APAddressBook()
    
    static var ContactsReading = true
    static var ContactsCount: Int = 0

    public static var AllContacts: [[String: String]] = [[String: String]]()
    public static var GetContactsStatus: Bool = false
    public func GetPhone(phones: [APPhone]?) -> String? {
        if(nil == phones) {
            return nil
        }
        
        let phoneCount = phones!.count
        
        if(phoneCount > 0) {
            let firstPhone = phones![0]
            if(nil == firstPhone.number) {
                return nil
            }
            
            let phoneNum = firstPhone.number
            var cleanNum = phoneNum!.stringByReplacingOccurrencesOfString("-", withString: "")
            cleanNum = cleanNum.stringByReplacingOccurrencesOfString("(", withString: "")
            cleanNum = cleanNum.stringByReplacingOccurrencesOfString(")", withString: "")
            cleanNum = cleanNum.stringByReplacingOccurrencesOfString(" ", withString: "")
            
            if(YMValueValidator.IsCellPhoneNum(cleanNum)) {
                return cleanNum
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    public func GetName(name: APName?) -> String {
        if(nil == name) {
            return ""
        }
        
        if(nil == name!.compositeName) {
            return ""
        }
        
        return name!.compositeName!
    }
    
    private let syncObj = NSObject()
    
    public func ReadAddressBook(cb: ReadAddressbookCallback) {
        APAB.loadContacts { (apc, err) in
            YMAddressBookTools.AllContacts.removeAll()
            if(nil == apc) {
                YMAddressBookTools.GetContactsStatus = true
                cb()
                return
            }
            
            YMAddressBookTools.ContactsCount = apc!.count

            for c in apc!.enumerate() {
                let phones = c.element.phones
                let phoneNum = self.GetPhone(phones)
                
                if(nil != phoneNum) {
                    let name = self.GetName(c.element.name)
                    YMAddressBookTools.AllContacts.append(["phone": phoneNum!, "name": name])
                }
            }
            
            YMAddressBookTools.GetContactsStatus = true
            cb()
        }
    }
}




























