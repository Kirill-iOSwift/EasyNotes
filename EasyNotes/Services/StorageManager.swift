//
//  StorageManager.swift
//  EasyNotes
//
//  Created by Кирилл on 14.03.2024.
//

import CoreData

final class StorageManager {
    
    static let shared = StorageManager()
    
    //MARK: - Core Data stack
    
    private let persistentContainer: NSPersistentContainer = {
        ///Создаем контейнер
        let container = NSPersistentContainer(name: "EasyNotes")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    ///Создаем и инициализируем context
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    //MARK: - CRUD
    
    ///Метод создает новую заметку
    func create(noteTitle: String, noteText: String) {
        let note = Note(context: viewContext)
        note.title = noteTitle
        note.text = noteText
        note.id = UUID()
        note.date = Date()
        saveContext()
    }
    
    ///Метод извлечения данных из БД
    func fetch(completion: (Result<[Note], Error>) -> Void) {
        let fetchRequest = Note.fetchRequest()
        
        do {
            let notes = try viewContext.fetch(fetchRequest)
            completion(.success(notes))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    ///Метод обновляет заметку
    func update(note: Note, newTitle: String, newText: String) {
        note.title = newTitle
        note.text = newText
        note.date = Date()
        saveContext()
    }
    
    ///Метод удаления заметки
    func delete(note: Note) {
        viewContext.delete(note)
        saveContext()
    }
    
    ///Метод создания мок объекта
    func firstObject() {
        let object = Note(context: viewContext)
        object.id = UUID()
        object.date = Date()
        object.title = "First note"
        object.text =
"""
- Movies
- Sports
- Food
- Music
"""
    }
    
    //MARK: - Core Data Saving support
    
    ///Метод сохранения контекста в БД
    func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
