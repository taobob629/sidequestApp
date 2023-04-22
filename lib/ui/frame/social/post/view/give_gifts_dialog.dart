import 'package:card_swiper/card_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/api_service/post_api.dart';
import 'package:wy/common/getx_refresh_controller.dart';
import 'package:wy/config/app_color.dart';
import 'package:get/get.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/model/pay_order_model.dart';
import 'package:wy/utils/index.dart';

import '../../../../../widget/cs_Intimacy_progress.dart';
import '../../../../controller/user_controller.dart';
import '../../../../pay/controller.dart';

class GiveGiftsDialog extends StatelessWidget {
  GiveGiftsDialog({Key? key, required this.receiverId, required this.postId, required this.avatar, this.source = 0}) : super(key: key);
  final String receiverId;
  final String postId;
  final String avatar;

  /// "送礼物场景，0: post，1:聊天，2:直播间
  int source = 0;

  @override
  Widget build(BuildContext context) {
    final t = Get.put(GiveGiftController(receiverId: receiverId, postId: postId, source: source));

    return Obx(() {
      return Container(
        height: 386.h,
        decoration: BoxDecoration(
          color: AppColor.itemBg,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: Column(
          children: [
            CsIntimacyProgress(
              firstAvatar: avatar,
              secondAvatar: UserController.find.userProfile.avatar,
              lv: t.summary.value.currentLevel,
              currentIntimacy: t.summary.value.currentValue,
              maxIntimacy: t.summary.value.nextLevelValue,
            ).marginOnly(left: 15, right: 15, top: 12),
            Container(
              padding: EdgeInsets.only(left: 20, top: 12, right: 20, bottom: 15),
              child: Row(
                children: [
                  Text("Gift List".tr, style: TextStyle(color: Colors.white, fontSize: 21, fontFamily: FONT_MEDIUM)),
                  Spacer(),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Text("Cancel".tr, style: TextStyle(color: AppColor.color8388, fontSize: 14)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() => SmartRefresher(
                    controller: t.refreshController,
                    onRefresh: () => t.onRefresh(),
                    onLoading: () => t.loadMore(),
                    enablePullUp: true,
                    child: GridView.count(
                      crossAxisCount: 4,
                      childAspectRatio: 87 / 97.0,
                      children: t.list.map((gift) {
                        bool isSelect = gift.id == t.selectGift.value.id;
                        return GestureDetector(
                          onTap: () {
                            t.selectGift.value = gift;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: isSelect ? Border.all(color: AppColor.yellow) : null,
                              boxShadow: isSelect
                                  ? [
                                      BoxShadow(
                                        offset: Offset(0, 10),
                                        blurRadius: 10,
                                        spreadRadius: 0.5,
                                        color: Color(0x337524C3),
                                      )
                                    ]
                                  : null,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ImageUtil.networkImage(
                                  url: gift.gifticon,
                                  fit: BoxFit.cover,
                                  width: 42.w,
                                  height: 42.h,
                                ),
                                Text(gift.giftname, style: TextStyle(color: Colors.white, fontSize: 14)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: AssetImage('assets/images/ic_balance_money.webp'),
                                      width: 12,
                                      height: 12,
                                    ),
                                    Text("${gift.needcoin}", style: TextStyle(color: AppColor.color8388, fontSize: 14)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )),
            ),
            Container(
              height: 40,
              margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: Row(
                children: [
                  Container(
                    width: 112,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: AppColor.color2E3C,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => t.calBuyNum(isAdd: false),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text("-", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                          ),
                        )),
                        Expanded(
                            child: Container(
                          alignment: Alignment.center,
                          child: Text(t.buyNum.value.toString(), style: TextStyle(color: Colors.white, fontSize: 14)),
                        )),
                        Expanded(
                            child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            t.calBuyNum();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Text("+", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                          ),
                        ))
                      ],
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      if (t.selectGift.value.id.isNotEmpty) {
                        t.payGift();
                      }
                    },
                    child: Container(
                      width: 116,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color(0xFFD49C21), Color(0xFFE96524)]),
                      ),
                      alignment: Alignment.center,
                      child: Text("Submit".tr),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}

class GiveGiftController extends GetxRefreshController<GiftModel> {
  final selectGift = GiftModel().obs;
  final summary = GiftSummary().obs;
  final buyNum = 1.obs;

  String _receiverId = "";
  String _postId = "";
  int source = 0;
  GiveGiftController({required String receiverId, required String postId, required source}) {
    _receiverId = receiverId;
    _postId = postId;
    this.source = source;
  }

  @override
  void onInit() {
    pageSize = 20;
    // TODO: implement onInit
    super.onInit();
  }

  // loadData(pageNum) {
  //   PostApi.getGiftsList(pageNum: pageNum).then((res) {
  //     if (res is Map) {
  //       totalGifts = res["data"]["total"];
  //       var tempSection = GiftSection(index: pageNum, giftList: (res["data"]["rows"] as List).map((e) => GiftModel.fromJson(e)).toList());
  //       pageList.add(tempSection);
  //       pageNum += 1;
  //       if (totalGifts / 6 >= pageNum - 1) {
  //         loadData(pageNum);
  //       }
  //     }
  //   });
  // }

  calBuyNum({bool isAdd = true}) {
    print("++++++++");
    if (!isAdd) {
      if (buyNum.value > 1) {
        buyNum.value -= 1;
      } else {
        buyNum.value = 1;
      }
    } else {
      buyNum.value += 1;
    }
  }

  ///送礼物
  payGift() {
    PayOrderModel orderModel = PayOrderModel()
      ..payType = -2
      ..type = -3
      ..giftId = selectGift.value.id
      ..liveId = _receiverId
      ..postId = _postId
      ..source = source
      ..uid = UserController.find.userProfile.pwId.toString()
      ..nums = buyNum.value;

    final payController = Get.put(PayPageController(payOrderModel: orderModel));
    payController.confirmPay();
    // NavigatorHelper.gotoPayPage(orderModel);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  @override
  Future<List<GiftModel>> loadData({int pageNum = 1}) async {
    // TODO: implement loadData
    GiftSummary model = await PostApi.getGiftsList(pageNum: pageNum,receverId:_receiverId);
    summary.value = model;
    return model.data.rows;
  }
}

class GiftSummary {
  String currentLevel = "";
  String image = "";
  GiftData data = GiftData();
  int nextLevelValue = 0;
  String nextLevel = "";
  int currentValue = 0;

  GiftSummary();

  GiftSummary.fromJson(Map<String, dynamic> json) {
    currentLevel = json['currentLevel'] ?? currentLevel;
    image = json['image'] ?? image;
    data = json['data'] != null ? new GiftData.fromJson(json['data']) : GiftData();
    nextLevelValue = json['nextLevelValue'] ?? nextLevelValue;
    nextLevel = json['nextLevel'] ?? nextLevel;
    currentValue = json['currentValue'] ?? currentValue;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentLevel'] = this.currentLevel;
    data['image'] = this.image;
    data['data'] = this.data.toJson();
    data['nextLevelValue'] = this.nextLevelValue;
    data['nextLevel'] = this.nextLevel;
    data['currentValue'] = this.currentValue;
    return data;
  }
}

class GiftData {
  int total = 0;
  List<GiftModel> rows = [];
  int code = 0;
  String msg = "";

  GiftData();

  GiftData.fromJson(Map<String, dynamic> json) {
    total = json['total'] ?? 0;
    if (json['rows'] != null) {
      rows = <GiftModel>[];
      json['rows'].forEach((v) {
        rows.add(new GiftModel.fromJson(v));
      });
    }
    code = json['code'] ?? 0;
    msg = json['msg'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['code'] = this.code;
    data['msg'] = this.msg;
    return data;
  }
}

class GiftModel {
  String id = "";
  int type = 0;
  int addtime = 0;
  int swftype = 0;
  String swf = "";
  String swftime = "";
  String giftname = "";
  String needcoin = "";
  String gifticon = "";
  int listOrder = 0;

  GiftModel({
    this.id = "",
    this.type = 0,
    this.addtime = 0,
    this.swftype = 0,
    this.swf = "",
    this.swftime = "",
    this.giftname = "",
    this.needcoin = "",
    this.gifticon = "",
    this.listOrder = 0,
  });

  GiftModel.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? "";
    type = json["type"] ?? 0;
    addtime = json["addtime"] ?? 0.0;
    swftype = json["swftype"] ?? 0;
    swf = json["swf"] ?? "";
    swftime = json["swftime"] ?? "";
    giftname = json["giftname"] ?? "";
    needcoin = json["needcoin"] ?? "";
    gifticon = json["gifticon"] ?? "";
    listOrder = json["listOrder"] ?? 0;
  }
}
