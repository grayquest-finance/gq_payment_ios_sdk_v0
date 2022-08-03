//
//  File.swift
//  
//
//  Created by admin on 02/08/22.
//

import Foundation

public struct CheckoutDetails {
    var order_id: String?
    var razorpay_key: String?
    var recurring: Bool?
    var notes: [String:Any]?
    var customer_id: String?
    var callback_url: String?
}
