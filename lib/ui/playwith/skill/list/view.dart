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
                    shrinkWrap: true,
                    itemBuilder: (context, index) => item(index),
                    separatorBuilder: (context, index) => Container(
                      height: 10,
                    ),
                    itemCount: controller.list.length,
                  )));
  }

  Widget item(int index) {
    var data = controller.list[index];
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                width: Get.width,
                height: 100,
                padding: EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/skill_rect_bg.webp'),
                        fit: BoxFit.fill)),
              )),
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              AssetImage('assets/images/skill_circle_bg.webp'),
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
                Expanded(
                    child: Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                  child: Column(children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PWidget.text('', [], {
                          'ff': 'DIN',
                          'exp': true
                        }, [
                          PWidget.textIs(
                            '${data.skillName}',
                            [Colors.yellow, 18, true],
                          ),
                          if (data.wswitch == 0)
                            PWidget.textIs(
                              '\t\t' + 'Disabled'.tr,
                              [Colors.red],
                            ),
                        ]),
                        Row(
                          children: [
                            if (data.status == SkillModel.ONGOING)
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
                                        return jumpPage(
                                            AddGamePage(data.toJson()),
                                            callback: (res) {
                                          if (res != null) controller.refresh();
                                        });
                                      ; //todo
                                    }
                                  }),
                            if (data.status != SkillModel.ONGOING)
                              GestureDetector(
                                  onTap: () =>
                                      jumpPage(AddGamePage(data.toJson()),
                                          callback: (res) {
                                        if (res != null) controller.refresh();
                                      }),
                                  child: Icon(
                                    Icons.edit_note_rounded,
                                    size: 30,
                                    color: Colors.white,
                                  )),
                            if (data.status == SkillModel.PASS) PWidget.boxw(2),
                            if (data.status == SkillModel.PASS)
                              GestureDetector(
                                  onTap: () => controller.addSkillItem(data),
                                  child: Icon(
                                    Icons.add,
                                    size: 24,
                                    color: Colors.white,
                                  )),
                            PWidget.boxw(16),
                          ],
                        )
                      ],
                    ),
                    PWidget.boxh(4),
                    Row(
                      children: [
                        Text(
                          '${data.levelName}',
                          style: TextStyle(
                              color: Colors.white60,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    // PWidget.boxh(6),
                    if (data.status == SkillModel.DENIED) PWidget.boxh(4),
                    if (data.status == SkillModel.DENIED)
                      Row(
                        children: [
                          PWidget.text('${'REJECT'.tr}: ${data.reason}',
                              [Colors.red, 12])
                        ],
                      ),
                    _skill_items(data)
                  ]),
                )),
              ]),
        ],
      ),
    );
  }

  _skill_items(SkillModel data) {
    var skillItems = data.childItemVoList;
    if (skillItems.isEmpty) return Container();
    return Column(
      children: skillItems.map((item) => skill_item(data, item)).toList(),
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
      padding: EdgeInsets.only(top: 4, bottom: 12),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: ExactAssetImage('assets/images/skill_divider.webp'),
            alignment: Alignment.bottomRight),
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (item != null)
            PWidget.text('', [], {
              'exp': true
            }, [
              PWidget.textIs('${item?.name}', [Colors.white]),
              if (item.isDefault == 0)
                PWidget.textIs('\t\t' + 'Disabled'.tr, [Colors.red]),
            ]),
          // Text(
          //   '${item?.name}',
          //   style: TextStyle(color: Colors.white, fontSize: 14),
          // ),
          if (item == null) Container(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (item != null)
                Row(
                  children: [
                    Image(
                      image: AssetImage('assets/images/ic_balance_money.webp'),
                      width: 18,
                      height: 18,
                    ),
                    PWidget.boxw(2),
                    Text.rich(TextSpan(children: [
                      TextSpan(
                          text: '${item?.price?.floor()}',
                          style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: '/${item?.unit}',
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                    ])),
                  ],
                ),
              PWidget.boxw(5),
              if (item != null)
                GestureDetector(
                    onTap: () => item.isDefault == 0
                        ? controller.addSkillItem(data, skillItemModel: item)
                        : null,
                    child: Icon(
                      Icons.edit_note_rounded,
                      size: icon_size,
                      color: item.isDefault == 1 ? Colors.grey : Colors.white,
                    )),
              PWidget.boxw(3),
              PWidget.boxw(icon_size),
            ],
          ),
        ],
      ),
    );
  }
}
