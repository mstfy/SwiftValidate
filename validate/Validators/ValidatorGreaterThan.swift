//
//  ValidatorGreaterThan.swift
//  validate
//
//  Created by Danilo Topalovic on 20.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import Foundation

public class ValidatorGreaterThan<TYPE: SignedNumberType>: ValidatorProtocol {
    
    /// nil is allowed
    public var allowNil: Bool = true
    
    /// the value to compare against
    public var min: TYPE = 0
    
    /// number inclusive?
    public var inclusive: Bool = true
    
    /// error message for invalid type (not a number)
    public var errorMessageInvalidType: String = NSLocalizedString("the given type was invalid", comment: "ValidatorGreaterThan - invalid type")
    
    /// error message if value is smaller than expected
    public var errorMessageNotGreaterThan: String = NSLocalizedString("the given value was not greater than %@", comment: "ValidatorGreaterThan - value too small")
    
    /// the errors
    private var _err: [String] = []
    
    /// the errors (if any)
    public var errors: [String] {
        return self._err
    }
    
    //MARK: comparision functions
    
    private let compareExclusive = { (alpha: TYPE, bravo: TYPE ) -> Bool in return alpha > bravo }
    private let compareInclusive = { (alpha: TYPE, bravo: TYPE ) -> Bool in return alpha >= bravo }
    
    //MARK: methods
    
    /**
    Easy init
    
    - returns: the instance
    */
    required public init(@noescape _ initializer: ValidatorGreaterThan -> () = { _ in }) {
        
        initializer(self)
    }
    
    /**
     Validates if the given value is greater than a predefined one
     
     - parameter value:   the value to compare
     - parameter context: the context (unused)
     
     - throws: validation errors
     
     - returns: true if ok
     */
    public func validate<T: Any>(value: T?, context: [String: Any?]?) throws -> Bool {
        
        if self.allowNil && nil == value {
            return true
        }
        
        if let strVal = value as? String {
            
            return try self.compareAsString(strVal)
        }
        
        if let myVal = value as? TYPE {
            
            return self.compareAsNumber(myVal)
        }
        
        self._err.append(self.errorMessageInvalidType)
        return false
    }
    
    //MARK: - private functions -
    
    private func compareAsString(value: String) throws -> Bool {
        
        if let numVal = Double(value) {
            
            guard let min = NumberConverter<TYPE>.toDouble(self.min) else {
                return false
            }
            
            let validator = ValidatorGreaterThan<Double>() {
                $0.min = min
                $0.inclusive = self.inclusive
            }
            
            let result = try validator.validate(numVal, context: nil)
            if !result {
                self._err.append(String(format: self.errorMessageNotGreaterThan, String(self.min)))
            }
            
            return result
        }
        
        self._err.append(self.errorMessageInvalidType)
        return false
    }
    
    /**
     Compares the number as is
     
     - parameter value: the number
     
     - returns: true if ok
     */
    private func compareAsNumber(value: TYPE) -> Bool {
        
        let result = (self.inclusive) ? self.compareInclusive(value, self.min) : self.compareExclusive(value, self.min)
        if !result {
            
            self._err.append(String(format: self.errorMessageNotGreaterThan, String(self.min)))
        }
        
        return result
    }
}
