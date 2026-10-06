import UIKit
import Flutter
import AlipayPlusClient

private final class SideQuestAlipaySDKService: NSObject, AlipaySDKServiceProtocol {
    func payOrder(
        _ orderStr: String,
        fromScheme schemeStr: String,
        callback completionBlock: @escaping ([AnyHashable: Any]) -> Void
    ) {
        guard let alipayService = AlipaySDK.defaultService() else {
            completionBlock([
                "resultStatus": "4000",
                "memo": "Alipay SDK is unavailable"
            ])
            return
        }

        alipayService.payOrder(orderStr, fromScheme: schemeStr) { result in
            completionBlock(result ?? [:])
        }
    }

    func processOrder(
        withPaymentResult resultUrl: URL,
        standbyCallback completionBlock: @escaping ([AnyHashable: Any]) -> Void
    ) {
        guard let alipayService = AlipaySDK.defaultService() else {
            completionBlock([
                "resultStatus": "4000",
                "memo": "Alipay SDK is unavailable"
            ])
            return
        }

        alipayService.processOrder(withPaymentResult: resultUrl) { result in
            completionBlock(result ?? [:])
        }
    }
}

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {

  var eventSink: FlutterEventSink?
  private let alipaySDKService = SideQuestAlipaySDKService()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)

//        StripeAPI.defaultPublishableKey = "pk_test_51L1kPsBizrDMUWwg9A6jFjNOhdIDUtvUoMStTIv0RpfJx00EYC5fdICvH0UVyQM7mLBdt97T1GqU0P4mZbAVBQpj00mWsHoGvg"

        guard let controller = window?.rootViewController as? FlutterViewController else {
            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
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
            let param = flutterMethodCall.arguments as? Dictionary<String, String> ?? [:]
            if flutterMethodCall.method == "getAlipay" {
                guard let paymentData = param["info"], !paymentData.isEmpty else {
                    flutterResult(FlutterError(
                        code: "ALIPAY_PAYMENT_DATA_EMPTY",
                        message: "Unable to start Alipay payment: payment data is empty",
                        details: nil
                    ))
                    return
                }

                let configuration = IAPConfiguration()
                configuration.envType = "PROD"
                configuration.acquirerId = "5Y39882YDWFU05385"
                configuration.merchantId = "AEF11846594"
                configuration.language = "zh_CN"
                configuration.fromScheme = "sideQuestAlipay"

                let alipayPlusClient = AlipayPlusClient.shared()
                alipayPlusClient.configuration = configuration
                alipayPlusClient.alipaySDKSService = self?.alipaySDKService

                var resultCompleted = false
                func complete(_ value: Any?) {
                    guard !resultCompleted else { return }
                    resultCompleted = true
                    flutterResult(value)
                }
                func fail(_ message: String?) {
                    guard !resultCompleted else { return }
                    resultCompleted = true
                    flutterResult(FlutterError(
                        code: "ALIPAY_SHEET_ERROR",
                        message: message ?? "Unable to open Alipay payment",
                        details: nil
                    ))
                }

                alipayPlusClient.showPaymentSheet(paymentData) { sheetEvent in
                    print("[Alipay+] event=\(sheetEvent.name), message=\(sheetEvent.message ?? "")")
                    if sheetEvent.name == IAPPaymentSheetEventDidShow {
                        // your own logic
                        print("zengchao = IAPPaymentSheetEventDidShow")
                    } else if sheetEvent.name == IAPPaymentSheetEventThrowException {
                        print("zengchao = IAPPaymentSheetEventThrowException")
                        fail(sheetEvent.message)
                    } else if sheetEvent.name == IAPPaymentSheetEventUserDidCancel {
                        print("zengchao = IAPPaymentSheetEventUserDidCancel")
                        complete("cancel")
                    } else if sheetEvent.name == IAPPaymentSheetEventDidSelectWalletAndPay {
                        // your own logic
                        print("zengchao = IAPPaymentSheetEventDidSelectWalletAndPay")
                        complete("gotopay")
                    } else if sheetEvent.name == IAPPaymentSheetEventPaymentException {
                        // your own logic after payment interruption
                        // Currently, this type of event may occur only after you import Alipay SDK to optimize the Alipay payment experience.
                        print("zengchao = IAPPaymentSheetEventPaymentException")
                        fail(sheetEvent.message)
                    } else if sheetEvent.name == IAPPaymentSheetEventPaymentCanceled {
                        // your own logic after payment cancelation
                        // Currently, this type of event may occur only after you import Alipay SDK to optimize the Alipay payment experience.
                        print("zengchao = IAPPaymentSheetEventPaymentCanceled")
                        complete("cancel")
                    } else if sheetEvent.name == IAPPaymentSheetEventPaymentFailed {
                        // your own logic after payment failure
                        // Currently, this type of event may occur only after you import Alipay SDK to optimize the Alipay payment experience.
                        print("zengchao = IAPPaymentSheetEventPaymentFailed")
                        fail(sheetEvent.message)
                    } else if sheetEvent.name == IAPPaymentSheetEventPaymentSuccess {
                        // your own logic after payment success
                        // Currently, this type of event may occur only after you import Alipay SDK to optimize the Alipay payment experience.
                        print("zengchao = IAPPaymentSheetEventPaymentSuccess")
                        complete("gotopay")
                    } else if sheetEvent.name == IAPPaymentSheetEventPaymentProcessing {
                        // your own logic after payment finishes but status is ongoing
                        // Currently, this type of event may occur only after you import Alipay SDK to optimize the Alipay payment experience.
                        print("zengchao = IAPPaymentSheetEventPaymentProcessing")
                        complete("gotopay")
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
        let alipayPlusClient = AlipayPlusClient.shared()
        if alipayPlusClient.canProcessOrder(withPaymentResult: url) {
            alipayPlusClient.processOrder(withPaymentResult: url)
            return true
        }

        return super.application(app, open: url, options: options)
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
