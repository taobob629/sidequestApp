import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/pay_order_model.dart';
import '../../model/play_detail_model.dart';
import '../common/base_scaffold.dart';
import '../common/dialog_date_time_picker.dart';
import '../common/input_view.dart';
import '../common/quantity_selector.dart';
import '../common/select_view.dart';
import 'pay_button.dart';
import 'package:date_format/date_format.dart';

class PlayOrder extends StatelessWidget {

  late final SkillModel skillModel;
  late final PlayOrderController controller;
  late final String liveUid;

  PlayOrder({required String liveUid, required SkillModel skillModel}){
    controller = Get.put(PlayOrderController(liveUid, skillModel));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Play Order",
      body: Stack(
        children: [
          Positioned(
            left: 0,right: 0,top: 0,bottom: 0,
            child: SingleChildScrollView(
              child: Obx(()=>Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  _buildItem(),
                  _buildTime(),
                  _buildMemo(),
                  Container(height: 120,)
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

  Widget _buildItem(){
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(left: 15,right: 15,bottom: 10),
      decoration: BoxDecoration(
        color: Color(0xff28253D),
        borderRadius: BorderRadius.circular(12)
      ),
      child: Column(
        children: [
          Container(
            height: 105,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0x08ffffff),
            ),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  child: controller.skillModel.value.thumb == "" ? Container():CachedNetworkImage(
                    imageUrl: controller.skillModel.value.thumb,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          controller.skillModel.value.name,
                          maxLines: 2,
                          style: TextStyle(color: Colors.white,fontSize: 20,fontFamily: "DIN"),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(child: Text("",style: TextStyle(color: Colors.white54,fontSize: 12),)),
                          QuantitySelector(
                            initValue: 1,
                            tag: "1",
                            onQuantityChanged: (quantity){
                              controller.changeQuantity(quantity);
                            },
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10,right: 10,top: 15,bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset("assets/images/ic_balance_money.webp",width: 18,height: 18,),
                SizedBox(width: 4,),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    "${controller.skillModel.value.coin}",
                    style: TextStyle(color: Colors.white,fontSize: 20,fontFamily: "DIN"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 7.0,left: 5),
                  child: Text(
                    " / Hour",
                    style: TextStyle(color: Colors.white54,fontSize: 14,fontFamily: "DIN"),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTime(){
    return SelectView(
      label: "Play Time",
      tips: "What Time",
      value: formatDate(controller.time.value, [dd, '/', M, '/', yyyy, ' ', HH, ':', nn]),
      onTap: (){
        controller.showSelectTime();
      },
    );
  }

  Widget _buildMemo(){
    return InputView(
      label: "Remarks",
      tips: "remarks",
      controller: controller.remarksController,
    );
  }
}

class PlayOrderController extends GetxController {
  var totalAmount = 0.obs;

  var nums = 1.obs;

  var timeSelect = false.obs;

  var time = DateTime.now().obs;

  late TextEditingController remarksController;

  Rx<SkillModel> skillModel = SkillModel().obs;

  late final String liveUid;

  PlayOrderController(String liveUid, SkillModel skillModel){
    remarksController = TextEditingController();
    this.skillModel.value = skillModel;
    this.liveUid = liveUid;
    changeQuantity(1);
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    remarksController.dispose();
    super.onClose();
  }

  void changeQuantity(int quantity){
    totalAmount.value = skillModel.value.coin * quantity;
    nums.value = quantity;
  }

  void showSelectTime(){
    DateTime start = DateTime.now();
    Get.dialog<DateTime?>(DateTimePickerDialog(
      format: "dd-MMM-yyyy HH:mm",
      initDateTime: start,
      minDateTime: start,
      minuteDivider: 30,
    ),barrierColor: Colors.black26).then((value) {
      if(value != null){
        this.timeSelect.value = true;
        this.time.value = value;
      }
    }
    );
  }

  PayOrderModel getPayOrderModel(){
    PayOrderModel model = PayOrderModel();
    model.type = -2;
    model.totalAmount = totalAmount.value.toString();
    model.svctm = this.time.value.millisecondsSinceEpoch;
    model.liveuid = liveUid;
    model.skillid = skillModel.value.id;
    model.nums = nums.value;
    model.des = remarksController.text;
    return model;
  }

}