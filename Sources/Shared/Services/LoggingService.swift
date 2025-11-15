//
//  LoggingService.swift
//  MySyncApp
//
//  Created: Shared Services
//

import Foundation
import OSLog

/// Zentraler Logging-Service für die App
public class LoggingService {
    public static let shared = LoggingService()
    
    private let logger = Logger(subsystem: "com.mysyncapp", category: "Sync")
    
    private init() {}
    
    public func logInfo(_ message: String) {
        logger.info("\(message)")
    }
    
    public func logError(_ message: String, error: Error? = nil) {
        if let error = error {
            logger.error("\(message): \(error.localizedDescription)")
        } else {
            logger.error("\(message)")
        }
    }
    
    public func logDebug(_ message: String) {
        logger.debug("\(message)")
    }
}

