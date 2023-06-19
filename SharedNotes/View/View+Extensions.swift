//
//  View+Extensions.swift
//  SharedNotes
//
//  Created by Kostya Tsyvilko on 28.01.23.
//

import Foundation
import SwiftUI

extension View {
    func disableAutoCapitalization() -> some View {
        if #available(iOS 15.0, *) {
            return textInputAutocapitalization(.never)
        } else {
            return autocapitalization(.none)
        }
    }
    
    func hideToolbar() -> some View {
        if #available(iOS 16.0, *) {
            return toolbar(.hidden)
        } else {
            return navigationBarHidden(true)
        }
    }
}
