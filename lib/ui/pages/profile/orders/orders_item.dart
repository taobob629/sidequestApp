import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/ui/pages/profile/orders/tab_order_page.dart';

import '../../../../api/order_api.dart';
import '../../../../common/colorful_button.dart';
import '../../../../model/order_model.dart';
import '../../../../model/product_item_model.dart';
import '../../../dialog/dialog_confirm.dart';

class OrdersItem extends StatelessWidget {

  final OrderModel orderModel;
  final int status;

  late final OrdersItemController ordersItemController;

  OrdersItem({required this.orderModel, required this.status}){
    ordersItemController = Get.put(OrdersItemController(orderModel: orderModel,status: status),tag: orderModel.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xff28253D),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildDetail()
      ),
    );
  }

  List<Widget> _buildDetail(){
    List<Widget> list = [];

    list.add(
      Container(
        color: Color(0x08ffffff),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
              child: Text("${orderModel.orderId}",style: TextStyle(color: Colors.white,fontSize: 11),),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
              child: Text("${orderModel.createTime}",style: TextStyle(color: Colors.white54,fontSize: 11),),
            )
          ],
        ),
      )
    );

    for(ProductItemModel productItemModel in orderModel.products){
      list.add(
        Container(
          height: 105,
          padding: const EdgeInsets.all(10),
          color: Color(0x08ffffff),
          child: Row(
            children: [
              Container(
                width: 90,
                height: 95,
                child: CachedNetworkImage(
                  imageUrl: productItemModel.image,
                  fit: BoxFit.cover,
                )
              ),
              SizedBox(width: 10,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "${productItemModel.name}",
                        maxLines: 2,
                        style: TextStyle(color: Colors.white,fontSize: 20,fontFamily: "DIN"),
                      ),
                    ),
                    Row(
                      children: [
                        Text("£ ${productItemModel.price}",style: TextStyle(color: Colors.white54,fontSize: 12)),
                        SizedBox(width: 10,),
                        Text("VAT: £ ${productItemModel.tax}",style: TextStyle(color: Colors.white54,fontSize: 12)),
                        Spacer(),
                        Text("×${productItemModel.count}",style: TextStyle(color: Colors.white54,fontSize: 12)),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        )
      );
    }

    list.add(
      Container(
        padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                "${'Total'.tr} : £ ${orderModel.totalAmount}",
              style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "DIN"),
            ),
            ),
            Spacer(),
            Offstage(
              offstage: true,
              child: ColorfulButton(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    "Repay".tr,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                height: 26
              ),
            ),
            SizedBox(width: 20,),
            Offstage(
              offstage: status != 0,
              child: GestureDetector(
                onTap: ()=> ordersItemController.deleteOrder(),
                child: Image.asset("assets/images/ic_delete.webp",width: 26,)
              )
            )
          ],
        ),
      )
    );
    return list;
  }
}

class OrdersItemController extends GetxController{
  final OrderModel orderModel;
  final int status;
  OrdersItemController({required this.orderModel, required this.status});

  void deleteOrder(){
    Get.dialog(ConfirmDialog(title: "Delete Order", info: "Do you confirm to delete this order?"),barrierColor: Colors.black26)
      .then((value) async{
        if(value != null && value){
          await OrderApi.delete(orderModel.orderId);
          TabOrderPageController tabOrderPageController = Get.find<TabOrderPageController>(tag: "$status");
          tabOrderPageController.reload();
        }
      });
  }
}