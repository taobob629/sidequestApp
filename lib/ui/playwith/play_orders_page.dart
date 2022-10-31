import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/model/data_model.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/im/order_detail.dart';
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
  bool isAuth = false;
  final controller = Get.find<UserController>();

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    isAuth = controller.userInfoModel.value.isauth == 1;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: AppBar(title: Text('Orders'), elevation: 0),
      body: TabWidget(
        indicator: null,
        isScrollable: false,
        tabList: isAuth ? ['我接受的', '我发起的'] : ['我发起的', '我接受的'],
        indicatorSize: TabBarIndicatorSize.tab,
        tabPage: isAuth ? [PlayOrdersChild(2), PlayOrdersChild(1)] : [PlayOrdersChild(1), PlayOrdersChild(2)],
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
      var list = (res.data['rows'] ?? []) as List;
      // orderlistDm.addList(list, isRef, (!isRef && list.isEmpty) ? orderlistDm.list.length : 9999);
      orderlistDm.addList(list, isRef, res.data['total']);
    }).catchError((e) {
      orderlistDm.toError(e.toString());
    });
    flog(orderlistDm.toJson(), 'skillDm');
    setState(() {});
    return orderlistDm.flag;
  }

  var statusMap = {-4: '已超时', -3: '拒绝', -2: '已完成', -1: '取消', 0: '待支付', 1: '已支付', 2: '已接单', 3: '等待退款', 4: '拒绝退款', 5: '同意退款', 6: '退款申诉,等待平台退款'};

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnimatedSwitchBuilder(
      value: orderlistDm,
      isRef: true,
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
          crossAxisCount: 1,
          mainAxisSpacing: 8,
          // divider: Divider(height: 12, color: Colors.transparent),
          itemModelBuilder: (i, data) {
            flog(data, 'ordersFlog');
            var skillVo = data['skillVo'];
            return PWidget.container(
              PWidget.row(
                [
                  if (skillVo['thumb'] != null) PWidget.container(CachedNetworkImage(imageUrl: skillVo['thumb'], fit: BoxFit.cover, width: 64, height: 64), {'crr': 8}),
                  if (skillVo['thumb'] != null) PWidget.boxw(8),
                  PWidget.column([
                    PWidget.text('${skillVo['nameEn']}', [Colors.white, 16, true], {'isOf': false}),
                    PWidget.spacer(),
                    PWidget.text('Services：${data['nums']} ${skillVo['method']}\t\t\t\t\t\t', [Colors.white54]),
                    PWidget.boxh(4),
                    PWidget.row([
                      PWidget.text('Price：', [Colors.white54]),
                      PWidget.image('assets/images/ic_balance_money.webp', [16, 16]),
                      PWidget.text('\t${data['total']}', [Colors.white54]),
                    ]),
                  ], {
                    'exp': 1
                  }),
                  PWidget.column([
                    PWidget.text('${statusMap[data['status']]}', [Colors.white54])
                  ], '221'),
                ],
                '011',
                {'fill': true},
              ),
              [null, null, Colors.white.withOpacity(0.05)],
              {
                'pd': 12,
                'br': 8,
                'fun': () async {
                  await Get.to(() => OrderDetail(orderId: int.parse(data['id'])));
                  this.orderlist(isRef: true);
                },
              },
            );
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
