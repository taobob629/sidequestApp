import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/wy_http.dart';
import '../../common/base_scaffold.dart';
import '../../common/dialog_date_time_picker.dart';
import '../../common/input_view.dart';
import '../../common/paixs_fun.dart';
import '../../common/quantity_selector.dart';
import '../../common/select_view.dart';
import '../../controller/user_controller.dart';
import '../../model/data_model.dart';
import '../../model/pay_order_model.dart';
import '../../model/play_detail_model.dart';
import '../../utils/navigator_helper.dart';
import '../../utils/toast_utils.dart';
import '../../utils/utils.dart';
import '../../widget/anima_switch_widget.dart';
import '../../widget/paixs_widget.dart';
import '../../widget/views.dart';
import 'pay_button.dart';

class PlayOrder extends StatelessWidget {
  late final SkillModel skillModel;
  late final PlayOrderController controller;
  final String liveUid;
  final Map serviceItem;

  TextEditingController textCon = TextEditingController();

  PlayOrder({required this.liveUid, required this.skillModel, required this.serviceItem}) {
    controller = Get.put(PlayOrderController(liveUid, skillModel, '${serviceItem['id']}', ''));
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
                    _buildItem(),
                    // buildServerItem(controller.preOrderDm.value.object?['serviceItems']),
                    buildServerItem(serviceItem),
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
                        // PWidget.row([
                        //   PWidget.text("${'Service Tax'.tr}", [Colors.white, 18], {'exp': true}),
                        //   PWidget.image("assets/images/ic_balance_money.webp", [20, 20]),
                        //   PWidget.boxw(5),
                        //   PWidget.text(controller.preOrderDm.value.object?['tax'], [Colors.white, 16]),
                        // ]),
                        // PWidget.boxh(15),
                        // YouhuiquanInputWidget(textCon, (v) async {
                        //   await controller.calculate(skillModel.authId.toString(), liveUid, '${serviceItem['id']}', v);
                        //   if (controller.calculateDm.value.object == 0) textCon.clear();
                        // }),
                        GestureDetector(
                          // onTap: () => Get.find<UserController>().checkLogin(() => NavigatorHelper.gotoCouponPage(
                          //     preOrder: Get.find<PlayOrderController>().getPayOrderModel().toJson(),
                          //     //  payOrderModel: pageController.getPayOrderModel(),
                          //     onSelect: (model) async {
                          //       //  flog('v $model');
                          //       await controller.calculate(
                          //         skillModel.authId.toString(),
                          //         liveUid,
                          //         '${serviceItem['id']}',
                          //         model.id,
                          //         model.couponModel.couponCode,
                          //       );
                          //     })),
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
                      [null, null, Colors.black],
                      {'pd': 15},
                    ),
                    PayButton(),
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

  Widget buildServerItem(serviceItem) {
    if (serviceItem == null) return PWidget.boxh(0);
    return PWidget.container(
      PWidget.row([
        PWidget.text(serviceItem['name'], [Colors.white], {'exp': true}),
        PWidget.image("assets/images/ic_balance_money.webp", [18, 18]),
        PWidget.boxw(5),
        PWidget.text("${serviceItem['price']}", [Colors.white, 18, true], {'null': ''}),
        PWidget.text(" / ${serviceItem['unit']}", [Colors.white, 12], {'null': '', 'exp': true}),
        PWidget.boxw(4),
        QuantitySelector(
          initValue: 1,
          tag: "1",
          onQuantityChanged: (quantity) async {
            flog(serviceItem);
            await controller.changeQuantity(quantity, '${serviceItem['skillAuthid']}');
          },
        )
      ]),
      {'pd': PFun.lg(8, 8, 15, 15)},
    );
  }

  Widget _buildItem() {
    return Container(
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
                  child: controller.skillModel.value.thumb == ""
                      ? Container()
                      : CachedNetworkImage(
                          imageUrl: controller.skillModel.value.thumb,
                          fit: BoxFit.cover,
                        ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          controller.skillModel.value.name,
                          maxLines: 2,
                          style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "DIN"),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Text(
                            "",
                            style: TextStyle(color: Colors.white54, fontSize: 12),
                          )),
                          // QuantitySelector(
                          //   initValue: 1,
                          //   tag: "1",
                          //   onQuantityChanged: (quantity) {
                          //     controller.changeQuantity(quantity);
                          //   },
                          // )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          if (1 != 1)
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/ic_balance_money.webp",
                    width: 18,
                    height: 18,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      "${controller.skillModel.value.coin}",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "DIN"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 7.0, left: 5),
                    child: Text(
                      " /  ${skillModel.unit}",
                      style: TextStyle(color: Colors.white54, fontSize: 14, fontFamily: "DIN"),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
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

class PlayOrderController extends GetxController {
  // var totalAmount = 0.0.obs;
  var balance = 0.0.obs;

  var nums = 1.obs;

  var timeSelect = false.obs;

  var time = DateTime.now().obs;

  late TextEditingController remarksController;

  Rx<SkillModel> skillModel = SkillModel().obs;

  late final String liveUid;
  late final String serviceItemId;
  late String code;

  var fellv = 0.0.obs;

  PlayOrderController(String liveUid, SkillModel skillModel, String serviceItemId, String code) {
    remarksController = TextEditingController();
    this.skillModel.value = skillModel;
    this.liveUid = liveUid;
    this.serviceItemId = serviceItemId;
    this.code = code;
    preOrder(skillModel.authId.toString(), liveUid, serviceItemId);
    // calculate(skillModel.authId.toString(), liveUid, serviceItemId, code);
  }

  @override
  void onInit() {
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

  Future<int> preOrder(String skillAuthId, String liveuid, String serviceItemId) async {
    await http.get('/peiwan/app/order/preOrder', queryParameters: {
      "skillAuthId": skillAuthId,
      "liveuid": liveuid,
      "serviceItemId": serviceItemId,
    }).then((res) async {
      preOrderDm.value.addObject(res.data);
      // totalAmount.value =
      //     (double.parse(preOrderDm.value.object?['serviceItems']['price']));
      nums.value = 1;
      balance.value = double.parse('${res.data['coin']}');
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

  Future<int> calculate(String skillAuthId, String liveuid, String serviceItemId, var couponId, var couponCode) async {
    this.code = code;
    Map params = Get.find<PlayOrderController>().getPayOrderModel().toJson();
    params['skillAuthId'] = skillAuthId;
    params['liveuid'] = liveuid;
    params['couponId'] = couponId;
    params['serviceItemId'] = serviceItemId;
    params['code'] = couponCode;
    await http.post('/peiwan/app/order/calculate', data: params).then((res) async {
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
  Future<int> changeQuantity(int quantity, String skillAuthId) async {
    showLoading();
    nums.value = quantity;
    this.code = code;
    Map params = Get.find<PlayOrderController>().getPayOrderModel().toJson();
    params['skillAuthId'] = skillAuthId;
    params['couponId'] = couponId;
    params['serviceItemId'] = serviceItemId;
    params['code'] = code;
    await http.post('/peiwan/app/order/calculate', data: params).then((res) async {
      // preOrderDm.value.object?['total']=res.data['total'];
      preOrderDm.value.addObject(res.data);

      this.couponId = res.data['couponId'];
    }).catchError((e) {
      dismissLoading();
      preOrderDm.value.toError(e.toString());
    });
    dismissLoading();
    preOrderDm.refresh();
    return quantity;
  }

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
    model.svctm = this.time.value.millisecondsSinceEpoch;
    model.liveuid = liveUid;
    model.skillid = skillModel.value.id;
    model.nums = nums.value;
    model.des = remarksController.text;
    model.serviceItemId = serviceItemId;
    model.code = preOrderDm.value.object == 0 ? '' : this.code;
    model.couponId = couponId;
    flog('model $model');
    return model;
  }
}
