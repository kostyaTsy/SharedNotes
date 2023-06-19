//
//  SharedNotes.swift
//  SharedNotes
//
//  Created by Kostya Tsyvilko on 28.01.23.
//

import SwiftUI

struct SharedNotesView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject var sharedNotesViewModel = SharedNotesViewModel()
    
    @State var searchText: String = ""
    var filteredData: [SharedNote] {
        if (searchText.isEmpty) {
            return sharedNotesViewModel.sharedNotes
        }
        
        var filteredNotes = [SharedNote]()
        for sharedNote in sharedNotesViewModel.sharedNotes {
            let notes = sharedNote.notes.filter { note in
                note.content.localizedCaseInsensitiveContains(searchText) || note.title.localizedCaseInsensitiveContains(searchText)
            }
            
            filteredNotes.append(SharedNote(email: sharedNote.email, notes: notes))
        }
        
        return filteredNotes
    }
    var body: some View {
        List {
            ForEach(filteredData) { sharedNote in
                Section(sharedNote.email) {
                    ForEach(sharedNote.notes) { note in
                        NavigationLink {
                            NoteView(note: note, isDisabled: true)
                        } label: {
                            NoteListItem(note: note)
                        }
                    }
                }.textCase(nil)
            }
        }
        .searchable(text: $searchText, prompt: Text("Search"))
        .onAppear {
            if (!sharedNotesViewModel.sharedNotes.isEmpty && !appViewModel.userUpdated) {
                return
            }
            appViewModel.userUpdated = false
            sharedNotesViewModel.fetchSharedNotes(userIds: appViewModel.currentUser.userIdWithSharedNotes)
        }.navigationTitle("Shared Notes")
    }
}

struct SharedNotesView_Previews: PreviewProvider {
    static var previews: some View {
        SharedNotesView()
    }
}
