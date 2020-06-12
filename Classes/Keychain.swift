//
//  Keychain.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/1/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation

let userAccount = "AuthenticatedUser"
let accessGroup = "SecurityService"

let kSecClassValue = NSString(format: kSecClass)
let kSEcAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSEcClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSEcMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

public class Keychain: NSObject {
    
    public class func save(key: String, value: String?) {
        guard let dataFromString: Data = value?.data(using: String.Encoding.utf8, allowLossyConversion: false) else {return}
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(
            objects: [
                kSecClassGenericPassword,
                key, userAccount,
                dataFromString,
            ],
            forKeys: [
                kSecClassValue,
                kSecAttrServiceValue,
                kSEcAttrAccountValue,
                kSecValueDataValue
            ]
        )
        SecItemDelete(keychainQuery as CFDictionary)
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }
    
    public class func loadFrom(key: String) -> String? {
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(
            objects: [
                kSEcClassGenericPasswordValue,
                key,
                userAccount,
                kCFBooleanTrue as Any,
                kSecMatchLimitOneValue,
            ],
            forKeys: [
                kSecClassValue,
                kSecAttrServiceValue,
                kSEcAttrAccountValue,
                kSecReturnDataValue,
                kSEcMatchLimitValue,
            ])
        var dataTypeRef : AnyObject?
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: String? = nil
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? Data {
                contentsOfKeychain = String(
                    data: retrievedData,
                    encoding: String.Encoding.utf8
                )
            }
        } else {
            print(
                "Warning: Nothing was retrieved from the keychain for key: \(key). Status code \(status)"
            )
        }
        return contentsOfKeychain
    }
    
    public class func logout()  {
        let secItemClasses =  [
            kSecClassGenericPassword,
            kSecClassInternetPassword,
            kSecClassCertificate,
            kSecClassKey,
            kSecClassIdentity,
        ]
        for itemClass in secItemClasses {
            let spec: NSDictionary = [kSecClass: itemClass]
            SecItemDelete(spec)
        }
    }
}
