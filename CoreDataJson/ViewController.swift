//
//  ViewController.swift
//  CoreDataJson
//
//  Created by Joakim Sjöstedt on 2020-03-12.
//  Copyright © 2020 Joakim Sjöstedt. All rights reserved.
//

import UIKit
import CoreData

extension Employees: CustomStringConvertible {
    var description: String {
        let txt = "\n" + "Namn: " + name + ", Jobb: " + job + ", Book: " + bestBook.title
        return txt
    }
}

struct People: Codable {
    let people: [Employees]!
}

struct Employees: Codable {
    let name: String
    let job: String
    let date: Date
    let bestBook: Book
}

struct Book: Codable {
    let id: Int
    let title: String
    let author: Author
}

struct Author: Codable {
    let id: Int
    let name: String
}

class ViewController: UIViewController {
    var contextMainThread: NSManagedObjectContext!
    var contextBackgroundThread: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.contextMainThread = setContext().viewContext
        self.contextBackgroundThread = setContext().newBackgroundContext()

         getJSON(completion: { data in
            
             self.setData(data: data)
                    
            self.fetchCoreData()
//
//             self.deleteData()
//
//             self.fetchCoreData()
            
//            self.fetchPredicate()
            
         })
    }

    func getJSON(completion: @escaping (People) -> ()) {
        guard let url = URL(string:"https://api.myjson.com/bins/sbmzi") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                jsonDecoder.dateDecodingStrategy = .iso8601
                
                let decodedJson = try jsonDecoder.decode(People.self, from: data)
                
                completion(decodedJson)

            } catch {
                print(error)
            }
        }.resume()
    }
    
    func setData(data: People) {
        
        let enmployeeEntity = NSEntityDescription.entity(forEntityName: "EmployeeCoreData", in: contextMainThread)
        let bookEntity = NSEntityDescription.entity(forEntityName: "BookCoreData", in: contextMainThread)
        let authorEntity = NSEntityDescription.entity(forEntityName: "AuthorCoreData", in: contextMainThread)

        for i in 0...data.people.count - 1 {
            let employee = EmployeeCoreData(entity: enmployeeEntity!, insertInto: contextMainThread)
            let book = BookCoreData(entity: bookEntity!, insertInto: contextMainThread)
            let author = AuthorCoreData(entity: authorEntity!, insertInto: contextMainThread)
            
            employee.name = data.people[i].name
            employee.job = data.people[i].job
            employee.date = data.people[i].date
            employee.bookRelationship = book
            
            book.id = Int64(data.people[i].bestBook.id)
            book.title = data.people[i].bestBook.title
            book.employeeRelationship = employee
            book.authorRelationship = author
            
            author.id = Int64(data.people[i].bestBook.author.id)
            author.name = data.people[i].bestBook.author.name
            author.bookRelationship = book
            
        }
    }
    
    func fetchCoreData() {
        do {
            let request = NSFetchRequest<EmployeeCoreData>(entityName: "EmployeeCoreData")
            let sorting = NSSortDescriptor(key: "name", ascending: true)
                request.sortDescriptors = [sorting]
            let result = try contextMainThread.fetch(request)
            
            for data in result  {
                print("🦁", data.name)
                print("🦁", data.job)
                print("🦁", data.date)
                print("🦁", data.bookRelationship!.title)
                print("🦁", data.bookRelationship!.authorRelationship!.name)
            }
           
            
        } catch  { let nserror = error as NSError
            print(nserror)
        }
    }
    
    func fetchPredicate() {
        
        
        do {
            let request = NSFetchRequest<EmployeeCoreData>(entityName: "EmployeeCoreData")
            request.predicate = NSPredicate(format: "name =[c] %@", "bob")
           
            let result = try contextMainThread.fetch(request)
            for data in result {
                print("🦁", data.name)
            }
            
        } catch  { let nserror = error as NSError
            print(nserror)
        }
    }
    
    func deleteData() {
        print("Deleting all data")
        let request = NSFetchRequest<EmployeeCoreData>(entityName: "EmployeeCoreData")
        if let result = try? contextMainThread.fetch(request) {
            for object in result {
                contextMainThread.delete(object)
            }
        }
    }
       
    
    func setContext() -> NSPersistentContainer {
        let persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "CoreDataJson")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
       return persistentContainer
    }
    
//    func backgroundThread() {
//        let a = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
//        a.persistentStoreCoordinator = setContext()
//    }
    
    func saveData() {
        do {
            try contextMainThread.save()
            print("saved")
        } catch {
            let nserror = error as NSError
            print(nserror)
        }
    }
    
    

}

