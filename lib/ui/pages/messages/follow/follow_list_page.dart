import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import '../../../../api/im_api.dart';
import '../../../../api/user_api.dart';
import '../../../../common/base_scaffold.dart';
import '../../../../common/floating_button.dart';
import '../../../../common/getx_refresh_controller.dart';
import '../../../../config/app_color.dart';
import '../../../../controller/user_controller.dart';
import '../../../../model/attention_model.dart';
import '../../../../utils/navigator_helper.dart';
import '../../../../utils/toast_utils.dart';
import '../../../../utils/utils.dart';
import '../../../../widget/level.dart';
import '../../../../widget/sex_age_widget.dart';
import '../chat/custom_message_view.dart';

class FollowListPage extends StatelessWidget {
  static void to({var groupName, var gid}) {
    Get.to(() => FollowListPage(),
        arguments: {}
          ..['group_name'] = groupName
          ..['gid'] = gid
          ..['select_mode'] = true);
  }

  FollowListPage({Key? key}) : super(key: key);

  final t = Get.put(FollowListController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'My Followings'.tr,
      body: Obx(
        () => SmartRefresher(
            controller: t.refreshController,
            onLoading: () => t.loadMore(),
            onRefresh: () => t.onRefresh(),
            enablePullUp: true,
            child: ListView.builder(
                itemCount: t.list.length,
                itemBuilder: (context, index) {
                  final model = t.list[index];
                  return Container(
                    height: 60,
                    margin: EdgeInsets.symmetric(horizontal: 14, vertical: 15),
                    child: Row(
                      children: [
                        Visibility(
                            visible: t.selelctMode,
                            child: Obx(() => Checkbox(
                                  value: model.isSelet,
                                  onChanged: (bool? value) {
                                    model.isSelet = value ?? false;
                                  },
                                ))),
                        GestureDetector(
                            onTap: () =>
                                NavigatorHelper.toOtherProfile(model.id),
                            child: CachedNetworkImage(
                                imageUrl: model.avatar,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover)),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  model.name,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  children: [
                                    SexAndAgeWidget(
                                      age: model.age,
                                      sex: model.sex,
                                    ),
                                    6.horizontalSpace,
                                    GameLevelWidget(
                                      height: 16.h,
                                      level: model.isAuth == 0
                                          ? model.titlesLevel
                                          : model.userLevel,
                                      isAuth: model.isAuth,
                                      userId:
                                          UserController.find.userProfile.pwId,
                                    ),
                                  ],
                                ),
                                Text(
                                  model.signature,
                                  style: TextStyle(
                                      fontSize: 12, color: AppColor.whiteGray),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // if (model.isFans)
                        GestureDetector(
                          onTap: () {
                            t.unFollow(model.id);
                          },
                          child: Container(
                            height: 28,
                            width: 76,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: AppColor.itemBg,
                                borderRadius: BorderRadius.circular(14)),
                            child: Text("UnFollow".tr,
                                style: TextStyle(
                                    color: AppColor.whiteGray, fontSize: 13)),
                          ),
                        )
                        // else
                        // Container(
                        //   height: 28,
                        //   width: 76,
                        //   alignment: Alignment.center,
                        //   decoration: BoxDecoration(border: Border.all(color: AppColor.yellow), borderRadius: BorderRadius.circular(14)),
                        //   child: Text("+ Follow", style: TextStyle(color: AppColor.yellow, fontSize: 13)),
                        // )
                      ],
                    ),
                  );
                })),
      ),
      floatingActionButton: Visibility(
        visible: t.selelctMode,
        child: FloatingButton(
          label: 'Invite'.tr,
          onTap: () => t.invite(),
        ),
      ),
    );
  }
}

class FollowListController extends GetxRefreshController<AttentionModel> {
  bool selelctMode = false;
  var gid = '';
  var groupName = '';
  var selects = [];

  @override
  void onInit() {
    super.onInit();
    Map? param = Get.arguments;
    if (param != null) {
      selelctMode = param['select_mode'];
      gid = param['gid'];
      groupName = param['group_name'];
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  unFollow(touid) {
    showLoading();
    UserApi.attention(touid).then((value) {
      onRefresh();
      UserController.find.updateInfo();
      dismissLoading();
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  @override
  Future<List<AttentionModel>> loadData({int pageNum = 1}) async {
    // TODO: implement loadData
    return await UserApi.followList(pageNum, 20);
  }

  invite() async {
    var selects = list.where((item) => item.isSelet);
    if (selects.isEmpty) {
      showToast('please select at least one user to share!'.tr);
      return;
    }
    var ids = selects.map((e) => e.uk).toList();
    flog('$ids ');
    ImApi.shareGroup({}
      ..['shareIds'] = ids
      ..['groupId'] = gid
      ..['name'] = groupName
      ..['invitor'] = UserController.find.userProfile.nickName);
    showToast('Share sucess!'.tr);
    Get.back();
    return;
    var nickName = UserController.find.userProfile.nickName;
    var params = Map()
      ..['invitor'] = nickName // 邀请人名字
      ..['type'] = MessageType.TYPE_INVITE //invite
      ..['groupId'] = gid //群id
      ..['group_name'] = groupName; //群名字
    flog('params $params');
    V2TimValueCallback<V2TimMsgCreateInfoResult> createCustomMessageRes =
        await TencentImSDKPlugin.v2TIMManager
            .getMessageManager()
            .createCustomMessage(
              data: json.encode(params),
              desc: '',
              extension: '自定义extension',
            );
    flog(createCustomMessageRes.code);
    if (createCustomMessageRes.code == 0) {
      //发送消息
      String? id = createCustomMessageRes.data?.id;
      V2TimValueCallback<V2TimMessage> sendMessageRes = await TencentImSDKPlugin
          .v2TIMManager
          .getMessageManager()
          .sendMessage(id: id!, receiver: "UK20021778", groupID: "");
      if (sendMessageRes.code == 0) {
        // 发送成功
      } else {
        showToast('邀请失败,错误码${sendMessageRes.code}');
      }
      flog(sendMessageRes.code);
    } else {
      showToast('邀请失败,错误码${createCustomMessageRes.code}');
    }
  }
}
