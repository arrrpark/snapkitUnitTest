
import UIKit
import CoreData

struct RecentWordDAO {
    private init() { }
    
    static let shared = RecentWordDAO()
    
    func saveOrUpdate(_ searchedWord: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let wordEntity = NSEntityDescription.entity(forEntityName: "Word", in: managedContext) else {
            return
        }
        
        let fetchrequest: NSFetchRequest<Word> = Word.fetchRequest()
        fetchrequest.predicate = NSPredicate(format: "word == %@", searchedWord)
        
        do {
            if let words = (try managedContext.fetch(fetchrequest)).first {
                words.setValue(Date().millisecondsSince1970, forKey: "timestamp")
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
    
    func getWords(_ word: String? = nil, limit: Int = 10) -> [Word] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
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
