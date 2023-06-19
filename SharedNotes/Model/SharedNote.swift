//
//  SharedNote.swift
//  SharedNotes
//
//  Created by Kostya Tsyvilko on 29.01.23.
//

import Foundation

struct SharedNote: Codable, Identifiable {
    var id: String = UUID().uuidString.lowercased()
    
    let email: String
    var notes: [Note]
}
