import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/ui/common/colorful_button.dart';

import '../../model/play_order_detail_model.dart';
import '../common/base_scaffold.dart';

class OrderDetail extends StatelessWidget {

  late final PlayOrderDetailModel playOrderDetailModel;
  late final OrderDetailController controller ;

  OrderDetail({required this.playOrderDetailModel}){
    controller = Get.put(OrderDetailController(playOrderDetailModel));
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
                    child: Text("Order Skill",style: TextStyle(fontSize: 18,color: Colors.white, fontFamily: "DIN"),),
                  ),
                  _buildSkillInfo(),
                  SizedBox(height: 20,),
                  _buildOrderInfo(),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text("Order Status",style: TextStyle(fontSize: 18,color: Colors.white, fontFamily: "DIN"),),
                  ),
                  _buildState()
                ],
              ))
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
        child: ColorfulButton(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text("SCORE",style: TextStyle(color: Colors.white,fontSize: 20,fontFamily: "DIN"),),
          ),
          onTap: (){},
        ),
      )
    );
  }

  Widget _buildSkillInfo(){
    return Container(
      height: 66,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
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
          Text("Order Information",style: TextStyle(fontSize: 18,color: Colors.white, fontFamily: "DIN"),),
          //_infoItem("Order Time","2022-09-12 23:00:00"),
          _infoItem("Order Number","${controller.playOrderDetailModel.value.orderno}"),
          _infoItem("Service Duration","${controller.playOrderDetailModel.value.nums} hours"),
          _infoItem("Total Price","£ ${controller.playOrderDetailModel.value.total}"),
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
                      Text("已付款",style: TextStyle(color: Colors.white,fontSize: 12),)
                    ],
                  ),
                ),
                Container(
                  width: 80,
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 6,
                      ),
                      Text("待服务",style: TextStyle(color: Colors.white,fontSize: 12),)
                    ],
                  ),
                ),
                Container(
                  width: 80,
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 6,
                      ),
                      Text("待评价",style: TextStyle(color: Colors.white,fontSize: 12),)
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
}

class OrderDetailController extends GetxController {
  Rx<PlayOrderDetailModel> playOrderDetailModel = PlayOrderDetailModel().obs;

  OrderDetailController(PlayOrderDetailModel model){
    playOrderDetailModel.value = model;
  }

  @override
  void onInit() {
    super.onInit();

  }

  @override
  void onReady() {
    super.onReady();

  }
}