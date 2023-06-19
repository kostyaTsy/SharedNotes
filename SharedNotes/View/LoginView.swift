//
//  LoginView.swift
//  SharedNotes
//
//  Created by Kostya Tsyvilko on 28.01.23.
//

import SwiftUI

struct LoginView: View {
    @State var email: String = ""
    @State var password: String = ""
    var isSignInButtonEnabled: Bool {
        return !email.isEmpty && !password.isEmpty
    }
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    
    private let cornerRadius = 10.0
    private let fieldMaxWidth = 350.0
    
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .padding()
                .background(RoundedRectangle(cornerRadius: cornerRadius).fill(Color(.secondarySystemBackground)))
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(lineWidth: 1)
                )
                .padding(.horizontal)
                .disableAutocorrection(true)
                .disableAutoCapitalization()
                .frame(maxWidth: fieldMaxWidth)
            SecureField("Password", text: $password)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.secondarySystemBackground)))
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(lineWidth: 1)
                )
                .padding(.horizontal)
                .disableAutocorrection(true)
                .disableAutoCapitalization()
                .frame(maxWidth: fieldMaxWidth)
            
            Spacer()
                .frame(height: 50)
            
            if (authViewModel.errorMessage != nil) {
                Text(authViewModel.errorMessage!)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    .foregroundColor(.red)
                    .frame(maxWidth: fieldMaxWidth)
                    .multilineTextAlignment(.center)
            }
            
            
            
            Button {
                guard !email.isEmpty, !password.isEmpty else { return }
                Task {
                    let user = await authViewModel.signIn(email: email, password: password)
                    if (authViewModel.isLoggedIn) {
                        appViewModel.currentUser = user!
                    }
                }
                
            } label: {
                Text("Sign In")
                    .padding()
                    .frame(maxWidth: fieldMaxWidth - 25)
                    .foregroundColor(.white)
                    .background(RoundedRectangle(cornerRadius: cornerRadius).fill(isSignInButtonEnabled ? Color(.blue) : Color(.gray)))
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(lineWidth: 1)
                    )
                
            }
            .disabled(!isSignInButtonEnabled)
            
            NavigationLink("Create an account", destination: SignUpView())
                .foregroundColor(Color.blue).padding(.top, 10)
        }
        .navigationTitle("Sing In")
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthViewModel())
    }
}
