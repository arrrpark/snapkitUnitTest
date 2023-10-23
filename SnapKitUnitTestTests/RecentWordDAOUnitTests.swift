//
//  CoreDataUnitTests.swift
//  SnapKitUnitTestTests
//
//  Created by Arrr Park on 23/10/2023.
//

import XCTest
import CoreData
@testable import SnapKitUnitTest

class RecentWordDAOUnitTests: XCTestCase {
    var recentWordDAO: RecentWordDAOForTest!
    
    override func setUp() {
        super.setUp()
        recentWordDAO = RecentWordDAOForTest.sharedForTest
        recentWordDAO.deleteWords()
    }
    
    override func tearDown() {
        super.tearDown()
        recentWordDAO.deleteWords()
        recentWordDAO = nil
    }
    
    func testInsertAndUpdateWord() {
        recentWordDAO.saveOrUpdateWord("Word")
        
        var words = recentWordDAO.getWords()
        XCTAssertTrue(words.count == 1)
        XCTAssertTrue(words[0].word == "Word")
        
        recentWordDAO.saveOrUpdateWord("iOS")
        words = recentWordDAO.getWords()
        
        XCTAssertTrue(words.count == 2)
        XCTAssertTrue(words[0].word == "iOS")
        XCTAssertTrue(words[1].word == "Word")
    }
    
    func testInsertAndUpdateWordUntil100Words() {
        recentWordDAO.insert98Words()
        
        var words = recentWordDAO.getWords()
        XCTAssertTrue(words.count == 98)
        
        recentWordDAO.saveOrUpdateWord("Android")
        words = recentWordDAO.getWords()
        
        XCTAssertTrue(words.count == 99)
        XCTAssertTrue(words[0].word == "Android")
        
        recentWordDAO.saveOrUpdateWord("iOS")
        words = recentWordDAO.getWords()
        
        XCTAssertTrue(words.count == 100)
        XCTAssertTrue(words[0].word == "iOS")
        
        recentWordDAO.saveOrUpdateWord("React")
        words = recentWordDAO.getWords()
        
        XCTAssertTrue(words.count == 100)
        XCTAssertTrue(words[0].word == "React")
        XCTAssertTrue(words[1].word == "iOS")
        XCTAssertTrue(words[2].word == "Android")
    }
    
    func testFilteredWords() {
        recentWordDAO.insert98Words()
        var words = recentWordDAO.getFilteredWords("kk", limit: 100)
        XCTAssertTrue(words.count == 50)
        
        words = recentWordDAO.getFilteredWords("kkk", limit: 100)
        XCTAssertTrue(words.count == 49)
        
        words = recentWordDAO.getFilteredWords("m", limit: 100)
        XCTAssertTrue(words.count == 48)
        
        words = recentWordDAO.getFilteredWords("ma", limit: 100)
        XCTAssertTrue(words.count == 48)
        
        words = recentWordDAO.getFilteredWords("i")
        XCTAssertTrue(words.count == 0)
        
        recentWordDAO.saveOrUpdateWord("iOS")
        words = recentWordDAO.getFilteredWords("i")
        XCTAssertTrue(words.count == 1)
    }
}

class AppDelegateForTest: AppDelegate {
    override var persistentContainer: NSPersistentContainer {
        get {
            let container = NSPersistentContainer(name: "RecentSearchWord")
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
            container.loadPersistentStores(completionHandler: { _, error in
                if let error = error as? NSError {
                    fatalError("error : \(error), \(error.userInfo)")
                }
            })
            return container
        }
    }
}

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

