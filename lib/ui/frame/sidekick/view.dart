/*
  view
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/ui/frame/sidekick/controller.dart';
import 'package:wy/ui/frame/sidekick/widget/horizontal_list.dart';
import 'package:wy/utils/image_util.dart';
import 'package:wy/utils/utils.dart';

import '../../../widget/refresh_list.dart';
import 'widget/section.dart';

class SideKickPage extends StatelessWidget {
  var controller = Get.put(SideKickController(),permanent: true);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg_sidekick.webp'),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter)),
      child: NestedScrollView(
        headerSliverBuilder: (context, index) => [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            leadingWidth: 120,
            leading: TextButton.icon(
              onPressed: () {},
              icon: Container(),
              label: Text(
                'Sidekick',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21.sp, color: Colors.white),
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: ImageUtil.assetImage('ic_search', width: 23.w, height: 23.w))
            ],
          ),
          HorizontalGameListWidget(),
        ],
        body: SectionWidget(listBody: biuldSmartRefresh(controller.refreshController, body(context), onRefresh: () {
          flog('onRefresh');
          controller.onRefresh();
          controller.refreshController.refreshCompleted();
        }),),
      ),
    );
  }

  body(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('index$index'),
        );
      },
      itemCount: 20,
    );
  }
}
