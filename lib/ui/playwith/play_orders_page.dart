import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/model/data_model.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/playwith/add_game_page.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/anima_switch_widget.dart';
import 'package:wy/widget/my_custom_scroll.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/scaffold_widget.dart';
import 'package:wy/widget/tab_widget.dart';

class PlayOrdersPage extends StatefulWidget {
  @override
  _PlayOrdersPageState createState() => _PlayOrdersPageState();
}

class _PlayOrdersPageState extends State<PlayOrdersPage> {
  UniqueKey? key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: AppBar(
        title: Text('Play Orders'),
        elevation: 0,
      ),
      body: TabWidget(
        tabList: ['我发起的', '我接受的'],
        tabPage: [PlayOrdersChild(1), PlayOrdersChild(1)],
        key: key,
      ),
    );
  }
}

class PlayOrdersChild extends StatefulWidget {
  final int status;

  const PlayOrdersChild(this.status, {Key? key}) : super(key: key);
  @override
  _PlayOrdersChildState createState() => _PlayOrdersChildState();
}

class _PlayOrdersChildState extends State<PlayOrdersChild> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.orderlist(isRef: true);
  }

  ///技能列表
  var orderlistDm = DataModel();
  Future<int> orderlist({int page = 1, bool isRef = false}) async {
    await http.get('/peiwan/app/order/list?pageSize=10&pageNum=$page&type=${widget.status}').then((res) async {
      orderlistDm.addList(res.data['list'], isRef, 0);
    }).catchError((e) {
      orderlistDm.toError(e.toString());
    });
    flog(orderlistDm.toJson(), 'skillDm');
    setState(() {});
    return orderlistDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnimatedSwitchBuilder(
      value: orderlistDm,
      errorOnTap: () => this.orderlist(isRef: true),
      listBuilder: (list, p, h) {
        return MyCustomScroll(
          isShuaxin: true,
          isGengduo: h,
          itemModel: orderlistDm,
          touchBottomAnimationValue: 0.1,
          btmWidget: PWidget.text('No more', [Colors.white54], {'ct': true, 'pd': 8}),
          onRefresh: () => this.orderlist(isRef: true),
          onLoading: (p) => this.orderlist(page: p),
          itemPadding: EdgeInsets.all(12),
          itemCount: list.length,
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          // divider: Divider(height: 12, color: Colors.transparent),
          itemModelBuilder: (i, data) {
            flog(data, 'skillsFlog');
            return PWidget.column([
              AspectRatio(
                aspectRatio: 1 / 1,
                child: PWidget.container(
                  CachedNetworkImage(imageUrl: data['skillThumb'], fit: BoxFit.cover),
                  {'crr': 8},
                ),
              ),
              PWidget.text(
                '${data['skillName']}',
                [Colors.white70, 12],
                {'pd': PFun.lg(8, 8)},
              ),
              // CupertinoSwitch(
              //     value: data['isOpen'] == 1,
              //     onChanged: (v) {
              //       setState(() {
              //         data['isOpen'] = (v ? 1 : 0);
              //       });
              //     }),
            ]);
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
