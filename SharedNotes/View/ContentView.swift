//
//  ContentView.swift
//  SharedNotes
//
//  Created by Kostya Tsyvilko on 28.01.23.
//

import SwiftUI

@MainActor
struct ContentView: View {
    @State var isLoading: Bool = false
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var appViewModel: AppViewModel

    var body: some View {
        HStack {
            if (authViewModel.isLoggedIn) {
                TabBarView()
            } else if isLoading {
                ProgressView()
            } else {
                NavigationView {
                    LoginView()
                }
               
            }
        }.onAppear {
            let isSignedIn = authViewModel.isSignedIn
            if (isSignedIn) {
                isLoading = true
                Task {
                    appViewModel.currentUser = await authViewModel.loadUser()
                    
                    isLoading = false
                    authViewModel.isLoggedIn = isSignedIn
                }
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
