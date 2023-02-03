//
//  File.swift
//  
//
//  Created by Avinash Soni on 03/02/23.
//

import Foundation

public struct CashDetails {
    
    public init(order_code: String, payment_session_id: String) {
        self.order_code = order_code
        self.payment_session_id = payment_session_id
       
    }
    
    public var order_code: String?
    public var payment_session_id: String?
}
