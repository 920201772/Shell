//
//  ShellTests.swift
//  ShellTests
//
//  Created by 杨柳 on 2021/10/18.
//

import XCTest
import Shell

class ShellTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        try QRCode.create(filePath: "/Users/developer/Desktop/test.png", content: "test", size: 64)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
