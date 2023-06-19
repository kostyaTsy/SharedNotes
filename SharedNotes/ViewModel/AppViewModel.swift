//
//  AppViewModel.swift
//  SharedNotes
//
//  Created by Kostya Tsyvilko on 28.01.23.
//

import Foundation
import Reachability

class AppViewModel: ObservableObject {
    @Published var currentUser: User!
    @Published var userUpdated: Bool = false
    
    var reachability = try? Reachability()
    private var userFireStoreService = FireStoreService<User>(collectionPath: "Users")
    
    var isConnected: Bool {
        return reachability?.connection != Reachability.Connection.unavailable
    }
    
    func fetchUser(userId: String) {
        userFireStoreService.fetchFilteredLiveData(field: "id", id: userId) { snapshot, error in
            let documents = snapshot?.documents
            self.currentUser = documents?.compactMap{ documentSnapshot in
                return try? documentSnapshot.data(as: User.self)
            }.first
            self.userUpdated = true
        }
    }
}
