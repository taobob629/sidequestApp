import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/model/data_model.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/playwith/add_game_page.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/anima_switch_widget.dart';
import 'package:wy/widget/my_custom_scroll.dart';
import 'package:wy/widget/mylistview.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/route.dart';
import 'package:wy/widget/scaffold_widget.dart';
import 'package:wy/widget/tab_widget.dart';

class PlaySkillsPage extends StatefulWidget {
  @override
  _PlaySkillsPageState createState() => _PlaySkillsPageState();
}

class _PlaySkillsPageState extends State<PlaySkillsPage> {
  UniqueKey? key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: AppBar(
        title: Text('My Services'.tr),
        elevation: 0,
      ),
      btnBar: FloatingButton(
        label: 'Add Service'.tr,
        onTap: () async {
          var res = await Get.to(() => AddGamePage({}));
          if (res != null) setState(() => key = UniqueKey());
        },
      ),
      body: PlaySkillsChild(key: key),
      // body: TabWidget(
      //   isScrollable: false,
      //   indicator: null,
      //   indicatorSize: TabBarIndicatorSize.tab,
      //   tabList: ['通过', '审核中', '拒绝'],
      //   tabPage: [PlaySkillsChild(1), PlaySkillsChild(0), PlaySkillsChild(2)],
      //   // tabList: ['审核中', '通过', '拒绝'],
      //   // tabPage: [PlaySkillsChild(0), PlaySkillsChild(1), PlaySkillsChild(2)],
      //   key: key,
      // ),
    );
  }
}

class PlaySkillsChild extends StatefulWidget {
  const PlaySkillsChild({Key? key}) : super(key: key);
  @override
  _PlaySkillsChildState createState() => _PlaySkillsChildState();
}

class _PlaySkillsChildState extends State<PlaySkillsChild> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.authlist(isRef: true);
  }

  ///技能列表
  var authlistDm = DataModel();
  Future<int> authlist({int page = 1, bool isRef = false}) async {
    await http.get('/peiwan/app/user/myauthlist').then((res) async {
      authlistDm.addList(res.data, isRef, 0);
    }).catchError((e) {
      authlistDm.toError(e.toString());
    });
    setState(() {});
    return authlistDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnimatedSwitchBuilder(
      value: authlistDm,
      errorOnTap: () => this.authlist(isRef: true),
      listBuilder: (list, p, h) {
        return MyCustomScroll(
          isShuaxin: false,
          isGengduo: false,
          itemModel: authlistDm,
          btmWidget: PWidget.text('No more'.tr, [Colors.white54], {'ct': true, 'pd': 8}),
          touchBottomAnimationValue: 0.1,
          // onRefresh: () => this.authlist(isRef: true),
          // onLoading: (p) => this.authlist(page: p),
          itemPadding: EdgeInsets.all(12),
          itemCount: list.length,
          crossAxisCount: 1,
          mainAxisSpacing: 12,
          // divider: Divider(height: 12, color: Colors.transparent),
          itemModelBuilder: (i, data) {
            return PWidget.row([
              CachedNetworkImage(imageUrl: data['skillThumb'], fit: BoxFit.cover, width: 64, height: 64),
              PWidget.boxw(8),
              PWidget.column([
                PWidget.text('${data['skillName']}', [Colors.white, 16, true]),
                PWidget.boxh(4),
                PWidget.text('${data['levelName']}', [Colors.white54, 12]),
                if (data['status'] == 2) PWidget.boxh(4),
                if (data['status'] == 2) PWidget.text('${data['reason']}', [Colors.red, 12]),
              ], {
                'exp': 1
              }),
              PWidget.container(
                PWidget.text({'2': 'eidt'.tr, '0': 'under review'.tr, '1': 'edit'.tr}['${data['status']}'], [
                  {'2': Colors.black.withOpacity(0.75), '0': Colors.white24, '1': Colors.black.withOpacity(0.75)}['${data['status']}'],
                  16,
                ], {
                  'pd': PFun.lg(4, 4, 12, 12),
                  'fun': () {
                    if ([1, 2].contains(data['status']))
                      return jumpPage(AddGamePage(data), callback: (res) {
                        if (res != null) this.authlist(isRef: true);
                      });
                  }
                }),
                [
                  null,
                  null,
                  {'2': Colors.white, '0': Colors.white.withOpacity(0.1), '1': Colors.white}['${data['status']}']
                ],
                {'br': 56},
              ),
            ]);
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
