//
//  Date+Extesion.swift
//  PDF GENERATER
//
//  Created by Vinay Patel on 12/12/24.
//

import SwiftUI

extension DateFormatter {
    // Utility to get the formatted timestamp for the filename
    func formattedCurrentTimestamp() -> String {
        self.dateFormat = "MMddyyyy_HHmmss"
        return self.string(from: Date())
    }
}
