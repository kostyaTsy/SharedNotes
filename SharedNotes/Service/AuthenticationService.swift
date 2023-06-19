//
//  AuthenticationService.swift
//  SharedNotes
//
//  Created by Kostya Tsyvilko on 28.01.23.
//

import Foundation
import FirebaseAuth

class AuthenticationService {
    private let auth = Auth.auth()
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    var currentUserId: String? {
        return auth.currentUser?.uid
    }
    
    func signIn(email: String, password: String) async -> Error? {
        do {
            _ = try await auth.signIn(withEmail: email, password: password)
        } catch {
            return error
        }
        
        return nil
    }
    
    func signUp(email: String, password: String) async -> Error? {
        do {
            _ = try await auth.createUser(withEmail: email, password: password)
        } catch {
            return error
        }
        
        return nil
    }
    
    func signOut() {
        try? auth.signOut()
    }
    
    
}
