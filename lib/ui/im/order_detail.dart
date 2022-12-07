import 'package:ff_stars/ff_stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/im/play_detail.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/paixs_widget.dart';

import '../../api/im_api.dart';
import '../../model/play_order_detail_model.dart';
import '../common/base_scaffold.dart';
import '../common/dialog_confirm.dart';
import 'dialog_comment.dart';
import 'dialog_reject.dart';

class OrderDetail extends StatelessWidget {
  late final int orderId;
  late final OrderDetailController controller;

  OrderDetail({required this.orderId}) {
    controller = Get.put(OrderDetailController(orderId));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        title: "Order Detail".tr,
        body: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 80,
              child: SingleChildScrollView(
                  child: Obx(() => Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: items(context),
                      ))),
            ),
          ],
        ),
        floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: _buildActionButton()));
  }

  List<Widget> items(BuildContext context) {
    var divider = SizedBox(height: 20);
    List<Widget> items = [];
    items.add(Padding(
      padding: const EdgeInsets.only(left: 15, bottom: 20),
      child: Text(
        "Service".tr,
        style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: "DIN"),
      ),
    ));
    items.add(_buildSkillInfo());
    items.add(divider);
    items.add(_buildOrderInfo());
    items.add(divider);
    items.add(
      Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Text(
          "Status".tr,
          style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: "DIN"),
        ),
      ),
    );
    items.add(_buildState());
    items.add(divider);
    if (controller.playOrderDetailModel.value.status == -2) {
      items.add(Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Text(
          "Score".tr,
          style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: "DIN"),
        ),
      ));
      items.add(_buildScore(context));
      items.add(divider);
    }
    items.add(Padding(
      padding: const EdgeInsets.only(left: 15, top: 10),
      child: Text(
        getCommentTitle(),
        style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: "DIN"),
      ),
    ));
    items.add(_buildComments(context));
    return items;
  }

  Widget _buildActionButton() {
    UserController userController = Get.find<UserController>();
    return Obx(() {
      if (controller.playOrderDetailModel.value.status == 1) {
        if (userController.userInfoModel.value.pwuserId ==
            controller.playOrderDetailModel.value.fromUid) {
          //发起人
          return ColorfulButton(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                "CANCEL".tr,
                style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "DIN"),
              ),
            ),
            height: 48,
            onTap: () {
              Get.dialog(
                  ConfirmDialog(
                    title: "Cancel Order".tr,
                    info: "Do you want to cancel this order?".tr,
                    confirmBtn: "CONFIRM".tr,
                    onConfirm: () async {
                      controller.cancelOrder();
                    },
                  ),
                  barrierColor: Colors.black26);
            },
          );
        } else if (userController.userInfoModel.value.pwuserId ==
            controller.playOrderDetailModel.value.toUid) {
          return Row(
            children: [
              Expanded(
                child: ColorfulButton(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "ACCEPT".tr,
                      style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "DIN"),
                    ),
                  ),
                  height: 48,
                  onTap: () {
                    controller.acceptOrder();
                  },
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.dialog(CommentDialog(controller.orderId, () => Get.back(), isRehect: true),
                        barrierColor: Colors.black26);
                    // Get.dialog(ConfirmDialog(
                    //   title: "Reject Order",
                    //   info: "Do you want to reject this order?",
                    //   confirmBtn: "CONFIRM",
                    //   onConfirm: () async {
                    //     controller.rejectOrder();
                    //   },
                    // ),barrierColor: Colors.black26);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white24, borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            "REJECT".tr,
                            style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "DIN"),
                          ),
                        ),
                      ),
                      height: 48),
                ),
              )
            ],
          );
        }
      } else if (controller.playOrderDetailModel.value.status == 2) {
        if (userController.userInfoModel.value.pwuserId ==
            controller.playOrderDetailModel.value.fromUid) {
          return Row(
            children: [
              Expanded(
                child: ColorfulButton(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "FINISHED".tr,
                      style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "DIN"),
                    ),
                  ),
                  height: 48,
                  onTap: () {
                    Get.dialog(
                        CommentDialog(
                          controller.orderId,
                          () => Get.back(),
                        ),
                        barrierColor: Colors.black26);
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ColorfulButton(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "REFUND".tr,
                      style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "DIN"),
                    ),
                  ),
                  height: 48,
                  onTap: () {
                    Get.dialog(CommentDialog(controller.orderId, () => Get.back(), isRefund: true),
                        barrierColor: Colors.black26);
                  },
                ),
              ),
            ],
          );
        }
      } else if (controller.playOrderDetailModel.value.status == 3) {
        if (userController.userInfoModel.value.isauth == 1) {
          return Row(
            children: [
              Expanded(
                child: ColorfulButton(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "REJECT".tr,
                      style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "DIN"),
                    ),
                  ),
                  height: 48,
                  onTap: () => controller.dsRejectOrder(),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ColorfulButton(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "REFUND".tr,
                      style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "DIN"),
                    ),
                  ),
                  height: 48,
                  onTap: () => controller.dsRefundOrder(),
                ),
              ),
            ],
          );
        }
      }
      return Container();
    });
  }

  Widget _buildSkillInfo() {
    return Container(
      height: 66,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          controller.playOrderDetailModel.value.icon == ""
              ? Container()
              : Image.network(
                  "${controller.playOrderDetailModel.value.icon}",
                  width: 66,
                  height: 66,
                  fit: BoxFit.cover,
                ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "${controller.playOrderDetailModel.value.gameName}",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              PWidget.boxh(8),
              Text(
                "${controller.playOrderDetailModel.value.serviceItem['name'] ?? ''}",
                style: TextStyle(color: Colors.white),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "",
                    style:
                        TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "",
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              )
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget _buildOrderInfo() {
    var palymodel = controller.playOrderDetailModel.value;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Information".tr,
            style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: "DIN"),
          ),
          //_infoItem("Order Time","2022-09-12 23:00:00"),
          _infoItem("Order Number".tr, "${palymodel.orderno}"),
          _infoItem(userLable(palymodel), userName(palymodel), isClickable: true),
          _infoItem("Service Time".tr,
              "${DateFormat('dd/MM/y HH:mm:ss', 'en_GB').format(DateTime.fromMillisecondsSinceEpoch(palymodel.addtime * 1000))}"),
          _infoItem("Quantity".tr, "${palymodel.nums} ${palymodel.unit}"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Text(
                  "Total".tr,
                  style: TextStyle(fontSize: 12, color: Colors.white54),
                ),
                Spacer(),
                Image.asset(
                  "assets/images/ic_balance_money.webp",
                  width: 14,
                  height: 14,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  "${palymodel.total}",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
          if (palymodel.acturalPayment > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Text(
                    "Actual payment".tr,
                    style: TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                  Spacer(),
                  Image.asset(
                    "assets/images/ic_balance_money.webp",
                    width: 14,
                    height: 14,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    "${palymodel.acturalPayment}",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ),
          if (palymodel.tax > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Text(
                    "Service Tax".tr,
                    style: TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                  Spacer(),
                  Image.asset(
                    "assets/images/ic_balance_money.webp",
                    width: 14,
                    height: 14,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    "${palymodel.tax}",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  )
                ],
              ),
            ),
          if (palymodel.profit > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Text(
                    "Profit".tr,
                    style: TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                  Spacer(),
                  Image.asset(
                    "assets/images/ic_balance_votes.webp",
                    width: 14,
                    height: 14,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    "${palymodel.profit}",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  )
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Text(
                  "Discount".tr,
                  style: TextStyle(fontSize: 12, color: Colors.white54),
                ),
                Spacer(),
                Image.asset(
                  "assets/images/ic_balance_money.webp",
                  width: 14,
                  height: 14,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  "${palymodel.discount}",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  userLable(PlayOrderDetailModel model) {
    UserController userController = Get.find<UserController>();
    bool isMe = (Get.find<UserController>().userInfoModel.value.pwuserId == model.liveuid);
    if (isMe) {
      return 'From'.tr;
    }
    return 'To'.tr;
  }

  userName(PlayOrderDetailModel model) {
    UserController userController = Get.find<UserController>();
    bool isMe = (Get.find<UserController>().userInfoModel.value.pwuserId == model.liveuid);
    if (isMe) {
      return model.creater;
    }
    return model.player;
  }

  Widget _infoItem(String title, String value, {bool isClickable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Text(
            "$title",
            style: TextStyle(fontSize: 12, color: Colors.white54),
          ),
          Spacer(),
          GestureDetector(
            onTap: () async {
              if (!isClickable) return;
              var model = controller.playOrderDetailModel.value;
              bool isMe =
                  (Get.find<UserController>().userInfoModel.value.pwuserId == model.liveuid);
              if (isMe) {
                Get.to(() => PlayDetail(userId: '${model.uid}'));
              } else {
                Get.to(() => PlayDetail(userId: '${model.liveuid}'));
              }
            },
            child: Text(
              "$value",
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Color getColor(int index) {
    switch (index) {
      case 1:
        return Colors.green;
      case 0:
        return Colors.blue;
      default:
        return Colors.blue;
    }
  }

  Widget _buildState() {
    int length = controller.playOrderDetailModel.value.statusArray.length;
    if (length == 0) return Container();
    return Container(
      height: 65,
      child: Timeline.tileBuilder(
        physics: NeverScrollableScrollPhysics(),
        theme: TimelineThemeData(
          direction: Axis.horizontal,
          connectorTheme: ConnectorThemeData(
            space: 25.0,
            thickness: 5.0,
          ),
        ),
        builder: TimelineTileBuilder.connected(
            itemExtentBuilder: (_, index) {
              if (index == 0) return 100;
              if (length <= 2) return Get.width + 100;
              if (index == (length - 1)) return 100;
              return Get.width - 200;
            },
            indicatorBuilder: (_, index) {
              return DotIndicator(
                color: getColor(controller.playOrderDetailModel.value.statusArray[index].colour),
              );
            },
            contentsBuilder: (_, index) {
              return PWidget.text(
                  '${controller.playOrderDetailModel.value.statusArray[index].displayLable}',
                  [Colors.white, 11, true]);
            },
            connectorBuilder: (_, index, type) {
              return SolidLineConnector(
                color: Colors.white24,
              );
            },
            itemCount: length),
      ),
    );
  }

  Widget _buildScore(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          controller.playOrderDetailModel.value.star == 0
              ? FFStars(
                  normalStar: Image.asset("assets/images/play/score0.png"),
                  selectedStar: Image.asset("assets/images/play/score1.png"),
                  step: 0.01,
                  defaultStars: 0,
                  starHeight: 20,
                  starWidth: 20,
                  starMargin: 16,
                  followChange: true,
                  justShow: true,
                )
              : FFStars(
                  normalStar: Image.asset("assets/images/play/score0.png"),
                  selectedStar: Image.asset("assets/images/play/score1.png"),
                  step: 0.01,
                  defaultStars: controller.playOrderDetailModel.value.star,
                  starHeight: 20,
                  starWidth: 20,
                  starMargin: 16,
                  followChange: true,
                  justShow: true,
                ),
          SizedBox(
            width: 10,
          ),
          Text(
            "${controller.playOrderDetailModel.value.star.toStringAsFixed(1)}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildComments(context) {
    double width = MediaQuery.of(context).size.width;
    var model = controller.playOrderDetailModel.value;
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      child: model.status == 4
          ? Text.rich(TextSpan(children: [
              TextSpan(text: '${'Refund Reason'.tr}:\n', style: TextStyle(color: Colors.white)),
              TextSpan(text: '${model.reason}\n', style: TextStyle(color: Colors.white54)),
              TextSpan(
                  text: '${'Refund Reject Reason'.tr}:\n', style: TextStyle(color: Colors.white)),
              TextSpan(
                  text: '${model.playerRejectRefundReason}\n',
                  style: TextStyle(color: Colors.white54))
            ]))
          : Text(
              getCommentText(),
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
    );
  }

  String getCommentTitle() {
    var model = controller.playOrderDetailModel.value;
    int status = model.status;
    switch (status) {
      case -3:
        return 'RejectReason'.tr;
      case 3:
        return 'Reason'.tr;
      // case 4:
      //   return 'Refund Reject Reason'.tr;
      default:
        return 'Comments'.tr;
    }
  }

  String getCommentText() {
    var model = controller.playOrderDetailModel.value;
    int status = model.status;
    switch (status) {
      case -3:
        return model.rejectReason;
      case 3:
        return model.reason;
      case 4:
        return 'Refund reason:${model.reason} \nRefund reject reason:${model.playerRejectRefundReason}';
      default:
        return model.comments;
    }
  }
}

class OrderDetailController extends GetxController {
  Rx<PlayOrderDetailModel> playOrderDetailModel = PlayOrderDetailModel().obs;
  late int orderId;

  OrderDetailController(int orderId) {
    this.orderId = orderId;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    ImApi.getPlayOrderDetail(orderId).then((value) => playOrderDetailModel.value = value);
  }

  void cancelOrder() {
    Get.back();
    EasyLoading.show();
    ImApi.cancelOrder(orderId.toString());
    EasyLoading.dismiss();
    Get.back();
  }

  Future<void> acceptOrder() async {
    EasyLoading.show();
    var res = await ImApi.acceptOrder(orderId.toString()).catchError((v) {});
    EasyLoading.showToast('${res.statusMessage}');
    EasyLoading.dismiss();
    Get.back();
  }

  ///大神拒绝退款
  Future<void> dsRejectOrder() async {
    Get.dialog(RejectDialog()).then((value) async {
      flog('value $value');
      if (value == null) return;
      EasyLoading.show();
      var res = await ImApi.dsRefundOrder(orderId.toString(), '4', playerRejectRefundReason: value)
          .catchError((v) {});
      EasyLoading.showToast('${res.statusMessage}');
      EasyLoading.dismiss();
      Get.back();
    });
  }

  ///大神同意退款
  Future<void> dsRefundOrder() async {
    EasyLoading.show();
    var res = await ImApi.dsRefundOrder(orderId.toString(), '5').catchError((v) {});
    EasyLoading.showToast('${res.statusMessage}');
    EasyLoading.dismiss();
    Get.back();
  }

// void rejectOrder(){
//   Get.back();
//   EasyLoading.show();
//   ImApi.rejectOrder(orderId.toString(),'');
//   EasyLoading.dismiss();
//   Get.back();
// }
}
