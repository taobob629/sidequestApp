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
import 'package:wy/config/app_pages.dart';
import 'package:wy/model/skill_item_model.dart';
import 'package:wy/model/skill_model.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/playwith/add_game_page.dart';
import 'package:wy/utils/utils.dart';
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
                : ListView.builder(
                    itemBuilder: (context, index) => item(index),
                    itemCount: controller.list.length,
                  )));
  }

  Widget item(int index) {
    flog('index$index');
    var data = controller.list[index];
    return ListTile(
      title: PWidget.row([
        CachedNetworkImage(
            imageUrl: data.skillThumb ?? '',
            fit: BoxFit.cover,
            width: 64,
            height: 64),
        PWidget.boxw(8),
        PWidget.column([
          PWidget.text('${data.skillName}', [Colors.white, 16, true]),
          PWidget.boxh(4),
          PWidget.text('${data.levelName}', [Colors.white54, 12]),
          if (data.status == SkillModel.DENIED) PWidget.boxh(4),
          if (data.status == SkillModel.DENIED)
            PWidget.text('${data.reason}', [Colors.red, 12]),
        ], {
          'exp': 1
        }),
        PWidget.container(
          PWidget.text(
              {
                '2': 'eidt'.tr,
                '0': 'under review'.tr,
                '1': 'edit'.tr
              }['${data.status}'],
              [
                {
                  '2': Colors.black.withOpacity(0.75),
                  '0': Colors.white24,
                  '1': Colors.black.withOpacity(0.75)
                }['${data.status}'],
                16,
              ],
              {
                'pd': PFun.lg(4, 4, 12, 12),
                'fun': () {
                  if ([SkillModel.DENIED, SkillModel.PASS]
                      .contains(data.status))
                    return jumpPage(AddGamePage(data.toJson()), callback: (res) {
                      if (res != null)controller.refresh();
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
              '1': Colors.white
            }['${data.status}']
          ],
          {'br': 56},
        ),
      ]),
      subtitle: Column(children: _buildBottom(data)),
    );
  }

  _buildBottom(SkillModel data) {
    List<Widget> items = [];
    // flog('data.childItemVoList ${data.childItemVoList}');
    var skillItems = data.childItemVoList;
    items.add(Row(
      mainAxisAlignment: skillItems.isNotEmpty
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.end,
      children: [
        if (skillItems.isNotEmpty) skill_item(data, skillItems.first),
        Row(
          children: [
            // IconButton(
            //     onPressed: () => controller.addSkillItem(data,skillItemModel: ),
            //     icon: Icon(
            //       Icons.edit,
            //       color: Colors.white,
            //     )),
            PWidget.boxw(4),
            IconButton(
                onPressed: () => controller.addSkillItem(data),
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                )),
          ],
        )
      ],
    ));
    if (skillItems.isEmpty) return items;
    var skillItemWidgets = skillItems
        .getRange(1, skillItems.length)
        .map(
          (item) => Row(
            children: [skill_item(data, item)],
          ),
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
          IconButton(
              onPressed: () => data.changeExpanded(),
              icon: Obx(() => Icon(
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

  Widget skill_item(SkillModel data, SkillItemModel item) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: () => controller.addSkillItem(data, skillItemModel: item),
        child: PWidget.text(
            '${item.name}:${item.price}', [Colors.white, 14, true]),
      ),
    );
  }
}
