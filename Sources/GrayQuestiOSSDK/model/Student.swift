//
//  File.swift
//  
//
//  Created by admin on 02/08/22.
//

import Foundation

public struct Student {
    public init() { }
    
    public init(studentId: String?, customerMobile: String?, feeAmount: String?, payableAmount: String?, env: String?, feeEditable: String?, customerId: String?, customerCode: String?, userType: String?) {
        self.studentId = studentId
        self.customerMobile = customerMobile
        self.feeAmount = feeAmount
        self.payableAmount = payableAmount
        self.env = env
        self.feeEditable = feeEditable
        self.customerId = customerId
        self.customerCode = customerCode
        self.userType = userType
    }
    
    public var studentId: String?
    public var customerMobile: String?
    public var feeAmount: String?
    public var payableAmount: String?
    public var env: String?
    public var feeEditable: String?
    public var customerId: String?
    public var customerCode: String?
    public var themeColor: String?
    public var s = "asdk"
    public var userType: String?
}
