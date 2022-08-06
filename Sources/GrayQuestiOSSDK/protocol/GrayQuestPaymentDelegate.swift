//
//  File.swift
//  
//
//  Created by admin on 03/08/22.
//

import Foundation


public protocol GQPaymentDelegate
{
    func gqSuccessResponse(data: [String: Any]?)
    
    func gqFailureResponse(data: [String: Any]?)
    
    func gqErrorResponse(error: Bool, message: String)
}
