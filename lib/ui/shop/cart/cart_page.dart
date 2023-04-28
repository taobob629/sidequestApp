import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:wy/api/address_api.dart';
import 'package:wy/model/address_model.dart';
import 'package:wy/model/pay_order_model.dart';
import 'package:wy/ui/common/base_scaffold.dart';
import 'package:wy/ui/controller/cart_controller.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/profile/address/default_address.dart';
import 'package:wy/ui/shop/cart/pay_button.dart';
import 'package:wy/utils/navigator_helper.dart';
import 'package:wy/utils/toast_utils.dart';

import 'cart_item.dart';
import 'dart:convert';

class CartPage extends StatelessWidget {

  final controller = Get.find<CartController>();

  final pageController = Get.put(CartPageController());

  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Shopping Cart".tr,
        body: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: SingleChildScrollView(
                  child: Obx(() => Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          _buildAddress(context),
                          _buildItems(),
                          _buildCoupon(),
                          _buildFee("Subtotal".tr, controller.totalAmount.value - controller.totalTax.value),
                          _buildFee("VAT".tr, controller.totalTax.value),
                          _buildFee("Delivery".tr, controller.shippingFee.value, decoration: controller.shippingFee.value > 0 ? TextDecoration.lineThrough : TextDecoration.none),
                          Container(
                            height: 120,
                          )
                        ],
              ))
            ),
          ),
          Positioned(
            left: 0,right: 0,bottom: 0,
            child: PayButton()
          )
        ],
      )
    );
  }

  Widget _buildAddress(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: DefaultAddress(
        selectable: true,
        addressModel: pageController.defaultAddress.value,
        selectAddress: ()=>userController.checkLogin(()=>pageController.selectAddress()),
      )
    );
  }

  Widget _buildItems(){
    List<Widget> list = [];
    for(var item in controller.productList){
      list.add(CartItem(product: item));
    }
    return Column(
      children: list,
    );
  }

  Widget _buildCoupon(){
    return Column(
      children: [
        GestureDetector(
          onTap: ()=>userController.checkLogin(
              ()=>NavigatorHelper.gotoCouponPage(
              payOrderModel: pageController.getPayOrderModel(),
              onSelect: (model)=>controller.couponSelect(model)
            )
          ),
          child: Container(
            padding: const EdgeInsets.only(left: 15,right: 15,top: 15),
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Vouchers".tr,
                  style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: "DIN"),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        Offstage(
          offstage: controller.coupon.value.id == 0,
          child: Container(
            padding: const EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 0),
            color: Colors.transparent,
            child: Row(
              children: [
                GestureDetector(
                  onTap:()=>controller.cancelCoupon(),
                  child: Container(
                    padding: const EdgeInsets.only(left: 5,right:5,),
                    color: Colors.transparent,
                    child: Icon(Icons.cancel,size: 20,color: Colors.red,)
                  ),
                ),
                Text(
                  "${controller.coupon.value.name}(${controller.coupon.value.discount}% off)",
                  style: TextStyle(color: Colors.white54,fontSize: 14),
                ),
                Spacer(),
                Text(
                  "- £ ${controller.discount.value}",
                  style: TextStyle(color: Colors.white54,fontSize: 14),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildFee(String title, double fee,{TextDecoration? decoration}){
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,style: TextStyle(color: Colors.white,fontSize: 16,fontFamily: "DIN"),),
          Text(
            fee >=0 ? "£ ${fee.toStringAsFixed(2)}" : "- £ ${(-fee).toStringAsFixed(2)}",
            style: TextStyle(color: Colors.white54,fontSize: 14, decoration: decoration),
          ),
        ],
      ),
    );
  }
}

class CartPageController extends GetxController {
  Rx<AddressModel> defaultAddress = AddressModel().obs;

  final cartController = Get.find<CartController>();

  @override
  void onInit() {
    super.onInit();
    cartController.getTotalAmount();
  }

  @override
  void onReady() async {
    super.onReady();
    List<AddressModel> list = await AddressApi.list();
    try {
      defaultAddress.value = list.firstWhere((element) => element.useDefault);
    }catch(e){
      defaultAddress.value = list.first;
    }
  }

  @override
  void onClose() {
    super.onClose();
    dismissLoading();
  }

  void selectAddress() async{
    AddressModel? model  = await NavigatorHelper.gotoAddressPage(select: true);
    if(model != null){
      defaultAddress.value = model;
    }
  }

  PayOrderModel getPayOrderModel(){
    var controller = Get.find<CartController>();
    PayOrderModel payOrderModel = PayOrderModel();
    payOrderModel.type = -1;
    payOrderModel.addressId = defaultAddress.value.id;
    payOrderModel.goodsPrice = "${controller.totalPrice.value}";
    payOrderModel.freightPrice = "${controller.shippingFee.value}";
    payOrderModel.tax = "${controller.totalTax.value}";
    payOrderModel.couponCode = controller.coupon.value.couponCode;
    payOrderModel.couponId = controller.coupon.value.id;
    payOrderModel.couponPrice = controller.discount.value.toString();
    payOrderModel.totalAmount = controller.totalAmount.value.toStringAsFixed(2);
    payOrderModel.orderShot = json.encode(controller.productList);
    return payOrderModel;
  }
}