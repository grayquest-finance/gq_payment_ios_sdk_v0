//
//  File.swift
//  
//
//  Created by admin on 02/08/22.
//

import Foundation
import WebKit


public class Customer {
    
    public func makeCustomerRequest(mobile: String, completion: @escaping([String: Any]?, Error?) -> Void) {
        
        print("StaticConfig.createCustomerUrl", StaticConfig.createCustomerUrl)
        print("customer_mobile", "\(mobile)")
        let url = URL(string: StaticConfig.createCustomerUrl)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("\(StaticConfig.gqAPIKey)", forHTTPHeaderField: "GQ-API-Key")
        request.setValue("Basic \(StaticConfig.aBase)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "customer_mobile": "\(mobile)",
        ]
        request.httpBody = parameters.percentEncoded()

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {                                                               // check for fundamental networking error
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
            // do whatever you want with the `data`, e.g.:
            
            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let responseObject = (try JSONSerialization.jsonObject(with: data)) as? [String: Any]
                return completion(responseObject, nil)
            } catch {
                print(error) // parsing error
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("responseString = \(responseString)")
                } else {
                    print("unable to parse response as string")
                }
                
                return completion(nil, error)
            }
        }
        task.resume()
    }
}

extension Dictionary {
    func percentEncoded() -> Data? {
        map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed: CharacterSet = .urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}


