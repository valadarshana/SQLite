//
//  ViewController.swift
//  SQLite_Demo
//
//  Created by user on 15/07/20.
//  Copyright © 2020 Nextpage. All rights reserved.
//

import UIKit
import SQLite3
class ViewController: UIViewController {

    var count = 0
    
    @IBOutlet weak var textAge: UITextField!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textID: UITextField!
    var dbHelper = SQLDBHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
       dbHelper.insert(id: 1, name: "Vijay", age: 24)
        dbHelper.insert(id: 2, name: "Ajay", age: 24)
        dbHelper.insert(id: 3, name: "jay", age: 24)
        dbHelper.insert(id: 4, name: "Dhruv", age: 24)
      
      
    }

    
    @IBAction func Button_click(_ sender: UIButton) {
        
        switch sender.tag
        {
        case 1:count = count-1
        case 2:count=1
            let arrPersion = dbHelper.read()
            print("Id:",arrPersion?.first?.id ?? "")
            print("Name:",arrPersion?.first?.name ?? "")
            print("Age:",arrPersion?.first?.age ?? "")
            
        default:
            print("Nothing")
        }
    }
    
    
    

}

