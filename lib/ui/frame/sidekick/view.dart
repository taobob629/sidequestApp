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
import 'package:wy/ui/frame/sidekick/widget/horizontal_list.dart';
import 'package:wy/utils/image_util.dart';

class SideKickPage extends StatelessWidget {
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
                  pinned: true,
                  leading: TextButton.icon(
                    onPressed: () {},
                    icon: Container(),
                    label: Text(
                      'Sidekick',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 21.sp, color: Colors.white),
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
          body: Container(
            child: Text('11'),
          )),
    );
  }
}
