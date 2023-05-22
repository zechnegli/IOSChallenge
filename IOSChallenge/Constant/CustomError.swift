//
//  CustomError.swift
//  IOSChallenge
//
//  Created by Zecheng Li on 5/16/23.
//

import Foundation

enum CustomError: LocalizedError,Equatable {
    case urlParseError(String)
    case networkError
    case decodingError
    case serverError(statusCode: Int)
    case unknownError
    case noData
    
    var errorDescription: String? {
        switch self {
        case .urlParseError(let errorMessage):
            return "URL parse error: \(errorMessage)"
        case .networkError:
            return "Network error occurred."
        case .decodingError:
            return "Decoding error occurred."
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)"
        case .unknownError:
            return "Unknown error occurred."
        case .noData:
            return "No data available."
        }
    }
}

