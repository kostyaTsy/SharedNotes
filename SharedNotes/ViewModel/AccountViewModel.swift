//
//  AccountViewModel.swift
//  SharedNotes
//
//  Created by Kostya Tsyvilko on 28.01.23.
//

import Foundation

class AccountViewModel: ObservableObject {
    @Published var errorMessage: String = ""
    private var accountFireStoreService = FireStoreService<User>(collectionPath: "Users")
    
    @MainActor
    func getUser(for email: String) async -> User? {
        if (email.isEmpty) {
            errorMessage = "Email is empty"
            return nil
        }
        let user = await accountFireStoreService.readFilteredData(value: email, filteredField: "email").first
        
        if (user == nil) {
            errorMessage = "No user with email \(email)"
            return nil
        }
        
        return user
    }
    
    
    
    func updateUser(user: User) {
        accountFireStoreService.addData(data: user)
    }
}
