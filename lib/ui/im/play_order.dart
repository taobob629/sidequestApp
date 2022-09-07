import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/model/play_item_model.dart';

import '../common/base_scaffold.dart';
import '../common/quantity_selector.dart';
import 'pay_button.dart';

class PlayOrder extends StatelessWidget {

  final controller = Get.put(PlayOrderController());

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
                  child: CachedNetworkImage(
                    imageUrl: controller.playItem.value.icon,
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
                          controller.playItem.value.name,
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
                            onQuantityChanged: (quantity){},
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    "£ 20.0",
                    style: TextStyle(color: Colors.white,fontSize: 20,fontFamily: "DIN"),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PlayOrderController extends GetxController {
  var totalAmount = 0.0.obs;

  var playItem = PlayItemModel().obs;

  @override
  void onInit() {
    super.onInit();
    playItem.value.icon = "http://p2.itc.cn/images01/20201106/bd3499c7f6694ef68dcf84f7085bf071.jpeg";
    playItem.value.name = "LEAGUE OF LEGENDS";
  }

}