import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/profile/balance/balance_page.dart';
import 'package:wy/ui/profile/balance/charge_item.dart';
import 'package:wy/ui/profile/balance/count_view.dart';
import 'package:wy/ui/profile/balance/input_formatter.dart';
import 'package:wy/ui/profile/balance/item_title.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/mylistview.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/scaffold_widget.dart';
import 'package:wy/widget/views.dart';

class PlayBalanceChild extends StatefulWidget {
  @override
  _PlayBalanceChildState createState() => _PlayBalanceChildState();
}

class _PlayBalanceChildState extends State<PlayBalanceChild> {
  late BalancePageController controller;
  var coin; //参数
  var votes; //钻石数
  @override
  void initState() {
    this.initData();
    if (Get.arguments != null) {
      coin = Get.arguments['coin'];
      votes = Get.arguments['votes'];
    }
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
      btnBar: FloatingButton(
        label: "CONFIRM",
        onTap: () => controller.pay(),
      ),
    );
  }

  List<Widget> get item {
    return [
      cardView(),
      ItemTitle(title: "Recharge", subTitle: ""),
      PWidget.boxh(8),
      Obx(() => _buildChargeItems(context!)),
      Obx(
        () => ItemTitle(
            title: "Other recharge amount",
            subTitle: '',
            customSubTitle: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  PWidget.image('assets/images/ic_balance_money.webp', [16, 16]),
                  Text(
                    " ${controller.iconByChargeRatio}",
                    style: TextStyle(color: Colors.yellow),
                  )
                ],
              ),
            ),
            actions: Text(
              'Min:£1',
              style: TextStyle(color: Colors.white54, fontFamily: "DIN", fontSize: 18),
            )),
      ),
      _buildCustomInput(),
      // ItemTitle(title: "Top Up Account", subTitle: ""),
      // _buildAccountSelect(context!),
    ];
  }

  Widget _buildCustomInput() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white24))),
        child: TextField(
          maxLines: 1,
          inputFormatters: [PrecisionLimitFormatter(2)],
          controller: controller.amountController,
          focusNode: controller.amountFocusNode,
          cursorColor: Colors.white70,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(
              color: Colors.white30, fontSize: 26, fontFamily: "DIN"),
          onSubmitted: (text) => controller.changeCustomAmount(text),
          decoration: const InputDecoration(
              hintText: "£1",
              hintStyle: TextStyle(fontSize: 26, color: Colors.white30, fontFamily: "DIN"),
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 0)),
        ));
  }

  Widget cardView() {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Color(0xFFFF3BC1)),
      child: AspectRatio(
        aspectRatio: 343 / 136,
        child: Stack(children: [
          Positioned(left: 0, right: 0, bottom: 0, height: 100, child: ClipPath(clipper: BottomPath(), child: Container(color: Colors.white30))),
          Positioned(left: 0, right: 0, bottom: 0, height: 100, child: ClipPath(clipper: _Bottom2Path(), child: Container(color: Colors.white30))),
          Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xaaFF3BC2), Color(0x998B00FF)]))),
          Positioned(right: 0, top: -10, width: 100, child: Image.asset("assets/images/bg_balance.webp")),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CountView(icon: "money", title: "Coin", count: "${coin ?? '0'}"),
              CountView(icon: "votes", title: "Diamond", count: '${votes ?? '0'}'),
            ],
          ),
        ]),
      ),
    );
  }

  Widget _buildChargeItems(BuildContext context) {
    controller.list.forEach((element) {
      flog(element);
    });
    List<Widget> itemList = [];
    int index = 0;
    controller.list.forEach((element) {
      itemList.add(ChargeItem(
        showCoin: true,
        index: index,
        item: element,
        selected: index == controller.productIndex.value,
        onTap: (idx) => controller.changeProductIndex(idx),
      ));
      index++;
    });
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      shrinkWrap: true,
      crossAxisCount: 3,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      childAspectRatio: 104 / 114,
      children: itemList,
    );
  }
}

class BottomPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var controlPoint;
    var endPoint;
    var path = Path();
    path.moveTo(0, size.height);
    path.lineTo(-size.width * 5 / 100, size.height * 70 / 100);

    controlPoint = Offset(size.width * 5 / 100, size.height * 80 / 100); //曲线开始点
    endPoint = Offset(size.width * 20 / 100, size.height * 45 / 100); // 曲线结束点
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    controlPoint = Offset(size.width * 38 / 100, 0); //曲线开始点
    endPoint = Offset(size.width * 60 / 100, size.height * 55 / 100); // 曲线结束点
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    controlPoint = Offset(size.width * 80 / 100, size.height); //曲线开始点
    endPoint = Offset(size.width, size.height * 75 / 100); // 曲线结束点
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    path.lineTo(size.width, size.height); // 第五个点
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class _Bottom2Path extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 55 / 100);
    path.cubicTo(size.width * 322 / 700, 0, size.width * 382 / 700, size.height * 1.3, size.width, size.height * 60 / 100);
    path.lineTo(size.width, size.height); // 第五个点
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
