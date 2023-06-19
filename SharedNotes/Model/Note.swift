//
//  Note.swift
//  SharedNotes
//
//  Created by Kostya Tsyvilko on 28.01.23.
//

import Foundation

struct Note: Codable, Identifiable {
    let id: String
    let userId: String
    
    var title: String
    var content: String
    var createDate: Date
    
    init(id: String = UUID().uuidString.lowercased(),
         userId: String,
         title: String = "",
         content: String = "",
         createDate: Date = Date()) {
        self.id = id
        self.userId = userId
        self.title = title
        self.content = content
        self.createDate = createDate
    }
}
