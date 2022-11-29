//
//  File.swift
//  
//
//  Created by admin on 02/08/22.
//

import Foundation


public struct StaticConfig {
    static var devBaseUrl = "https://erp-api.graydev.tech/"
    static var prodBaseUrl = "https://erp-api.grayquest.com/"
//    static var baseUrl = devBaseUrl
    static var baseUrl = prodBaseUrl
    static var gqAPIKey = ""
    static var aBase = ""
    static var gqAPIKeyCopy = "9db4fc333d8bcf7fee98804105d9fc0c85199d77"
    static var aBaseCopy = "MzU0NTk4ZmQtNTc1YS00YzFmLWE2ZTMtZTA4ZmM1ZWEwNmQzOjJlYjM0OTczMjU5NGZlNzc3YmUwNzlmYjNjN2U1NTcxOTRmNTVhMTQ="
    static var createCustomerUrl = baseUrl + "v1/customer/create-customer"
//    static var checkElegibility = "https://erp-sdk-old.graydev.tech/instant-eligibility/"
    static var checkElegibility = "https://erp-sdk-old.grayquest.com/instant-eligibility/"
}
