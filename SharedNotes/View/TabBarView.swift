//
//  TabBarView.swift
//  SharedNotes
//
//  Created by Kostya Tsyvilko on 28.01.23.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            NavigationView {
                NotesView()
                    .navigationTitle("Notes")
            }
            .tabItem {
                Label("Notes", systemImage: "note.text")
            }
            
            NavigationView {
                SharedNotesView()
            }
            .tabItem {
                Label("Shared Notes", systemImage: "shareplay")
            }
            
            AccountView()
                .tabItem {
                    Label("Account", systemImage: "person")
                }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
