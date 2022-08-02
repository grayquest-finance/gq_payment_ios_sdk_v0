//
//  File.swift
//  
//
//  Created by admin on 02/08/22.
//

import Foundation

protocol CheckoutControllerDelegate
{
    func checkoutControllerSuccessResponse(data: [AnyHashable : Any]?)
    
    func checkoutControllerFailureResponse(data: [AnyHashable : Any]?)
}
