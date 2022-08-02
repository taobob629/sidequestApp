import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/booking_api.dart';
import 'package:wy/common/getx_list_controller.dart';
import 'package:wy/model/booking_model.dart';
import 'package:wy/ui/common/base_scaffold.dart';
import 'package:wy/ui/common/dialog_confirm.dart';
import 'package:wy/ui/common/empty_view.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/profile/booking/booking_item.dart';
import 'package:wy/ui/profile/booking/reserve_page.dart';

class BookingPage extends StatelessWidget {

  final controller = Get.put(BookingPageController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "My Bookings",
      body: Stack(
        children: [
          Positioned(
            left: 0,right: 0,top: 0,bottom: 0,
            child: Obx(()=>controller.initializing.value ? Container() : controller.list.length == 0 ? EmptyView():
              ListView.separated(
              controller: controller.scrollController,
              itemBuilder: (context, index){
                BookingModel model = controller.list[index];
                return BookingItem(
                  model: model,
                  onCancel: (id)=>controller.cancelBook(id),
                );
              },
              separatorBuilder: (context, index){
                return Container(height: 15,);
              },
              itemCount: controller.list.length
            ))
          )
        ],
      ),
      floatingActionButton: Obx(
          ()=>controller.floatingActionButtonShow.value ? FloatingButton(label: "MAKE A NEW BOOKING",onTap: () => gotoAddPage(),) : Container()
      ),
    );
  }

  void gotoAddPage() {
    Get.to(()=>ReservePage())?.then((value){
      if(value != null && value == true) {
        controller.reload();
      }
    });
  }
}

class BookingPageController extends GetxListController<BookingModel> {

  late ScrollController scrollController;
  late var floatingActionButtonShow = true.obs;
  late double offset = 0;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  @override
  void onReady() {
    scrollController.addListener(() {
      if (scrollController.offset - offset > 0) { //down
        if (floatingActionButtonShow.value) {
          floatingActionButtonShow.value = false;
        }
      } else { //up
        if (!floatingActionButtonShow.value) {
          floatingActionButtonShow.value = true;
        }
      }
      offset = scrollController.offset;
    });
    super.onReady();
  }

  Future<List<BookingModel>> loadData() async {
    EasyLoading.show();
    List<BookingModel> bookingList = await BookingApi.list();
    EasyLoading.dismiss();
    return bookingList;
  }

  Future <void> cancelBook(int id)async{
    Get.dialog(ConfirmDialog(title: "Cancel Booking", info: "Do you confirm to cancel this booking?"),barrierColor: Colors.black26)
      .then((value) async{
        if(value != null && value == true){
          EasyLoading.show();
          await BookingApi.cancel(id);
          reload();
        }
    });

  }
}