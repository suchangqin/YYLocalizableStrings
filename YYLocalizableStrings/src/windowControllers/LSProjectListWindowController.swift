//
//  LSProjectListWindowController.swift
//  YYLocalizableStrings
//
//  Created by suchangqin on 19/10/2016.
//  Copyright © 2016 suchangqin. All rights reserved.
//

import Cocoa

class LSProjectListWindowController: NSWindowController ,NSTableViewDelegate,NSTableViewDataSource,NSMenuDelegate {
    
    
    @IBOutlet weak var tableView: NSTableView!
    
    
    private var tableProjects = LSTableProjects.sharedInstance
    
    private var arrayProject:[[String:String]] = []
    
    private var windowControllerProjectInfo:LSProjectInfoWindowController?
    
    override func windowDidLoad() {
        super.windowDidLoad()
        ___reloadTableView()
        
        tableView.doubleAction = #selector(___doMenuOpen(_:))
        tableView.tableColumns.first?.title = YYLocalized("项目列表")
    }
    
    @IBAction func ___doAddNewProject(_ sender: AnyObject) {
        let api = LSAPI.sharedInstance
        let panel = NSOpenPanel()
        panel.directoryURL = URL(string: DYY_URLEncoding(api.stringLastRecentSelectedDir))
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        if panel.runModal() == NSModalResponseOK {
            let selectedURL = panel.urls.first
            let path = selectedURL?.path
            api.add(authorizeUrl: selectedURL!, path: path!)
            
            if tableProjects.exist(path: path) {
                DYYAlert(YYLocalized("项目已经存在！"))
            }else{
                api.stringLastRecentSelectedDir = path
                let name = selectedURL?.pathComponents.last
                tableProjects.insert(name: name, path: path)
                ___reloadTableView()
            }
        }
    }
    
    private func ___reloadTableView() -> Void{
        arrayProject = tableProjects.queryAll()
        tableView.reloadData()
    }
    // MARK: menu click
    @IBAction func ___doMenuShowInFilnder(_ sender: AnyObject) {
        let dict = ___dataFromClickTableView();
        let path = dict[tableProjects.KeysCloums_path]
        if !DYY_IsEmpty(path) {
            NSWorkspace.shared().selectFile(nil, inFileViewerRootedAtPath: path!)
        }
    }
    @IBAction func ___doMenuOpen(_ sender: AnyObject) {
        let dict = ___dataFromClickTableView()
        if windowControllerProjectInfo != nil {
            let dictOpen = windowControllerProjectInfo?.dictProjectInfo
            if dictOpen?[tableProjects.KeysCloums_id] == dict[tableProjects.KeysCloums_id] {
                windowControllerProjectInfo?.showWindow(self);
                return
            }
            windowControllerProjectInfo?.window?.close()
            windowControllerProjectInfo = nil
        }
        windowControllerProjectInfo = LSProjectInfoWindowController(windowNibName: "LSProjectInfoWindowController")
        windowControllerProjectInfo?.dictProjectInfo = dict
        windowControllerProjectInfo?.showWindow(self)
    }
    @IBAction func ___doMenuShowInTerminal(_ sender: AnyObject) {
        let dict = ___dataFromClickTableView()
        let path = dict[tableProjects.KeysCloums_path]
        if !DYY_IsEmpty(path) {
            let script = "tell application \"Terminal\" to do script \"cd '\(path!)'\"";
            let appleScript = NSAppleScript(source: script)
            appleScript?.executeAndReturnError(nil)
        }
    }
    @IBAction func ___doMenuDelete(_ sender: AnyObject) {
        let dict = ___dataFromClickTableView()
        let id = dict[tableProjects.KeysCloums_id]
        _ = tableProjects.delete(id: id)
        ___reloadTableView()
    }
    // MARK: NSTableView dataSource & delegate
    func ___dataFromClickTableView() -> [String:String]{
        let clickRow = tableView.clickedRow
        return arrayProject[clickRow]
    }
    func numberOfRows(in tableView: NSTableView) -> Int {
        return arrayProject.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let CellIdent = "LSCellProject01"
        
        let iden = tableColumn?.identifier
        
        if iden == CellIdent {
            let dict:[String:String] = arrayProject[row]
            
            let cellView = tableView.make(withIdentifier: CellIdent, owner: self)
            
            let textFiledName:NSTextField? = cellView?.viewWithTag(1) as! NSTextField?
            let textFiledPath:NSTextField? = cellView?.viewWithTag(2) as! NSTextField?
            
            textFiledName?.stringValue = dict[tableProjects.KeysCloums_name] ?? ""
            textFiledPath?.stringValue = dict[tableProjects.KeysCloums_path] ?? ""
            
            return cellView
        }
        return nil;
    }
    // MARK: NSMenu delegate
    func menuWillOpen(_ menu: NSMenu) {
        let clickRow = tableView.clickedRow
        let allRow = numberOfRows(in: tableView)
        var hide = true
        if clickRow<allRow && clickRow>=0 {
            //show
            hide = false
        }
        
        for item in menu.items {
            item.isHidden = hide;
        }
    }
    
    
    
}
