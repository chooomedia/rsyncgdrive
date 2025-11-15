//
//  DateExtensions.swift
//  MySyncApp
//
//  Created: Shared Utilities
//

import Foundation

extension Date {
    /// Formatiert das Datum für die Anzeige im UI
    public func formattedForDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    /// Formatiert das Datum als kurze Zeichenkette (z.B. "vor 5 Minuten")
    public func shortRelativeFormat() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}

