//
//  Symbol.swift
//  Lumberjack
//
//  Created by Mitch Treece on 6/21/23.
//

import Foundation

public typealias SymbolProvider = (Level)->String

public enum Symbol {
    
    case just(String)
    case provider(SymbolProvider)
    
    public static var `default`: Symbol {
        return .provider { $0.symbol }
    }
    
}
