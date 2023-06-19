//
//  NotesView.swift
//  SharedNotes
//
//  Created by Kostya Tsyvilko on 28.01.23.
//

import SwiftUI
import Reachability

struct NotesView: View {
    
    @StateObject var notesViewModel = NotesViewModel()
    @EnvironmentObject var appViewModel: AppViewModel
    @State var searchText: String = ""
    let reachability = try! Reachability()
    
    var filteredData: [Note] {
        if (searchText.isEmpty) {
            return notesViewModel.notes
        }
        return notesViewModel.notes.filter { note in
            note.content.localizedCaseInsensitiveContains(searchText) || note.title.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        List {
            ForEach(filteredData) { note in
                NavigationLink {
                    NoteView(note: note)
                        .environmentObject(notesViewModel)
                } label: {
                    NoteListItem(note: note)
                }
            }.onDelete { index in
                let items = index.map { notesViewModel.notes[$0] }
                for item in items {
                    notesViewModel.deleteNote(note: item)
                }
            }
        }
        .searchable(text: $searchText, prompt: Text("Search"))
        .onAppear {
            
            if (!notesViewModel.notes.isEmpty) {
                return
            }
            
            self.notesViewModel.fetchNotes(userId: appViewModel.currentUser.id)
            self.appViewModel.fetchUser(userId: appViewModel.currentUser.id)
            
            if (!appViewModel.isConnected) {
                notesViewModel.fetchLocalNotes(userId: appViewModel.currentUser.id)
            } else if (appViewModel.isConnected) {
                
            }
            
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                NavigationLink {
                    NoteView(note: Note(userId: appViewModel.currentUser.id))
                        .environmentObject(notesViewModel)
                } label: {
                    Image(systemName: "plus")
                }
                
            }
        }
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView()
            .environmentObject(AppViewModel())
    }
}
