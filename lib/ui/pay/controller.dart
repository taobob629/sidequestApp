/*
  controller
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:wy/api/address_api.dart';
import 'package:wy/api/pay_api.dart';
import 'package:wy/api/user_api.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/model/address_model.dart';
import 'package:wy/model/credit_card_model.dart';
import 'package:wy/model/db_model.dart';
import 'package:wy/model/pay_info_model.dart';
import 'package:wy/model/pay_order_model.dart';
import 'package:wy/ui/common/dialog_checking.dart';
import 'package:wy/ui/common/dialog_confirm.dart';
import 'package:wy/ui/common/dialog_password.dart';
import 'package:wy/ui/controller/cart_controller.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/profile/settings/change_password_page.dart';
import 'package:wy/utils/storage_manager.dart';
import 'package:wy/utils/utils.dart';

class PayPageController extends GetxController {
  static const MethodChannel _channel = const MethodChannel('uk.co.wanyoo.wy.method');

  late StreamSubscription _streamSubscription;
  static const EventChannel _eventChannel = const EventChannel('uk.co.wanyoo.wy.event.msg');

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

  var address = AddressModel().obs;

  @override
  void onInit() async {
    super.onInit();
    this.getCoin();
    List<AddressModel> list = await AddressApi.list();
    if (list.length > 0) {
      try {
        address.value = list.firstWhere((element) => element.useDefault);
      } catch (e) {
        address.value = list.first;
      }
    }
    _streamSubscription = _eventChannel.receiveBroadcastStream().listen(_onPayResult, onError: (e) {
      EasyLoading.dismiss();
    }, cancelOnError: true);
    await havePassword();
  }

  @override
  void onReady() async {
    super.onReady();

    print("apple pay:: ${Stripe.instance.isApplePaySupported.value}");
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
    EasyLoading.show();
    havePayPassword.value = await UserApi.havePayPassword();
    EasyLoading.dismiss();
  }

  @override
  void onClose() {
    _streamSubscription.cancel();
    _timer?.cancel();
    _timer == null;
    super.onClose();
  }

  void changePayType(int value) {
    payType.value = value;
  }

  void pay({bool isPlay = false}) async {
    if (!isPlay) {
      if (address.value.id == 0) {
        EasyLoading.showInfo("Please select your billing address".tr);
        return;
      }
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

  Future<void> confirmPay({bool isPlay = false}) async {
    checkCount = 0;
    payOrderModel.payType = payType.value;
    if (payType.value == 4) {
      PayInfoModel payInfoModel = await PayApi.pay(payOrderModel);
      if (payInfoModel.result != null) {
        final Map params = <String, dynamic>{'info': payInfoModel.result!.appData};
        //    flog('appdata $params');
        await _channel.invokeMethod('getAlipay', params);
      } else {
        EasyLoading.showError("Server response error!".tr);
        return;
      }
      Get.dialog(CheckingDialog(tips: "Checking payment result ...".tr), barrierColor: Colors.black26).whenComplete(() {
        _timer?.cancel();
        Get.find<UserController>().updateInfo();
      });
      startTimer(payInfoModel);
    } else if (payType.value == 1) {
      EasyLoading.show();
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

      PaymentSheetApplePay? applePay = payInfoModel.applePay ? PaymentSheetApplePay(merchantCountryCode: 'GB') : null;
      PaymentSheetGooglePay? googlePay = payInfoModel.googlePay
          ? PaymentSheetGooglePay(
              merchantCountryCode: 'GB',
              testEnv: env == "prod" ? false : true,
            )
          : null;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: payInfoModel.clientSecret,
          merchantDisplayName: 'SideQuest',
          customerId: payInfoModel.customerId,
          customerEphemeralKeySecret: payInfoModel.ephemeralKeySecret,
          applePay: applePay,
          googlePay: googlePay,
          style: ThemeMode.dark,
          appearance: PaymentSheetAppearance(
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
                dark: PaymentSheetPrimaryButtonThemeColors(background: Color(0xFFFC3C02)),
              ),
            ),
          ),
          billingDetails: billingDetails,
        ),
      );
      try {
        EasyLoading.dismiss();
        await Stripe.instance.presentPaymentSheet();
        // Get.dialog(
        //   ConfirmDialog(title: "Payment Result", info: "Payment Successful!"),barrierColor: Colors.black26
        // ).then((value) => Get.back(result: true));
        Get.dialog(CheckingDialog(tips: "Checking payment status ...".tr), barrierColor: Colors.black26).whenComplete(() {
          _timer?.cancel();
          Get.find<UserController>().updateInfo();
        });
        startTimer(payInfoModel);
      } on Exception catch (e) {
        if (e is StripeException) {
          EasyLoading.showInfo(e.error.localizedMessage == null ? "Payment Failed!".tr : e.error.localizedMessage!);
        }
      }
    } else if (payType.value == 2) {
      //余额支付
      checkPayPin(() async {
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
                  Get.toNamed(AppPages.WALLET_PAGE);
                },
              ),
              barrierColor: Colors.black26,
            );
          } else {
            Get.dialog(ConfirmDialog(title: "Payment Result".tr, info: "Payment Successful!".tr), barrierColor: Colors.black26).whenComplete(() {
              if (!isPlay) Get.back();
              Get.back(result: payInfoModel.orderNo);
              Get.find<UserController>().updateInfo();
            });
          }
        } else {
          if (payInfoModel.orderNo.isEmpty) {
            EasyLoading.showError("Server response error!".tr);
          } else {
            if (payOrderModel.type == -1) {
              var cartController = Get.find<CartController>();
              cartController.clearCart();
            }
            Get.dialog(ConfirmDialog(title: "Payment Result".tr, info: "Payment Successful!".tr), barrierColor: Colors.black26).whenComplete(() {
              Get.back();
              Get.find<UserController>().updateInfo();
            });
          }
        }
      });
    }
  }

  startTimer(PayInfoModel payInfoModel) {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (checkCount > 10) {
        timer.cancel();
        return;
      }
      ;
      autoCheckPay(payInfoModel.orderNo);
    });
  }

  void checkPayPin(Function checkDone) {
    if (havePayPassword.value == false) {
      Get.to(() => ChangePasswordPage(
            type: 2,
            check: false,
            have: false,
          ))?.whenComplete(() async => await havePassword());
      return;
    } else {
      DateTime now = DateTime.now();
      DateTime checkTime = StorageManager.getPayPasswordCheckTime();
      if ((now.millisecondsSinceEpoch - checkTime.millisecondsSinceEpoch) / 1000 < 300) {
        checkDone.call();
      } else {
        Get.dialog(PasswordDialog(), barrierDismissible: true, barrierColor: Colors.black26).then((value) {
          if (value == true) {
            StorageManager.setPayPasswordCheckTime(now);
            checkDone.call();
          }
        });
      }
      return;
    }
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
      _timer?.cancel();
      _timer = null;
      Get.dialog(
          ConfirmDialog(
            cancelable: true,
            title: "Payment Result".tr,
            info: "The payment result can not be confirmed, do you have finished it?".tr,
            onConfirm: () => manualCheckPay(orderId),
          ),
          barrierColor: Colors.black26);
    }
  }

  Future<void> manualCheckPay(String orderNo) async {
    EasyLoading.show();
    bool payStatus = await PayApi.status(payOrderModel.type, orderNo);
    if (payStatus) {
      _onPayDone();
    } else {
      Get.dialog(
          ConfirmDialog(
            cancelable: true,
            title: "Payment Result".tr,
            info: "The payment result still can not be confirmed, please contact our customer service.".tr,
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
    Get.dialog(ConfirmDialog(title: "Payment Result".tr, info: "Payment Successful!".tr), barrierColor: Colors.black26).then((value) => Get.back(result: true));
  }

  //原生返回事件调用
  void _onPayResult(dynamic content) async {
    if (payType.value == 4) {
      //alipay
      if (content.toString() == "6001") {
        //cancel
        EasyLoading.dismiss();
        _timer?.cancel();
        _timer = null;
        Get.back(result: true);
        Get.dialog(ConfirmDialog(title: "Payment Result".tr, info: "The payment has been canceled.".tr), barrierColor: Colors.black26);
      }
    } else if (payType.value == 1) {
      var result = content as Map;
      String code = result["code"];
      if (code == "0") {
        EasyLoading.showError("Payment failed".tr);
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
        Future.delayed(Duration(seconds: 2), () => userController.startPayNotify());
      }
      await PayApi.notifyCardPay(orderId, transactionId);
      if (payOrderModel.type == -1) {
        var cartController = Get.find<CartController>();
        cartController.clearCart();
      }
      EasyLoading.dismiss();
      Get.dialog(ConfirmDialog(title: "Payment Result".tr, info: "Payment Successful!".tr), barrierColor: Colors.black26).then((value) => Get.back(result: true));
    }
  }
}
