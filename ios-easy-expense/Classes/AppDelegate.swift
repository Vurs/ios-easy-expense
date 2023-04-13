//
//  AppDelegate.swift
//  ios-easy-expense
//
//  Created by Vincent Ursino on 2023-04-04.
//

import UIKit
import SQLite3

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var databaseName : String? = "EasyExpense.db"
    var databasePath : String?
    var transactions : [Transaction] = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Figure out where the files are located on the device
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDir = documentPaths[0]
        
        databasePath = documentsDir.appending("/" + databaseName!)
        
        checkAndCreateDatabase()
        readDataFromDatabase()
        
        return true
    }
    
    func readDataFromDatabase() {
        transactions.removeAll()
        
        var db : OpaquePointer? = nil
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(self.databasePath)")
            
            // Setup our query
            var queryStatement : OpaquePointer? = nil
            var queryStatementString : String = "select * from entries"
            
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                // While there is a row
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    // Extract a row, put it inside a Transaction object, and put that object inside the Transactions array
                    let id : Int = Int(sqlite3_column_int(queryStatement, 0))
                    let type : Int = Int(sqlite3_column_int(queryStatement, 1))
                    let recurring : Int = Int(sqlite3_column_int(queryStatement, 3))
                    let amount : Decimal = Decimal(sqlite3_column_double(queryStatement, 5))
                    
                    // C Strings which will be converted to regular Strings
                    let cName = sqlite3_column_text(queryStatement, 2)
                    let cDate = sqlite3_column_text(queryStatement, 4)
                    
                    // Convert the C Strings to regular Strings
                    let name = String(cString: cName!)
                    let date = String(cString: cDate!)
                    
                    // Fetch the Image blob and convert it to a Data object
                    //let imageData = sqlite3_column_blob(queryStatement, 6)
                    //let imageLength = sqlite3_column_bytes(queryStatement, 6)
                    //let imageDataPtr = UnsafeRawPointer(imageData!)
                    //let imageDataData = Data(bytes: imageDataPtr, count: Int(imageLength))
                    
                    // Convert Date String to a Date object, and Recurring to a boolean
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    
                    var dateConverted = dateFormatter.date(from: date)
                    if dateConverted == nil {
                        dateConverted = Date()
                    }
                    
                    let recurringBool = recurring == 0 ? false : true
                    
                    // Finally, map the data to a Transaction object and append it to the array
                    let transaction : Transaction = Transaction.init()
                    transaction.initWithData(TransactionType: Transaction.TransactionType.allCases[type], TransactionName: name, Recurring: recurringBool, Date: dateConverted!, AmountTransacted: amount)
                    
                    transactions.append(transaction)
                }
                
                // Free up memory that was allocated, and flush any data that is yet to be flushed
                sqlite3_finalize(queryStatement)
            } else {
                print("Select statement could not be prepared")
            }
            
            sqlite3_close(db)
        } else {
            print("Unable to open database")
        }
    }
    
    func checkAndCreateDatabase() {
        var success = false
        
        let fileManager = FileManager.default
        success = fileManager.fileExists(atPath: databasePath!)
        
        if success {
            return
        }
        
        let databasePathFromApp = Bundle.main.resourcePath?.appending("/" + databaseName!)
        
        try? fileManager.copyItem(atPath: databasePathFromApp!, toPath: databasePath!)
        
        return
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

