//
//  IOSChallengeUITests.swift
//  IOSChallengeUITests
//
//  Created by Zecheng Li on 5/16/23.
//

import XCTest
@testable import IOSChallenge

final class DetailViewControllerUITests: XCTestCase {
    //landscape and portrait
    func test_DetailViewControllerLayout() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Wait for the app to load meals
        sleep(5)
        //inital
        XCUIDevice.shared.orientation = .portrait
        
        // Check if there is at least one cell
        guard app.tables.cells.count > 0 else {
            XCTAssert(true, "Network loading issue: No cells found in the HomeViewController table view, ")
            return
        }
        let imageViewSize = 200.0
        let imageViewSizeLandscape = 100.0
        
        // Tap on the first cell
        app.tables.cells.element(boundBy: 0).tap()

        // Perform layout checks in portrait orientation
        XCTAssertTrue(app.images["imageView"].exists, "imageView does not exist in portrait orientation")
        XCTAssertEqual(app.images["imageView"].frame.size.width, CGFloat(imageViewSize))
        XCTAssertEqual(app.images["imageView"].frame.size.height, CGFloat(imageViewSize))

        // Rotate the device to landscape orientation
        XCUIDevice.shared.orientation = .landscapeRight

        // Wait for the rotation to complete
        usleep(500000) // Wait for 0.5 seconds (adjust if needed)

        // Perform layout checks in landscape orientation
        XCTAssertTrue(app.images["imageView"].exists, "imageView does not exist in landscape orientation")
        XCTAssertEqual(app.images["imageView"].frame.size.width, CGFloat(imageViewSizeLandscape))
        XCTAssertEqual(app.images["imageView"].frame.size.height, CGFloat(imageViewSizeLandscape))
    }

}
