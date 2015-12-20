//
//  ValidatorStrLenTests.swift
//  validate
//
//  Created by Danilo Topalovic on 19.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import XCTest
@testable import validate

class ValidatorStrLenTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValidatorCanHandleOdds() {

        let validator = ValidatorStrLen() {
            $0.maxLength = 10
            $0.minLength = 2
        }
        
        let testValue: String? = nil
        var result: Bool       = true
        
        do {
            
            // handle nil
            result = try validator.validate(testValue, context: nil)
            XCTAssertFalse(result)
            
            // handle int
            result = try validator.validate(123456, context: nil)
            XCTAssertFalse(result)
            
        } catch _ {
            
            XCTAssert(false)
        }
    }
    
    func testValidatorValidatesStrLen() {
        
        let validator = ValidatorStrLen() {
            $0.maxLength = 10
            $0.minLength = 2
        }
        
        var result: Bool       = true
        
        do {
            
            // handle too short
            result = try validator.validate("A", context: nil)
            XCTAssertFalse(result)
            
            // handle too long
            result = try validator.validate("aaaaaaaaaaaaaaaaaaa", context: nil)
            XCTAssertFalse(result)
            
            // handle correct
            result = try validator.validate("aaaaa", context: nil)
            XCTAssertTrue(result)
            
        } catch _ {
            
            XCTAssert(false)
        }
    }

}
