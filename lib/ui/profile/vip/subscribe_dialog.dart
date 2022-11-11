import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

import '../../common/colorful_button.dart';
import '../../common/wy_dialog.dart';

class SubscribeDialog extends StatelessWidget {

  final  subscribeDialogController = Get.put(SubscribeDialogController());

  @override
  Widget build(BuildContext context) {
    return WyDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "VIP Subscription".tr,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.circular(5)),
            child: CardField(
              onCardChanged: (card) {
                subscribeDialogController.card = card;
              },
            ),
          ),
          SizedBox(height: 10,),
          ColorfulButton(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "CONFIRM".tr,
                  style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "DIN"),
                ),
              ),
            height: 40,
            onTap: () {
              Get.back(result: true);
            }
          )
        ],
      ),
    );
  }
}

class SubscribeDialogController extends GetxController {
  CardFieldInputDetails? card;
}