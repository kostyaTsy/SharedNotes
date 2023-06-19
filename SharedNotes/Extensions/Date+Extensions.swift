//
//  Date+Extensions.swift
//  SharedNotes
//
//  Created by Kostya Tsyvilko on 28.01.23.
//

import Foundation

extension Date {
    func getShortDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        return dateFormatter.string(from: self).replacingOccurrences(of: "/", with: ".")
        
    }
}
