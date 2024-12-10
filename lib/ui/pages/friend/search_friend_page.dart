import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/ui/pages/friend/search_friend_ctr.dart';

import '../../../config/icon_font.dart';

class SearchFriendPage extends StatelessWidget {
  final ctr = Get.put(SearchFriendCtr());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search'.tr,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 18.sp,
            fontFamily: FONT_MEDIUM,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}
