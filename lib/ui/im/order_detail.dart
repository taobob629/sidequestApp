import 'package:ff_stars/ff_stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/ui/controller/user_controller.dart';

import '../../api/im_api.dart';
import '../../model/play_order_detail_model.dart';
import '../common/base_scaffold.dart';
import '../common/dialog_confirm.dart';
import 'dialog_comment.dart';

class OrderDetail extends StatelessWidget {

  late final int orderId;
  late final OrderDetailController controller ;

  OrderDetail({required this.orderId}){
    controller = Get.put(OrderDetailController(orderId));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Play Order Detail",
      body: Stack(
        children: [
          Positioned(
            left: 0,right: 0,top: 0,bottom: 0,
            child: SingleChildScrollView(
              child: Obx(()=>Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15,bottom: 20),
                    child: Text("Skill",style: TextStyle(fontSize: 18,color: Colors.white, fontFamily: "DIN"),),
                  ),
                  _buildSkillInfo(),
                  SizedBox(height: 20,),
                  _buildOrderInfo(),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text("Status",style: TextStyle(fontSize: 18,color: Colors.white, fontFamily: "DIN"),),
                  ),
                  _buildState(),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text("Comments",style: TextStyle(fontSize: 18,color: Colors.white, fontFamily: "DIN"),),
                  ),
                  _buildComments(context)
                ],
              ))
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
        child: _buildActionButton()
      )
    );
  }

  Widget _buildActionButton(){
    UserController userController = Get.find<UserController>();
    return Obx((){
        if(controller.playOrderDetailModel.value.status == 1){
          if(userController.userInfoModel.value.pwuserId == controller.playOrderDetailModel.value.fromUid){//发起人
            return ColorfulButton(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text("CANCEL",style: TextStyle(color: Colors.white,fontSize: 20,fontFamily: "DIN"),),
              ),
              height: 48,
              onTap: (){
                Get.dialog(ConfirmDialog(
                  title: "Cancel Order",
                  info: "Do you want to cancel this order?",
                  confirmBtn: "CONFIRM",
                  onConfirm: () async {
                    controller.cancelOrder();
                  },
                ),barrierColor: Colors.black26);
              },
            );
          }else if(userController.userInfoModel.value.pwuserId == controller.playOrderDetailModel.value.toUid){
            return Row(
              children: [
                Expanded(
                  child: ColorfulButton(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text("ACCEPT",style: TextStyle(color: Colors.white,fontSize: 20,fontFamily: "DIN"),),
                    ),
                    height: 48,
                    onTap: (){
                      controller.acceptOrder();
                    },
                  ),
                ),
                SizedBox(width: 15,),
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      Get.dialog(ConfirmDialog(
                        title: "Reject Order",
                        info: "Do you want to reject this order?",
                        confirmBtn: "CONFIRM",
                        onConfirm: () async {
                          controller.rejectOrder();
                        },
                      ),barrierColor: Colors.black26);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text("REJECT",style: TextStyle(color: Colors.white,fontSize: 20,fontFamily: "DIN"),),
                        ),
                      ),
                      height: 48
                    ),
                  ),
                )
              ],
            );
          }
        }else if(controller.playOrderDetailModel.value.status == 2){
          if(userController.userInfoModel.value.pwuserId == controller.playOrderDetailModel.value.fromUid) {
            return ColorfulButton(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text("FINISHED", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "DIN"),),
              ),
              height: 48,
              onTap: () {
                Get.dialog(
                  CommentDialog(controller.orderId, ()=>Get.back(),),
                  barrierColor: Colors.black26
                );
              },
            );
          }
        }
        return Container();
    });
  }

  Widget _buildSkillInfo(){
    return Container(
      height: 66,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          controller.playOrderDetailModel.value.icon == "" ? Container():
          Image.network("${controller.playOrderDetailModel.value.icon}",width: 66,height: 66,fit: BoxFit.cover,),
          SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("${controller.playOrderDetailModel.value.gameName}",style: TextStyle(color: Colors.white,fontSize: 14),),
              Text("",style: TextStyle(color: Colors.white54,fontSize: 12),),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                  Text("",style: TextStyle(color: Colors.white54,fontSize: 12),),
                ],
              )
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget _buildOrderInfo(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Information",style: TextStyle(fontSize: 18,color: Colors.white, fontFamily: "DIN"),),
          //_infoItem("Order Time","2022-09-12 23:00:00"),
          _infoItem("Order Number","${controller.playOrderDetailModel.value.orderno}"),
          _infoItem("Service Time","${DateFormat('dd/MM/y HH:mm:ss', 'en_GB').format(DateTime.fromMillisecondsSinceEpoch(controller.playOrderDetailModel.value.svctm))}"),
          _infoItem("Service Duration","${controller.playOrderDetailModel.value.nums} ${controller.playOrderDetailModel.value.nums > 1 ? 'Hours':'Hour'}"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child: Row(
              children: [
                Text("Total Price", style: TextStyle(fontSize: 12, color: Colors.white54),),
                Spacer(),
                Image.asset("assets/images/ic_balance_money.webp",width: 14,height: 14,),
                SizedBox(width: 4,),
                Text("${controller.playOrderDetailModel.value.total}", style: TextStyle(fontSize: 14, color: Colors.white),),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _infoItem(String title, String value){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: Row(
        children: [
          Text("$title", style: TextStyle(fontSize: 12, color: Colors.white54),),
          Spacer(),
          Text("$value", style: TextStyle(fontSize: 14, color: Colors.white),),
        ],
      ),
    );
  }

  Widget _buildState(){
    var status = controller.playOrderDetailModel.value.status;
    if(status == 0){
      return Container();
    }

    String serviceState = "Waiting";
    Color serviceColor = Colors.blue;
    if(status == 2){
      serviceState = "Serving";
      serviceColor = Colors.green;
    }else if(status == -2){
      serviceState = "Served";
      serviceColor = Colors.green;
    }

    String finishState = "Comment";
    Color finishColor = Colors.blue;
    if(status == -1){
      finishState = "Canceled";
      finishColor = Colors.green;
    }else if(status == -3){
      finishState = "Rejected";
      finishColor = Colors.green;
    }else if(status == -2){
      finishState = "Complete";
      finishColor = Colors.green;
    }

    return Container(
      height: 80,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 45,
            child: Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 35),
              color: Colors.white24,
            )
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 80,
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 6,
                      ),
                      Container(
                        height: 16,
                        child: Text("Paid",style: TextStyle(color: Colors.white,fontSize: 12),)
                      )
                    ],
                  ),
                ),
            status == -1 || status == -3? Container():
                Container(
                  width: 80,
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: serviceColor,
                        radius: 6,
                      ),
                      Container(
                        height: 16,
                        child: Text(serviceState,style: TextStyle(color: Colors.white,fontSize: 12),)
                      )
                    ],
                  ),
                ),
                Container(
                  width: 80,
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: finishColor,
                        radius: 6,
                      ),
                      Container(
                        height: 16,
                        child: Text(finishState,style: TextStyle(color: Colors.white,fontSize: 12),)
                      )
                    ],
                  ),
                )
              ],
            )
          )
        ],
      ),
    );
  }

  Widget _buildComments(BuildContext context){
    double width = MediaQuery.of(context).size.width;
    print(controller.playOrderDetailModel.value.star);
    if(controller.playOrderDetailModel.value.star == 0){
      return Container();
    }
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20,),
          FFStars(
            normalStar: Image.asset("assets/images/play/score0.png"),
            selectedStar: Image.asset("assets/images/play/score1.png"),
            step: 0.01,
            defaultStars: controller.playOrderDetailModel.value.star,
            starHeight: 20,
            starWidth: 20,
            starMargin: 16,
            followChange: true,
            justShow: true,
          ),
          SizedBox(height: 20,),
          Text(
            "${controller.playOrderDetailModel.value.comments}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }
}

class OrderDetailController extends GetxController {
  Rx<PlayOrderDetailModel> playOrderDetailModel = PlayOrderDetailModel().obs;
  late int orderId;

  OrderDetailController(int orderId){
    this.orderId = orderId;
  }

  @override
  void onInit() {
    super.onInit();

  }

  @override
  void onReady() {
    super.onReady();
    ImApi.getPlayOrderDetail(orderId).then((value) => playOrderDetailModel.value = value);
  }

  void cancelOrder(){
    Get.back();
    EasyLoading.show();
    ImApi.cancelOrder(orderId.toString());
    EasyLoading.dismiss();
    Get.back();
  }

  void acceptOrder(){
    EasyLoading.show();
    ImApi.acceptOrder(orderId.toString());
    EasyLoading.dismiss();
    Get.back();
  }

  void rejectOrder(){
    Get.back();
    EasyLoading.show();
    ImApi.rejectOrder(orderId.toString());
    EasyLoading.dismiss();
    Get.back();
  }
}