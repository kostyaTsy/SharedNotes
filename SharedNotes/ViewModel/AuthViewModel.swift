//
//  AuthViewModel.swift
//  SharedNotes
//
//  Created by Kostya Tsyvilko on 28.01.23.
//

import Foundation
import SwiftUI

class AuthViewModel: ObservableObject {
    
    @Published var errorMessage: String?
    @Published var isLoggedIn: Bool = false
    
    private var authService = AuthenticationService()
    private var userFireStoreService = FireStoreService<User>(collectionPath: "Users")
    
    var isSignedIn: Bool {
        return authService.isSignedIn
    }
    
    var userId: String? {
        return authService.currentUserId
    }
    
    func loadUser() async -> User? {
        guard let id = authService.currentUserId else { return nil }
        return await userFireStoreService.readData(documentId: id)
    }
    
    @MainActor
    func signIn(email: String, password: String) async -> User? {
        let error = await authService.signIn(email: email, password: password)
        
        if (error != nil) {
            errorMessage = error?.localizedDescription
            return nil
        }
        let user = await loadUser()
        isLoggedIn = true
        
        return user
    }
    
    @MainActor
    func signUp(email: String, password: String) async -> User? {
        let error = await authService.signUp(email: email, password: password)
        
        if (error != nil) {
            errorMessage = error?.localizedDescription
            return nil
        }
        
        guard let id = authService.currentUserId else { return nil }
        
        isLoggedIn = true
        
        let user = User(id: id, email: email, emailsToShareNotesWith: [], userIdWithSharedNotes: [])
        userFireStoreService.addData(data: user)
        
        return user
    }
    
    func singOut() {
        authService.signOut()
        isLoggedIn = false
    }
    
}
