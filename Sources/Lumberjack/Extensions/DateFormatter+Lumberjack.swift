//
//  DateFormatter+Lumberjack.swift
//  Lumberjack
//
//  Created by Mitch Treece on 6/21/23.
//

import Foundation

public extension DateFormatter {
    
    convenience init(dateFormat: String) {
        
        self.init()
        self.dateFormat = dateFormat
        
    }
    
    @discardableResult
    func withDateFormat(_ format: String) -> Self {
        
        self.dateFormat = format
        return self
        
    }
    
}
