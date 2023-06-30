//
//  DateFormatter+Lumberjack.swift
//  Lumberjack
//
//  Created by Mitch Treece on 6/21/23.
//

import Foundation

public extension DateFormatter {
    
    /// Initializes a date formatter with a specified format.
    ///
    /// - parameter dateFormat: The date format.
    convenience init(dateFormat: String) {
        
        self.init()
        self.dateFormat = dateFormat
        
    }
    
    /// Sets the date formatter's format.
    ///
    /// - format: The date format.
    /// - returns: This date formatter.
    @discardableResult
    func withDateFormat(_ format: String) -> Self {
        
        self.dateFormat = format
        return self
        
    }
    
}
