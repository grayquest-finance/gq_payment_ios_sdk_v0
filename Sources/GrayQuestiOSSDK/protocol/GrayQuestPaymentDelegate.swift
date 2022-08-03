//
//  File.swift
//  
//
//  Created by admin on 03/08/22.
//

import Foundation


public protocol GQPaymentDelegate
{
    func gqSuccessResponse(data: [AnyHashable : Any]?)
    
    func gqFailureResponse(data: [AnyHashable : Any]?)
}
