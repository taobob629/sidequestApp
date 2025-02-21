import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/model/friend_model.dart';
import 'package:sq_hub_app/ui/pages/friend/approval/approval_ctr.dart';
import 'package:sq_hub_app/utils/utils.dart';

import '../../../api/wy_http.dart';
import '../../../config/app_color.dart';
import '../../../config/icon_font.dart';
import '../../../controller/user_controller.dart';
import '../../../utils/toast_utils.dart';
import '../../dialog/dialog_confirm.dart';
import '../../dialog/dialog_sign_success.dart';
import 'approval/approval_page.dart';

class AddFriendCtr extends GetxController {
  static AddFriendCtr get find => Get.find();

  var friendOutModel = FriendOutModel(
    approvalNum: 0,
    list: [],
  ).obs;
  var friendList = <FriendModel>[].obs;

  TextEditingController searchCtr = TextEditingController();

  // 是否是搜索的朋友，true：是，反之
  var isSearchFriend = false.obs;

  @override
  void onInit() {
    super.onInit();

    requestData();
  }

  void requestData() async {
    showLoading();
    final response = await http.get('/app/point/friend/list');
    dismissLoading();

    friendOutModel.value = FriendOutModel.fromJson(response.data);

    friendList.value = friendOutModel.value.list;
    isSearchFriend.value = false;
  }

  void searchFriend(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (searchCtr.text.isEmpty) {
      requestData();
      return;
    }
    showLoading();
    final response = await http.get('/app/point/member/list', queryParameters: {
      "name": searchCtr.text,
    });
    dismissLoading();

    friendList.value = response.data
        .map<FriendModel>((item) => FriendModel.fromJson(item))
        .toList();
    isSearchFriend.value = true;
  }

  void removeFriend(FriendModel model) async {
    showLoading();
    final response =
        await http.get('/app/point/friend/del/num', queryParameters: {
      "toMemberId": model.toMemberId,
    });
    dismissLoading();

    if (response.data == 1) {
      Get.dialog(
        ConfirmDialog(
          title: "Delete Friend".tr,
          info: "Are you sure to disconnect with ${model.nickName}".tr,
          onConfirm: () async {
            Get.back();
            showLoading();
            await http.post('/app/point/del/friend', data: {
              "toMemberId": model.toMemberId,
            });
            dismissLoading();
            requestData();
          },
        ),
        barrierColor: Colors.black26,
      );
    } else {
      Get.dialog(
        ConfirmDialog(
          title: "Delete Friend".tr,
          info:
              "- Flexible Connection Changes:\nYou can update your connection once every month \n- Automatic Maximum Combo Discount:\nOur system ensures you always receive the best possible discount automatically when combining your connections."
                  .tr,
          onConfirm: () async {
            Get.back();
            showLoading();
            await http.post('/app/point/del/friend', data: {
              "toMemberId": model.toMemberId,
            });
            dismissLoading();
            requestData();
          },
        ),
        barrierColor: Colors.black26,
      );
    }
  }

  void addFriend(FriendModel model) async {
    if (model.memberCode == UserController.find.userProfile.uk) {
      showToast("You cannot add yourself".tr);
      return;
    }
    showLoading();
    final result = await http.post('/app/point/add/friend', data: {
      "toMemberId": model.id,
    });
    dismissLoading();
    if (result.data == true) {
      showCustom(SignSuccessDialog(
        points: "",
        congratulations: result.statusMessage,
        title: "Successful".tr,
      ));
      searchFriend(Get.context!);
    }
  }

  void approval() async {
    await Get.to(() => ApprovalPage());
  }

  void addOrRejectFriends(bool isAdd, int? memberId) async {
    Get.dialog(
      ConfirmDialog(
        title: isAdd ? "Accept".tr : "Reject".tr,
        info: "Are you sure ${isAdd ? "Accept".tr : "Reject".tr}".tr,
        onConfirm: () async {
          Get.back();
          showLoading();
          await http.post('/app/point/set/friend', data: {
            "memberId": memberId,
            // 1同意 4拒绝
            "friendState": isAdd ? 1 : 4,
          });
          dismissLoading();
          requestData();
          if (Get.isRegistered<ApprovalCtr>()) {
            ApprovalCtr.find.requestData();
          }
        },
      ),
      barrierColor: Colors.black26,
    );
  }

  Widget getFunByState(FriendModel model) {
    // friendState  状态（ 0待确认  1已通过  2陌生人，3已申请 ，4，已拒绝）
    switch (model.friendState) {
      case 0:
        return Row(
          children: [
            InkWell(
              onTap: () => addOrRejectFriends(false, model.memberId),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 6.h,
                ),
                child: Text(
                  "Reject".tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontFamily: FONT_LIGHT,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () => addOrRejectFriends(true, model.memberId),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 6.h,
                ),
                margin: EdgeInsets.only(left: 6.w),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  "Accept".tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontFamily: FONT_LIGHT,
                  ),
                ),
              ),
            ),
          ],
        );
      case 1:
        return IconButton(
          onPressed: () => removeFriend(model),
          icon: Icon(
            Icons.remove_circle_outline,
            color: Colors.red,
            size: 30.sp,
          ),
        );
      case 3:
        return Text(
          "Wait Approve".tr,
          style: TextStyle(
            color: hexColor('#32BE48'),
            fontFamily: FONT_MEDIUM,
            fontSize: 14.sp,
          ),
        ).paddingOnly(left: 4.w);

      case 2:
      case 4:
      default:
        // 陌生人、已拒绝和默认的时候显示添加按钮
        return IconButton(
          onPressed: () => addFriend(model),
          icon: Icon(
            Icons.add_circle_outline_outlined,
            color: hexColor('FFB20E'),
            size: 30.sp,
          ),
        );
    }
  }

  void cancelFriends(FriendModel model) async {
    showCustom(ConfirmDialog(
      title: "Confirm",
      info: "Are you sure to cancel this connection request?",
      onConfirm: () async {
        dismissLoading();
        int toMemberId = model.toMemberId ?? -1;
        if (UserController.find.userProfile.memberId == toMemberId) {
          toMemberId = model.memberId ?? -1;
        }

        showLoading();
        final result = await http.post('/app/point/cancel/friend', data: {
          "toMemberId": isSearchFriend.value ? model.id : toMemberId,
        });
        dismissLoading();
        if (result.data == true) {
          if (isSearchFriend.value) {
            searchFriend(Get.context!);
            return;
          }
          requestData();
        }
      },
    ));
  }
}
