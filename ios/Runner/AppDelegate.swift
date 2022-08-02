import UIKit
import Flutter
import Pay360

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {

  var eventSink: FlutterEventSink?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
          
        let controller:FlutterViewController = window.rootViewController as! FlutterViewController
        let eventChannel = FlutterEventChannel(
            name: "uk.co.wanyoo.wy.event.msg",
            binaryMessenger: controller.binaryMessenger
        )
        eventChannel.setStreamHandler(self)
                  
        let methodChannel = FlutterMethodChannel.init(
            name: "uk.co.wanyoo.wy.method",
            binaryMessenger: controller.binaryMessenger
        )
          
        methodChannel.setMethodCallHandler {[weak self](flutterMethodCall, flutterResult) in
            let param = flutterMethodCall.arguments as! Dictionary<String, String>
            if flutterMethodCall.method == "getAlipay" {
                AlipaySDK.defaultService()?.payOrder(param["info"]!, dynamicLaunch: true, fromScheme: "sideQuestAlipay", callback: { (resultDic) in
                    self?.eventSink?(resultDic?["resultStatus"])
                })
                flutterResult("")
            } else if flutterMethodCall.method == "verifyCard" {
                let cardNumber = param["cardNumber"]!
                print("cardNumber::::"+cardNumber)
                let cardFine = PPOLuhn.validate(cardNumber)
                print(cardFine)
                flutterResult(cardFine)
            } else if flutterMethodCall.method == "getCardPay" {
                let token = param["token"]!
                let cardNumber = param["cardNumber"]!
                let cardHolder = param["cardHolder"]!
                let exDate = param["exDate"]!
                let cvCode = param["cvCode"]!
                let orderId = param["orderId"]!
                let amount = param["amount"]!
                let recurring = param["recurring"]!
                
                print(token)
                
                let transaction = PPOTransaction()
                transaction.currency = "GBP"
                transaction.amount = NSDecimalNumber(string: amount)
                transaction.transactionDescription = "SideQuest Transaction"
                transaction.merchantRef = orderId
                transaction.isRecurring = recurring
                transaction.isDeferred = "false"
                
                let card = PPOCard()
                card.pan = cardNumber
                card.cvv = cvCode
                card.expiry = exDate
                card.cardHolderName = cardHolder
                
                let billingAddress = PPOBillingAddress()
                billingAddress.line1 = ""
                billingAddress.line2 = ""
                billingAddress.line3 = ""
                billingAddress.line4 = ""
                billingAddress.city = ""
                billingAddress.region = ""
                billingAddress.postcode = ""
                billingAddress.countryCode = "GBR"
                
                let customer = PPOCustomer()
                customer.email = ""
                customer.dateOfBirth = ""
                customer.telephone = ""
                
                let credentials = PPOCredentials()
                credentials.clientToken = token
                credentials.installationId = "8001699"
                credentials.environment = PPOEnvironmentProduction
                
                let customFieldSDKVersion = PPOCustomField()
                customFieldSDKVersion.name = "sdkVersion"
                customFieldSDKVersion.value = "1.0.2"
                
                let customFieldMerchantAppName = PPOCustomField()
                customFieldMerchantAppName.name = "merchantAppName"
                customFieldMerchantAppName.value = "SideQuest"
                
                let customFieldMerchantAppVersion = PPOCustomField()
                customFieldMerchantAppVersion.name = "merchantAppVersion"
                customFieldMerchantAppVersion.value = "1.0.0"
                
                let customFieldsSet = NSMutableSet()
                customFieldsSet.addObjects(from: [customFieldSDKVersion, customFieldMerchantAppName, customFieldMerchantAppVersion])
                
                let payment = PPOPayment.init(self!)
                payment.credentials = credentials
                payment.transaction = transaction
                payment.card = card
                payment.address = billingAddress
                payment.customer = customer
                payment.customFields = customFieldsSet as! Set<PPOCustomField>
                
                var result = [String: String]()
                
                payment.processGuestPayment { (data:PPOPaymentResponse) in
                    print("\(data.processing.status) \(data.transaction.transactionId)")
                    if("SUCCESS" == data.processing.status) {
                        result["code"] = "1"
                        result["data"] = data.transaction.transactionId
                    }else{
                        result["code"] = "0"
                        result["data"] = data.processing.result
                    }
                    self?.eventSink?(result)
                } failure: { (error) in
                    print(error.localizedDescription)
                    result["code"] = "0"
                    result["data"] = error.localizedDescription
                    self?.eventSink?(result)
                }

                
            }
        }
      
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        }
          
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if(url.host == "safepay") {
            AlipaySDK.defaultService()?.processOrder(withPaymentResult: url, standbyCallback:{ (resultDic) in
                self.eventSink?(resultDic?["resultStatus"])
            })
        }
        return true
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
            self.eventSink = events
            return nil
    }
        
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
            self.eventSink = nil
            return nil
    }
}
