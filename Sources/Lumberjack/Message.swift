//
//  Message.swift
//  Lumberjack
//
//  Created by Mitch Treece on 6/21/23.
//

import Foundation

public struct Message {
    
    public let level: Level
    public let category: String?
    public let message: String
    public let file: String
    public let function: String

}
