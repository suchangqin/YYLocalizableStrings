//
//  LSProjectInfoWindowController.swift
//  YYLocalizableStrings
//
//  Created by suchangqin on 24/10/2016.
//  Copyright © 2016 suchangqin. All rights reserved.
//

import Cocoa

class LSProjectInfoWindowController: NSWindowController {

    var dictProjectInfo = [String:String]()
    
    private var tableProjects = LSTableProjects.sharedInstance
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.title = dictProjectInfo[tableProjects.KeysCloums_name]!
        
        
        
        
    }
    
}
