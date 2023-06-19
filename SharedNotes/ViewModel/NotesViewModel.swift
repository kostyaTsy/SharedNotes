//
//  NotesViewModel.swift
//  SharedNotes
//
//  Created by Kostya Tsyvilko on 28.01.23.
//

import Foundation

class NotesViewModel: ObservableObject {
    @Published var notes = [Note]()
    private let notesFireStoreService = FireStoreService<Note>(collectionPath: "Notes")
    private let sqLiteNotesService = SqLiteNoteService.shared
    
    
    func fetchNotes(userId: String) {
        notesFireStoreService.fetchFilteredLiveData(field: "userId", id: userId) { snapshot, error in
            let documents = snapshot?.documents
            self.notes = documents?.compactMap{ documentSnapshot in
                return try? documentSnapshot.data(as: Note.self)
            } ?? []
        }

    }
    
    func fetchLocalNotes(userId: String) {
        self.notes = sqLiteNotesService.read(for: userId)
    }
    
    func deleteNote(note: Note) {
        notesFireStoreService.delete(data: note)
        sqLiteNotesService.delete(note: note)
    }
    
    func saveNote(note: Note) async {
        sqLiteNotesService.add(note: note)
        notesFireStoreService.addData(data: note)
    }
    
    func syncNotes() {
        let notes = sqLiteNotesService.read(for: nil)
        for note in notes {
            notesFireStoreService.addData(data: note)
        }
    }
}
