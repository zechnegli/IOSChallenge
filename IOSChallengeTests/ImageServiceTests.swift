//
//  ImageServiceTests.swift
//  IOSChallengeTests
//
//  Created by Zecheng Li on 5/19/23.
//

import XCTest
@testable import IOSChallenge

final class ImageServiceTests: XCTestCase {
    private func makeSUT() -> ImageService {
        return ImageService()
    }
    
    func test_DownloadImageWithInvalidURL() {
        let invalidURL = ""
        let imageService = makeSUT()
        let downloadTask = imageService.downdloadImageWithKingFisher(url: invalidURL) { downloadedImage in
            XCTFail("Completion handler should not be called for an invalid URL")
        }
        
        XCTAssertNil(downloadTask)
    }
}
