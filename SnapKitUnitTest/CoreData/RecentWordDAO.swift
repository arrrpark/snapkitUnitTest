
import UIKit
import CoreData

class RecentWordDAO {
    internal init() { }
    
    static let shared = RecentWordDAO()
    
    var viewContext: NSManagedObjectContext? {
        get {
            return (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        }
    }
    
    func saveOrUpdateWord(_ searchedWord: String) {
        guard let managedContext = viewContext,
              let wordEntity = NSEntityDescription.entity(forEntityName: "Word", in: managedContext) else {
            return
        }
        
        // save words uniquely
        let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "word == %@", searchedWord)
        
        do {
            if let word = (try managedContext.fetch(fetchRequest)).first {
                word.setValue(Date().millisecondsSince1970, forKey: "timestamp")
                do {
                    try managedContext.save()
                    return
                } catch let error as NSError {
                    print("Save error : \(error), \(error.userInfo)")
                    return
                }
            }
        } catch let error as NSError {
            print("Retrieve error : \(error), \(error.userInfo)")
            return
        }
        
        // save 100 words at most
        fetchRequest.predicate = nil
        let timemillsSort = NSSortDescriptor(key: "timestamp", ascending: true)
        fetchRequest.sortDescriptors = [timemillsSort]
        
        do {
            let words = try managedContext.fetch(fetchRequest)
            if words.count >= 100,
               let word = words.first {
                word.setValue(searchedWord, forKey: "word")
                word.setValue(Date().millisecondsSince1970, forKey: "timestamp")
                do {
                    try managedContext.save()
                    return
                } catch let error as NSError {
                    print("Save error : \(error), \(error.userInfo)")
                    return
                }
            }
        } catch let error as NSError {
            print("Retrieve error : \(error), \(error.userInfo)")
            return
        }
        
        let word = NSManagedObject(entity: wordEntity, insertInto: managedContext)
        word.setValue(searchedWord, forKey: "word")
        word.setValue(Date().millisecondsSince1970, forKey: "timestamp")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Save error : \(error), \(error.userInfo)")
        }
    }
    
    func getFilteredWords(_ word: String? = nil, limit: Int = 10) -> [Word] {
        guard let managedContext = viewContext else { return [] }
        
        let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
        
        if let word {
            let predicate = NSPredicate(format: "word BEGINSWITH[c] %@", word)
            fetchRequest.predicate = predicate
        }
        let timemillsSort = NSSortDescriptor(key: "timestamp", ascending: false)
        let wordSort = NSSortDescriptor(key: "word", ascending: true)
        
        fetchRequest.sortDescriptors = [timemillsSort, wordSort]
        fetchRequest.fetchLimit = limit
        
        var words: [Word] = []
        
        do {
            words = try managedContext.fetch(fetchRequest)
            return words
        } catch let error as NSError {
            print("Retrieve error : \(error), \(error.userInfo)")
            return []
        }
    }
}
