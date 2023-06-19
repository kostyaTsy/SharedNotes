//
//  String+Extensions.swift
//  SharedNotes
//
//  Created by Kostya Tsyvilko on 29.01.23.
//

import Foundation

extension String {
    func getDate(format: String = "yyyy-MM-dd HH:mm:ssZ") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = format
        
        return  dateFormatter.date(from: self)!
    }
}
