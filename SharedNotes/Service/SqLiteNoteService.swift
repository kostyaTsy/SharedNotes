//
//  SqLiteService.swift
//  SharedNotes
//
//  Created by Kostya Tsyvilko on 29.01.23.
//

import Foundation
import SQLite

class SqLiteNoteService {
    private var db: Connection?
    
    private let notesTable = Table("Notes")
    private let id = Expression<String>("id")
    private let userId = Expression<String>("userId")
    private let title = Expression<String>("title")
    private let content = Expression<String>("content")
    private let createDate = Expression<Date>("createDate")
    
    static var shared = SqLiteNoteService()
    
    private init() {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        print(path)
        db = try? Connection("\(path)/notes.sqlite3")
        create()
    }
    
    func create() {
        do {
            try db?.run(notesTable.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(userId)
                t.column(title)
                t.column(content)
                t.column(createDate)
            })
        } catch {
            print(error)
        }
    }
    
    func add(note: Note) {
        let insert = notesTable.insert(or: .replace, id <- note.id,
                                  userId <- note.userId,
                                  title <- note.title,
                                  content <- note.content,
                                  createDate <- note.createDate)
        do {
            try db?.run(insert)
        } catch {
            print(error)
        }
    }
    
    func delete(note: Note) {
        let noteToDelete = notesTable.filter(id == note.id)
        
        do {
            try db?.run(noteToDelete.delete())
        } catch {
            print(error)
        }
    }
    
    func read(for currentUserId: String?) -> [Note] {
        var notes = [Note]()
        
        do {
            var filteredNotes: Table = notesTable
            if let currentUserId = currentUserId {
                filteredNotes = notesTable.filter(userId == currentUserId)
            }
            for note in try db!.prepare(filteredNotes) {
                let noteModel = Note(id: note[id],
                                     userId: note[userId],
                                     title: note[title],
                                     content: note[content],
                                     createDate: note[createDate])
                
                notes.append(noteModel)
            }
        } catch {
            print(error)
        }
        
        return notes
    }
    
}
