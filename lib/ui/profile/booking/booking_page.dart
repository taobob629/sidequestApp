import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/api/booking_api.dart';
import 'package:wy/common/getx_list_controller.dart';
import 'package:wy/model/booking_model.dart';
import 'package:wy/res/index.dart';
import 'package:wy/res/index.dart';
import 'package:wy/ui/common/base_scaffold.dart';
import 'package:wy/ui/common/dialog_confirm.dart';
import 'package:wy/ui/common/empty_view.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/common/page_title.dart';
import 'package:wy/ui/profile/booking/booking_item.dart';
import 'package:wy/ui/profile/booking/reserve_page.dart';

import 'controller.dart';

class BookingPage extends GetView<BookingPageController> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: pageDecoration(),
        ),
        NestedScrollView(
            headerSliverBuilder: (context, _) => [
                  SliverAppBar(
                    title: PageTitle(
                      title: "My Bookings".tr,
                    ),
                    pinned: true,
                    backgroundColor: Colors.transparent,
                  )
                ],
            body: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: null,
              body: Stack(
                children: [
                  Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Obx(() => controller.initializing.value
                          ? Container()
                          : controller.list.length == 0
                              ? EmptyView()
                              : MediaQuery.removePadding(
                                  context: context,
                                  removeTop: true,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                      controller: controller.scrollController,
                                      itemBuilder: (context, index) {
                                        BookingModel model = controller.list[index];
                                        return BookingItem(
                                          model: model,
                                          onCancel: (id) => controller.cancelBook(id),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return listDivider15;
                                      },
                                      itemCount: controller.list.length))))
                ],
              ),
              bottomNavigationBar: Obx(() => controller.floatingActionButtonShow.value
                  ? Padding(padding: EdgeInsets.only(bottom: 10.h),child: FloatingButton(
                label: "MAKE A NEW BOOKING".tr,
                onTap: () => gotoAddPage(),
              ),)
                  : Container()),
            ))
      ],
    );
  }

  void gotoAddPage() {
    Get.to(() => ReservePage())?.then((value) {
      if (value != null && value == true) {
        controller.reload();
      }
    });
  }
}
