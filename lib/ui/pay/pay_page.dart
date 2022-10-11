import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:wy/api/pay_api.dart';
import 'package:wy/api/user_api.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/model/credit_card_model.dart';
import 'package:wy/model/data_model.dart';
import 'package:wy/model/db_model.dart';
import 'package:wy/model/pay_info_model.dart';
import 'package:wy/model/pay_order_model.dart';
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/ui/common/dialog_checking.dart';
import 'package:wy/ui/common/dialog_confirm.dart';
import 'package:wy/ui/common/keyboard_scaffold.dart';
import 'package:wy/ui/controller/cart_controller.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/profile/settings/change_password_page.dart';
import 'package:wy/utils/platform_utils.dart';
import 'package:wy/utils/storage_manager.dart';

import '../../api/address_api.dart';
import '../../config/app_config.dart';
import '../../model/address_model.dart';
import '../../utils/navigator_helper.dart';
import '../common/dialog_password.dart';
import '../playwith/play_balance_page.dart';

class PayPage extends StatelessWidget {

  late final PayPageController controller;

  final userController = Get.find<UserController>();

  PayPage({required PayOrderModel payOrderModel,}){
    controller = Get.put(PayPageController(payOrderModel: payOrderModel));
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardScaffold(
      title: "Pay Confirm",
      body: ListView.separated(
        itemBuilder: (context, index){
          if(index == 0){
            return _buildAmount();
          }else if(index == 1){
            return Obx(()=>_buildBillAddress());
          }else if(index == 2){
            if(controller.payOrderModel.type == -2){
              return Container();
            }
            return Obx(()=>_buildCredit(1,controller.payType.value));
          }else if(index == 3){
            if(controller.payOrderModel.type > 0 || controller.payOrderModel.type == -2){
              return Container();
            }else {
              return Obx(() => _buildPayView("Alipay", "alipay", 4, controller.payType.value));
              //return Container();
            }
          }else if(index == 4){
            if(controller.payOrderModel.type == -2){
              return Obx(()=>
                _buildPayView(
                  "Gold Coins",
                  "balance_money",
                  2,
                  controller.payType.value,
                  subTitle: Row(
                    children: [
                      Image.asset("assets/images/ic_balance_money.webp",width: 14,height: 14,),
                      SizedBox(width: 5,),
                      Text("${controller.coin.value}",style: TextStyle(color: Colors.white,fontSize: 14),)
                    ],
                  )
                )
              );
            }else if(controller.payOrderModel.type > -2){
              return Container();
            }else {
              return Obx(()=>_buildPayView("Balance", "balance_money",2,controller.payType.value));
            }
          }
          return Container(height: 70,);
        },
        separatorBuilder: (context, index){
          return Container(height: 15,);
        },
        itemCount: 5
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
      child: ColorfulButton(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text("CONFIRM",style: TextStyle(color: Colors.white,fontSize: 20,fontFamily: "DIN"),),
        ),
        onTap: ()=>userController.checkLogin(()=>controller.pay()),
      ),
    );
  }

  Widget _buildAmount(){
    return Padding(
      padding: const EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 20),
      child: Stack(
        children: [
          Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child:Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    controller.payOrderModel.type == -2 ?
                    Image.asset("assets/images/ic_balance_money.webp",width: 30,height: 30,):
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "£",
                        style: TextStyle(fontSize: 34,color: Colors.white, fontFamily: "DIN"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0,left: 5),
                      child: Text(
                        "${double.parse(controller.payOrderModel.totalAmount).toStringAsFixed(controller.payOrderModel.type == -2 ? 0:2)}",
                        style: TextStyle(fontSize: 34,color: Colors.white, fontFamily: "DIN"),
                      ),
                    ),
                  ],
                )
              )
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Text("Amount",style: TextStyle(fontSize: 16,color: Colors.white),),
          )
        ],
      ),
    );
  }

  Widget _buildBillAddress(){
    Widget text = Expanded(child:Text("Please select your billing address",style: TextStyle(fontSize: 14,color: Colors.white38),));
    if(controller.address.value.id != 0){
      var addressModel = controller.address.value;
      text = Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${addressModel.firstName} ${addressModel.lastName} ${addressModel.phone}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14,color: Colors.white),
            ),
            Text(
              "${addressModel.line1} ${addressModel.line2}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14,color: Colors.white),
            ),
            Text(
              " ${addressModel.city} ${addressModel.postCode}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14,color: Colors.white),
            ),
          ],
        ),
      );
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text("Billing Address",style: TextStyle(fontSize: 16,color: Colors.white),),
          ),
          SizedBox(height: 15,),
          GestureDetector(
            onTap: () async{
              AddressModel? model  = await NavigatorHelper.gotoAddressPage(select: true);
              if(model != null){
                controller.address.value = model;
              }
            },
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  text,
                  Icon(Icons.arrow_forward_ios_rounded,color: Colors.white, size: 18,)
                ],
              ),
            ),
          ),
          SizedBox(height: 15,),
        ],
      ),
    );
  }

  Widget _buildCredit(int value, int groupValue){
    String payMethod = "";
    if(Platform.isAndroid){
      payMethod = "Google Pay";
    }else if(Platform.isIOS){
      payMethod = "Apple Pay";
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xff28253D),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: ()=>controller.changePayType(value),
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.only(left: 5,right: 15,top: 5,bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio(
                    activeColor: AppColor.accent,
                    value: value,
                    groupValue: groupValue,
                    onChanged: (value) => controller.changePayType(value as int),
                    hoverColor: AppColor.accent,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "Credit Card  &  $payMethod",
                      style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: "DIN"),
                    ),
                  ),
                  Spacer(),
                  // Image.asset("assets/images/ic_visa.webp",height: 32,),
                  // SizedBox(width: 10,),
                  // Image.asset("assets/images/ic_master.webp",height: 32,)
                ],
              ),
            ),
          ),
        ],
      )
    );
  }

  Widget _buildPayView(String name, String icon, int value, int groupValue, {Widget? subTitle}){
    return GestureDetector(
      onTap: ()=>controller.changePayType(value),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.only(right: 15,top: 5,bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Color(0xff28253D),
        ),
        child: Row(
          children: [
            Radio(
              activeColor: AppColor.accent,
              value: value,
              groupValue: groupValue,
              onChanged: (value) => controller.changePayType(value as int),
              hoverColor: AppColor.accent,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                name,
                style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: "DIN"),
              ),
            ),
            Spacer(),
            subTitle??Container()
            //Image.asset("assets/images/ic_$icon.webp",height: 24,),
          ],
        ),
      ),
    );
  }
}

class PayPageController extends GetxController {
  static const MethodChannel _channel = const MethodChannel('uk.co.wanyoo.wy.method');

  late StreamSubscription _streamSubscription;
  static const EventChannel _eventChannel = const EventChannel('uk.co.wanyoo.wy.event.msg');

  var payType = 1.obs;

  late PayOrderModel payOrderModel;

  late Timer _timer;

  late int checkCount = 0;

  var havePayPassword = false.obs;

  PayPageController({required this.payOrderModel}){
    if(payOrderModel.type == -2){
      payType.value = 2;
    }
  }

  CreditCardModel cardModel = CreditCardModel();
  String orderId = "";

  var address = AddressModel().obs;

  @override
  void onInit() async{
    super.onInit();
    this.getCoin();
    List<AddressModel> list = await AddressApi.list();
    if(list.length > 0) {
      try {
        address.value = list.firstWhere((element) => element.useDefault);
      }catch(e){
        address.value = list.first;
      }
    }
    _streamSubscription = _eventChannel
      .receiveBroadcastStream()
      .listen(_onPayResult, onError: (e){
        EasyLoading.dismiss();
        },
      cancelOnError: true);
    await havePassword();
  }

  @override
  void onReady() async{
    super.onReady();

    print("apple pay:: ${Stripe.instance.isApplePaySupported.value}");
  }

  ///硬币
  var coin = 0.obs;
  Future<int> getCoin() async {
    await http.get('/peiwan/app/user/getCoin').then((res) async {
      coin.value = res.data['coin'];
    }).catchError((e) {
    });
    return coin.value;
  }

  Future<void> havePassword()async{
    EasyLoading.show();
    havePayPassword.value = await UserApi.havePayPassword();
    EasyLoading.dismiss();
  }

  @override
  void onClose() {
    _streamSubscription.cancel();
    super.onClose();
  }

  void changePayType(int value){
    payType.value = value;
  }

  void pay() async {
    if(address.value.id == 0){
      EasyLoading.showInfo("Please select your billing address");
      return;
    }
    payOrderModel.addressId = address.value.id;

    confirmPay();
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

  Future<void> confirmPay() async{
    payOrderModel.payType = payType.value;
    if(payType.value == 4) {
      PayInfoModel payInfoModel = await PayApi.pay(payOrderModel);
      if(payInfoModel.result != null) {
        final Map params = <String, dynamic>{'info': payInfoModel.result!.appData};
        await _channel.invokeMethod('getAlipay', params);
      }else{
        EasyLoading.showError("Server response error!");
        return;
      }
      Get.dialog(CheckingDialog(tips: "Checking payment result ..."),barrierColor: Colors.black26).whenComplete(() {
        _timer.cancel();
      });
      _timer = Timer.periodic(Duration(seconds: 2), (timer) {
        autoCheckPay(payInfoModel.orderNo);
      });
    }else if(payType.value == 1){
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

      PaymentSheetApplePay? applePay = payInfoModel.applePay ? PaymentSheetApplePay(merchantCountryCode: 'GB'):null;
      PaymentSheetGooglePay? googlePay = payInfoModel.googlePay ? PaymentSheetGooglePay(
        merchantCountryCode: 'GB',
        testEnv: env == "prod" ? false:true,
      ) : null;

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
              placeholderText:Color(0xff969696),
              primary: Color(0xFFFC3C02),
              icon: Color(0xffa5a3ae),
            ),
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              shapes: PaymentSheetPrimaryButtonShape(blurRadius: 40.0),
              colors: PaymentSheetPrimaryButtonTheme(
                dark: PaymentSheetPrimaryButtonThemeColors(
                  background: Color(0xFFFC3C02)
                ),
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
        Get.dialog(CheckingDialog(tips: "Checking payment status ..."),barrierColor: Colors.black26).whenComplete(() {
          _timer.cancel();
        });
        _timer = Timer.periodic(Duration(seconds: 2), (timer) {
          autoCheckPay(payInfoModel.orderNo);
        });
      }on Exception catch (e){
        if (e is StripeException) {
          EasyLoading.showInfo(e.error.localizedMessage == null ? "Payment Failed!" : e.error.localizedMessage!);
        }
      }
    }
    else if(payType.value == 2) { //余额支付
      checkPayPin(()async{
        PayInfoModel payInfoModel = await PayApi.pay(payOrderModel);

        if (payOrderModel.type == -2) {
          if (payInfoModel.insufficient) {
            Get.dialog(
              ConfirmDialog(
                title: "Payment Result",
                info: "Insufficient coin, Please recharge first!",
                onConfirm: (){
                  Get.back();
                  Get.back();
                  Get.to(() => PlayBalancePage());
                },
              ),
              barrierColor: Colors.black26,
            );
          }else{
            Get.dialog(ConfirmDialog(title: "Payment Result", info: "Payment Successful!"), barrierColor: Colors.black26)
              .whenComplete(() => Get.back());
          }
        } else {
          if (payInfoModel.orderNo.isEmpty) {
            EasyLoading.showError("Server response error!");
          } else {
            if (payOrderModel.type == -1) {
              var cartController = Get.find<CartController>();
              cartController.clearCart();
            }
            Get.dialog(ConfirmDialog(title: "Payment Result", info: "Payment Successful!"), barrierColor: Colors.black26)
              .whenComplete(() => Get.back());
          }
        }
      });
    }
  }

  void checkPayPin(Function checkDone){
    if(havePayPassword.value == false){
      Get.to(()=>ChangePasswordPage(type: 2, check: false, have: false,))?.whenComplete(() async=> await havePassword());
      return;
    }else{
      DateTime now = DateTime.now();
      DateTime checkTime = StorageManager.getPayPasswordCheckTime();
      if((now.millisecondsSinceEpoch - checkTime.millisecondsSinceEpoch)/1000 < 300){
        checkDone.call();
      }else {
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

  Future<void> autoCheckPay(String orderNo) async{
    checkCount ++;
    bool payStatus = await PayApi.status(payOrderModel.type,orderNo);
    if(payStatus) {
      _timer.cancel();
      _onPayDone();
    }
    if (checkCount > 60) {
      _timer.cancel();
      Get.dialog(
        ConfirmDialog(
          cancelable: true,
          title: "Payment Result",
          info: "The payment result can not be confirmed, do you have finished it?",
          onConfirm: ()=>manualCheckPay(orderId),
        ),barrierColor: Colors.black26
      );
    }
  }

  Future<void> manualCheckPay(String orderNo) async{
    EasyLoading.show();
    bool payStatus = await PayApi.status(payOrderModel.type, orderNo);
    if(payStatus) {
      _onPayDone();
    }else{
      Get.dialog(
        ConfirmDialog(
          cancelable: true,
          title: "Payment Result",
          info: "The payment result still can not be confirmed, please contact our customer service.",
          onConfirm: ()=>Get.back(),
        ),barrierColor: Colors.black26
      );
    }
  }

  void _onPayDone(){
    if(payOrderModel.type == -1) {
      var cartController = Get.find<CartController>();
      cartController.clearCart();
    }
    Get.back();
    Get.dialog(
      ConfirmDialog(title: "Payment Result", info: "Payment Successful!"),barrierColor: Colors.black26
    ).then((value) => Get.back(result: true));
  }

  //原生返回事件调用
  void _onPayResult(dynamic content) async{
    if(payType.value == 4) { //alipay
      if (content.toString() == "6001") { //cancel
        EasyLoading.dismiss();
        _timer.cancel();
        Get.back(result: true);
        Get.dialog(ConfirmDialog(title: "Payment Result", info: "The payment has been canceled."),barrierColor: Colors.black26);
      }
    }else if(payType.value == 1){
      var result = content as Map;
      String code = result["code"];
      if(code == "0"){
        EasyLoading.showError("Payment failed");
        return;
      }
      String transactionId = result["data"];

      StorageManager.setCreditCardModel(cardModel);
      print("transactionId:$transactionId --- orderId:$orderId");
      UserController userController = Get.find<UserController>();
      if(userController.db != null){
        PayRecord payRecord = PayRecord();
        payRecord.createTime = DateTime.now();
        payRecord.orderId = orderId;
        payRecord.tranId = transactionId;
        await userController.db!.insertPayRecord(payRecord);
        Future.delayed(Duration(seconds: 2), ()=>userController.startPayNotify());
      }
      await PayApi.notifyCardPay(orderId, transactionId);
      if(payOrderModel.type == -1) {
        var cartController = Get.find<CartController>();
        cartController.clearCart();
      }
      EasyLoading.dismiss();
      Get.dialog(
        ConfirmDialog(title: "Payment Result", info: "Payment Successful!"),barrierColor: Colors.black26
      ).then((value) => Get.back(result: true));
    }
  }

}