//
//  AccountView.swift
//  SharedNotes
//
//  Created by Kostya Tsyvilko on 28.01.23.
//

import SwiftUI

struct AccountView: View {
    @StateObject var accountViewModel = AccountViewModel()
    
    @State var emailToAdd: String = ""
    private var cornerRadius = 10.0
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Account")
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.largeTitle)
                .padding(.vertical)
                
            HStack {
                Text(appViewModel.currentUser.email)
                
                Spacer()
                
                Button {
                    authViewModel.singOut()
                } label: {
                    Text("Sign Out")
                        
                }
            }.padding(.bottom, 40)
            
            HStack {
                Text("Add user to share notes with")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Button {
                    if (appViewModel.currentUser.email == emailToAdd) {
                        accountViewModel.errorMessage = "Can't add email that specified for current user"
                        return
                    } else if (appViewModel.currentUser.emailsToShareNotesWith.contains(emailToAdd)) {
                        accountViewModel.errorMessage = "Email already specified"
                        return
                    }
                    
                    
                    Task {
                        await addEmailToShareNotesWith()
                    }
                } label: {
                    Image(systemName: "plus")
                }

            }
            
            if (!accountViewModel.errorMessage.isEmpty) {
                Text(accountViewModel.errorMessage)
                    .padding()
                    .foregroundColor(.red)
            }
            
            TextField("Email", text: $emailToAdd)
                .padding(7)
                .background(RoundedRectangle(cornerRadius: cornerRadius).fill(Color(.secondarySystemBackground)))
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(lineWidth: 1)
                )
                .padding(.horizontal)
                .disableAutocorrection(true)
                .disableAutoCapitalization()
                .padding()
            
            
            Text(appViewModel.currentUser.emailsToShareNotesWith.isEmpty ? "" : "Added users")
                .frame(maxWidth: .infinity, alignment: .leading)
            List {
                ForEach(appViewModel.currentUser.emailsToShareNotesWith, id: \.self) { item in
                    Text(item)
                }
                .onDelete { index in
                    let emails = index.map { appViewModel.currentUser.emailsToShareNotesWith[$0] }
                    for email in emails {
                        Task {
                            await onDeleteEmailToShare(email: email)
                        }
                    }
                }
                
            }
            .listStyle(.plain)
            
            
            
        }.padding()

    }
    
    private func onDeleteEmailToShare(email: String) async {
        let user = await accountViewModel.getUser(for: email)
        guard var user = user else {
            accountViewModel.errorMessage = "Something went wrong. Please try again!"
            return
        }
        
        user.userIdWithSharedNotes.removeAll { value in
            value == appViewModel.currentUser.id
        }
        accountViewModel.updateUser(user: user)
        
        appViewModel.currentUser.emailsToShareNotesWith.removeAll { value in
            value == email
        }
        accountViewModel.updateUser(user: appViewModel.currentUser)
    }
    
    private func addEmailToShareNotesWith() async {
        let user = await accountViewModel.getUser(for: emailToAdd)
        guard var user = user else {
            accountViewModel.errorMessage = "Something went wrong. Please try again!"
            return
        }
        
        user.userIdWithSharedNotes.append(appViewModel.currentUser.id)
        accountViewModel.updateUser(user: user)
        
        appViewModel.currentUser.emailsToShareNotesWith.append(emailToAdd)
        accountViewModel.updateUser(user: appViewModel.currentUser)
        
        emailToAdd = ""
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(AuthViewModel())
            .environmentObject(AppViewModel())
    }
}
