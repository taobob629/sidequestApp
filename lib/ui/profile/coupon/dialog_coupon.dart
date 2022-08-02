import 'package:ai_barcode/ai_barcode.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/ui/common/wy_dialog.dart';

import '../../../model/coupon_model.dart';

class CouponDialog extends StatelessWidget {

  final CouponModel model;
  final CouponDialogController controller = Get.put(CouponDialogController());
  CouponDialog({required this.model});

  @override
  Widget build(BuildContext context) {
    return WyDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("${model.name}",style: TextStyle(fontSize: 16, color: Colors.white),),
          SizedBox(height: 20,),
          Container(
            width: 300,
            height: 300,
            child: PlatformAiBarcodeCreatorWidget(
              creatorController: controller.controller,
              initialValue: model.qrcode,
            ),
          ),
          SizedBox(height: 15,),
          Text("${model.couponCode}",style: TextStyle(fontSize: 18, color: Colors.white),),
          SizedBox(height: 15,),
          Text("Expire date : ${model.expireTime}",style: TextStyle(fontSize: 14, color: Colors.white),),
        ],
      ),
    );
  }
}

class CouponDialogController extends GetxController {
  CreatorController controller = CreatorController();
}