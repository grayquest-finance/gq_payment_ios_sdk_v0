//
//  GrayQuestCheckoutVC.swift
//  
//
//  Created by admin on 02/08/22.
//

import UIKit
import WebKit

public class GrayQuestCheckoutVC: UIViewController, WKUIDelegate, WKScriptMessageHandler, WKNavigationDelegate, CheckoutControllerDelegate {
    
    var webView: WKWebView!
    
    var checkout_details: CheckoutDetails?
    public var delegate: GQPaymentDelegate?
    
    public var config: [String: Any]?
    public var prefill: [String: Any]?
    
    private var mobileNumber: String?
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        guard let urlAsString = navigationAction.request.url?.absoluteString.lowercased() else {
            return
        }
        if (!urlAsString.contains("cashfree.com")) {return}
        let newViewController = GrayQuestPaymentVC()
        newViewController.paymentURL = urlAsString
        self.present(newViewController, animated: true, completion: nil)
     }

    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
       if let data = text.data(using: .utf8) {
           do {
               let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
               return json
           } catch {
               print("Something went wrong")
               delegate?.gqErrorResponse(error: true, message: error.localizedDescription)
               self.dismiss(animated: true, completion: nil)
           }
       }
       return nil
   }

    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if (message.name == "sdkSuccess") {
            do {
                let data = message.body as! String
                let con = try JSONSerialization.jsonObject(with: data.data(using: .utf8)!, options: []) as! [String: Any]
                delegate?.gqSuccessResponse(data: con)
            } catch {
                print(error)
                delegate?.gqErrorResponse(error: true, message: error.localizedDescription)
                self.dismiss(animated: true, completion: nil)
            }
        } else if (message.name == "sdkError") {
            do {
                let data = message.body as! String
                let con = try JSONSerialization.jsonObject(with: data.data(using: .utf8)!, options: []) as! [String: Any]
                delegate?.gqFailureResponse(data: con)
            } catch {
                delegate?.gqErrorResponse(error: true, message: error.localizedDescription)
                self.dismiss(animated: true, completion: nil)
            }
        } else if (message.name == "sdkCancel") {
            self.dismiss(animated: true, completion: nil)
        } else if (message.name == "sendADOptions") {
            let ad_data = convertStringToDictionary(text: message.body as! String)
            let razorpay_key = ad_data!["key"]
            let order_id = ad_data!["order_id"]
            let callback_url = ad_data!["callback_url"]
            let recurring = ad_data!["recurring"]
            let notes = ad_data!["notes"]
            let customer_id = ad_data!["customer_id"]
            let recurring_flag: Bool?
            
            if (recurring as! String == "1") { recurring_flag = true }
            else { recurring_flag = false }
            
            checkout_details = CheckoutDetails(order_id: order_id as? String ?? "", razorpay_key: (razorpay_key as! String), recurring: recurring_flag ?? true, notes: (notes as? [String : Any] ?? ["nil": "nil"]), customer_id: (customer_id as! String), callback_url: (callback_url as! String))
            
            let newViewController = CheckoutViewController()
            newViewController.checkout_details = checkout_details
            newViewController.delegate = self
            self.present(newViewController, animated: true, completion: nil)
        }
        print("Received message from web -> \(message.body)")
    }
    
    public override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.configuration.userContentController.add(self, name: "Gqsdk")
        webView.configuration.userContentController.add(self, name: "sdkSuccess")
        webView.configuration.userContentController.add(self, name: "sdkError")
        webView.configuration.userContentController.add(self, name: "sdkCancel")
        webView.configuration.userContentController.add(self, name: "sendADOptions")
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    public override func viewDidAppear(_ animated: Bool) {
        guard (config != nil) else {
            print("Config is empty")
            return
        }
        
        guard let auth = config!["auth"] as? [String : String] else {
            print("Auth is empty")
            return
        }
        
        let base = "\(auth["client_id"] ?? ""):\(auth["client_secret_key"] ?? "")"
        StaticConfig.aBase = base.base64EncodedString
        StaticConfig.gqAPIKey = auth["gq_api_key"]!
        
        let response1 = validation1(config: config!, auth: auth)
        if (response1["error"] == "false") { customer() }
        else {
            print("Error Validation 1 -> \(response1["message"] ?? "ViewDidLoad Error")")
            delegate?.gqErrorResponse(error: true, message: response1["message"] ?? "ViewDidLoad Error")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func checkoutControllerSuccessResponse(data: [AnyHashable : Any]?) {
        var userInfo = data as NSDictionary? as? [String: String]
        userInfo?["callback_url"] = checkout_details?.callback_url
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userInfo ?? [], options: [])
            let jsonString = String(data: jsonData, encoding: .utf8)
            webView.evaluateJavaScript("javascript:sendADPaymentResponse(\(jsonString!));")
        } catch {
            print("Error in checkoutControllerSuccessResponse => \(error)")
            delegate?.gqErrorResponse(error: true, message: error.localizedDescription)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func checkoutControllerFailureResponse(data: [AnyHashable : Any]?) {
        var userInfo = data as NSDictionary? as? [String: String]
        userInfo?["callback_url"] = checkout_details?.callback_url
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userInfo ?? [], options: [])
            let jsonString = String(data: jsonData, encoding: .utf8)
            webView.evaluateJavaScript("javascript:sendADPaymentResponse(\(jsonString!));")
        } catch {
            print("Error in checkoutControllerFailureResponse => \(error)")
            delegate?.gqErrorResponse(error: true, message: error.localizedDescription)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    public func validation1(config: [String: Any], auth: [String: String]) -> [String: String] {
        var errorMessage = ""
        
        print("config \(config)")
        print("auth \(auth)")
        
        if (auth["client_id"] == nil || !(auth["client_id"] ?? "").isEmpty) {
            errorMessage += "Please enter a valid Client Id\n"
        }
        
        if (auth["client_secret_key"] == nil || !(auth["client_id"] ?? "").isEmpty) {
            errorMessage += "Please enter a valid Client secret key\n"
        }
        
        if (auth["gq_api_key"] == nil || !(auth["client_id"] ?? "").isEmpty) {
            errorMessage += "Please enter a valid GQ Api Key\n"
        }
        
        if (config["student_id"] == nil || !(auth["client_id"] ?? "").isEmpty) {
            errorMessage += "Student ID cannot be null\n"
        }
        
        if (config["customer_number"] == nil || !(auth["client_id"] ?? "").isEmpty) {
            errorMessage += "Customer number cannot be null\n"
        }
        
        if (errorMessage != "") {
            return ["error": "true", "message": errorMessage]
        }
        
        mobileNumber = config["customer_number"] as? String
        return ["error": "false", "message": "Validation Successful"]
    }
    
    public func customer() {
        guard mobileNumber != nil else {
            print("Mobile Number cannot be empty!")
            return
        }
        Customer().makeCustomerRequest(mobile: "\(mobileNumber!)") { responseObject, error in
            guard let responseObject = responseObject, error == nil else {
                print(error ?? "Unknown error")
                self.delegate?.gqErrorResponse(error: true, message: "You are unauthorized to access the SDK, please check your GQKey, and GQSecret")
                return
            }
            
            DispatchQueue.main.async {
                let message = responseObject["message"] as! String
                
                if (message == "Customer Exists") { self.config?["userType"] = "existing" }
                else { self.config?["userType"] = "new" }
                
                let data = responseObject["data"] as! [String:AnyObject]
                self.config?["customerCode"] = (data["customer_code"] as! String)
                self.config?["customerMobile"] = (data["customer_mobile"] as! String)
                self.config?["customerId"] = data["customer_id"] as! Int
                
                self.elegibity()
            }
        }
    }
    
    func getOptionalData() -> String {
        if prefill == nil {
            return ""
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: prefill!, options: [])
            let convertedString = String(data: jsonData, encoding: String.Encoding.utf8) // the data will be converted to the string

            return convertedString ?? ""
        } catch {
            print("Something went wrong while getting optional data \(error)")
            return ""
        }
    }
    
    public func elegibity() {
        let optionalData = getOptionalData().addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        let urlStr = "\(StaticConfig.checkElegibility)?gapik=\(StaticConfig.gqAPIKey)&abase=\(StaticConfig.aBase)&sid=\(self.config?["student_id"] as! String)&m=\(self.mobileNumber!)&famt=\(self.config?["fee_amount"] ?? "0")&pamt=\(self.config?["payable_amount"] ?? "0" )&env=\(self.config?["env"] as! String )&fedit=\(self.config?["fee_editable"] as! String)&cid=\(self.config?["customerId"] as! Int)&ccode=\(self.config?["customerCode"] as! String)&pc=&s=asdk&user=\(self.config?["userType"] as! String)&optional=\(optionalData!)"
        print(urlStr)
        let url = URL(string: urlStr)
        let request = URLRequest(url: url!)
        webView.load(request)
    }
}

extension WKWebView {
    func evaluate(script: String, completion: @escaping (Any?, Error?) -> Void) {
        var finished = false

        evaluateJavaScript(script, completionHandler: { (result, error) in
            if error == nil {
                if result != nil {
                    completion(result, nil)
                }
            } else {
                completion(nil, error)
            }
            finished = true
        })

        while !finished {
            RunLoop.current.run(mode: RunLoop.Mode(rawValue: "NSDefaultRunLoopMode"), before: NSDate.distantFuture)
        }
    }
}

public extension String{
    ///base64EncodedString
    var base64EncodedString:String{
        if let data = data(using: .utf8){
            return data.base64EncodedString()
        }
        return ""
    }
}
