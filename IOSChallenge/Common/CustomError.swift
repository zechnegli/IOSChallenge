//
//  CustomError.swift
//  IOSChallenge
//
//  Created by Zecheng Li on 5/16/23.
//

import Foundation

enum CustomError: LocalizedError {
    case urlParseError(String)
    case networkError
    case decodingError
    case serverError(statusCode: Int)
    case unknownError
    case noData
}
