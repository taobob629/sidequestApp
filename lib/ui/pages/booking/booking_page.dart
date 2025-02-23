import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/empty_view.dart';
import '../../../common/floating_button.dart';
import '../../../common/page_title.dart';
import '../../../common/styles.dart';
import '../../../model/booking_model.dart';
import 'booking_item.dart';
import 'controller.dart';

class BookingPage extends StatelessWidget {

  final controller = Get.put(BookingPageController());

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
            : controller.list.isEmpty
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
          onTap: () => controller.gotoAddPage(),
        ),
      ),
    );
  }
}
