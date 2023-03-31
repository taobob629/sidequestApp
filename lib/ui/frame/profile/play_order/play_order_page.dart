import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/model/data_model.dart';
import 'package:wy/model/pay_order_model.dart';
import 'package:wy/model/play_detail_model.dart';
import 'package:wy/ui/common/base_scaffold.dart';
import 'package:wy/ui/common/dialog_date_time_picker.dart';
import 'package:wy/ui/common/input_view.dart';
import 'package:wy/ui/common/quantity_selector.dart';
import 'package:wy/ui/common/select_view.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/frame/profile/other_profile/mdoel/player_info_mdoel.dart';
import 'package:wy/utils/navigator_helper.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/view/views.dart';
import 'package:wy/widget/anima_switch_widget.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:flutter_easyloading/src/widgets/indicator.dart';
import 'package:wy/widget/views.dart';

import '../../../im/pay_button.dart';

// import '../../../im/pay_button.dart';

class MulitablePlayOrderPage extends StatelessWidget {
  late final List<ServiceItem> serviceItemList;
  late final MulitablePlayOrderController controller;

  TextEditingController textCon = TextEditingController();

  MulitablePlayOrderPage({required this.serviceItemList, String code = ""}) {
    controller = Get.put(MulitablePlayOrderController(serviceItemList, code));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return BaseScaffold(
        title: "Play Order".tr,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: SingleChildScrollView(child: Obx(() {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // _buildItem(),
                    // buildServerItem(controller.preOrderDm.value.object?['serviceItems']),
                    ...controller.serviceItemList.map((serviceItem) {
                      return buildServerItem(serviceItem);
                    }),
                    // _buildTime(),
                    //  _buildMemo(),
                    Container(height: 120)
                  ],
                );
              })),
            ),
            PWidget.positioned(
              AnimatedSwitchBuilder(
                value: controller.preOrderDm.value,
                errorOnTap: () async => getTime(),
                initViewIsCenter: true,
                initialState: PWidget.container(buildLoad(), {'pd': PFun.lg(16, 16)}),
                isAnimatedSize: true,
                objectBuilder: (v) {
                  return PWidget.column([
                    PWidget.container(
                      PWidget.column([
                        PWidget.row([
                          PWidget.text('SUBTOTAL'.tr, [Colors.white, 18], {'exp': true}),
                          PWidget.image("assets/images/ic_balance_money.webp", [20, 20]),
                          PWidget.boxw(5),
                          // PWidget.text('112', [Colors.white, 16]),
                          PWidget.text(controller.preOrderDm.value.object?['subtotal'], [Colors.white, 16]),
                        ]),
                        PWidget.boxh(15),
                        PWidget.row([
                          PWidget.text("${'Service Tax'.tr}", [Colors.white, 18], {'exp': true}),
                          PWidget.image("assets/images/ic_balance_money.webp", [20, 20]),
                          PWidget.boxw(5),
                          PWidget.text(controller.preOrderDm.value.object?['tax'], [Colors.white, 16]),
                        ]),
                        PWidget.boxh(15),
                        // YouhuiquanInputWidget(textCon, (v) async {
                        //   await controller.calculate(skillModel.authId.toString(), liveUid, '${serviceItem['id']}', v);
                        //   if (controller.calculateDm.value.object == 0) textCon.clear();
                        // }),
                        ///优惠卷
                        GestureDetector(
                          onTap: () => Get.find<UserController>().checkLogin(() => NavigatorHelper.gotoCouponPage(
                              preOrder: Get.find<MulitablePlayOrderController>().getPayOrderModel().toJson(),
                              //  payOrderModel: pageController.getPayOrderModel(),
                              onSelect: (model) async {
                                //  flog('v $model');
                                controller.couponId = int.tryParse(model.couponCode) ?? 0;
                                controller.calculateMulit();
                                // await controller.calculate(
                                //   serviceItem.skillAuthid.toString(),
                                //   liveUid,
                                //   '${serviceItem['id']}',
                                //   model.id,
                                //   model.couponCode,
                                // );
                              })),
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Vouchers".tr,
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Obx(() {
                          if (controller.preOrderDm.value.object?['discount'] == null || controller.preOrderDm.value.object?['discount'] == 0) return PWidget.boxh(0);
                          return PWidget.container(
                            PWidget.row([
                              PWidget.text("${'Discount'.tr}", [Colors.white, 18], {'exp': true}),
                              Stack(clipBehavior: Clip.none, children: [
                                PWidget.row([
                                  PWidget.image("assets/images/ic_balance_money.webp", [16, 16]),
                                  PWidget.boxw(5),
                                  PWidget.text('${controller.preOrderDm.value.object?['coupon'] ?? ''}  ${controller.preOrderDm.value.object?['discount'] ?? ''}', [Colors.white54, 16]),
                                ]),
                                PWidget.positioned(PWidget.container(null, [null, 1, Colors.white]), [10, null, -4, -4]),
                              ]),
                            ]),
                            {'pd': PFun.lg(15, 15)},
                          );
                        }),
                        PWidget.boxh(15),
                        PWidget.row([
                          PWidget.text("${'TOTAL'.tr}", [Color(0xffeeca46), 24, true], {'exp': true}),
                          PWidget.image("assets/images/ic_balance_money.webp", [28, 28]),
                          PWidget.boxw(5),
                          Obx(() {
                            return PWidget.text(controller.preOrderDm.value.object?['total'], [Color(0xffeeca46), 24]);
                          }),
                        ]),
                      ]),
                      [null, null, AppColor.itemBg],
                      {'pd': 15, "cs": AppColor.itemBg},
                    ),
                    PayOrderButton(),
                  ], '220');
                },
              ),
              [null, MediaQuery.of(context).viewInsets.bottom, 0, 0],
            )
          ],
        ),
      );
    });
  }

  Widget buildServerItem(ServiceItem serviceItem) {
    if (serviceItem == null) return PWidget.boxh(0);
    return Column(
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
          decoration: BoxDecoration(color: Color(0xff28253D), borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Container(
                height: 105,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0x08ffffff),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                      child: serviceItem.avatar.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: serviceItem.avatar,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(),
                            )
                          : Container(),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                serviceItem.skillName,
                                style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "DIN"),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                serviceItem.name,
                                style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: "DIN"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        PWidget.container(
          PWidget.row([
            PWidget.text(serviceItem.skillName, [Colors.white], {'exp': true}),
            PWidget.image("assets/images/ic_balance_money.webp", [18, 18]),
            PWidget.boxw(5),
            PWidget.text("${serviceItem.price}", [Colors.white, 18, true], {'null': ''}),
            PWidget.text(" / ${serviceItem.unit}", [Colors.white, 12], {'null': '', 'exp': true}),
            PWidget.boxw(4),
            Obx(() => QuantitySelector(
                  initValue: serviceItem.num.value,
                  tag: serviceItem.id.toString(),
                  onQuantityChanged: (quantity) async {
                    // serviceItem.num.value = quantity;
                    controller.serviceItemList.firstWhere((service) => service.id == serviceItem.id).num.value = quantity;
                    // flog(serviceItem);
                    controller.calculateMulit();
                  },
                ))
          ]),
          {'pd': PFun.lg(8, 8, 15, 15)},
        ),
      ],
    );
  }

  Widget _buildTime() {
    return SelectView(
      label: "Play Time",
      tips: "What Time",
      value: formatDate(controller.time.value, [dd, '/', M, '/', yyyy, ' ', HH, ':', nn]),
      onTap: () {
        controller.showSelectTime();
      },
    );
  }

  Widget _buildMemo() {
    return InputView(
      label: "Remarks",
      tips: "remarks",
      controller: controller.remarksController,
    );
  }
}

class YouhuiquanInputWidget extends StatefulWidget {
  final TextEditingController textCon;
  final Function(String) fun;

  const YouhuiquanInputWidget(this.textCon, this.fun, {Key? key}) : super(key: key);

  @override
  _YouhuiquanInputWidgetState createState() => _YouhuiquanInputWidgetState();
}

class _YouhuiquanInputWidgetState extends State<YouhuiquanInputWidget> {
  @override
  Widget build(BuildContext context) {
    return PWidget.container(
      PWidget.row([
        buildTFView(
          context,
          hintText: 'please enter voucher code'.tr,
          height: 40,
          padding: EdgeInsets.only(left: 8, right: 8),
          isExp: true,
          textColor: Colors.white70,
          hintColor: Colors.white24,
          con: widget.textCon,
          onChanged: (v) => setState(() {}),
        ),
        PWidget.container(
          PWidget.text('Submit'.tr, [Colors.white.withOpacity(widget.textCon.text.isEmpty ? 0.2 : 0.7)]),
          [null, null, Colors.white.withOpacity(widget.textCon.text.isEmpty ? 0.1 : 0.2)],
          {'pd': PFun.lg(4, 4, 12, 12), 'br': 4, if (widget.textCon.text.isNotEmpty) 'fun': () => widget.fun(widget.textCon.text)},
        ),
      ]),
      [null, null, Colors.white.withOpacity(0.1)],
      {
        'br': 8,
        'pd': PFun.lg(0, 0, 0, 8),
      },
    );
  }
}

class MulitablePlayOrderController extends GetxController {
  // var totalAmount = 0.0.obs;
  var balance = 0.0.obs;

  // var nums = 1.obs;

  var timeSelect = false.obs;

  var time = DateTime.now().obs;

  late TextEditingController remarksController;

  final serviceItemList = <ServiceItem>[].obs;

  late String code;

  var fellv = 0.0.obs;

  String orderId = "";

  MulitablePlayOrderController(List<ServiceItem> serviceItemList, String code) {
    remarksController = TextEditingController();
    this.serviceItemList.addAll(serviceItemList);
    this.code = code;
    preOrder();
    // preOrder(skillModel.skillAuthid.toString(), liveUid, serviceItemId);
    // calculate(skillModel.authId.toString(), liveUid, serviceItemId, code);
  }

  @override
  void onInit() {
    orderId = Get.arguments ?? "";
    super.onInit();
  }

  @override
  void onClose() {
    remarksController.dispose();
    super.onClose();
  }

  feilv() {
    if (preOrderDm.value.object?.isNotEmpty ?? false) {
      fellv.value = preOrderDm.value.object?['bossfee'];
    }
  }

  var preOrderDm = DataModel(object: {}).obs;

  Future<int> preOrder() async {
    await http.post('/peiwan/app/new/orders/preMulitOrder', data: {
      "preOrdersBos": serviceItemList
          .map((item) => {
                "skillAuthId": item.skillAuthid,
                "liveuid": item.uid,
                "serviceItemId": item.id,
              })
          .toList()
    }).then((res) async {
      preOrderDm.value.addObject(res.data);
      // totalAmount.value =
      //     (double.parse(preOrderDm.value.object?['serviceItems']['price']));
      // nums.value = 1;
      balance.value = double.parse('${res.data['coin']}');
      serviceItemList.value = res.data["serviceItems"].map<ServiceItem>((e) {
        // changeQuantity(1,skillAuthId);
        return ServiceItem.fromJson(e);
      }).toList();
      // changeQuantity(1,skillAuthId);
      feilv();
    }).catchError((e) {
      preOrderDm.value.toError(e.toString());
    });
    preOrderDm.refresh();
    return preOrderDm.value.flag;
  }
  // Future<CalculateModel> getPreorder(String skillAuthId, String liveuid, String serviceItemId) async {
  //
  //   await http.get('/peiwan/app/order/preOrder', queryParameters: {
  //     "skillAuthId": skillAuthId,
  //     "liveuid": liveuid,
  //     "serviceItemId": serviceItemId,
  //   }).then((res) async {
  //     calculateModel=new CalculateModel();
  //
  //     preOrderDm.value.addObject(res.data);
  //     calculateModel.couponId = res.data['couponId'];
  //     calculateModel.tax=res.data['tax'];
  //     calculateModel.discount=res.data['discount'];
  //     calculateModel.subtotal=res.data['subtotal'];
  //     calculateModel.total=888;
  //     nums.value=1;
  //     // changeQuantity(1);
  //     feilv();
  //   }).catchError((e) {
  //     preOrderDm.value.toError(e.toString());
  //   });
  //   preOrderDm.refresh();
  //   return calculateModel;
  // }

  // var calculateDm = DataModel(object: 0).obs;
  int couponId = 0;

  Future<int> calculateMulit() async {
    this.code = code;
    // Map params = Get.find<MulitablePlayOrderController>().getPayOrderModel().toJson();
    // params['skillAuthId'] = skillAuthId;
    // params['liveuid'] = liveuid;
    // params['couponId'] = couponId;
    // params['serviceItemId'] = serviceItemId;
    // params['code'] = couponCode;
    await http.post('/peiwan/app/new/orders/calculateMulit', data: {
      "preOrdersBos": serviceItemList
          .asMap()
          .map((key, item) => MapEntry(key, {
                "skillAuthId": item.skillAuthid,
                "liveuid": item.uid,
                "serviceItemId": item.id,
                "nums": item.num.value,
                "couponId": key == 0 ? couponId : 0,
              }))
          .values
          .toList()
    }).then((res) async {
      // calculateDm.value.addObject(res.data['discount']);
      // preOrderDm.value.object?['total']=res.data['total'];
      preOrderDm.value.addObject(res.data);

      this.couponId = res.data['couponId'];
    }).catchError((e) {
      preOrderDm.value.toError(e.toString());
    });
    // calculateDm.refresh();
    preOrderDm.refresh();
    return preOrderDm.value.flag;
  }

  // Future<int> calculate2(String skillAuthId, String liveuid,
  //     String serviceItemId, var couponId, var couponCode) async {
  //   this.code = code;
  //   Map params = Get.find<PlayOrderController>().getPayOrderModel().toJson();
  //   params['skillAuthId'] = skillAuthId;
  //   params['liveuid'] = liveuid;
  //   params['couponId'] = couponId;
  //   params['serviceItemId'] = serviceItemId;
  //   params['code'] = couponCode;
  //   await http
  //       .post('/peiwan/app/order/calculate', data: params)
  //       .then((res) async {
  //     preOrderDm.value.addObject(res.data);
  //     this.couponId = res.data['couponId'];
  //   }).catchError((e) {
  //     preOrderDm.value.toError(e.toString());
  //   });
  //   preOrderDm.refresh();
  //   return preOrderDm.value.flag;
  // }
  // Future<int> changeQuantity(int quantity, String skillAuthId) async {
  //   EasyLoading.show();
  //   nums.value = quantity;
  //   this.code = code;
  //   Map params = Get.find<MulitablePlayOrderController>().getPayOrderModel().toJson();
  //   params['skillAuthId'] = skillAuthId;
  //   params['couponId'] = couponId;
  //   // params['serviceItemId'] = serviceItemId;
  //   params['code'] = code;
  //   await http.post('/peiwan/app/order/calculate', data: params).then((res) async {
  //     // preOrderDm.value.object?['total']=res.data['total'];
  //     preOrderDm.value.addObject(res.data);

  //     this.couponId = res.data['couponId'];
  //   }).catchError((e) {
  //     EasyLoading.dismiss();
  //     preOrderDm.value.toError(e.toString());
  //   });
  //   EasyLoading.dismiss();
  //   preOrderDm.refresh();
  //   return quantity;
  // }

  void showSelectTime() {
    DateTime start = DateTime.now();
    Get.dialog<DateTime?>(
            DateTimePickerDialog(
              format: "dd-MMM-yyyy HH:mm",
              initDateTime: start,
              minDateTime: start,
              minuteDivider: 30,
            ),
            barrierColor: Colors.black26)
        .then((value) {
      if (value != null) {
        this.timeSelect.value = true;
        this.time.value = value;
      }
    });
  }

  PayOrderModel getPayOrderModel() {
    PayOrderModel model = PayOrderModel();
    model.type = -2;
    // model.totalAmount = totalAmount.value.toString();
    model.orderId = orderId;
    model.svctm = this.time.value.millisecondsSinceEpoch;
    model.preOrdersBos = serviceItemList
        .map((item) => {
              "skillAuthId": item.skillAuthid,
              "liveuid": item.uid,
              "serviceItemId": item.id,
              "nums": item.num.value,
              "couponId": 0,
            })
        .toList();
    // model.liveuid = liveUid;
    // model.skillid = skillModel.value.skillid.toString();
    // model.nums = nums.value;
    model.des = remarksController.text;
    // model.serviceItemId = serviceItemId;
    model.code = preOrderDm.value.object == 0 ? '' : this.code;
    model.couponId = couponId;
    flog('model $model');
    return model;
  }
}
