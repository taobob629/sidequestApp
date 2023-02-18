/**
    author:mac
    创建日期:2023/2/17
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/drop_down/gzx_dropdown_menu.dart';

class SectionWidget extends StatelessWidget {
  GlobalKey _stackKey = GlobalKey();
  Widget listBody;

  SectionWidget({required this.listBody});

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: _stackKey,
      children: [
        Column(
          children: [
            buildDropdownHeader(),
            Expanded(child: listBody),
          ],
        ),
        buildDropdownMenu()
      ],
    );
  }

  var controller = GZXDropdownMenuController();

  Widget buildDropdownHeader() {
    return MediaQuery.removePadding(
        context: Get.context!,
        removeTop: true,
        child: GZXDropDownHeader(
          color: Color(0xFF1B1A1E),
          height: 30.h,
        //  borderColor: Colors.transparent,
          items: [
            GZXDropDownHeaderItem(
              '2',
              iconData: Icons.keyboard_arrow_down,
              iconDropDownData: Icons.keyboard_arrow_up,
            ),
            GZXDropDownHeaderItem(
              '2',
              iconData: Icons.keyboard_arrow_down,
              iconDropDownData: Icons.keyboard_arrow_up,
            ),
            GZXDropDownHeaderItem(
              '3',
              iconData: Icons.keyboard_arrow_down,
              iconDropDownData: Icons.keyboard_arrow_up,
            ),
            GZXDropDownHeaderItem(
              '4',
              iconData: Icons.keyboard_arrow_down,
              iconDropDownData: Icons.keyboard_arrow_up,
            ),
          ],
          dividerHeight: 1,
          //  style: TextStyle(color: Colors.white),
          controller: controller,
          stackKey: _stackKey,
          onItemTap: (item) {
            //   controller.show(1);
          },

          ///特殊模块,选中数据只亮起,不需要更改头部title,下标为1
        ));
  }

  buildDropdownMenu() {
    flog('build---buildDropdownMenu');
    return GZXDropDownMenu(
      dropdownMenuChanged: (bool isShow, int? index) {
        flog('index $index isSHow $isShow');
      },
      controller: controller,
      menus: [
        GZXDropdownMenuBuilder(
            dropDownWidget: Text(
              '1qwwqwq',
              style: TextStyle(color: Colors.red),
            ),
            dropDownHeight: 30),
        GZXDropdownMenuBuilder(dropDownWidget: Text('2wqwqwq'), dropDownHeight: 30),
        GZXDropdownMenuBuilder(dropDownWidget: Text('3qwwqqw'), dropDownHeight: 30),
        GZXDropdownMenuBuilder(dropDownWidget: Text('3qwwqqw'), dropDownHeight: 30),
      ],
    );
  }
}
