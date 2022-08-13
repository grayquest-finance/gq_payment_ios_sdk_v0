//
//  File.swift
//  
//
//  Created by admin on 02/08/22.
//

import Foundation

public struct CheckoutDetails {
    
    public init(order_id: String, razorpay_key: String, recurring: Bool, notes: [String : Any], customer_id: String, callback_url: String) {
        self.order_id = order_id
        self.razorpay_key = razorpay_key
        self.recurring = recurring
        self.notes = notes
        self.customer_id = customer_id
        self.callback_url = callback_url
    }
    
    public var order_id: String?
    public var razorpay_key: String?
    public var recurring: Bool?
    public var notes: [String:Any]?
    public var customer_id: String?
    public var callback_url: String?
}
