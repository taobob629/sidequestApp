import UIKit
import Flutter
import AlipayPlusClient


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {

  var eventSink: FlutterEventSink?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)
      
//        StripeAPI.defaultPublishableKey = "pk_test_51L1kPsBizrDMUWwg9A6jFjNOhdIDUtvUoMStTIv0RpfJx00EYC5fdICvH0UVyQM7mLBdt97T1GqU0P4mZbAVBQpj00mWsHoGvg"
          
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
                let configuration = IAPConfiguration()
                configuration.envType = "PROD"
                configuration.acquirerId = "5Y39882YDWFU05385"
                configuration.merchantId = "AEF11846594"
                configuration.language = "zh_CN"
                configuration.fromScheme = "sideQuestAlipay"
                    
                AlipayPlusClient.shared().configuration = configuration
                    
                AlipayPlusClient.shared().showPaymentSheet(param["info"]!) { sheetEvent in
                    if sheetEvent.name == IAPPaymentSheetEventDidShow {
                        // your own logic
                        print("zengchao = IAPPaymentSheetEventDidShow")
                    } else if sheetEvent.name == IAPPaymentSheetEventThrowException {
                        // your own logic
                        print("zengchao = IAPPaymentSheetEventThrowException")
                    } else if sheetEvent.name == IAPPaymentSheetEventUserDidCancel {
                        // your own logic
                        print("zengchao = IAPPaymentSheetEventUserDidCancel")
                    } else if sheetEvent.name == IAPPaymentSheetEventDidSelectWalletAndPay {
                        // your own logic
                        print("zengchao = IAPPaymentSheetEventDidSelectWalletAndPay")
                        flutterResult("gotopay")
                    } else if sheetEvent.name == IAPPaymentSheetEventPaymentException {
                        // your own logic after payment interruption
                        // Currently, this type of event may occur only after you import Alipay SDK to optimize the Alipay payment experience.
                        print("zengchao = IAPPaymentSheetEventPaymentException")
                    } else if sheetEvent.name == IAPPaymentSheetEventPaymentCanceled {
                        // your own logic after payment cancelation
                        // Currently, this type of event may occur only after you import Alipay SDK to optimize the Alipay payment experience.
                        print("zengchao = IAPPaymentSheetEventPaymentCanceled")
                    } else if sheetEvent.name == IAPPaymentSheetEventPaymentFailed {
                        // your own logic after payment failure
                        // Currently, this type of event may occur only after you import Alipay SDK to optimize the Alipay payment experience.
                        print("zengchao = IAPPaymentSheetEventPaymentFailed")
                    } else if sheetEvent.name == IAPPaymentSheetEventPaymentSuccess {
                        // your own logic after payment success
                        // Currently, this type of event may occur only after you import Alipay SDK to optimize the Alipay payment experience.
                        print("zengchao = IAPPaymentSheetEventPaymentSuccess")
                    } else if sheetEvent.name == IAPPaymentSheetEventPaymentProcessing {
                        // your own logic after payment finishes but status is ongoing
                        // Currently, this type of event may occur only after you import Alipay SDK to optimize the Alipay payment experience.
                        print("zengchao = IAPPaymentSheetEventPaymentProcessing")
                    }
                    self?.eventSink?("0")
                }
            } else if flutterMethodCall.method == "verifyCard" {
//                let cardNumber = param["cardNumber"]!
//                print("cardNumber::::"+cardNumber)
//                let cardFine = PPOLuhn.validate(cardNumber)
//                print(cardFine)
                flutterResult("")
            } else if flutterMethodCall.method == "getCardPay" {
//                let token = param["token"]!
//                let cardNumber = param["cardNumber"]!
//                let cardHolder = param["cardHolder"]!
//                let exDate = param["exDate"]!
//                let cvCode = param["cvCode"]!
//                let orderId = param["orderId"]!
//                let amount = param["amount"]!
//                let recurring = param["recurring"]!
//
//                print(token)
//
//                let transaction = PPOTransaction()
//                transaction.currency = "GBP"
//                transaction.amount = NSDecimalNumber(string: amount)
//                transaction.transactionDescription = "SideQuest Transaction"
//                transaction.merchantRef = orderId
//                transaction.isRecurring = recurring
//                transaction.isDeferred = "false"
//
//                let card = PPOCard()
//                card.pan = cardNumber
//                card.cvv = cvCode
//                card.expiry = exDate
//                card.cardHolderName = cardHolder
//
//                let billingAddress = PPOBillingAddress()
//                billingAddress.line1 = ""
//                billingAddress.line2 = ""
//                billingAddress.line3 = ""
//                billingAddress.line4 = ""
//                billingAddress.city = ""
//                billingAddress.region = ""
//                billingAddress.postcode = ""
//                billingAddress.countryCode = "GBR"
//
//                let customer = PPOCustomer()
//                customer.email = ""
//                customer.dateOfBirth = ""
//                customer.telephone = ""
//
//                let credentials = PPOCredentials()
//                credentials.clientToken = token
//                credentials.installationId = "8001699"
//                credentials.environment = PPOEnvironmentProduction
//
//                let customFieldSDKVersion = PPOCustomField()
//                customFieldSDKVersion.name = "sdkVersion"
//                customFieldSDKVersion.value = "1.0.2"
//
//                let customFieldMerchantAppName = PPOCustomField()
//                customFieldMerchantAppName.name = "merchantAppName"
//                customFieldMerchantAppName.value = "SideQuest"
//
//                let customFieldMerchantAppVersion = PPOCustomField()
//                customFieldMerchantAppVersion.name = "merchantAppVersion"
//                customFieldMerchantAppVersion.value = "1.0.0"
//
//                let customFieldsSet = NSMutableSet()
//                customFieldsSet.addObjects(from: [customFieldSDKVersion, customFieldMerchantAppName, customFieldMerchantAppVersion])
//
//                let payment = PPOPayment.init(self!)
//                payment.credentials = credentials
//                payment.transaction = transaction
//                payment.card = card
//                payment.address = billingAddress
//                payment.customer = customer
//                payment.customFields = customFieldsSet as! Set<PPOCustomField>
//
//                var result = [String: String]()
//
//                payment.processGuestPayment { (data:PPOPaymentResponse) in
//                    print("\(data.processing.status) \(data.transaction.transactionId)")
//                    if("SUCCESS" == data.processing.status) {
//                        result["code"] = "1"
//                        result["data"] = data.transaction.transactionId
//                    }else{
//                        result["code"] = "0"
//                        result["data"] = data.processing.result
//                    }
//                    self?.eventSink?(result)
//                } failure: { (error) in
//                    print(error.localizedDescription)
//                    result["code"] = "0"
//                    result["data"] = error.localizedDescription
//                    self?.eventSink?(result)
//                }

                
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
