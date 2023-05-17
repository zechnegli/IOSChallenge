//
//  ImageService.swift
//  IOSChallenge
//
//  Created by Zecheng Li on 5/17/23.
//

import UIKit
import Kingfisher

protocol ImageServiceProtocol {
    func downdloadImageWithKingFisher(url: String, completion: @escaping (UIImage) -> Void) -> DownloadTask?
}

struct ImageService: ImageServiceProtocol {
    func downdloadImageWithKingFisher(url: String, completion: @escaping (UIImage) -> Void) -> DownloadTask? {
        guard let url = URL(string: url) else {
            return nil
        }
        let options: KingfisherOptionsInfo = [] // Add any
        return KingfisherManager.shared.retrieveImage(with: url, options: options, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    // Image retrieved successfully (from cache or download)
                    completion(value.image)
                    
                case .failure(let error):
                    // Error occurred during the retrieval
                    print("Retrieval error: \(error)")
                }
            }
        
    }
}
