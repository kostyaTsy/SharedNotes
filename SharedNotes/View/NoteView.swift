//
//  NoteView.swift
//  SharedNotes
//
//  Created by Kostya Tsyvilko on 28.01.23.
//

import SwiftUI

struct NoteView: View {
   
    @State var note: Note
    @State var isDisabled = false
    @EnvironmentObject var notes: NotesViewModel
    
    @State var noteContent: String = ""
    var body: some View {
        TextEditor(text: $noteContent)
            .disabled(isDisabled)
            .padding()
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                if (isDisabled) {
                    return
                }
                Task {
                    await saveNote()
                }
            }
            .onAppear {
                noteContent = note.title + "\n" + note.content
            }
    }
    
    private func saveNote() async {
        var splitedContent = noteContent.split(separator: "\n")
        note.title = String(splitedContent.first ?? "")
        if (!splitedContent.isEmpty) {
            splitedContent[0] = ""
        }
        
        note.content = splitedContent.joined(separator: "\n") //noteContent
        await notes.saveNote(note: note)
    }
}

struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        let note = Note(userId: "")
        NoteView(note: note)
    }
}
