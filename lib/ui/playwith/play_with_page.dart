import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:tim_ui_kit/ui/controller/tim_uikit_conversation_controller.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/model/data_model.dart';
import 'package:wy/model/user_info_model.dart';
import 'package:wy/ui/im/play_detail.dart';
import 'package:wy/ui/playwith/filter_widget.dart';
import 'package:wy/ui/playwith/game_score_page.dart';
import 'package:wy/ui/playwith/play_profile_page.dart';
import 'package:wy/ui/playwith/play_tab_widget.dart';
import 'package:wy/ui/playwith/play_user_info.dart';
import 'package:wy/ui/playwith/success_page.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/view/views.dart';
import 'package:wy/widget/anima_switch_widget.dart';
import 'package:wy/widget/my_bouncing_scroll_physics.dart';
import 'package:wy/widget/my_custom_scroll.dart';
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
    Widget page = Obx(() => userController.imLoginDone.value
        ? ConversationPage(
            conversationController: conversationController,
          )
        : Container());
    return ScaffoldWidget(
      body: PlayTabWidget(
        isScrollable: true,
        // rightChild: rightTopViews(),
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
        tabPage: [PlayWithChild(), page],
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
    return Obx(() => userController.unreadMsgCount.value == 0
        ? Container()
        : PWidget.positioned(
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
  var gid = '';

  var playSwitchKey = 0;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    // await this.superlist(isRef: true);
  }

  ///大神列表
  var superlistDm = DataModel(flag: 2);
  Future<int> superlist({int page = 1, bool isRef = false}) async {
    await http.get('/peiwan/app/home/superlist?pageNum=$page&pageSize=10&searchParams=&gid=$gid').then((res) async {
      superlistDm.addList(res.data, true, 0);
    }).catchError((e) {
      superlistDm.toError(e.toString());
    });
    setState(() {});
    return superlistDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(children: [
      Image.asset('assets/images/play_bg.png', width: double.infinity, fit: BoxFit.cover),
      MyCustomScroll(
        isShuaxin: true,
        isGengduo: superlistDm.hasNext,
        onRefresh: () {
          playSwitchKey = getTime();
          setState(() {});
          return this.superlist(isRef: true);
        },
        onLoading: (p) => this.superlist(page: p),
        itemModel: superlistDm,
        headPadding: EdgeInsets.only(top: pmPadd.top + 56, bottom: 16),
        headers: [
          MaterialBanner(
            backgroundColor: Colors.transparent,
            content: PWidget.text('Services', [Colors.white, 20], {'ff': 'DIN'}),
            actions: [
              IconButton(
                  onPressed: () async {
                    await Get.toNamed(AppPages.MoreGames);
                    playSwitchKey = getTime();
                    setState(() => superlistDm.init());
                    this.superlist(isRef: true);
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white60,
                  ))
            ],
          ),
          PlaySwitchWidget(
            key: ValueKey(playSwitchKey),
            onTap: (v) {
              gid = v['id'] ?? '';
              setState(() => superlistDm.init());
              this.superlist(isRef: true);
            },
          ),
        ],
        mainAxisSpacing: 10,
        itemPadding: EdgeInsets.only(bottom: 16),
        itemModelBuilder: (i, data) {
          var city;
          var signature = data['signature'];
          var levelName = data['levelName'];
          Location location = Location.fromStr(data['location']);
          city = location.location();
          return PWidget.container(
            Stack(alignment: Alignment.bottomRight, children: [
              PWidget.container(
                PWidget.row([
                  Stack(alignment: Alignment.topCenter, children: [
                    if (data['thumb'] == null || data['thumb'] == '')
                      defaultAvatar()
                    else
                      PWidget.container(
                        CachedNetworkImage(imageUrl: data['thumb'], fit: BoxFit.cover, width: 74, height: 74),
                        {'crr': 8},
                      ),
                    // if (levelName != null && levelName != '')
                    //   PWidget.container(
                    //     PWidget.text('$levelName', [Colors.white54, 12]),
                    //     [74 - 8, null, Color(0xff7C5EF4)],
                    //     {'ali': PFun.lg(0, 0), 'pd': PFun.lg(2, 2, 8, 8)},
                    //   ),
                  ]),
                  PWidget.boxw(8),
                  PWidget.column([
                    PWidget.row([
                      Flexible(
                          child: Container(
                        child: Text(
                          '${data['name']}'.replaceAll("", "\u200B"),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                            constraints: BoxConstraints(maxWidth: 100),
                      )),
                      PWidget.boxw(8),
                      PWidget.container(
                        PWidget.row([
                          SexAndAgeWidget(age: '${data['age']}', sex: '${data['sex']}'),
                          PWidget.boxw(8),
                          PlayLevelWidget(level: '${data['userLevel']}', isauth: 1,userId: data['id'].toString(),),
                        ]),
                      ),
                    ]),
                    PWidget.boxh(6),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/ic_balance_money.webp",width: 18,height: 14,),
                          SizedBox(width: 5,),
                          Text("${data['price']}",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                          OrdersAndStarWidget(data,margin: [0],),
                        ]),

                    // if (signature != null && signature != '') PWidget.boxh(8),
                    // if (signature != null && signature != '') PWidget.text('$signature', [Colors.white54, 12]),
                    if (levelName != null && levelName != '') PWidget.boxh(6),
                    if (levelName != null && levelName != '') PWidget.text('$levelName', [Colors.white54, 12]),
                    Builder(builder: (context) {
                      var list = (data['label'] ?? []) as List;
                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(list.length, (i) {
                          var item = list[i];
                          // return PWidget.image('assets/images/play_item_tag.png', [72, 19]);
                          return PWidget.container(
                            PWidget.text(item, [Colors.white]),
                            [null, null, pColor],
                            {
                              'crr': 56,
                              'pd': [2, 2, 8, 8],
                            },
                          );
                        }),
                      );
                    }),
                  ], {
                    'exp': 1,
                  }),
                ], '001'),
                {'pd': 8},
              ),
              locationWidget(city),
              // if (data['online'] == 1)
              PWidget.container(
                PWidget.text(data['online'] == 1 ? 'Online' : 'OffLine', [Colors.white.withOpacity(data['online'] == 1 ? 1 : 0.5), 12]),
                [null, null, data['online'] == 1 ? Color(0xff5ADBAE) : Colors.white.withOpacity(0.1)],
                {
                  // 'gd': data['online'] == 1 ? PFun.tl2brGd(Color(0xff5ADBAE), Color(0x005ADBAE)) : PFun.tl2brGd(Color(0xFF434343), Color(0x00434343)),
                  'pd': PFun.lg(2, 2, 12, 12),
                  'br': PFun.lg(12),
                },
              ),
            ]),
            [null, null, Color(0xff282640)],
            {
              'mg': PFun.lg(0, 0, 16, 16),
              'crr': 12,
              'fun': () {
                return Get.to(() => PlayDetail(userId: "${data['id']}")); //jumpPage(PlayUserInfo(data));
              }
            },
          );
        },
      ),
    ]);
  }

  Positioned locationWidget(String city) {
    return Positioned(
        right: 10,
        top: 10,
        child: Row(
          children: [
            Icon(
              Icons.location_on,
              color: Colors.white60,
              size: 14,
            ),
            Container(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text(
                city,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(color: Colors.white60, fontSize: 11),
              ),
            )
          ],
        ));
  }

  Widget defaultAvatar() {
    return Container(
      width: 76,
      height: 76,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: AssetImage("assets/images/default_logo.webp"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}

///游戏列表
class PlaySwitchWidget extends StatefulWidget {
  final Function(Map)? onTap;

  const PlaySwitchWidget({Key? key, this.onTap}) : super(key: key);
  @override
  _PlaySwitchWidgetState createState() => _PlaySwitchWidgetState();
}

class _PlaySwitchWidgetState extends State<PlaySwitchWidget> {
  int? seleIndex;

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
      // gamelistDm.addList([
      //   for (var i = 0; i < 100; i++) ...gamelistDm.list,
      // ], false, 0);
      // if (gamelistDm.list.isNotEmpty) {
      //   fun(0, gamelistDm.list.first);
      // }
    }).catchError((e) {
      flog(e, 'gamelistDm');
      gamelistDm.toError();
    });
    flog(gamelistDm.toJson());
    setState(() {});
    if (gamelistDm.list.isNotEmpty) {
      fun(0, gamelistDm.list.isEmpty ? {} : gamelistDm.list.first);
    }
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
            separatorBuilder: (_, i) => VerticalDivider(color: Colors.transparent, width: 12),
            itemCount: list.length,
            itemBuilder: (_, i) {
              var isDy = seleIndex == i;
              var data = list[i];
              return PWidget.container(
                PWidget.ccolumn([
                  PWidget.container(
                    CachedNetworkImage(
                      imageUrl: data['thumb'],
                      fit: BoxFit.cover,
                    ),
                    [(isDy ? 72 : 64), (isDy ? 72 : 56) + 24, Colors.white10],
                    {'crr': 12},
                  ),
                  //PWidget.text('${data['name']}', [Colors.white, 12]),
                ], '211'),
                [(isDy ? 72 : 64)],
                {'fun': () => fun(i, data)},
              );
            },
          ),
          [null, (72 + 16) + 12],
        );
      },
    );
  }

  void fun(i, data) {
    if (1 != 1) {
      widget.onTap!({'id': ''});
      setState(() => seleIndex = null);
    } else {
      widget.onTap!(data);
      setState(() => seleIndex = i);
    }
  }
}
