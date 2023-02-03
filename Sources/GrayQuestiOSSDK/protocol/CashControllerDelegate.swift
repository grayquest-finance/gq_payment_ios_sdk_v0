//
//  File.swift
//  
//
//  Created by Avinash Soni on 03/02/23.
//

import Foundation

protocol CashControllerDelegate
{
    func cashControllerSuccessResponse(data: [AnyHashable : Any]?)
    
    func cashControllerFailureResponse(data: [AnyHashable : Any]?)
}
