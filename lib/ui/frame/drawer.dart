/*
  drawer
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/res/styles.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/frame/home/view.dart';
import 'package:wy/widget/lable.dart';

List<Map> users = [
  Map()
    ..['title'] = 'Game accounts'
    ..['action'] = () => EasyLoading.showToast('FAQ'),
  Map()
    ..['title'] = 'Friends'
    ..['action'] = () => EasyLoading.showToast('Help Center'),
];
List<Map> supports = [
  Map()
    ..['title'] = 'Teams'
    ..['action'] = () => EasyLoading.showToast('FAQ'),
  Map()
    ..['title'] = 'My sidequest subscription'
    ..['action'] = () => EasyLoading.showToast('Help Center'),
  Map()
    ..['title'] = 'Profile'
    ..['action'] = () => EasyLoading.showToast('Give us feedback'),
  Map()
    ..['title'] = 'Password'
    ..['action'] = () => EasyLoading.showToast('Give us feedback'),
  Map()
    ..['title'] = 'Language'
    ..['action'] = () => EasyLoading.showToast('Give us feedback'),
  Map()
    ..['title'] = 'Connections'
    ..['action'] = () => EasyLoading.showToast('Give us feedback'),
];
List<Map> legals = [
  Map()
    ..['title'] = 'Terms of use'
    ..['action'] = () => EasyLoading.showToast('FAQ'),
  Map()
    ..['title'] = 'Privacy Policy'
    ..['action'] = () => EasyLoading.showToast('Help Center'),
];

class HomeDrawer extends StatelessWidget {
  final user = Get.find<UserController>().userInfoModel?.value;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: Get.width,
      backgroundColor: AppColor.background,
      child: ListView(
        children: <Widget>[
          AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 16,
              ),
              onPressed: () => drawerKey.currentState?.closeDrawer(),
            ),
          ),
          DrawerHeader(
            // drawer的头部控件
            decoration: BoxDecoration(),
            child: ListTile(
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 40.w,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(
                      user?.avatar ?? '',
                    ),
                  )
                ],
              ),
              title: Text(
                '${user?.nick}',
                style: PageStyle.ts_FFFFFF_15sp,
              ),
              dense: false,
              subtitle: Text(
                'View profile',
                style: PageStyle.ts_FFFFFF_15sp,
              ),
              trailing: IconButton(
                iconSize: 16,
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white54,
                ),
                onPressed: () {},
              ),
            ),
          ),
          LableWidget(label: 'Support'.tr),
          Column(
            children: supports.map((e) => _listItem(e['title'], onTapMore: e['action'])).toList(),
          )
        ],
      ),
    );
  }

  Widget _listItem(var label, {Function()? onTapMore}) {
    return ListTile(
      // 子项
      leading: SizedBox(
        width: 20,
      ),
      title: Text(
        '$label',
        style: PageStyle.labelStyle,
      ),
      trailing: IconButton(
        icon: Icon(
          Icons.arrow_forward_ios,
          color: Colors.white54,
          size: 16,
        ),
        onPressed: onTapMore,
      ),
    );
  }
}
