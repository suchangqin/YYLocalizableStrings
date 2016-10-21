//
//  YYDefines.swift
//  YYLocalizableStrings
//
//  Created by suchangqin on 20/10/2016.
//  Copyright © 2016 suchangqin. All rights reserved.
//

import Cocoa
func DYYAlert(_ title:String) -> Void{
    DYYAlert(title: title, subtitle: nil)
}
func DYYAlert(title:String,subtitle:String?) -> Void {
    #if os(iOS)
        
    #else
        let alert = NSAlert()
        alert.addButton(withTitle: "OK")
        alert.messageText = title
        if !DYY_IsEmpty(subtitle) {
            alert.informativeText = subtitle!
        }
        alert.alertStyle = NSAlertStyle.warning
        alert.runModal()
    #endif
}

class YYDefines: NSObject {

}
