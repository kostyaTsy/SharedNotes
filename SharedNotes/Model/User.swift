//
//  User.swift
//  SharedNotes
//
//  Created by Kostya Tsyvilko on 28.01.23.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable, Identifiable {
    var id: String
    
    var email: String
    var emailsToShareNotesWith: [String]
    var userIdWithSharedNotes: [String]
}
