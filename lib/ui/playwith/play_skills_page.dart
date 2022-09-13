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
        title: Text('Play Skills'),
        elevation: 0,
      ),
      btnBar: FloatingButton(
        label: 'apply for new skill',
        onTap: () async {
          var res = await Get.to(() => AddGamePage());
          if (res != null) setState(() => key = UniqueKey());
        },
      ),
      body: TabWidget(
        tabList: ['审核中', '通过', '拒绝'],
        tabPage: [PlaySkillsChild(0), PlaySkillsChild(1), PlaySkillsChild(2)],
        key: key,
      ),
    );
  }
}

class PlaySkillsChild extends StatefulWidget {
  final int status;

  const PlaySkillsChild(this.status, {Key? key}) : super(key: key);
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
    await http.get('/peiwan/app/user/authlist?pageSize=10&pageNum=$page&status=${widget.status}').then((res) async {
      authlistDm.addList(res.data['rows'], isRef, res.data['total']);
    }).catchError((e) {
      authlistDm.toError(e.toString());
    });
    flog(authlistDm.toJson(), 'skillDm');
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
          isShuaxin: true,
          isGengduo: h,
          itemModel: authlistDm,
          btmWidget: PWidget.text('No more', [Colors.white54], {'ct': true, 'pd': 8}),
          touchBottomAnimationValue: 0.1,
          onRefresh: () => this.authlist(isRef: true),
          onLoading: (p) => this.authlist(page: p),
          itemPadding: EdgeInsets.all(12),
          itemCount: list.length,
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          // divider: Divider(height: 12, color: Colors.transparent),
          itemModelBuilder: (i, data) {
            flog(data, 'skillsFlog');
            return PWidget.ccolumn([
              AspectRatio(
                aspectRatio: 1 / 1,
                child: PWidget.container(
                  CachedNetworkImage(imageUrl: data['skillThumb'], fit: BoxFit.cover),
                  {'crr': 8},
                ),
              ),
              PWidget.boxh(8),
              PWidget.text('${data['skillName']}', [Colors.white70, 12]),
              if (widget.status == 1)
                Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(
                    value: data['wswitch'] == 1,
                    thumbColor: Colors.white,
                    trackColor: Colors.white24,
                    onChanged: (v) async {
                      setState(() => data['wswitch'] = (v ? 1 : 0));
                      var jsonData = {"skillid": data['skillid'], "wswitch": data['wswitch']};
                      flog(jsonData);
                      await http.post('/peiwan/app/user/setSwitch', data: jsonData).then((v) {}).catchError((e) {
                        setState(() => data['wswitch'] = (!v ? 1 : 0));
                        EasyLoading.showToast('Network exception');
                      });
                    },
                  ),
                ),
              PWidget.boxh(8),
            ]);
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
