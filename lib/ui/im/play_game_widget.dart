import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:tim_ui_kit/tim_ui_kit.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/model/play_detail_model.dart';
import 'package:wy/model/skill_item_model.dart';
import 'package:wy/model/skill_model.dart' as m;
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/im/chat.dart';
import 'package:wy/ui/im/play_detail.dart';
import 'package:wy/ui/im/play_order.dart';
import 'package:wy/ui/playwith/add_game_page.dart';
import 'package:wy/ui/playwith/game_comment.dart';
import 'package:wy/ui/playwith/play_profile_page.dart';
import 'package:wy/ui/playwith/skill/list/controller.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/expansion_tile.dart';
import 'package:wy/widget/mylistview.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/views.dart';

// 陪玩游戏组件
class PlayGameWidget extends StatefulWidget {
  final SkillModel skillModel;
  final PlayDetailController controller;
  final int i;
  const PlayGameWidget(this.skillModel, this.controller, this.i, {Key? key}) : super(key: key);
  @override
  _PlayGameWidgetState createState() => _PlayGameWidgetState();
}

class _PlayGameWidgetState extends State<PlayGameWidget> {
  ///自己视角
  bool isMe = false;

  @override
  Widget build(BuildContext context) {
    var isOpen = widget.skillModel.wswitch == 1;
    isMe = widget.controller.userId == Get.find<UserController>().userInfoModel.value.pwuserId.toString();
    var serviceItems = widget.skillModel.serviceItem;
    var isShow = isOpen && widget.skillModel.background != '';
    return PWidget.container(
      Stack(
        children: [
          if (isShow) bgImageView(-pmSize.width),
          // Positioned.fill(
          //     child: PWidget.container(
          //   null,
          //   [null, null, Colors.black],
          //   {'br': 8},
          // )),
          ExpansionTileWidget(
            title: GestureDetector(
              // onTap: () async {
              //   if(isMe){
              //     await Get.to(()=>AddGamePage({"id":skillModel.authId}));
              //     controller.onReady();
              //     return;
              //   }else if(isOpen){
              //   var res = await Get.to(()=>PlayOrder(liveUid: "${controller.detailModel.value.userId}", skillModel: skillModel,));
              //   flog('$res','Get.to(()=>PlayOrder');
              //   if(res != null){
              //     var conversationManager = TencentImSDKPlugin.v2TIMManager.getConversationManager();
              //     V2TimValueCallback<V2TimConversation> conv = await conversationManager.getConversation(conversationID: "c2c_${controller.detailModel.value.memberId}");
              //     if(conv.data != null) {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) =>
              //             Chat(
              //               selectedConversation: conv.data!,
              //               orderSn: res,
              //             ),
              //         ));
              //     }
              //   }
              //   }
              // },
              child: Container(
                // height: 100,
                decoration: BoxDecoration(color: widget.skillModel.wswitch == 0 ? Colors.white12 : Color(0xFF7D00FF)),
                child: Stack(children: [
                  if (isShow) bgImageView(0),
                  Row(children: [
                    // SizedBox(width: 8),
                    // CachedNetworkImage(imageUrl: "${widget.skillModel.thumb}", width: 66, height: 66, fit: BoxFit.cover),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.skillModel.star <= 0) PWidget.boxh(8),
                          PWidget.row([
                            //646*158
                            PWidget.boxw((pmSize.width) * (263 / 646)),
                            PWidget.text("${widget.skillModel.name}", [Colors.white], {'exp': true}),
                            if (widget.skillModel.star > 0)
                              OrdersAndStarWidget(
                                {
                                  ///controller.detailModel.value
                                  'orders': widget.skillModel.orders,
                                  'star': widget.skillModel.star,
                                },
                                bgColor: Colors.transparent,
                                isTran: true,
                                fun: () => Get.to(() => GameComment(widget.skillModel, "${widget.skillModel.authId}")),
                              ),
                          ]),
                          if (widget.skillModel.star <= 0) PWidget.boxh(8),
                          PWidget.row([
                            PWidget.text("${widget.skillModel.level}", [Colors.white54, 12], {'pd': PFun.lg(0, 0, (pmSize.width + 24) * (263 / 646)), 'exp': true}),
                            PWidget.image("assets/images/ic_balance_money.webp", [18, 18]),
                            PWidget.boxw(5),
                            PWidget.text("${widget.skillModel.coin}", [Colors.white, 18, true]),
                            PWidget.text(" / ${widget.skillModel.unit}", [Colors.white, 12]),
                          ]),
                          if (isOpen || isMe)
                            PWidget.container(
                              PWidget.text(isMe ? "Edit".tr : "Play".tr, [Colors.white], {'ff': 'DIN'}),
                              [null, null, Colors.black26],
                              {
                                'wali': PFun.lg(1, 0),
                                'mg': PFun.lg(8, 8),
                                'br': 56,
                                'pd': PFun.lg(4, 4, 12, 12),
                                if (isMe) 'fun': () => fun(context, isOpen, {}),
                              },
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                  ]),
                ]),
              ),
            ),
            onTap: () => animaOpen(),
            controller: playDetailValue.animationController[widget.i],
            children: [
              MyListView(
                isShuaxin: false,
                itemCount: serviceItems.length,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(top: 8),
                divider: Divider(color: Colors.white10, height: 12, thickness: 1),
                item: (i) {
                  var serviceItem = serviceItems[i];
                  return PWidget.container(
                    PWidget.row([
                      PWidget.text(serviceItem['name'], [Colors.white], {'exp': true}),
                      PWidget.row([
                        PWidget.image("assets/images/ic_balance_money.webp", [18, 18]),
                        PWidget.boxw(5),
                        PWidget.text("${serviceItem['price']}", [Colors.white, 18, true], {'null': ''}),
                        PWidget.text(" / ${serviceItem['unit']}", [Colors.white, 12], {'null': ''}),
                      ], {
                        'exp': 1
                      }),
                      if ((isOpen || isMe))
                        Opacity(
                          opacity: !isMe ? 1 : (serviceItem['isDefault'] == 0 ? 1 : 0.25),
                          child: PWidget.container(
                            PWidget.text(isMe ? "Edit".tr : "Play".tr, [Colors.white], {'ff': 'DIN'}),
                            [null, null, Colors.black26],
                            {
                              'wali': PFun.lg(1, 0),
                              'mg': PFun.lg(8, 8),
                              'br': 56,
                              'pd': PFun.lg(4, 4, 12, 12),
                              if (serviceItem['isDefault'] == 0 || !isMe) 'fun': () => fun(context, isOpen, serviceItem),
                            },
                          ),
                        ),
                    ]),
                    {'pd': PFun.lg(0, 0, 8, 8)},
                  );
                },
              ),
            ],
          ),
        ],
      ),
      {'mg': PFun.lg(0, 8), 'crr': 8},
    );
  }

  Future<void> fun(BuildContext context, bool isOpen, Map serviceItem) async {
    if (isMe) {
      if (serviceItem.isEmpty) {
        //父级
        // await Get.to(() => AddGamePage({"id": widget.skillModel.authId}));
        await Get.toNamed(AppPages.SkillList);
        widget.controller.onReady();
      } else {
        //子级
        // var controller = Get.put(SkillListPageController());
        // var sm = m.SkillModel();
        // sm.skillid = serviceItem['skillid'];
        // sm.levelid = serviceItem['levelId'];
        // sm.id = serviceItem['id'];
        // sm.skillName = serviceItem['skillName'];
        // controller.addSkillItem(sm);
        // await Get.to(() => AddGamePage({"id": widget.skillModel.authId}));
        // widget.controller.onReady();
        // var skillItemModel = SkillItemModel(id: serviceItem['id']);
        // await Get.toNamed(AppPages.SkillItem,
        // arguments: Map()
        //   ..['id'] = skillItemModel.id
        //   ..['skillid'] = serviceItem['skillid']
        //   ..['levelid'] = serviceItem['levelId']
        //   ..['skillAuthid'] = serviceItem['skillAuthid']
        //   ..['skillName'] = serviceItem['skillName']);
        await Get.toNamed(AppPages.SkillList);
        widget.controller.onReady();
      }
      return;
    } else if (isOpen) {
      var res = await Get.to(() {
        return PlayOrder(
          liveUid: "${widget.controller.detailModel.value.userId}",
          skillModel: widget.skillModel,
          serviceItem: serviceItem,
        );
      });
      flog('$res', 'Get.to(()=>PlayOrder');
      if (res != null) {
        var conversationManager = TencentImSDKPlugin.v2TIMManager.getConversationManager();
        V2TimValueCallback<V2TimConversation> conv = await conversationManager.getConversation(conversationID: "c2c_${widget.controller.detailModel.value.memberId}");
        if (conv.data != null) Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(selectedConversation: conv.data!, orderSn: res)));
      }
    }
  }

  Widget bgImageView(double left) {
    return Positioned.fill(
      left: left,
      child: Stack(fit: StackFit.expand, children: [
        CachedNetworkImage(imageUrl: "${widget.skillModel.background}", fit: BoxFit.cover),
        if (left != 0) PWidget.container(null, [null, null, Colors.black12]),
      ]),
    );
  }

  ///展开
  void animaOpen() => setState(() {
        for (var i = 0; i < playDetailValue.animationController.length; i++) {
          if (i != widget.i) {
            playDetailValue.animationController[i].reverse();
          } else {
            if (playDetailValue.animationController[i].isCompleted) {
              playDetailValue.animationController[i].reverse();
            } else {
              playDetailValue.animationController[i].forward();
            }
          }
        }
      });
}
