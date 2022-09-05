import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/playwith/scroll_monitor_widget.dart';
import 'package:wy/ui/playwith/swiper_widget.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/mylistview.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/scaffold_widget.dart';
import 'package:wy/widget/views.dart';

buttonView(label, {Function? onTap, double height = 40, EdgeInsetsGeometry? padding}) {
  return ColorfulButton(
    height: height,
    child: Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16).copyWith(top: 4),
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "DIN"),
      ),
    ),
    onTap: onTap,
  );
}

class PlayUserInfo extends StatefulWidget {
  @override
  _PlayUserInfoState createState() => _PlayUserInfoState();
}

class _PlayUserInfoState extends State<PlayUserInfo> {
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      body: Stack(children: [
        MyListView(controller: controller, isShuaxin: false, flag: false, item: (i) => item[i], itemCount: item.length),
        titleView(),
        headPortraitView(),
      ]),
    );
  }

  ///头像
  Widget headPortraitView() {
    return ScrollMonitorWidget(
      controller: controller,
      builder: (v) {
        return PWidget.positioned(
          Stack(alignment: Alignment.bottomCenter, children: [
            PWidget.container(
              CachedNetworkImage(imageUrl: '', width: 70, height: 70),
              {'br': 70, 'bd': PFun.bdAllLg(Colors.white, 2)},
            ),
            PWidget.container(
              PWidget.row([
                PWidget.image('assets/images/play/online.png', [10, 10]),
                PWidget.boxw(4),
                PWidget.text('Online', [Colors.white, 10]),
              ]),
              [null, null, Color(0xff5ADBAE)],
              {'br': 56, 'pd': PFun.lg(2, 2, 10, 10)},
            ),
          ]),
          [300 - 35 - v, null, 16],
          {'anima': PFun.lg2(100, Curves.easeOutCubic)},
        );
      },
    );
  }

  var games = [];

  List<Widget> get item {
    return [
      SwiperWidget(
        imageList: ['', '', ''],
        height: 300,
      ),
      PWidget.container(
        PWidget.column([
          PWidget.row([
            PWidget.container(
              PWidget.row([
                PWidget.container(
                  PWidget.text('接单数:', [Colors.white70, 12]),
                  [null, null, Color(0xff63608C)],
                  {'pd': PFun.lg(2, 2, 8, 4)},
                ),
                PWidget.text('1212', [Colors.white70, 12], {'pd': PFun.lg(0, 0, 8, 8)}),
                ...List.generate(5, (i) {
                  return PWidget.image('assets/images/play/xingzuan_gold.png', [10, 10]);
                }),
                PWidget.boxw(8),
              ]),
              [null, null, Color(0xff444264)],
              {'crr': 56},
            ),
          ], '111'),
          PWidget.boxh(16),
          PWidget.text('Nick Name', [Colors.white, 20]),
          PWidget.boxh(8),
          PWidget.row([
            PWidget.text('', [], {}, [
              PWidget.textIs('Follow：', [Color(0xff8291B4), 12]),
              PWidget.textIs('232', [Color(0xffEEF3FF), 16]),
            ]),
            PWidget.boxw(16),
            PWidget.text('', [], {}, [
              PWidget.textIs('Fans：', [Color(0xff8291B4), 12]),
              PWidget.textIs('232W', [Color(0xffEEF3FF), 16]),
            ]),
          ]),
          PWidget.boxh(16),
          PWidget.text('Good games:：', [Colors.white, 21], {'ff': 'DIN'}),
          PWidget.container(
            Wrap(
              runSpacing: 10,
              children: List.generate(4, (i) {
                return PWidget.container(
                  Stack(children: [
                    Image.asset('assets/images/play_bg.png', fit: BoxFit.cover, height: 80, width: double.infinity),
                    Positioned.fill(child: PWidget.container(PWidget.boxh(0), {'gd': PFun.cl2crGd(Color(0xff7400FF), Color(0xff7400FF).withOpacity(0))})),
                    PWidget.row([
                      PWidget.container(
                        Image.asset('assets/images/play_bg.png', fit: BoxFit.cover, height: 67, width: 67),
                        // CachedNetworkImage(imageUrl: 'imageUrl', width: 67, height: 67),
                        {'crr': 4},
                      ),
                      buttonView(
                        "Place an order",
                        onTap: () {},
                      ),
                    ]),
                  ]),
                  {'crr': 8},
                );
              }),
            ),
            [null, null, Color(0xFF282640)],
            {
              'br': 12,
              'pd': 10,
            },
          ),
        ]),
        [null, null, Color(0xff171525)],
        {'br': PFun.lg(12, 12), 'pd': 12},
      ),
    ];
  }

  ///标题栏
  Widget titleView() {
    return PWidget.container(
      PWidget.column([
        PWidget.boxh(pmPadd.top),
        PWidget.container(
          PWidget.row([
            GestureDetector(
              onTap: () => close(),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                ),
              ),
            ),
            PWidget.spacer(),
            PWidget.text('Edit', [Colors.white, 16], {'pd': 4}),
          ]),
          [null, 48],
          {'pd': PFun.lg(0, 0, 8, 8)},
        ),
      ], '000'),
    );
  }
}
