//
//  CheckoutViewController.swift
//  Handles ADOptions (Razorpay part of the application)
//
//  Created by admin on 02/08/22.
//

import UIKit
import Razorpay

public class CheckoutViewController: UIViewController, RazorpayPaymentCompletionProtocolWithData {
    
    var razorpay : RazorpayCheckout? = nil
    var checkout_details: CheckoutDetails?
    
    var delegate: CheckoutControllerDelegate?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if (checkout_details?.razorpay_key == nil) {
            return
        }
        razorpay = RazorpayCheckout.initWithKey(checkout_details?.razorpay_key ?? "", andDelegateWithData: self)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
        self.showPaymentForm()
    }
    
    public func showPaymentForm() {
        let options: [String:Any] = [
            "order_id": checkout_details?.order_id! ?? "",
            "recurring": checkout_details?.recurring ?? true,
            "notes": checkout_details?.notes ?? [],
            "customer_id": checkout_details?.customer_id ?? ""
        ]
        
        DispatchQueue.main.async {
            self.razorpay!.open(options, displayController: self)
        }
    }
    
    public func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        print("Payment Error!")
        self.delegate?.checkoutControllerFailureResponse(data: response)
        self.dismiss(animated: true, completion: nil)
    }

    public func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        print("Payment Success")
        self.delegate?.checkoutControllerSuccessResponse(data: response)
        self.dismiss(animated: true, completion: nil)
    }
}
