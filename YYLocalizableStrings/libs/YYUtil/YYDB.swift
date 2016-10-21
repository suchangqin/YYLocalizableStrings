//
//  YYDB.swift
//  YYLocalizableStrings
//
//  Created by suchangqin on 20/10/2016.
//  Copyright © 2016 suchangqin. All rights reserved.
//

import Cocoa

func DB_StringFormat(_ str:String?) -> String {
    if str == nil {
        return ""
    }
    return str!;
}

class YYDB: NSObject {
    private let DATABASE_NAME = "lsdb.sqlite3"
    private var database:OpaquePointer?
    
    private var stringDatabasePath:String?
    
    static let sharedInstance = YYDB()
    override private init() {
    }
    
    private func ___connectDatabase()->Bool{
        if DYY_IsEmpty(stringDatabasePath) {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let dbUrl = url?.appendingPathComponent(DATABASE_NAME)
            print(dbUrl)
            stringDatabasePath = dbUrl?.absoluteString
        }
        if sqlite3_open(stringDatabasePath,&database) != SQLITE_OK {
            sqlite3_close(database)
            print("Error:  Failed to open database")
            return false
        }
        return true
    }
    
    private func ___execute(sql:String) -> Bool {
        print("execute sql:\(sql)")
        var re = false
        if ___connectDatabase() {
            var errorMsg:UnsafeMutablePointer<Int8>?
            if (sqlite3_exec (database, sql,nil, nil, &errorMsg) == SQLITE_OK) {
                re = true;
                print("Success");
            }else{
                print("Error: \(String(cString: errorMsg!))");
            }
            sqlite3_close(database);
        }
        return re
    }
    
    func dbQueryCount(sql:String) -> Int{
        var count = 0;
        if(___connectDatabase()){
            var statement:OpaquePointer?
            if (sqlite3_prepare_v2(database, sql, -1, &statement, nil) == SQLITE_OK) {
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    count = Int(sqlite3_column_int(statement, 0));
                }
            }
            sqlite3_finalize(statement);
            sqlite3_close(database);
        }
        return count;
    }
    
    func dbExist(tableName:String) -> Bool{
        let sql = "select count(type) from sqlite_master where type='table' and name ='\(tableName)';";
        return ___execute(sql: sql);
    }
    func dbCreateTable(sql:String) -> Bool {
        return ___execute(sql: sql)
    }
    func dbUpdate(sql:String) -> Bool {
        return ___execute(sql: sql)
    }
    
    func dbQuery(sql:String) -> [[String:String]]{
        var result = [[String:String]]()
        if(___connectDatabase()){
            var statement:OpaquePointer?
            if (sqlite3_prepare_v2(database, sql, -1, &statement, nil) == SQLITE_OK) {
                var arrayColumn = [String]()
                let columnCount = sqlite3_column_count(statement)
                for index in 0..<columnCount {
                    arrayColumn.append(String(cString: sqlite3_column_name(statement, index)))
                }
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    var dict = [String:String]()
                    for index in 0..<columnCount {
                        let col_value = String(cString: sqlite3_column_text(statement, index));
                        if (DYY_IsEmpty(col_value)) {
                            continue;
                        }
                        let col_name = arrayColumn[Int(index)]
                        dict[col_name] = col_value
                    }
                    result.append(dict)
                }
    
            }
            sqlite3_finalize(statement)
            sqlite3_close(database)
        }
        print("result:\(result)")
        return result;
    }
}
