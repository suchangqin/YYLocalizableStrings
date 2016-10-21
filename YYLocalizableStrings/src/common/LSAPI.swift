//
//  LSAPI.swift
//  YYLocalizableStrings
//
//  Created by suchangqin on 19/10/2016.
//  Copyright © 2016 suchangqin. All rights reserved.
//

import Cocoa

class LSAPI: NSObject {
    
    private let __kUser_lastRecentSelectedDir = "__kUser_lastRecentSelectedDir_001"
    
    static let sharedInstance = LSAPI()

    private var _stringLastRecentSelectedDir:String?
    
    var stringLastRecentSelectedDir:String?{
        get {
            if(!DYY_IsEmpty(_stringLastRecentSelectedDir)){
                return _stringLastRecentSelectedDir
            }
            let n = UserDefaults.standard.string(forKey: __kUser_lastRecentSelectedDir)
            if !DYY_IsEmpty(n) {
                _stringLastRecentSelectedDir = n
            }
            return _stringLastRecentSelectedDir
        }
        set {
            _stringLastRecentSelectedDir = newValue
            UserDefaults.standard.set(newValue, forKey: __kUser_lastRecentSelectedDir)
            UserDefaults.standard.synchronize()
        }
    }
    
    private override init() {
        
    }
    
    
    
    func add(authorizeUrl:URL,path:String) -> Void {
        do {
            let bookmarkData = try authorizeUrl.bookmarkData(options: URL.BookmarkCreationOptions.withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
            UserDefaults.standard.setValue(bookmarkData, forKey: path)
            UserDefaults.standard.synchronize()
        } catch {
            
        }
    }
    
    func authorizedURLStart(path:String) -> Bool {
        let url = authorizedURL(path: path)
        if url != nil {
            return true
        }
        return false
    }
    private func authorizedURL(path:String) -> URL? {
        let userDefault = UserDefaults.standard
        let boolMarkDataToResolve = userDefault.object(forKey: path)
        if (boolMarkDataToResolve != nil) {
            do {
                var isState = false
                let url:URL? = try URL(resolvingBookmarkData: boolMarkDataToResolve as! Data, options: URL.BookmarkResolutionOptions.withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isState)
                let start = url?.startAccessingSecurityScopedResource()
                if start == true {
                    return url
                }
            } catch {
                print("failed \(path) \(error)")
            }
            
        }
        return nil
    }
    
}
