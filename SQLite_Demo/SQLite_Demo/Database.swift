//
//  Database.swift
//  SQLite_Demo
//
//  Created by user on 16/07/20.
//  Copyright © 2020 Nextpage. All rights reserved.
//

import Foundation
import SQLite3

class SQLDBHelper{
    
  
    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?
   
    init()
     {
         db = openDatabase()
         createTable()
     }

    
    func openDatabase() -> OpaquePointer?
      {
          let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
              .appendingPathComponent(dbPath)
        
          var db: OpaquePointer? = nil
        
          if sqlite3_open(fileURL.path, &db) != SQLITE_OK
          {
              print("error opening database")
              return nil
          }
          else
          {
              print("Successfully opened connection to database at \(fileURL)")
              return db
          }
      }
    
    func createTable(){
        let createTableString = "CREATE TABLE IF NOT EXISTS person(id INTEGER PRIMARY KEY,name TEXT, age INTEGER);"
        
        var createTable:OpaquePointer? = nil
        
       
        
        if sqlite3_prepare_v2(db, createTableString, -1, &createTable, nil) == SQLITE_OK{
                
            if sqlite3_step(createTable) == SQLITE_DONE{
                print("Person Table Created")
            }else{
                print("Person Table Not Created")
            }
            
        }else{
            print("ERROR In CREATE TABLE")
        }
        sqlite3_finalize(createTable)
    }
    
    
    func insert(id:Int,name:String,age:Int){
        
        let insertSatementString = "INSERt INTO person(id,name,age) VALUES (?,?,?);"
        var insertSatement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertSatementString, -1, &insertSatement, nil) == SQLITE_OK{
            
            sqlite3_bind_int(insertSatement, 1, Int32(id))
            sqlite3_bind_text(insertSatement, 2, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertSatement, 3, Int32(age))
            
            if sqlite3_step(insertSatement) == SQLITE_DONE{
                print("Successfully Insert row")
            }else{
                print("Data not inserted")
            }
            
        }else{
            print("INSERt Statement couyld not be corrct")
        }
   
        sqlite3_finalize(insertSatement)
        
    }
    
    func read()->[Person]?{
        let queryStatementString = "SELECT * FROM person;"
        var queryStatement:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db,queryStatementString, -1, &queryStatement, nil) == SQLITE_OK{
            var arrPersion = [Person]()
            while sqlite3_step(queryStatement) == SQLITE_ROW{
                print(queryStatement)
                
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let age = sqlite3_column_int(queryStatement, 2)
                
                var person = Person()
                person.name = name
                person.age = Int(age)
                person.id = Int(id)
                arrPersion.append(person)
            }
            return arrPersion
        }else{
            
            print("SQL Satement could not Prepared")
            return nil
        }
        
        sqlite3_finalize(queryStatement)
        return nil
    }
    
    func deleteBy(id:Int){
        
        let deleteStatementString = "DELETE  FROM person WHERE id = ?;"
        var deleteStatement:OpaquePointer?=nil
        
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK{
            
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE{
                print("Successfully deleted row.")
            }else{
                print("Could not delete row.")
            }
            
        }else{
            print("DELETE statement COULD NOT PREPARED")
        }
    
        
        sqlite3_finalize(deleteStatement)
    }
    
}
