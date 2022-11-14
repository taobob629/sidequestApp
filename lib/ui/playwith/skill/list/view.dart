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
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/scaffold_widget.dart';

import 'controller.dart';

class PlaySkillsPage extends GetView<SkillListPageController> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
        appBar: AppBar(
          title: Text('${Get.arguments}'.tr),
          elevation: 0,
        ),
        btnBar: FloatingButton(
          label: "CONFIRM".tr,
        ),
        body: Obx(() => controller.list.isEmpty
            ? PWidget.text(
                'No more'.tr, [Colors.white54], {'ct': true, 'pd': 8})
            : SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                return item(index, controller.list[index]);
              }, childCount: controller.list.length))));
  }

  Widget item(int index, var data) {
    var data;
    return ListTile(
      title: PWidget.row([
        CachedNetworkImage(
            imageUrl: data['skillThumb'],
            fit: BoxFit.cover,
            width: 64,
            height: 64),
        PWidget.boxw(8),
        PWidget.column([
          PWidget.text('${data['skillName']}', [Colors.white, 16, true]),
          PWidget.boxh(4),
          PWidget.text('${data['levelName']}', [Colors.white54, 12]),
          if (data['status'] == 2) PWidget.boxh(4),
          if (data['status'] == 2)
            PWidget.text('${data['reason']}', [Colors.red, 12]),
        ], {
          'exp': 1
        }),
        PWidget.container(
          PWidget.text(
              {
                '2': 'eidt'.tr,
                '0': 'under review'.tr,
                '1': 'edit'.tr
              }['${data['status']}'],
              [
                {
                  '2': Colors.black.withOpacity(0.75),
                  '0': Colors.white24,
                  '1': Colors.black.withOpacity(0.75)
                }['${data['status']}'],
                16,
              ],
              {
                'pd': PFun.lg(4, 4, 12, 12),
                'fun': () {
                  if ([1, 2].contains(data['status'])) return; //todo
                }
              }),
          [
            null,
            null,
            {
              '2': Colors.white,
              '0': Colors.white.withOpacity(0.1),
              '1': Colors.white
            }['${data['status']}']
          ],
          {'br': 56},
        ),
      ]),
      subtitle: Column(
        children: [
          PWidget.boxh(6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PWidget.text('铂金：50/小时', [Colors.white, 14, true]),
              Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  PWidget.boxw(4),
                  Icon(
                    Icons.add,
                    color: Colors.white,
                  )
                ],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.expand_more_outlined,
                color: Colors.white,
              )
            ],
          )
        ],
      ),
    );
  }
}
