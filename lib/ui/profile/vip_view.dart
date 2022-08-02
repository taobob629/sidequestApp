import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/profile/profile_page.dart';

import 'vip/vip_page.dart';

class VipView extends StatelessWidget {

  final String title;
  final String icon;
  final int level;
  final int index;
  final double fee;

  final profilePageController = Get.find<ProfilePageController>();
  final userController = Get.find<UserController>();

  VipView({
    required this.level,
    required this.index,
    required this.title,
    required this.icon,
    required this.fee
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Color(0xFF1F1D30),
        borderRadius: BorderRadius.circular(12)
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: (){
          userController.checkLogin(()=>Get.to(()=>VipPage(vipLevel: level, vipIndex: index,list: profilePageController.vipInfoList,))?.whenComplete(() => userController.updateInfo()));
          },
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/images/$icon.webp",width: 30,height: 30,),
              SizedBox(width: 5,),
              Padding(
                padding: const EdgeInsets.only(top:4.0),
                child: Text(title,style: TextStyle(fontSize: 20,fontFamily:"DIN", color: Colors.white),),
              ),
              SizedBox(width: 10,),
              userController.userInfoModel.value.vipLevel < level?
              ColorfulButton(
                height: 26,
                child: Container(
                  padding: const EdgeInsets.only(left: 10,right: 10,bottom: 0),
                  child: Text(fee == 0 ? "Invite Only":"£$fee",style: TextStyle(fontSize: 10,color: Colors.white),),
                ),
                onTap: ()=>Get.to(()=>VipPage(vipLevel: level, vipIndex: index,list: profilePageController.vipInfoList)),
              ):Container(
                height: 26,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: Colors.white12
                ),
                padding: const EdgeInsets.only(left: 10,right: 10,bottom: 0),
                child: Center(child: Text("Subscribed",style: TextStyle(fontSize: 10,color: Colors.white54),)),
              )
            ],
          ),
        ),
      ),
    );
  }
}