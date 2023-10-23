//
//  RecentWordDAOForTest.swift
//  SnapKitUnitTestTests
//
//  Created by Arrr Park on 23/10/2023.
//

import Foundation
import CoreData
@testable import SnapKitUnitTest

class RecentWordDAOForTest: RecentWordDAO {
    
    override private init() { }
    
    static let sharedForTest = RecentWordDAOForTest()
    
    func getWords() -> [Word] {
        guard let managedContext = viewContext else { return [] }
        
        let timemillsSort = NSSortDescriptor(key: "timestamp", ascending: false)
        let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
        fetchRequest.sortDescriptors = [timemillsSort]
        
        let words = try! managedContext.fetch(fetchRequest)
        return words
    }
    
    func deleteWords() {
        guard let managedContext = viewContext else { return }
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Word")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        try! managedContext.execute(deleteRequest)
    }
    
    func insert98Words() {
        var tmpString = NSMutableString(string: "k")
        for _ in 0..<50 {
            tmpString.append("k")
            saveOrUpdateWord(tmpString as String)
        }
        
        tmpString = NSMutableString(string: "m")
        for _ in 0..<48 {
            tmpString.append("a")
            saveOrUpdateWord(tmpString as String)
        }
    }
}

