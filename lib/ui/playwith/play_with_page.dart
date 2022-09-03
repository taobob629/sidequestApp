import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/model/data_model.dart';
import 'package:wy/ui/playwith/filter_widget.dart';
import 'package:wy/ui/playwith/play_tab_widget.dart';
import 'package:wy/ui/playwith/play_user_info.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/view/views.dart';
import 'package:wy/widget/my_bouncing_scroll_physics.dart';
import 'package:wy/widget/mylistview.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/route.dart';
import 'package:wy/widget/scaffold_widget.dart';
import 'package:wy/widget/views.dart';

///陪玩
class PlayWithPage extends StatefulWidget {
  @override
  _PlayWithPageState createState() => _PlayWithPageState();
}

class _PlayWithPageState extends State<PlayWithPage> {
  var tabList = ['Play with', 'Message'];

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      body: PlayTabWidget(
        isScrollable: true,
        rightChild: rightTopViews(),
        tabList: tabList,
        // color: Color(0xff3B3860),
        controller: scrollController,
        tabBuilder: (i, t) {
          return Stack(clipBehavior: Clip.none, children: [
            Tab(text: t),
            if (i == 1) buildCount(Random().nextInt(99)),
          ]);
        },
        tabPage: [
          PlayWithChild(),
          Container(
            alignment: Alignment.center,
            child: Text('im', style: TextStyle(fontSize: 24, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // 顶部按钮
  Widget rightTopViews() {
    return PWidget.container(
      PWidget.row([
        PWidget.icon(
          Icons.menu_rounded,
          [Colors.white],
          {
            'pd': 8,
            'fun': () {
              return FilterWidget.show(fun: (v) {
                EasyLoading.showToast('$v');
              });
            }
          },
        ),
        PWidget.boxw(8),
        PWidget.icon(
          Icons.search_rounded,
          [Colors.white],
          {'pd': 8},
        ),
        PWidget.boxw(8),
      ]),
      [null, 48],
    );
  }

  ///消息总数
  Widget buildCount(count) {
    return PWidget.positioned(
      PWidget.container(PWidget.text(count ?? '99', [Colors.white, 12]), {
        'gd': PFun.tbGd(Color(0xffFF6D6D), Color(0xffFF5252)),
        'br': 24,
        'pd': PFun.lg(1, 0, 4, 4),
      }),
      [-4, null, null, -16],
    );
  }
}

class PlayWithChild extends StatefulWidget {
  @override
  _PlayWithChildState createState() => _PlayWithChildState();
}

class _PlayWithChildState extends State<PlayWithChild> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        Image.asset('assets/images/play_bg.png', width: double.infinity, fit: BoxFit.cover),
        MyListView(
          isShuaxin: false,
          isGengduo: false,
          padding: EdgeInsets.only(top: pmPadd.top + 56),
          item: (i) {
            if (i == 0) return PlaySwitchWidget();
            i = i - 1;
            return PWidget.container(
              Stack(children: [
                PWidget.container(
                  PWidget.row([
                    PWidget.container(
                      CachedNetworkImage(
                        imageUrl: 'https://pic1.afdiancdn.com/user/de28a438903911ecb24d52540025c377/common/f1b37f4c524ca61b9a0c2da941f0a35f_w960_h960_s271.jpg?imageView2/1/w/576/h/320',
                        fit: BoxFit.cover,
                        width: 74,
                        height: 74,
                      ),
                      {'crr': 8},
                    ),
                    PWidget.boxw(8),
                    PWidget.column([
                      PWidget.text('Nick name', [Colors.white, 14, true]),
                      PWidget.boxh(8),
                      PWidget.text('我擅长英雄联盟以及永劫无间，请找我吧~', [Colors.white54, 12]),
                      PWidget.boxh(8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(3, (i) {
                          return PWidget.image('assets/images/play_item_tag.png', [72, 19]);
                        }),
                      ),
                    ], {
                      'exp': 1,
                    }),
                  ], '001'),
                  {'pd': 8},
                ),
                PWidget.container(PWidget.text('Online', [Colors.white, 10]), {
                  'gd': PFun.cl2crGd(Color(0xff5ADBAE), Color(0x005ADBAE)),
                  'pd': PFun.lg(1, 1, 12, 12),
                }),
              ]),
              [null, null, Color(0xff282640)],
              {'mg': PFun.lg(0, 0, 16, 16), 'crr': 12, 'fun': () {
                // return jumpPage(PlayUserInfo());
              }},
            );
          },
          itemCount: 100 + 1,
          listViewType: ListViewType.Separated,
          divider: Divider(height: 10, color: Colors.transparent),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class PlaySwitchWidget extends StatefulWidget {
  @override
  _PlaySwitchWidgetState createState() => _PlaySwitchWidgetState();
}

class _PlaySwitchWidgetState extends State<PlaySwitchWidget> {
  int seleIndex = 0;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.gamelist();
    await this.superlist();
  }

  var gamelistDm = DataModel();
  Future<int> gamelist() async {
    await http.get('/app/home/gamelist?pageNum=1&pageSize=10&searchParams=111').then((res) async {
      gamelistDm.addList(res.data, true, 0);
    }).catchError((e) {
      gamelistDm.toError();
    });
    flog(gamelistDm.toJson());
    setState(() {});
    return gamelistDm.flag;
  }

  var superlistDm = DataModel();
  Future<int> superlist({int page = 1, bool isRef = false}) async {
    await http.get('/app/home/superlist?pageNum=$page&pageSize=10&searchParams=').then((res) async {
      superlistDm.addList(res.data, true, 0);
    }).catchError((e) {
      superlistDm.toError(e.toString());
    });
    flog(superlistDm.toJson());
    setState(() {});
    return superlistDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    // return
    return PWidget.container(
      ListView.separated(
        physics: MyBouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        separatorBuilder: (_, i) => VerticalDivider(color: Colors.transparent, width: 10),
        itemCount: 10,
        itemBuilder: (_, i) {
          var isDy = seleIndex == i;
          return PWidget.container(
            PWidget.ccolumn([
              PWidget.container(Placeholder(), [isDy ? 64 : 56, isDy ? 64 : 56, Colors.white10], {'crr': 8}),
              PWidget.boxh(8),
              PWidget.text('文本', [Colors.white, 12]),
            ], '211'),
            {'fun': () => setState(() => seleIndex = i)},
          );
        },
      ),
      [null, 64 + 14 + 16],
    );
  }
}
