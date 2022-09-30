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
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/model/attention_model.dart';
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/ui/common/empty_view.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/scaffold_widget.dart';

import 'controller.dart';

const int TYPE_FOLLOW = 0;
const int TYPE_FANS = 1;

class AttentionUserListPage extends GetView<AttentionListPageController> {
  final type;

  AttentionUserListPage(this.type) {
    Get.put(AttentionListPageController(this.type), tag: 'attention_${type}');
  }

  @override
  AttentionListPageController get controller =>
      GetInstance().find<AttentionListPageController>(tag: 'attention_${type}')!;

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      body: Obx(() => SmartRefresher(
          controller: controller.refreshController,
          onRefresh: controller.refresh,
          onLoading: controller.loadMore,
          enablePullUp: true,
          child: controller.initializing.value
              ? Container()
              : controller.list.length == 0
                  ? Stack(
                      children: [
                        Positioned(left: 0, right: 0, top: 0, bottom: 0, child: EmptyView())
                      ],
                    )
                  : CustomScrollView(
                      slivers: [
                        Obx(() {
                          return SliverList(
                              delegate:
                                  SliverChildBuilderDelegate((BuildContext context, int index) {
                            return item(controller.list[index]);
                          }, childCount: controller.list.length));
                        })
                      ],
                    ))),
    );
  }

  item(AttentionModel user) {
    return ListTile(
      leading: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 24,
          child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: CachedNetworkImage(
                imageUrl: user.avatar ?? '',
                fit: BoxFit.cover,
                imageBuilder: (context, provider) {
                  return Container(
                    width: 48,
                    height: 48,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        image: DecorationImage(
                          image: provider,
                          fit: BoxFit.cover,
                        )),
                  );
                },
              ))),
      title: Row(
        children: [
          Text(user.name ?? 'Unkown', style: TextStyle(color: Colors.white, fontSize: 15)),
          PWidget.boxw(5),
          CircleAvatar(
              radius: 8,
              backgroundColor: Color.fromRGBO(255, 149, 212, 1),
              child: Image(
                fit: BoxFit.scaleDown,
                image: AssetImage('assets/images/ic_female.webp'),
                height: 16,
              )),
        ],
      ),
      subtitle: Text(
        '${user.signature ?? ''}',
        style: TextStyle(color: Color.fromRGBO(88, 99, 126, 1), fontSize: 12),
        maxLines: 1,
      ),
      trailing: button(user),
    );
  }

  button(AttentionModel user) {
    //   int type = user.status ?? 0;
    if (type == TYPE_FOLLOW) {
      return MaterialButton(
        color: Color.fromRGBO(40, 62, 90, 1),
        textColor: Color.fromRGBO(130, 145, 180, 1),
        child: Text(
          'Unfollow',
        ),
        onPressed: () {},
        shape: StadiumBorder(),
        height: 28,
      );
    }
    int focusStatus = user.status ?? 0;
    if (focusStatus == BOTH_FOCUS) {
      return MaterialButton(
        minWidth: 60,
        color: Color.fromRGBO(40, 62, 90, 1),
        textColor: Color.fromRGBO(130, 145, 180, 1),
        child: Text(
          'Follow',
        ),
        onPressed: () {},
        shape: StadiumBorder(),
        height: 28,
      );
    }
    return ColorfulButton(
      child: Text(
        'Follow',
        style: TextStyle(color: Colors.white),
      ),
      height: 28,
      width: 60,
    );
  }
}
