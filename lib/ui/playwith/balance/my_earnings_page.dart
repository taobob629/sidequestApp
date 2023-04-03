import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/common/privacy_check.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/playwith/balance/play_balance_child.dart';
import 'package:wy/ui/playwith/balance/widget/bank_widget.dart';
import 'package:wy/ui/profile/balance/input_formatter.dart';
import 'package:wy/ui/profile/balance/item_title.dart';
import 'package:wy/widget/mylistview.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/scaffold_widget.dart';
import 'package:wy/widget/views.dart';

import '../../../config/icon_font.dart';
import '../../../image_utils.dart';

class MyEarningsPage extends StatefulWidget {
  @override
  _MyEarningsPageState createState() => _MyEarningsPageState();
}

class _MyEarningsPageState extends State<MyEarningsPage> {
  late WalletBalancePageController controller;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    controller = Get.put(WalletBalancePageController());
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      body: MyListView(
        isShuaxin: false,
        padding: EdgeInsets.only(top: pmPadd.top + 56),
        item: (i) => item[i],
        itemCount: item.length,
      ),
    );
  }

  List<Widget> get item {
    return [
      Stack(
        children: [
          Container(
              margin: EdgeInsets.symmetric(horizontal: 15.w),
              child: Image.asset(
                ImageUtils.pic_amount,
                fit: BoxFit.fill,
              )),
          PWidget.container(
            PWidget.column([
              PWidget.row([
                PWidget.image('assets/images/ic_balance_votes.webp'),
                PWidget.boxw(6),
                PWidget.text('Total amount'.tr, [Color(0xffEEF3FF), 14, true],
                    {'exp': true}),
              ]),
              PWidget.boxh(10),
              Obx(() => PWidget.text(
                  '${controller.diamonds}', [Color(0xffEEF3FF), 32, true])),
            ]),
            [null, null, null],
            {'pd': 16, 'br': 12, 'mg': PFun.lg(0, 0, 16, 16)},
          ),
        ],
      ),
      Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20.h),
        margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Color(0xff262731),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Withdrawal amount".tr,
                  style: TextStyle(
                      color: Color(0xffb2b9c9),
                      fontFamily: "DIN",
                      fontSize: 13),
                ),
                GestureDetector(
                  onTapDown: (details) {
                    print(details.globalPosition);
                    Get.dialog(WithdrawTipsDialog(
                      offset: details.globalPosition,
                    ));
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 6),
                    width: 12.w,
                    height: 12.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xffb2b9c9),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Image.asset(
                      ImageUtils.icon_help,
                      width: 10.w,
                      height: 10.w,
                    ),
                  ),
                )
              ],
            ),
            _buildCustomInput(),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: controller.selectMethodReceipt,
              child: GetBuilder<WalletBalancePageController>(
                builder: (builder) {
                  return Row(
                    children: [
                      Text(
                        "Method of receipt".tr,
                        style: TextStyle(
                          color: Color(0xffb2b9c9),
                          fontFamily: "DIN",
                          fontSize: 14.sp,
                        ),
                      ),
                      Spacer(),
                      Image.asset(
                        controller.currentPayMethod == null
                            ? ImageUtils.icon_bank
                            : controller.currentPayMethod!.icon!,
                        width: 16.w,
                        height: 16.w,
                      ),
                      8.horizontalSpace,
                      Text(
                        controller.currentPayMethod == null
                            ? ""
                            : controller.currentPayMethod!.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "DIN",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      8.horizontalSpace,
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                    ],
                  );
                },
                id: controller.currentPayMethodId,
              ),
            ),
          ],
        ),
      ),
      Obx(() => Column(
            children: [
              // Container(
              //   margin: EdgeInsets.only(left: 15, right: 15, top: 20),
              //   clipBehavior: Clip.antiAlias,
              //   decoration: BoxDecoration(
              //       color: Color(0xff282640),
              //       borderRadius: BorderRadius.circular(20)),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Radio(
              //                 value: 0,
              //                 groupValue: controller.withdrawType.value,
              //                 onChanged: (value) {
              //                   print(value);
              //                   controller.withdrawType.value =
              //                       int.parse(value.toString());
              //                 }),
              //             Text(
              //               "Bank Card".tr,
              //               style: TextStyle(color: Colors.white),
              //             ),
              //           ],
              //         ),
              //       ),
              //       Expanded(
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Radio(
              //                 value: 1,
              //                 groupValue: controller.withdrawType.value,
              //                 onChanged: (value) {
              //                   print(value);
              //                   controller.withdrawType.value =
              //                       int.parse(value.toString());
              //                 }),
              //             Text(
              //               "Paypal",
              //               style: TextStyle(color: Colors.white),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              if (controller.withdrawType.value == 0) ...[
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 16.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 16.h),
                      decoration: BoxDecoration(
                        color: Color(0xff262731),
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Withdrawal amount".tr,
                            style: TextStyle(
                                color: Color(0xffb2b9c9),
                                fontFamily: "DIN",
                                fontSize: 13),
                          ),
                          Spacer(),
                          controller.ifBankPay.value
                              ? GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    if (controller.bankList.length >= 4) {
                                      EasyLoading.showToast(
                                          'Only 4 bankcards allowed!'.tr);
                                      return;
                                    }
                                    Get.toNamed(AppPages.BindBankCard);
                                  },
                                  child: controller.currentPayMethod?.id == null
                                      ? Row(
                                          children: [
                                            Image.asset(
                                              ImageUtils.icon_add_earnings,
                                              width: 17.w,
                                              height: 17.w,
                                            ),
                                            4.horizontalSpace,
                                            Text(
                                              'Add'.tr,
                                              style: TextStyle(
                                                color: Color(0xffFFCB0E),
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Image.asset(
                                              ImageUtils.icon_edit_earnings,
                                              width: 17.w,
                                              height: 17.w,
                                            ),
                                            4.horizontalSpace,
                                            Text(
                                              'edit'.tr,
                                              style: TextStyle(
                                                color: Color(0xffFFCB0E),
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                )
                              : Text(
                                  (controller.currentPayMethod == null ||
                                          controller.currentPayMethod?.account
                                                  .length ==
                                              0)
                                      ? 'no account'
                                      : controller.currentPayMethod!.name,
                                  style: TextStyle(
                                    color: Color(0xffFFCB0E),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    //  _buildAccountSelect(context),
                    BankListWidget(),
                  ],
                )
              ] else ...[
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    padding: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.white24))),
                    child: TextField(
                      maxLines: 1,
                      controller: controller.paypalController,
                      cursorColor: Colors.white70,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 26, fontFamily: "DIN"),
                      // onSubmitted: (text) => controller.changeCustomAmount(text),
                      decoration: const InputDecoration(
                          hintText: "paypal account",
                          hintStyle: TextStyle(
                              fontSize: 26,
                              color: Colors.white30,
                              fontFamily: "DIN"),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 0)),
                    )),
              ]
            ],
          )),
      PWidget.boxh(8),
      FloatingButton(
        label: "Withdrawal".tr,
        onTap: () {
          if (controller.privacyCheckController.check()) {
            if (controller.withdrawType.value == 0) {
              controller.withDraw('withDraw');
            } else {
              controller.withDraw("paypal");
            }
          } else {
            EasyLoading.showInfo(
                'You should read and agree to our seller payment terms first.'
                    .tr);
          }
        },
      ),
      // FloatingButton(
      //   label: "Paypal Withdrawal".tr,
      //   onTap: () {
      //     if (controller.privacyCheckController.check()) {
      //       Get.dialog(PaypalWithdrawDialog()).then((value) {
      //         if (value != null && value.toString().isNotEmpty) {
      //           controller.withDraw('paypal', cardNum: value);
      //         }
      //       });
      //     } else {
      //       EasyLoading.showInfo('You should read and agree to our seller payment terms first.'.tr);
      //     }
      //   },
      // ),
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => controller.privacyCheckController.check()
            ? controller.withDraw('exchange')
            : EasyLoading.showInfo(
                'You should read and agree to our seller payment terms first.'
                    .tr,
              ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          height: 40.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40.r),
            border: Border.all(
              color: Color(0xffF4C708),
              width: 1.w,
            ),
          ),
          child: Text(
            'Exchange To Coin'.tr,
            style: TextStyle(
              color: Color(0xffF4C708),
              fontSize: 14.sp,
              fontFamily: FONT_MEDIUM,
            ),
          ),
        ),
      ),

      PWidget.boxh(8),
      PrivacyCheck(
          controller: controller.privacyCheckController, type: TYPE_ADD_BANK),
    ];
  }

  Widget _buildCustomInput() {
    return Container(
        margin: EdgeInsets.only(
          top: 30.h,
          bottom: 15.h,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xff2d2e3a),
            ),
          ),
        ),
        child: Row(
          children: [
            PWidget.image('assets/images/ic_balance_votes.webp'),
            4.horizontalSpace,
            Expanded(
              child: TextField(
                maxLines: 1,
                inputFormatters: [PrecisionLimitFormatter(2)],
                controller: controller.amountController,
                focusNode: controller.amountFocusNode,
                cursorColor: Colors.white70,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontFamily: "DIN",
                ),
                onSubmitted: (text) => controller.changeCustomAmount(text),
                decoration: const InputDecoration(
                  hintText: "0.00",
                  hintStyle: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontFamily: "DIN",
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 0),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildAccountSelect(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Column(
        children: [
          Container(
            height: 50,
            padding: const EdgeInsets.only(left: 10, right: 15),
            decoration: BoxDecoration(
                color: Colors.white10, borderRadius: BorderRadius.circular(12)),
            child: Obx(() {
              return Row(
                children: [
                  Radio(
                      activeColor: AppColor.accent,
                      value: 0,
                      groupValue: controller.accountType.value,
                      onChanged: (value) {
                        controller.changeAccountType(0);
                        controller.accountFocusNode.unfocus();
                      }),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      "2930118234@qq.com",
                      style: TextStyle(
                          fontSize: 18,
                          color: controller.accountType.value == 0
                              ? Colors.white
                              : Colors.white30,
                          fontFamily: "DIN"),
                    ),
                  )
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class WithdrawTipsDialog extends StatelessWidget {
  WithdrawTipsDialog({Key? key, required this.offset}) : super(key: key);
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Positioned(
          top: offset.dy - MediaQuery.of(Get.context!).padding.top + 15,
          left: offset.dx - 10,
          child: ClipPath(
            clipper: Triangle(dir: -1),
            child: Container(
              width: 20.0,
              height: 10.0,
              color: Color(0xff282640),
              child: null,
            ),
          ),
        ),
        Positioned(
          top: offset.dy - MediaQuery.of(Get.context!).padding.top + 15 + 10,
          width: Get.width - offset.dx / 2,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                color: Color(0xff282640),
                borderRadius: BorderRadius.circular(10)),
            child: PWidget.container(
              PWidget.column([
                PWidget.text('Withdrawal and exchange instructions:'.tr,
                    [Color(0xffEEF3FF)]),
                Text(
                  '''1. ${'Withdrawals typically take three to five bank working days.'.tr}\n2. ${'6 Diamond for £1.'.tr}\n3. ${'If you withdraw cash from us, you’ll be charged a handling fee of 3%.'.tr}''',
                  style: TextStyle(color: Color(0xff8291B4), height: 1.5),
                ),
              ]),
              {'pd': 16},
            ),
          ),
        ),
      ],
    );
  }
}

class Triangle extends CustomClipper<Path> {
  double dir;

  Triangle({required this.dir});

  @override
  Path getClip(Size size) {
    var path = Path();

    double w = size.width;
    double h = size.height;
    if (dir < 0) {
      path.moveTo(w / 2, 0);
      path.quadraticBezierTo(w / 2, 0, 0, h);
      path.quadraticBezierTo(0, h, w, h);
    } else {
      path.quadraticBezierTo(0, h / 2, w * 2 / 3, h);
      path.quadraticBezierTo(w / 3, h / 3, w, 0);
      path.lineTo(0, 0);
    }
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
