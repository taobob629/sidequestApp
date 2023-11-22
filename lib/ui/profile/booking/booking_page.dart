import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/model/booking_model.dart';
import 'package:wy/res/index.dart';
import 'package:wy/ui/common/empty_view.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/common/page_title.dart';
import 'package:wy/ui/profile/booking/booking_item.dart';
import 'package:wy/ui/profile/booking/reserve_page.dart';

import 'controller.dart';

class BookingPage extends GetView<BookingPageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: PageTitle(
          title: "My Bookings".tr,
        ),
      ),
      body: Obx(
        () => controller.initializing.value
            ? Container()
            : controller.list.length == 0
                ? Center(child: EmptyView())
                : ListView.separated(
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
                    itemCount: controller.list.length,
                  ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: FloatingButton(
          label: "MAKE A NEW BOOKING".tr,
          onTap: () => gotoAddPage(),
        ),
      ),
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
