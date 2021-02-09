import Flutter
import Khalti
import UIKit

public class SwiftKhaltiKhaltiPlugin: NSObject, FlutterPlugin, KhaltiPayDelegate {
    
    public var viewController: UIViewController
    public var channel:FlutterMethodChannel
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "khalti_khalti", binaryMessenger: registrar.messenger())
        
        let viewController: UIViewController =
            (UIApplication.shared.delegate?.window??.rootViewController)!;
        let instance = SwiftKhaltiKhaltiPlugin(viewController: viewController, channel
            : channel)
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public init(viewController:UIViewController, channel:FlutterMethodChannel) {
        self.viewController = viewController
        self.channel = channel
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(call.method == "khaltiPayment"){
            startPayment(call: call)
            result(true)
            
        }
    }
    
    func startPayment(call: FlutterMethodCall){
        let message = call.arguments as? Dictionary<String,Any>
        let publicKey =  message!["publicKey"] as? String
        let khaltiUrlScheme:String = "KhaltiPayScheme"
        let paymentPreferences = message!["paymentPreferences"] as? [String]
        
        let _CONFIG:Config = Config(
            publicKey: toString(data: publicKey!),
            amount: toInt(json: message!["amount"]!),
            productId: toString(data: message!["productId"]!),
            productName: toString(data: message!["productName"]!),
            productUrl:toString(data: message!["productUrl"]!),
            additionalData: (message!["customData"] as! Dictionary<String, String>),
            ebankingPayment: paymentPreferences?.contains("ebanking") ?? true
            
        );
        
        Khalti.shared.appUrlScheme = khaltiUrlScheme
        
        Khalti.present(caller: viewController, with: _CONFIG, delegate: self)
    }
    
    
    public func onCheckOutSuccess(data: Dictionary<String, Any>) {
        channel.invokeMethod("khaltiSucess",arguments:  data)
    }
    
    public func onCheckOutError(action: String, message: String, data: Dictionary<String, Any>?) {
        var d = data!
        d.updateValue(message, forKey: "errorMessage")
        d.updateValue(action, forKey: "action")
        channel.invokeMethod("khaltiError",arguments: data)
    }
    
    func toString(data:Any) -> String{
        return data as? String ?? ""
    }
    
    func toInt(json:Any) -> Int{
        return json as! Int
    }
}
