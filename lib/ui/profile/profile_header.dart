import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/model/vip_info_model.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/im/play_detail.dart';
import 'package:wy/ui/playwith/play_profile_page.dart';
import 'package:wy/ui/profile/energy_view.dart';
import 'package:wy/ui/profile/profile_page.dart';
import 'package:wy/utils/navigator_helper.dart';
import 'package:wy/utils/storage_manager.dart';

import 'balance/balance_page.dart';
import 'count_info.dart';
import 'vip/vip_page.dart';
import 'vip_view.dart';

class ProfileHeader extends StatelessWidget {

  final controller = Get.find<UserController>();

  final profilePageController = Get.find<ProfilePageController>();
  @override
  Widget build(BuildContext context) {
    return Obx(()=>Stack(
      children: [
        Container(
          height: profilePageController.online.value ? 320 : 250,
          margin: const EdgeInsets.only(left: 10,right: 10,top: 40),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x66171525),Colors.transparent]
            )
          ),
        ),
        Positioned(
          left: 15,
          top: 15,
          child: Offstage(
            offstage: controller.user.value.id == 0,
            child: GestureDetector(
              onTap: ()=>profilePageController.goDev(),
              child: Text(
                "ID:${controller.user.value.memberCode}",
                style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.w300),
              ),
            ),
          )
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () {
              // if(controller.userInfoModel.value.isauth==1){
                controller.checkLogin(()=>Get.to(()=>PlayDetail(userId: "${controller.userInfoModel.value.pwuserId}")));
              // }else{
              //   controller.checkLogin(()=>NavigatorHelper.gotoEditProfilePage());
              // }
            },
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 40,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: _buildAvatar()
              )
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 95,
          child: GestureDetector(
            onTap: ()=>profilePageController.goDev(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${controller.userInfoModel.value.nick}",
                  style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w400),
                ),
                _buildLevelIcon()
              ],
            ),
          )
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${controller.user.value.email}", style: TextStyle(color: Colors.white38,fontSize: 12,fontWeight: FontWeight.w300),)
            ],
          )
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CountInfo(
                icon: "corns",
                label: profilePageController.online.value ? "£${controller.userInfoModel.value.balance}" : "${controller.userInfoModel.value.balance}",
                info: profilePageController.online.value ? "Credits" : "Online Time",
                onTap: ()=>controller.checkLogin(()=>profilePageController.online.value ? Get.to(()=>BalancePage())?.whenComplete(() => controller.updateInfo()):null),
              ),
              CountInfo(
                icon: "times",
                label: "${controller.userInfoModel.value.freeMins}",
                info: "Free Time",
                onTap: ()=>controller.checkLogin(
                    ()=>profilePageController.online.value ? Get.to(
                        ()=>VipPage(vipLevel: 1, vipIndex: 0,list: profilePageController.vipInfoList,)
                    ):null
                ),
              ),
              CountInfo(
                icon: "coupons",
                label: "${controller.userInfoModel.value.coupons}",
                info: "Vouchers",
                onTap: ()=>controller.checkLogin(()=>NavigatorHelper.gotoCouponPage(
                  whenComplete: () => controller.updateInfo()
                )),
              ),
            ],
          )
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 235,
          child: EnergyView(
            percent: controller.userInfoModel.value.total == 0 ? 0 : controller.userInfoModel.value.remain.toDouble() / controller.userInfoModel.value.total,
            remaining: controller.userInfoModel.value.remain,
          )
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: profilePageController.online.value ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _buildVipViews(),
            ),
          ) : Container()
        ),
      ],
    ));
  }

  Widget _buildAvatar(){
    if(controller.user.value.id == 0){
      return _defaultAvatar();
    }else{
      if(controller.userInfoModel.value.avatar.isEmpty){
        return _defaultAvatar();
      }else{
        // return Container(
        //   width: 76,
        //   height: 76,
        //   clipBehavior: Clip.antiAlias,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(40),
        //     image:DecorationImage(
        //       image: NetworkImage(controller.userInfoModel.value.avatar,),
        //       fit: BoxFit.cover,
        //     )
        //   )
        // );
        return CachedNetworkImage(
          imageUrl: "${controller.userInfoModel.value.avatar}",
          fit: BoxFit.cover,
          imageBuilder: (context,provider){
            return Container(
              width: 76,
              height: 76,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                image:DecorationImage(
                  image: provider,
                  fit: BoxFit.cover,
                )
              ),
            );
          },
        );
      }
    }
  }

  Widget _defaultAvatar(){
    return Container(
      width: 76,
      height: 76,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        image:DecorationImage(
          image: AssetImage("assets/images/default_logo.webp"),
          fit: BoxFit.cover,
        )
      ),
    );
  }

  Widget _buildLevelIcon(){
    if(controller.userInfoModel.value.vipLevel == 0){
      return Container();
    }else{
      return Image.asset("assets/images/ic_level${controller.userInfoModel.value.vipLevel}.webp",width: 26,height: 26,);
    }
  }

  List<Widget> _buildVipViews(){
    List<Widget> list = [];
    list.add(SizedBox(width: 20),);
    for(int i = 0; i < profilePageController.vipInfoList.length;i++ ){
      VipInfoModel infoModel = profilePageController.vipInfoList[i];
      list.add(VipView(
        title: infoModel.name,
        icon: "ic_level${infoModel.level}",
        level: infoModel.level,
        index: i,
        fee: infoModel.monthFee
      ),);
      list.add(SizedBox(width: 20),);
    }
    return list;
  }
}