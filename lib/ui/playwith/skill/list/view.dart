/*
  view
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/model/skill_item_model.dart';
import 'package:wy/model/skill_model.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/playwith/add_game_page.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/route.dart';
import 'package:wy/widget/scaffold_widget.dart';
import 'package:wy/widget/views.dart';

import 'controller.dart';

class SkillListPage extends GetView<SkillListPageController> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
        appBar: AppBar(
          title: Text('My Services'.tr),
          elevation: 0,
        ),
        btnBar: FloatingButton(
          onTap: () async {
            controller.addGame();
          },
          label: 'Add Service'.tr,
        ),
        body: Obx(() => controller.pageState == SkillListPageController.INIT
            ? buildLoad()
            : controller.list.isEmpty
                ? PWidget.text(
                    'No more'.tr, [Colors.white54], {'ct': true, 'pd': 8})
                : ListView.separated(
                    itemBuilder: (context, index) => item(index),
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.white10,
                    ),
                    itemCount: controller.list.length,
                  )));
  }

  Widget item(int index) {
    var data = controller.list[index];
    return ListTile(
      dense: true,
      title: Container(
        padding: EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/skill_rect_bg.webp'),
                fit: BoxFit.fill)),
        child: PWidget.row([
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/skill_circle_bg.webp'),
                    fit: BoxFit.fill)),
            child: CircleAvatar(
              radius: 32,
              child: ClipOval(
                child: CachedNetworkImage(
                    imageUrl: data.skillThumb ?? '',
                    fit: BoxFit.cover,
                    width: 64,
                    height: 64),
              ),
            ),
          ),
          PWidget.boxw(8),
          PWidget.column([
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PWidget.text('${data.skillName}', [Colors.yellow, 18, true],
                    {'ff': 'DIN'}),
                Row(
                  children: [
                    if (data.status != SkillModel.PASS)
                      PWidget.container(
                        PWidget.text(
                            {
                              '2': 'edit'.tr,
                              '0': 'under review'.tr,
                              '1': 'edit'.tr
                            }['${data.status}'],
                            [
                              {
                                '2': Colors.black.withOpacity(0.75),
                                '0': Colors.white24,
                                '1': Colors.black
                              }['${data.status}'],
                              14,
                            ],
                            {
                              'pd': PFun.lg(2, 2, 8, 8),
                              'fun': () {
                                if ([SkillModel.DENIED, SkillModel.PASS]
                                    .contains(data.status))
                                  return jumpPage(AddGamePage(data.toJson()),
                                      callback: (res) {
                                    if (res != null) controller.refresh();
                                  });
                                ; //todo
                              }
                            }),
                        [
                          null,
                          null,
                          {
                            '2': Colors.white,
                            '0': Colors.white.withOpacity(0.1),
                            '1': Colors.white.withOpacity(0.5)
                          }['${data.status}']
                        ],
                        {'br': 56},
                      ),
                    if (data.status == SkillModel.PASS)
                      GestureDetector(
                          onTap: () => jumpPage(AddGamePage(data.toJson()),
                                  callback: (res) {
                                if (res != null) controller.refresh();
                              }),
                          child: Icon(
                            Icons.edit_note_rounded,
                            size: 24,
                            color: Colors.white,
                          )),
                    if (data.status == SkillModel.PASS) PWidget.boxw(4),
                    if (data.status == SkillModel.PASS)
                      GestureDetector(
                          onTap: () => controller.addSkillItem(data),
                          child: Icon(
                            Icons.add,
                            size: 24,
                            color: Colors.green,
                          )),
                  ],
                )
              ],
            ),
            PWidget.boxh(4),
            PWidget.text('${data.levelName}', [Colors.white, 12]),
            // if (data.status == SkillModel.DENIED) PWidget.boxh(4),
            // if (data.status == SkillModel.DENIED)
            //   PWidget.text('${data.reason}', [Colors.red, 12]),
          ], {
            'exp': 1
          }),
        ]),
      ),
      //contentPadding: EdgeInsets.all(0),
      subtitle: Container(child: Column(children: _buildBottom(data))),
    );
  }

  _buildBottom(SkillModel data) {
    List<Widget> items = [];
    var skillItems = data.childItemVoList;
    items.add(PWidget.boxh(6));
    if (data.status == SkillModel.DENIED) items.add(PWidget.boxh(4));
    if (data.status == SkillModel.DENIED)
      items.add(Row(
        children: [
          PWidget.text('${'REJECT'.tr}: ${data.reason}', [Colors.red, 12])
        ],
      ));
    if (data.status == SkillModel.DENIED) if (skillItems.isEmpty == false)
      items.add(PWidget.boxh(4));
    items.add(skill_item(data, skillItems.isEmpty ? null : skillItems.first,
        showAdd: true));
    if (skillItems.isEmpty) return items;
    var skillItemWidgets = skillItems
        .getRange(1, skillItems.length)
        .map(
          (item) => skill_item(data, item, showAdd: false),
        )
        .toList();
    items.add(Obx(() => Visibility(
        visible: data.expanded,
        child: Column(
          children: skillItemWidgets,
        ))));
    if (skillItems.length > 1) {
      items.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () => data.changeExpanded(),
              child: Obx(() => Icon(
                    data.expanded
                        ? Icons.expand_less_outlined
                        : Icons.expand_more_outlined,
                    color: Colors.white,
                  )))
        ],
      ));
    }
    return items;
  }

  Widget skill_item(SkillModel data, SkillItemModel? item,
      {bool showAdd = false}) {
    double icon_size = 20;
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 0.6,
            color: Colors.yellow.withOpacity(0.6),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // IconButton(
          //     onPressed: () => controller.addSkillItem(data,skillItemModel: ),
          //     icon: Icon(
          //       Icons.edit,
          //       color: Colors.white,
          //     )),
          if (item != null)
            Text(
              '${item?.name}',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          if (item == null) Container(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (item != null)
                Row(
                  children: [
                    Image(
                      image: AssetImage('assets/images/ic_balance_money.webp'),
                      width: 20,
                      height: 20,
                    ),
                    PWidget.boxw(2),
                    Text(
                      '${item?.price}/${item?.unit ?? ''}',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    )
                  ],
                ),
              PWidget.boxw(5),
              // if (item != null)
              //   GestureDetector(
              //       onTap: () => controller.addSkillItem(data),
              //       child: Icon(
              //         Icons.delete,
              //         size: icon_size,
              //         color: Colors.white60,
              //       )),
              if (item != null)
                GestureDetector(
                    onTap: () =>
                        controller.addSkillItem(data, skillItemModel: item),
                    child: Icon(
                      Icons.edit_note_rounded,
                      size: icon_size,
                      color: Colors.white,
                    )),
              PWidget.boxw(3),
              // if (showAdd)
              //   GestureDetector(
              //       onTap: () => controller.addSkillItem(data),
              //       child: Icon(
              //         Icons.add,
              //         size: icon_size,
              //         color: Colors.green,
              //       )),
              // if (!showAdd) PWidget.boxw(icon_size),
              PWidget.boxw(icon_size),
            ],
          ),
        ],
      ),
    );
  }
}
