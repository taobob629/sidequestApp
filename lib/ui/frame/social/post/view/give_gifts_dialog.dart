import 'package:card_swiper/card_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wy/api_service/post_api.dart';
import 'package:wy/config/app_color.dart';
import 'package:get/get.dart';
import 'package:wy/model/pay_order_model.dart';
import 'package:wy/utils/index.dart';

import '../../../../controller/user_controller.dart';
import '../../../../pay/controller.dart';

class GiveGiftsDialog extends StatelessWidget {
  GiveGiftsDialog({Key? key, required this.receiverId, required this.postId, this.source = 0}) : super(key: key);
  final String receiverId;
  final String postId;

  /// "送礼物场景，0: post，1:聊天，2:直播间
  int source = 0;

  @override
  Widget build(BuildContext context) {
    final t = Get.put(GiveGiftController(receiverId: receiverId, postId: postId, source: source));

    return Obx(() {
      return Container(
        height: 420,
        decoration: BoxDecoration(
          color: AppColor.itemBg,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 15),
              child: Row(
                children: [
                  Text("Gift List", style: TextStyle(color: Colors.white, fontSize: 21)),
                  Spacer(),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Text("Cancel", style: TextStyle(color: AppColor.color8388, fontSize: 14)),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Swiper(
              autoplay: false,
              loop: false,
              itemCount: t.pageList.length,
              pagination: SwiperPagination(
                  alignment: Alignment(0, 1.2),
                  builder: DotSwiperPaginationBuilder(
                    color: Color(0xFF2D2E3C),
                    activeColor: Colors.white,
                    size: 6,
                    activeSize: 6,
                    space: 6,
                  )),
              itemBuilder: (context, index) {
                var section = t.pageList[index];
                return Container(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 40),
                  // color: Colors.lightBlue,
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: section.giftList.map((gift) {
                      bool isSelect = gift.id == t.selectGift.value.id;
                      return GestureDetector(
                        onTap: () {
                          t.selectGift.value = gift;
                          t.pageList.refresh();
                        },
                        child: Container(
                          width: (Get.width - 60) / 3,
                          height: 110,
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
                            color: AppColor.color2E3C,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ImageUtil.networkImage(
                                url: gift.gifticon,
                                fit: BoxFit.cover,
                                width: 60,
                                height: 70,
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
                );
              },
            )),
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
                      child: Text("Submit"),
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

class GiveGiftController extends GetxController {
  final pageList = <GiftSection>[].obs;

  final selectGift = GiftModel().obs;

  final buyNum = 1.obs;

  String _receiverId = "";
  String _postId = "";
  int source = 0;
  GiveGiftController({required String receiverId, required String postId, required source}) {
    _receiverId = receiverId;
    _postId = postId;
    this.source = source;
  }
  int totalGifts = 0;

  @override
  void onInit() {
    // TODO: implement onInit
    loadData(1);
    super.onInit();
  }

  loadData(pageNum) {
    PostApi.getGiftsList(pageNum: pageNum).then((res) {
      if (res is Map) {
        totalGifts = res["total"];
        var tempSection = GiftSection(index: pageNum, giftList: (res["rows"] as List).map((e) => GiftModel.fromJson(e)).toList());
        pageList.add(tempSection);
        pageNum += 1;
        if (totalGifts / 6 >= pageNum - 1) {
          loadData(pageNum);
        }
      }
    });
  }

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
}

class GiftSection {
  int index = 0;
  List<GiftModel> giftList = [];

  GiftSection({this.index = 0, this.giftList = const []});
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
