import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/model/data_model.dart';
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/playwith/add_game_page.dart';
import 'package:wy/ui/playwith/scroll_monitor_widget.dart';
import 'package:wy/ui/playwith/swiper_widget.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/mylistview.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/route.dart';
import 'package:wy/widget/scaffold_widget.dart';
import 'package:wy/widget/views.dart';

buttonView(label, {Widget? child, Function? onTap, double height = 35, double fontSize = 14, double? width, EdgeInsetsGeometry? padding}) {
  return ColorfulButton(
    height: height,
    width: width,
    child: Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16).copyWith(top: 4),
      child: child ??
          Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: fontSize, fontFamily: "DIN"),
          ),
    ),
    onTap: onTap,
  );
}

class PlayUserInfo extends StatefulWidget {
  final Map data;
  const PlayUserInfo(this.data, {Key? key}) : super(key: key);
  @override
  _PlayUserInfoState createState() => _PlayUserInfoState();
}

class _PlayUserInfoState extends State<PlayUserInfo> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.getSuper();
  }

  ///大神详细接口
  var superDm = DataModel();
  Future<int> getSuper() async {
    await http.get('/peiwan/app/home/super/${widget.data['id']}').then((res) async {
      superDm.addList(res.data, true, 0);
    }).catchError((e) {
      superDm.toError(e.toString());
    });
    flog(superDm.toJson());
    setState(() {});
    return superDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      body: Stack(children: [
        MyListView(controller: controller, isShuaxin: false, flag: false, item: (i) => item[i], itemCount: item.length),
        titleView(),
        headPortraitView(),
        PWidget.positioned(
          PWidget.row([
            PWidget.image('assets/images/play/gz.png', [null, 50], {'exp': true}),
            PWidget.boxw(12),
            PWidget.image('assets/images/play/msg.png', [null, 50], {'exp': true}),
          ]),
          [null, 16, 16, 16],
        ),
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
      SwiperWidget(imageList: ['', '', ''], height: 300),
      PWidget.container(
        PWidget.column([
          PWidget.row([
            PWidget.container(
              PWidget.row([
                PWidget.container(
                  PWidget.text('${'Services'.tr}:', [Colors.white70, 12]),
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
              PWidget.textIs('${'Follow'.tr}：', [Color(0xff8291B4), 12]),
              PWidget.textIs('232', [Color(0xffEEF3FF), 16]),
            ]),
            PWidget.boxw(16),
            PWidget.text('', [], {}, [
              PWidget.textIs('${'Fans'.tr}：', [Color(0xff8291B4), 12]),
              PWidget.textIs('232W', [Color(0xffEEF3FF), 16]),
            ]),
          ]),
          PWidget.boxh(16),
          gamesView(),
          Divider(color: Colors.white24, height: 24),
          PWidget.text(
            "I'm good at League of heroes and eternity. Please come to me~".tr,
            [Color(0xff8291B4), 12],
            {'isOf': false},
          ),
          Divider(color: Colors.white24, height: 24),
          PWidget.container(
            PWidget.column([
              PWidget.text("Accompanying materials".tr, [Colors.white, 16, true]),
              PWidget.boxh(4),
              PWidget.container(PWidget.boxh(0), [24, 4, Colors.white], {'br': 4}),
            ]),
          ),
          PWidget.text('Personal information'.tr, [Colors.white, 14], {'pd': PFun.lg(16, 16)}),
          PWidget.row([
            PWidget.container(
              PWidget.text('ID：', [Color(0xff8291B4), 12]),
              [40],
            ),
            PWidget.text('12345', [Color(0xff8291B4), 12]),
          ]),
        ]),
        // [null, null, Color(0xff171525)],
        {'br': PFun.lg(12, 12), 'pd': 12},
      ),
    ];
  }

  ///游戏列表
  Widget gamesView() {
    return PWidget.column([
      PWidget.text('${'Good games'.tr}:：', [Colors.white, 21], {'ff': 'DIN'}),
      PWidget.boxh(8),
      if (games.isEmpty)
        Stack(alignment: Alignment.center, children: [
          AspectRatio(aspectRatio: 343 / 151, child: Image.asset('assets/images/play/games_bg.png')),
          GestureDetector(
            child: Image.asset('assets/images/play/add_games.png', height: 44),
            onTap: () {
              jumpPage(AddGamePage({}));
            },
          ),
        ])
      else
        PWidget.container(
          Wrap(
            runSpacing: 10,
            children: List.generate(games.length, (i) {
              return PWidget.container(
                Stack(alignment: Alignment.centerLeft, children: [
                  Image.asset('assets/images/play_bg.png', fit: BoxFit.cover, height: 80, width: double.infinity),
                  Positioned.fill(child: PWidget.container(PWidget.boxh(0), {'gd': PFun.cl2crGd(Color(0xff7400FF), Color(0xff7400FF).withOpacity(0))})),
                  PWidget.row([
                    PWidget.boxw(13 / 2),
                    PWidget.container(
                      Image.asset('assets/images/play_bg.png', fit: BoxFit.cover, height: 67, width: 67),
                      // CachedNetworkImage(imageUrl: 'imageUrl', width: 67, height: 67),
                      {'crr': 4},
                    ),
                    PWidget.boxw(8),
                    PWidget.column([
                      PWidget.text('LEAGUE OF LEGENDS'.tr, [Colors.white, 14, true]),
                      PWidget.text('King 120star'.tr, [Colors.white54, 12]),
                      PWidget.text('', [], {}, [
                        PWidget.textIs('£ 10.99', [Colors.white, 18, true]),
                        PWidget.textIs('\t\t/30min', [Colors.white54, 12]),
                      ]),
                    ], {
                      'exp': 1
                    }),
                    PWidget.boxw(8),
                    buttonView("Place an order".tr, onTap: () {}),
                    PWidget.boxw(8),
                  ]),
                ]),
                {'crr': 8},
              );
            }),
          ),
          [null, null, Color(0xFF282640)],
          {'br': 12, 'pd': 10},
        ),
    ]);
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
            PWidget.text('Edit'.tr, [Colors.white, 16], {'pd': 4}),
          ]),
          [null, 48],
          {'pd': PFun.lg(0, 0, 8, 8)},
        ),
      ], '000'),
    );
  }
}
