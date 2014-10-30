//
//  iSpyTests.swift
//  iSpyTests
//
//  Created by brett davis on 9/20/14.
//  Copyright (c) 2014 brett davis. All rights reserved.
//

import UIKit
import XCTest

/*extension Double {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f", self)
    }
}
*/
class iSpyTests: XCTestCase {
    
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
  /*  func formatTest(){
        let x = 0.123456789
        let y = x.format(".04")
        XCTAssertEqual(y,"0.123", "should equal 0.123")
        
    }
    
    func formatTestShouldFail(){
        let x = 0.123456789
        let y = x.format(".01")
        XCTAssertFalse(y == "0.123", "should not be equal")
    }
    
    func formatTestZero(){
        let x = 0.0
        let y = x.format(".05")
        XCTAssertEqual(y, "0.0", "should not be equal")
    }

*/
    func testFillSample(){
        let x = ViewController()
        
        for(var i = 0; i < 20; i++){
            let node = Node(ax: i.description, ay: i.description, az: i.description, gx: i.description, gy: i.description, gz: i.description)
            x.sample.append(node)
        }
        XCTAssertEqual(x.sample.count, 20, "should have 20 elements")
    }
    
    func testEmptySample(){
        let x = ViewController()
    
    for(var i = 0; i < 20; i++){
        let node = Node(ax: i.description, ay: i.description, az: i.description, gx: i.description, gy: i.description, gz: i.description)
        x.sample.append(node)
    }
        x.sendSample()
        XCTAssertEqual(x.sample.count, 0, "should have 0 elements")
    }

    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

    
}
