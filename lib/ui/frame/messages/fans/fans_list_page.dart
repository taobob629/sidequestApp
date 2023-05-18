import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:wy/api/im_api.dart';
import 'package:wy/api/user_api.dart';
import 'package:wy/common/getx_refresh_controller.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/model/attention_model.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/frame/messages/chat/custom_message_view.dart';
import 'package:wy/ui/im/im_util.dart';
import 'package:wy/utils/image_util.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/utils/navigator_helper.dart';
import 'package:wy/utils/toast_utils.dart';

import '../../../../widget/home/sex_age_widget.dart';
import '../../../common/base_scaffold.dart';

class FansListPage extends StatelessWidget {
  FansListPage({Key? key}) : super(key: key);
  static void to({var groupName, var gid}) {
    Get.toNamed(AppPages.FansList,
        arguments: Map()
          ..['group_name'] = groupName
          ..['gid'] = gid
          ..['select_mode'] = true);
  }
  final t = Get.put(FansListController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'My Followers'.tr,
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
                    height: 48,
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
                            child: ImageUtil.networkImage(
                                url: model.avatar,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover)),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    model.name,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  6.horizontalSpace,
                                  SexAndAgeWidget(
                                    age: model.age,
                                    sex: model.sex,
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
                        )),
                        if (model.status.value == 1)
                          GestureDetector(
                            onTap: () {
                              t.followOrNot(model.id);
                            },
                            child: Container(
                              height: 28,
                              width: 76,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: AppColor.itemBg,
                                  borderRadius: BorderRadius.circular(14)),
                              child: Image.asset(
                                  "assets/images/ic_exchange.webp",
                                  width: 16,
                                  height: 16),
                            ),
                          )
                        else
                          GestureDetector(
                              onTap: () {
                                t.followOrNot(model.id);
                              },
                              child: Container(
                                height: 28,
                                width: 76,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(color: AppColor.yellow),
                                    borderRadius: BorderRadius.circular(14)),
                                child: Text("+ Follow",
                                    style: TextStyle(
                                        color: AppColor.yellow, fontSize: 13)),
                              ))
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

class FansListController extends GetxRefreshController<AttentionModel> {
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

  followOrNot(touid) {
    UserApi.attention(touid).then((value) {
      onRefresh();
    });
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  Future<List<AttentionModel>> loadData({int pageNum = 1}) async {
    return await UserApi.fansList(pageNum, 20);
  }
  invite() async {
    var selects = list.where((item) => item.isSelet);
    if(selects.isEmpty){
      showToast('please select at least one user to share!'.tr);
      return;
    }
    var ids=selects.map((e) => e.uk).toList();
    flog(ids);
    // var nickName = UserController.find.userProfile.nickName;
    // var params = Map()
    //   ..['invitor'] = nickName // 邀请人名字
    //   ..['type'] = MessageType.TYPE_INVITE //invite
    //   ..['groupId'] = gid //群id
    //   ..['group_name'] = groupName; //群名字
    //   ImUtils.invite(params);
   var res =await ImApi.shareGroup(Map()
      ..['shareIds'] = ids
      ..['groupId'] = gid
      ..['group_name'] = groupName
      ..['name'] = groupName
      ..['invitor'] = UserController.find.userProfile.nickName);
    showToast('Share sucess!'.tr);
    Get.back();
  }

}
