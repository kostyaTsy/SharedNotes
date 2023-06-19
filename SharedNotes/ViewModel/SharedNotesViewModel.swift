//
//  SharedNotesViewModel.swift
//  SharedNotes
//
//  Created by Kostya Tsyvilko on 29.01.23.
//

import Foundation

class SharedNotesViewModel: ObservableObject {
    @Published var sharedNotes = [SharedNote]()
    private var sharedNotesFireStoreService = FireStoreService<Note>(collectionPath: "Notes")
    private var userFireStoreService = FireStoreService<User>(collectionPath: "Users")
    
    @MainActor
    func fetchSharedNotes(userIds: [String]) {
        sharedNotes = []
        for id in userIds {
            sharedNotesFireStoreService.fetchFilteredLiveData(field: "userId", id: id) { snapshot, error in
                let documents = snapshot?.documents
                let notes = documents?.compactMap{ documentSnapshot in
                    return try? documentSnapshot.data(as: Note.self)
                } ?? []
                
                Task {
                    let user = await self.userFireStoreService.readFilteredData(value: id, filteredField: "id").first
                    self.sharedNotes.removeAll { note in
                        note.email == user?.email ?? id
                    }
                    
                    self.sharedNotes.append(SharedNote(email: user?.email ?? id, notes: notes))
                }
            }
        }
    }
}
