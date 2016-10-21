//
//  AppDelegate.swift
//  YYLocalizableStrings
//
//  Created by suchangqin on 19/10/2016.
//  Copyright © 2016 suchangqin. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    var windowControllerProjectList:LSProjectListWindowController?
    
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let wc = LSProjectListWindowController(windowNibName: "LSProjectListWindowController")
        windowControllerProjectList = wc
        wc.showWindow(self)
        wc.window?.makeKeyAndOrderFront(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

