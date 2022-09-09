import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:tim_ui_kit/ui/controller/tim_uikit_conversation_controller.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/model/data_model.dart';
import 'package:wy/ui/im/play_detail.dart';
import 'package:wy/ui/playwith/filter_widget.dart';
import 'package:wy/ui/playwith/game_score_page.dart';
import 'package:wy/ui/playwith/play_tab_widget.dart';
import 'package:wy/ui/playwith/play_user_info.dart';
import 'package:wy/ui/playwith/success_page.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/view/views.dart';
import 'package:wy/widget/anima_switch_widget.dart';
import 'package:wy/widget/my_bouncing_scroll_physics.dart';
import 'package:wy/widget/my_custom_scroll.dart';
import 'package:wy/widget/mylistview.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/route.dart';
import 'package:wy/widget/scaffold_widget.dart';
import 'package:wy/widget/views.dart';

import '../controller/user_controller.dart';
import '../im/conversation.dart';

///陪玩
class PlayWithPage extends StatefulWidget {
  @override
  _PlayWithPageState createState() => _PlayWithPageState();
}

class _PlayWithPageState extends State<PlayWithPage> {
  var tabList = ['Play with', 'Message'];

  ScrollController scrollController = ScrollController();

  final UserController userController = Get.find<UserController>();

  TIMUIKitConversationController conversationController = TIMUIKitConversationController();

  @override
  Widget build(BuildContext context) {
    Widget page = Obx(()=>userController.imLoginDone.value?ConversationPage(conversationController: conversationController,):Container());
    return ScaffoldWidget(
      body: PlayTabWidget(
        isScrollable: true,
        rightChild: rightTopViews(),
        tabList: tabList,
        isShowLeft: false,
        // color: Color(0xff3B3860),
        controller: scrollController,
        tabBuilder: (i, t) {
          return Stack(clipBehavior: Clip.none, children: [
            Tab(text: t),
            if (i == 1) buildCount(),
          ]);
        },
        tabPage: [
          PlayWithChild(),
          page
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
              return jumpPage(GameScorePage());
              var page = SuccessPage(
                title: 'Accompany certification',
                content: ['Submitted successfully', 'The information has been submitted successfully,\nplease wait for the staff to review and confirm'],
                child: PWidget.row([buttonView('Back', fontSize: 16, width: 130)], '221'),
              );
              return jumpPage(page);
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
          {
            'pd': 8,
            'fun': () {
              var page = SuccessPage(
                title: 'Game support',
                content: ['Recharge successfully', 'Play with order has been placed, please wait for play with\nOr contact can contact play with'],
                child: PWidget.ccolumn([
                  PWidget.boxh(16),
                  PWidget.container(CachedNetworkImage(imageUrl: 'imageUrl', width: 48, height: 48), {'crr': 48}),
                  PWidget.boxh(20),
                  PWidget.row([buttonView('Sent Message', fontSize: 16, width: 130)], '221'),
                ]),
              );
              jumpPage(page);
            },
          },
        ),
        PWidget.boxw(8),
      ]),
      [null, 48],
    );
  }

  ///消息总数
  Widget buildCount() {
    return Obx(()=>userController.unreadMsgCount.value == 0 ?Container() : PWidget.positioned(
      PWidget.container(PWidget.text(userController.unreadMsgCount.value, [Colors.white, 12]), {
        'gd': PFun.tbGd(Color(0xffFF6D6D), Color(0xffFF5252)),
        'br': 24,
        'pd': PFun.lg(1, 0, 4, 4),
      }),
      [-4, null, null, -16],
    ));


  }
}

class PlayWithChild extends StatefulWidget {
  @override
  _PlayWithChildState createState() => _PlayWithChildState();
}

class _PlayWithChildState extends State<PlayWithChild> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.superlist(isRef: true);
  }

  ///大神列表
  var superlistDm = DataModel();
  Future<int> superlist({int page = 1, bool isRef = false}) async {
    await http.get('/peiwan/app/home/superlist?pageNum=$page&pageSize=10&searchParams=').then((res) async {
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
    super.build(context);
    return Stack(
      children: [
        Image.asset('assets/images/play_bg.png', width: double.infinity, fit: BoxFit.cover),
        MyCustomScroll(
          isShuaxin: true,
          isGengduo: superlistDm.hasNext,
          onRefresh: () => this.superlist(isRef: true),
          onLoading: (p) => this.superlist(page: p),
          itemModel: superlistDm,
          headPadding: EdgeInsets.only(top: pmPadd.top + 56, bottom: 16),
          headers: [PlaySwitchWidget(onTap: (v) => EasyLoading.showToast(v.toString()))],
          mainAxisSpacing: 10,
          itemPadding: EdgeInsets.only(bottom: 16),
          itemModelBuilder: (i, data) {
            flog(data, 'superlist');
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
                      PWidget.text('${data['name']}', [Colors.white, 14, true]),
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
                if (data['online'] == 1)
                  PWidget.container(PWidget.text('Online', [Colors.white, 10]), {
                    'gd': PFun.cl2crGd(Color(0xff5ADBAE), Color(0x005ADBAE)),
                    'pd': PFun.lg(1, 1, 12, 12),
                  }),
              ]),
              [null, null, Color(0xff282640)],
              {
                'mg': PFun.lg(0, 0, 16, 16),
                'crr': 12,
                'fun': () {
                  return Get.to(()=>PlayDetail(userId: "2"));//jumpPage(PlayUserInfo(data));
                }
              },
            );
          },
        ),
        // MyListView(
        //   isShuaxin: true,
        //   isGengduo: superlistDm.hasNext,
        //   onRefresh: () => this.superlist(isRef: true),
        //   onLoading: () => this.superlist(page: superlistDm.page),
        //   value: superlistDm,
        //   padding: EdgeInsets.only(top: pmPadd.top + 56),
        //   itemCount: superlistDm.list.length + 1,
        //   listViewType: ListViewType.Separated,
        //   divider: Divider(height: 10, color: Colors.transparent),
        //   item: (i) {
        //     if (i == 0) return PlaySwitchWidget();
        //     i = i - 1;
        //     var data = superlistDm.list[i];
        //     flog(data, 'superlistDm');
        //     return PWidget.container(
        //       Stack(children: [
        //         PWidget.container(
        //           PWidget.row([
        //             PWidget.container(
        //               CachedNetworkImage(
        //                 imageUrl: 'https://pic1.afdiancdn.com/user/de28a438903911ecb24d52540025c377/common/f1b37f4c524ca61b9a0c2da941f0a35f_w960_h960_s271.jpg?imageView2/1/w/576/h/320',
        //                 fit: BoxFit.cover,
        //                 width: 74,
        //                 height: 74,
        //               ),
        //               {'crr': 8},
        //             ),
        //             PWidget.boxw(8),
        //             PWidget.column([
        //               PWidget.text('Nick name', [Colors.white, 14, true]),
        //               PWidget.boxh(8),
        //               PWidget.text('我擅长英雄联盟以及永劫无间，请找我吧~', [Colors.white54, 12]),
        //               PWidget.boxh(8),
        //               Wrap(
        //                 spacing: 8,
        //                 runSpacing: 8,
        //                 children: List.generate(3, (i) {
        //                   return PWidget.image('assets/images/play_item_tag.png', [72, 19]);
        //                 }),
        //               ),
        //             ], {
        //               'exp': 1,
        //             }),
        //           ], '001'),
        //           {'pd': 8},
        //         ),
        //         PWidget.container(PWidget.text('Online', [Colors.white, 10]), {
        //           'gd': PFun.cl2crGd(Color(0xff5ADBAE), Color(0x005ADBAE)),
        //           'pd': PFun.lg(1, 1, 12, 12),
        //         }),
        //       ]),
        //       [null, null, Color(0xff282640)],
        //       {
        //         'mg': PFun.lg(0, 0, 16, 16),
        //         'crr': 12,
        //         'fun': () {
        //           return jumpPage(PlayUserInfo());
        //         }
        //       },
        //     );
        //   },
        // ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

///游戏列表
class PlaySwitchWidget extends StatefulWidget {
  final Function(Map)? onTap;

  const PlaySwitchWidget({Key? key, this.onTap}) : super(key: key);
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
  }

  var gamelistDm = DataModel<dynamic>();
  Future<int> gamelist() async {
    await http.get('/peiwan/app/home/gamelist?pageNum=1&pageSize=10&searchParams=').then((res) async {
      gamelistDm.addList(res.data, true, 0);
    }).catchError((e) {
      flog(e, 'gamelistDm');
      gamelistDm.toError();
    });
    flog(gamelistDm.toJson());
    setState(() {});
    return gamelistDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitchBuilder<dynamic>(
      value: gamelistDm,
      errorOnTap: () => this.gamelist(),
      listBuilder: (list, p, h) {
        return PWidget.container(
          ListView.separated(
            physics: MyBouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            separatorBuilder: (_, i) => VerticalDivider(color: Colors.transparent, width: 10),
            itemCount: list.length,
            itemBuilder: (_, i) {
              var isDy = seleIndex == i;
              var data = list[i];
              flog(data);
              return PWidget.container(
                PWidget.ccolumn([
                  PWidget.container(
                    CachedNetworkImage(
                      imageUrl: data['thumb'],
                      fit: BoxFit.cover,
                    ),
                    [isDy ? 64 : 56, isDy ? 64 : 56, Colors.white10],
                    {'crr': 8},
                  ),
                  PWidget.boxh(8),
                  PWidget.text('${data['name']}', [Colors.white, 12]),
                ], '211'),
                [isDy ? 64 : 56],
                {'fun': () => fun(i, data)},
              );
            },
          ),
          [null, 64 + 14 + 16],
        );
      },
    );
  }

  void fun(i, data) {
    widget.onTap!(data);
    setState(() => seleIndex = i);
  }
}
