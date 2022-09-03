import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/profile/balance/balance_page.dart';
import 'package:wy/ui/profile/balance/input_formatter.dart';
import 'package:wy/ui/profile/balance/item_title.dart';
import 'package:wy/widget/mylistview.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/scaffold_widget.dart';
import 'package:wy/widget/views.dart';

class MyEarningsPage extends StatefulWidget {
  @override
  _MyEarningsPageState createState() => _MyEarningsPageState();
}

class _MyEarningsPageState extends State<MyEarningsPage> {
  late BalancePageController controller;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    controller = Get.put(BalancePageController());
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
      PWidget.container(
        PWidget.column([
          PWidget.row([
            PWidget.image('assets/images/play/xingzuan_gold.png'),
            PWidget.boxw(4),
            PWidget.text('Withdrawal income amount', [Color(0xffEEF3FF)], {'exp': true}),
          ]),
          PWidget.boxh(10),
          PWidget.text('532', [Color(0xffEEF3FF), 32, true]),
        ]),
        [null, null, Color(0xff282640)],
        {'pd': 16, 'br': 12, 'mg': PFun.lg(0, 0, 16, 16)},
      ),
      ItemTitle(title: "Enter withdrawal amount", subTitle: ""),
      _buildCustomInput(),
      ItemTitle(title: "Withdrawal Account", subTitle: ""),
      _buildAccountSelect(context),
      PWidget.boxh(8),
      FloatingButton(
        label: "Withdrawal",
        onTap: () => controller.pay(),
      ),
      PWidget.container(
        PWidget.column([
          PWidget.text('Withdrawal and exchange instructions:', [Color(0xffEEF3FF)]),
          PWidget.text('''1. Withdrawal introduction and relevant legal provisions；
1. Withdrawal introduction and relevant legal provisions；
1. Withdrawal introduction and relevant legal provisions；
1. Withdrawal introduction and relevant legal provisions；
1. Withdrawal introduction and relevant legal provisions；
1. Withdrawal introduction and relevant legal provisions；
1. Withdrawal introduction and relevant legal provisions；
1. Withdrawal introduction and relevant legal provisions；
1. Withdrawal introduction and relevant legal provisions；
1. Withdrawal introduction and relevant legal provisions；''', [Color(0xff8291B4)]),
        ]),
        {'pd': 16},
      ),
    ];
  }

  Widget _buildCustomInput() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white24))),
        child: TextField(
          maxLines: 1,
          inputFormatters: [PrecisionLimitFormatter(2)],
          controller: controller.amountController,
          focusNode: controller.amountFocusNode,
          cursorColor: Colors.white70,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.white30, fontSize: 26, fontFamily: "DIN"),
          onSubmitted: (text) => controller.changeCustomAmount(text),
          decoration: const InputDecoration(hintText: "£0", hintStyle: TextStyle(fontSize: 26, color: Colors.white30, fontFamily: "DIN"), border: InputBorder.none, contentPadding: EdgeInsets.only(top: 0)),
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
            decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
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
                      style: TextStyle(fontSize: 18, color: controller.accountType.value == 0 ? Colors.white : Colors.white30, fontFamily: "DIN"),
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
