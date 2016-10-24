//
//  LSTableProjects.swift
//  YYLocalizableStrings
//
//  Created by suchangqin on 21/10/2016.
//  Copyright © 2016 suchangqin. All rights reserved.
//

import Cocoa

class LSTableProjects: NSObject {
    
    static let sharedInstance = LSTableProjects()
    override private init() {
        super.init()
        ___createTable()
    }
    
    public let KeysCloums_id   = "id"
    public let KeysCloums_name = "name"
    public let KeysCloums_path = "path"
    
    public let stringTableName = "ls_projects"
    
    let db:YYDB = YYDB.sharedInstance
    
    
    
    private func ___createTable() -> Void {
        let cloumns = ["id INTEGER PRIMARY KEY",
                      "name TEXT",
                      "path TEXT"]
        let sql = "CREATE TABLE IF NOT EXISTS \(stringTableName)(\(cloumns.joined(separator: ",")));"
        _ = db.dbUpdate(sql:sql)
    }
    
    func insert(name:String?,path:String?) -> Void {
        let sql = "INSERT INTO \(stringTableName)(name,path) VALUES('\(DB_StringFormat(name))','\(DB_StringFormat(path))');"
        _ = db.dbUpdate(sql: sql)
    }
    func exist(path:String?) -> Bool {
        let sql = "SELECT count(*) FROM \(stringTableName) WHERE path='\(DB_StringFormat(path))';"
        let count = db.dbQueryCount(sql: sql)
        if count>0{
            return true
        }
        return false
        
    }
    func queryAll() -> [[String:String]] {
        return db.dbQuery(sql: "select * from \(stringTableName);")
    }
    func delete(id:String?) -> Bool {
        let sql = "DELETE FROM \(stringTableName) WHERE id = \(DB_StringFormat(id))"
        return db.dbUpdate(sql: sql)
    }
    func query(id:String?) -> [String:String]? {
        let sql = "select * from \(stringTableName) where id = \(DB_StringFormat(id))"
        return db.dbQuery(sql: sql).first
    }
}
