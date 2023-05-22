import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import 'package:wy/config/icon_font.dart';
import 'package:wy/res/index.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/common/input_view.dart';
import 'package:wy/widget/scaffold_widget.dart';

import 'controller.dart';

class CreateGroupPage extends GetView<CreateGroupController> {
  ValueChanged<V2TimConversation>? directToChat;
  final V2TIMManager _sdkInstance = TIMUIKitCore.getSDKInstance();
  List<V2TimFriendInfo> selectedFriendList = [];


  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: AppBar(
        title: Text('Create Group'.tr),
      ),
      body: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView(
            children: [
              InputView(
                label: 'Group Name'.tr,
                tips: 'Enter group name'.tr,
                maxLength: 30,
                controller: controller.teRoomName,
              ),
              // InputView(
              //   label: 'Password'.tr,
              //   tips: 'Enter password'.tr,
              //   obscureText: true,
              //   controller: controller.tePwd,
              // ),
              // InputView(
              //   label: 'Number Limit'.tr,
              //   tips: 'Enter room name'.tr,
              //   customInput: Container(
              //     child: Row(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         Text(
              //           'Number Limit',
              //           style: ts1,
              //         ),
              //         Expanded(
              //             child: Container(
              //           child: PriceSlider(
              //             min: 10,
              //             max: 20,
              //             value: 15,
              //             index: 0,
              //             model: PriceRangeModel(gameCoinMax: 20, gameCoinMin: 10),
              //           ),
              //           height: 45.h,
              //         ))
              //       ],
              //     ),
              //     height: 45.h,
              //   ),
              // ),
              // InputView(
              //   label: 'Game name'.tr,
              //   tips: '',
              //   customInput: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         'Number Limit',
              //         style: ts1,
              //       ),
              //       arrowMore(color: Color(0xFFC5C3C6))
              //     ],
              //   ),
              // ),
              InputView(
                label: 'Group introduction'.tr,
                autoHeight: true,
                tips: '',
                customInput: TextField(
                  maxLines: 10,
                  maxLength: 120,
                  controller: controller.teIntrodution,
                  cursorColor: Colors.white70,
                  textAlign: TextAlign.start,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  onSubmitted: (text) => {},
                  decoration: InputDecoration(
                    hintText: 'Please enter...',
                    counterText: '',
                    hintStyle: inputHint(),
                    border: InputBorder.none,
                    //  contentPadding: EdgeInsets.only(bottom: 8)
                  ),
                ),
              ),

              30.verticalSpace,
              FloatingButton(
                label: 'Create Group'.tr,
                onTap: () => {controller.createGroup(context)},
              )
            ],
          )),
    );
  }
}
