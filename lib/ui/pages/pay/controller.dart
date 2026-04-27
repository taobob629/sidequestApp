/*
  controller
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:sq_hub_app/ui/pages/order/detail/view.dart';
import 'package:sq_hub_app/ui/pages/order/list/view.dart';

import '../../../api/address_api.dart';
import '../../../api/pay_api.dart';
import '../../../api/user_api.dart';
import '../../../api/wy_http.dart';
import '../../../common/address_model.dart';
import '../../../common/dialog_checking.dart';
import '../../../common/dialog_password.dart';
import '../../../config/app_color.dart';
import '../../../controller/cart_controller.dart';
import '../../../controller/user_controller.dart';
import '../../../model/credit_card_model.dart';
import '../../../model/db_model.dart';
import '../../../model/pay_info_model.dart';
import '../../../model/pay_order_model.dart';
import '../../../utils/storage_manager.dart';
import '../../../utils/toast_utils.dart';
import '../../../utils/utils.dart';
import '../../dialog/dialog_confirm.dart';
import '../playwith/play_balance_page.dart';

class PayPageController extends GetxController {
  static const MethodChannel _channel =
      const MethodChannel('uk.co.wanyoo.wy.method');

  late StreamSubscription _streamSubscription;
  static const EventChannel _eventChannel =
      const EventChannel('uk.co.wanyoo.wy.event.msg');

  var payType = 1.obs;

  late PayOrderModel payOrderModel;

  Timer? _timer;

  late int checkCount = 0;

  var havePayPassword = false.obs;

  PayPageController({required this.payOrderModel}) {
    if (payOrderModel.type == -2 || payOrderModel.type == -3) {
      payType.value = 2;
    }
  }

  CreditCardModel cardModel = CreditCardModel();
  String orderId = "";
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  var address = AddressModel().obs;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  initInAppPay() {
    print('initInAppPay = ${_inAppPurchase.isAvailable()}');
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      print('onDone====');
      _subscription.cancel();
    }, onError: (Object error) {
      print('onError====$error');
    });
  }

  PurchaseDetails? lastPurchaseDetails;

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      flog(
          '_listenToPurchaseUpdated====status ${purchaseDetails.status} purchaseID ${purchaseDetails.purchaseID} ');
      if (purchaseDetails.status == PurchaseStatus.canceled) {
        dismissLoading();
      }
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showLoading();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          dismissLoading();
          showError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          if (lastPurchaseDetails?.purchaseID == purchaseDetails.purchaseID)
            return;
          lastPurchaseDetails = purchaseDetails;
          dismissLoading();
          //支付成功，调用接口获取金币
          inAppPayCharge(purchaseDetails);
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  inAppPayCharge(PurchaseDetails detail) async {
    showLoading(msg: "flag = ${payOrderModel.flag}");
    if (payOrderModel.flag == 0) {
      // 充值
      var res = await PayApi.appleCreditPay(<String, dynamic>{}
        ..['chargeid'] = payOrderModel.chargeid
        ..['goodsPrice'] = payOrderModel.goodsPrice
        // type(0：充值，1：订阅)
        ..['type'] = 0
        ..['paytype'] = payType.value
        ..['localVerificationData'] =
            detail.verificationData.localVerificationData
        ..['serverVerificationData'] =
            detail.verificationData.serverVerificationData
        ..['source'] = detail.verificationData.source
        ..['productID'] = detail.productID
        ..['purchaseID'] = detail.purchaseID);
      // dismissLoading();
      if (res.statusCode == 200) {
        UserController.find.updateInfo();
        Get.back();
      } else {
        showError(res.statusMessage);
      }
    } else {
      // 订阅
      var res = await PayApi.appleSub(Map<String, dynamic>()
        ..['chargeid'] = payOrderModel.chargeid
        ..['goodsPrice'] = payOrderModel.goodsPrice
        // type(订阅传登记)
        ..['type'] = payOrderModel.type
        ..['paytype'] = payType.value
        ..['localVerificationData'] =
            detail.verificationData.localVerificationData
        ..['serverVerificationData'] =
            detail.verificationData.serverVerificationData
        ..['source'] = detail.verificationData.source
        ..['productID'] = detail.productID
        ..['purchaseID'] = detail.purchaseID);
      // dismissLoading();
      if (res.statusCode == 200) {
        UserController.find.updateInfo();
        Get.back();
      } else {
        showError(res.statusMessage);
      }
    }
  }

  @override
  void onInit() async {
    super.onInit();
    this.getCoin();
    initInAppPay();
    List<AddressModel> list = await AddressApi.list();
    if (list.length > 0) {
      try {
        address.value = list.firstWhere((element) => element.useDefault);
      } catch (e) {
        address.value = list.first;
      }
    }
    _streamSubscription = _eventChannel
        .receiveBroadcastStream()
        .listen(_onPayResult, onError: (e) {
      dismissLoading();
    }, cancelOnError: true);
    await havePassword();
  }

  ///硬币
  var coin = 0.obs;
  RxString _balance = RxString('');

  String get balance => _balance.value;

  set balance(String value) {
    _balance.value = value;
  }

  isSufficient() {
    try {
      double balanceValue = double.parse(balance);
      double amount = double.parse(payOrderModel.totalAmount);
      if (amount < balanceValue) return true;
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<int> getCoin() async {
    await http.get('/peiwan/app/user/getCoin').then((res) async {
      coin.value = res.data['coin'];
      balance = res.data['balance'];
    }).catchError((e) {});
    return coin.value;
  }

  Future<void> havePassword() async {
    havePayPassword.value = await UserApi.havePayPassword();
    dismissLoading();
  }

  @override
  void onClose() {
    _streamSubscription.cancel();
    _subscription?.cancel();
    _timer?.cancel();
    _timer == null;
    super.onClose();
  }

  void changePayType(int value) {
    payType.value = value;
  }

  void pay({bool isPlay = false}) async {
    flog('pay 正常支付进来了');
    if (!isPlay) {
      if (address.value.id == 0) {
        showInfo("Please select your billing address".tr);
        return;
      }
    }
    showLoading(clickMaskDismiss: false);
    if (Platform.isIOS && payType.value == 7) {
      // 苹果内购
      inAppPay();
      return;
    }
    payOrderModel.addressId = address.value.id;

    await confirmPay(isPlay: isPlay);
    /*
    if(havePayPassword.value == false){
      Get.to(()=>ChangePasswordPage(type: 2, check: false, have: false,))?.whenComplete(() async=> await havePassword());
      return;
    }else{
      DateTime now = DateTime.now();
      DateTime checkTime = StorageManager.getPayPasswordCheckTime();
      if((now.millisecondsSinceEpoch - checkTime.millisecondsSinceEpoch)/1000 < 300){
        confirmPay();
      }else {
        Get.dialog(PasswordDialog(), barrierDismissible: true, barrierColor: Colors.black26).then((value) {
          if (value == true) {
            StorageManager.setPayPasswordCheckTime(now);
            confirmPay();
          }
        });
      }
      return;
    }*/
  }

  Future<void> confirmPay({
    bool isPlay = false,
  }) async {
    checkCount = 0;
    payOrderModel.payType = payType.value;
    //  flog('payType $payType');
    if (payType.value == 4) {
      PayInfoModel payInfoModel = await PayApi.pay(payOrderModel);
      if (payInfoModel.result != null) {
        try {
          final Map params = <String, dynamic>{
            'info': payInfoModel.result!.appData
          };
          //    flog('appdata $params');
          String result = await _channel.invokeMethod('getAlipay', params);
          flog("zengchao = $result");
          dismissLoading();
          if (result == "gotopay") {
            Get.dialog(CheckingDialog(tips: "Checking payment result ...".tr),
                    barrierColor: Colors.black26)
                .whenComplete(() {
              _timer?.cancel();
              Get.find<UserController>().updateInfo();
            });
            startTimer(payInfoModel);
          }
        } catch (e) {
          flog(e.toString());
          dismissLoading();
        }
      } else {
        showError("Server response error!".tr);
        return;
      }
    } else if (payType.value == 1) {
      showLoading();
      final billingDetails = BillingDetails(
        name: "${address.value.firstName} ${address.value.lastName}",
        email: address.value.email,
        phone: address.value.phone,
        address: Address(
          city: address.value.city,
          country: 'GB',
          line1: address.value.line1,
          line2: address.value.line2,
          state: '',
          postalCode: address.value.postCode,
        ),
      );

      String env = StorageManager.getEnv();
      PayInfoModel payInfoModel = await PayApi.pay(payOrderModel);

      PaymentSheetApplePay? applePay = payInfoModel.applePay
          ? PaymentSheetApplePay(merchantCountryCode: 'GB')
          : null;
      PaymentSheetGooglePay? googlePay = payInfoModel.googlePay
          ? PaymentSheetGooglePay(
              merchantCountryCode: 'GB',
              testEnv: env == "prod" ? false : true,
            )
          : null;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: payInfoModel.clientSecret,
          merchantDisplayName: 'Sidequest Hub',
          customerId: payInfoModel.customerId,
          customerEphemeralKeySecret: payInfoModel.ephemeralKeySecret,
          applePay: applePay,
          googlePay: googlePay,
          style: ThemeMode.dark,
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              background: AppColor.background,
              componentBackground: Color(0xff444444),
              componentBorder: Color(0xff78777f),
              componentDivider: Color(0xff78777f),
              componentText: Colors.white,
              primaryText: Colors.white,
              secondaryText: Color(0xffa5a3b1),
              placeholderText: Color(0xff969696),
              primary: Color(0xFFFC3C02),
              icon: Color(0xffa5a3ae),
            ),
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              shapes: PaymentSheetPrimaryButtonShape(blurRadius: 40.0),
              colors: PaymentSheetPrimaryButtonTheme(
                dark: PaymentSheetPrimaryButtonThemeColors(
                    background: Color(0xFFFC3C02)),
              ),
            ),
          ),
          billingDetails: billingDetails,
        ),
      );
      try {
        dismissLoading();
        await Stripe.instance.presentPaymentSheet();
        // Get.dialog(
        //   ConfirmDialog(title: "Payment Result", info: "Payment Successful!"),barrierColor: Colors.black26
        // ).then((value) => Get.back(result: true));
        Get.dialog(CheckingDialog(tips: "Checking payment status ...".tr),
                barrierColor: Colors.black26)
            .whenComplete(() {
          _timer?.cancel();
          Get.find<UserController>().updateInfo();
        });
        startTimer(payInfoModel);
      } on Exception catch (e) {
        if (e is StripeException) {
          showInfo(e.error.localizedMessage == null
              ? "Payment Failed!".tr
              : e.error.localizedMessage!);
        }
      }
    } else if (payType.value == 2) {
      //余额支付
      //  checkPayPin(() async {
      flog(payOrderModel.code, 'payOrderModel.code');
      PayInfoModel payInfoModel = await PayApi.pay(payOrderModel);
      flog(payOrderModel.type, 'payOrderModel.type');
      if (payOrderModel.type == -2 || payOrderModel.type == -3) {
        if (payInfoModel.insufficient) {
          Get.dialog(
            ConfirmDialog(
              title: "Payment Result".tr,
              info: "Insufficient coin, Please recharge first!".tr,
              onConfirm: () {
                Get.back();
                Get.back();
                Get.to(() => PlayBalancePage());
              },
            ),
            barrierColor: Colors.black26,
          );
        } else {
          Get.dialog(
                  ConfirmDialog(
                      title: "Payment Result".tr,
                      info: "Payment Successful!".tr),
                  barrierColor: Colors.black26)
              .whenComplete(() {
            if (payOrderModel.type == -3) {
              Get.back(result: payInfoModel.desc);
            } else {
              if (!isPlay) Get.back(result: true);
              Get.back(result: payInfoModel.uk);
              Get.find<UserController>().updateInfo();
            }
          });
        }
      } else {
        if (payInfoModel.orderNo.isEmpty) {
          showError("Server response error!".tr);
        } else {
          if (payOrderModel.type == -1) {
            var cartController = Get.find<CartController>();
            cartController.clearCart();
          }
          Get.dialog(
                  ConfirmDialog(
                      title: "Payment Result".tr,
                      info: "Payment Successful!".tr),
                  barrierColor: Colors.black26)
              .whenComplete(() {
            Get.back();
            Get.find<UserController>().updateInfo();
          });
        }
      }
      // });
    } else if (payType.value == 9999) {
      if (Platform.isAndroid) {
        // 谷歌支付
      } else if (Platform.isIOS) {
        // 苹果支付
      }
    }
  }

  startTimer(PayInfoModel payInfoModel) {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (checkCount > 10) {
        timer.cancel();
        return;
      }
      autoCheckPay(payInfoModel.orderNo);
    });
  }

  void checkPayPin(Function checkDone) {
    // if (havePayPassword.value == false) {
    //   Get.to(() => ChangePasswordPage(
    //         type: 2,
    //         check: false,
    //         have: false,
    //       ))?.whenComplete(() async => await havePassword());
    //   return;
    // } else {
    DateTime now = DateTime.now();
    DateTime checkTime = StorageManager.getPayPasswordCheckTime();
    if ((now.millisecondsSinceEpoch - checkTime.millisecondsSinceEpoch) / 1000 <
        300) {
      checkDone.call();
    } else {
      Get.dialog(
        PasswordDialog(),
        barrierDismissible: true,
        barrierColor: Colors.black26,
      ).then((value) {
        if (value == true) {
          StorageManager.setPayPasswordCheckTime(now);
          checkDone.call();
        }
      });
    }
    return;
    // }
  }

  Future<void> autoCheckPay(String orderNo) async {
    checkCount++;
    if (_timer == null) {
      return;
    }
    bool payStatus = await PayApi.status(payOrderModel.type, orderNo);
    if (payStatus) {
      _timer?.cancel();
      _timer = null;
      _onPayDone();
      return;
    }
    if (checkCount > 10) {
      Get.back();
      _timer?.cancel();
      _timer = null;
      Get.dialog(
        ConfirmDialog(
          cancelable: true,
          title: "Payment Result".tr,
          info:
              "The payment result can not be confirmed, do you have finished it?"
                  .tr,
          onConfirm: () {
            if (payOrderModel.type == 4) {
              Get.offUntil(
                  GetPageRoute(
                    settings: RouteSettings(arguments: payOrderModel.orderId),
                    page: () => OrderDetailPage(),
                  ),
                  (route) => route.isFirst);
            } else {
              manualCheckPay(orderId);
            }
          },
        ),
        barrierColor: Colors.black26,
      );
    }
  }

  Future<void> manualCheckPay(String orderNo) async {
    showLoading();
    bool payStatus = await PayApi.status(payOrderModel.type, orderNo);
    dismissLoading();
    if (payStatus) {
      _onPayDone();
    } else {
      Get.dialog(
          ConfirmDialog(
            cancelable: true,
            title: "Payment Result".tr,
            info:
                "The payment result still can not be confirmed, please contact our customer service."
                    .tr,
            onConfirm: () => Get.back(),
          ),
          barrierColor: Colors.black26);
    }
  }

  void _onPayDone() {
    if (payOrderModel.type == -1) {
      var cartController = Get.find<CartController>();
      cartController.clearCart();
    }
    Get.back();

    Get.dialog(
      ConfirmDialog(
        title: "Payment Result".tr,
        info: "Payment Successful!".tr,
      ),
      barrierColor: Colors.black26,
    ).then(
      (value) {
        if (payOrderModel.type == 4) {
          Get.offUntil(
              GetPageRoute(
                settings: RouteSettings(arguments: payOrderModel.orderId),
                page: () => OrderDetailPage(),
              ),
              (route) => route.isFirst);
        } else {
          Get.back(result: true);
        }
      },
    );
  }

  //原生返回事件调用
  void _onPayResult(dynamic content) async {
    // 收到android原生eventSink?.success和iOS原生self?.eventSink返回的消息关闭弹窗
    dismissLoading();
    if (payType.value == 4) {
      //alipay
      if (content.toString() == "6001") {
        //cancel
        dismissLoading();
        _timer?.cancel();
        _timer = null;
        Get.back(result: true);
        Get.dialog(
            ConfirmDialog(
                title: "Payment Result".tr,
                info: "The payment has been canceled.".tr),
            barrierColor: Colors.black26);
      }
    } else if (payType.value == 1) {
      var result = content as Map;
      String code = result["code"];
      if (code == "0") {
        showError("Payment failed".tr);
        return;
      }
      String transactionId = result["data"];

      StorageManager.setCreditCardModel(cardModel);
      print("transactionId:$transactionId --- orderId:$orderId");
      UserController userController = Get.find<UserController>();
      if (userController.db != null) {
        PayRecord payRecord = PayRecord();
        payRecord.createTime = DateTime.now();
        payRecord.orderId = orderId;
        payRecord.tranId = transactionId;
        await userController.db!.insertPayRecord(payRecord);
        Future.delayed(
            Duration(seconds: 2), () => userController.startPayNotify());
      }
      await PayApi.notifyCardPay(orderId, transactionId);
      if (payOrderModel.type == -1) {
        var cartController = Get.find<CartController>();
        cartController.clearCart();
      }
      dismissLoading();
      Get.dialog(
              ConfirmDialog(
                  title: "Payment Result".tr, info: "Payment Successful!".tr),
              barrierColor: Colors.black26)
          .then((value) => Get.back(result: true));
    }
  }

  var cartController = Get.find<CartController>();

  /**
   * 苹果内购
   */
  inAppPay() {
    flog('pay 苹果内购进来了');
    //苹果内购
    if (cartController.products.isEmpty) {
      showError('No products，Retry later');
      cartController.initInAppPay();
      return;
    }
    //根据金额，找到对应的内购商品
    var price = parsePrice(payOrderModel.goodsPrice);
    var product = cartController.products.firstWhereOrNull((element) {
      if (payOrderModel.type >= 5) {
        return element.id == 'VIP_${payOrderModel.goodsPrice}';
      }
      return element.id == 'coin_$price';
    });
    if (product == null) {
      showError("No product found");
      return;
    }
    flog('product ${product.price} ');
    //调用支付'
    PurchaseParam purchaseParam = PurchaseParam(
      productDetails: product,
    );
    _inAppPurchase.buyConsumable(
      purchaseParam: purchaseParam,
      autoConsume: true,
    );
  }

  parsePrice(var price) {
    var result = 0.0;
    try {
      result = double.parse(price.toString().trim());
    } catch (e) {
      flog('e $e');
      return result;
    }
    return result.toInt();
  }
}
