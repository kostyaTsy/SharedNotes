//
//  NoteListItem.swift
//  SharedNotes
//
//  Created by Kostya Tsyvilko on 28.01.23.
//

import SwiftUI

struct NoteListItem: View {
    var note: Note
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(note.title)
                .bold()
                .font(.title2)
                .lineLimit(1)
            HStack(spacing: 10.0) {
                Text(note.createDate.getShortDate())
                
                Text(note.content == "" ? "No additional text" : note.content.replacingOccurrences(of: "\n", with: " ").trimmingCharacters(in: .whitespacesAndNewlines))
                    .lineLimit(1)
            }.foregroundColor(.gray)
        }.padding(.horizontal)
    }
}

struct NoteListItem_Previews: PreviewProvider {
    static var previews: some View {
        NoteListItem(note: Note(userId: "", title: "Test", content: "Very long content to specify the clip action dfsdfasdfdf"))
    }
}
