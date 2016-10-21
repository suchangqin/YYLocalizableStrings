//
//  String+YYExtension.swift
//  YYLocalizableStrings
//
//  Created by suchangqin on 20/10/2016.
//  Copyright © 2016 suchangqin. All rights reserved.
//

import Cocoa


func DYY_IsEmpty(_ string:String?) -> Bool {
    let str:String! = string != nil ? string : ""
    return str.isEmpty
}
func DYY_URLEncoding(_ string:String?) -> String {
    let str:String! = string != nil ? string : ""
    return str.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
}

class String_YYExtension: NSObject {

}
