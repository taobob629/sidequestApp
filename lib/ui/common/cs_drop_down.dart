import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../config/app_color.dart';

class DropDownModel {
  String title = "";
}

class CsDropDownDialog extends StatelessWidget {
  CsDropDownDialog({
    Key? key,
    required this.optionContext,
    required this.onTap,
    this.ancesterHeight = 0,
    this.itemList = const [],
  }) : super(key: key);

  final BuildContext optionContext;
  double ancesterHeight = 0;

  List<DropDownModel> itemList = [];

  final Function(int index, String value) onTap;

  final _cellHeight = 40.h;

  @override
  Widget build(BuildContext context) {
    final RenderBox box = optionContext.findRenderObject()! as RenderBox;
    final Offset target = box.localToGlobal(
      box.size.bottomLeft(Offset.zero),
    );
    double viewHeight = min(160, _cellHeight * itemList.length);
    double? positionTop = target.dy;
    double? positionBottom = Get.height - target.dy;

    if (target.dy + viewHeight >= Get.height) {
      positionTop = null;
    } else {
      positionBottom = null;
    }
    debugPrint("left:${target.dx} top:${target.dy}, paddingTop:${MediaQuery.of(Get.context!).padding.top}");
    return Stack(
      children: [
        Positioned(
            left: target.dx,
            top: positionTop! + 1.0,
            bottom: positionBottom,
            child: Container(
              height: viewHeight,
              width: box.size.width,
              decoration: BoxDecoration(
                color: AppColor.itemBg2,
              ),
              // decoration: CommonWidget.whiteShadowDecoration,
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: itemList.length,
                itemBuilder: ((context, index) {
                  final item = itemList[index];
                  return InkWell(
                    child: Container(
                      height: _cellHeight,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        item.title,
                        style: TextStyle(color: AppColor.colorB9C9, fontSize: 14.sp),
                      ),
                    ),
                    onTap: () {
                      onTap(index, item.title);
                      Get.back();
                    },
                  );
                }),
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    color: AppColor.background,
                    height: 1,
                  );
                },
              ),
            )),
      ],
    );
  }
}

// class CsDropDownMulitSelectDialog extends StatelessWidget {
//   CsDropDownMulitSelectDialog({
//     Key? key,
//     required this.optionContext,
//     required this.onTap,
//     this.ancesterHeight = 0,
//     this.itemList = const [],
//     this.initSelectList = const [],
//   }) : super(key: key);

//   final BuildContext optionContext;
//   double ancesterHeight = 0;

//   List<DropDownModel> itemList = [];
//   List<String> initSelectList = [];

//   final selectList = [].obs;

//   final Function(int index, String value) onTap;

//   final _cellHeight = 40.h;

//   @override
//   Widget build(BuildContext context) {
//     final RenderBox box = optionContext.findRenderObject()! as RenderBox;
//     final Offset target = box.localToGlobal(
//       box.size.bottomLeft(Offset.zero),
//     );
//     double viewHeight = min(160, _cellHeight * itemList.length);
//     double? positionTop = target.dy;
//     double? positionBottom = Get.height - target.dy;

//     if (target.dy + viewHeight >= Get.height) {
//       positionTop = null;
//     } else {
//       positionBottom = null;
//     }
//     selectList.value = initSelectList;
//     debugPrint("left:${target.dx} top:${target.dy}, paddingTop:${MediaQuery.of(Get.context!).padding.top}");
//     return Stack(
//       children: [
//         Positioned(
//             left: target.dx,
//             top: positionTop! + 1.0,
//             bottom: positionBottom,
//             child: Container(
//               height: viewHeight,
//               width: box.size.width,
//               decoration: BoxDecoration(
//                 color: AppColor.itemBg2,
//               ),
//               // decoration: CommonWidget.whiteShadowDecoration,
//               child: Obx(() => ListView.separated(
//                     padding: EdgeInsets.zero,
//                     shrinkWrap: true,
//                     itemCount: itemList.length,
//                     itemBuilder: ((context, index) {
//                       final item = itemList[index];
//                       bool isSelect = selectList.contains(item.title);
//                       return InkWell(
//                         child: Container(
//                           height: _cellHeight,
//                           alignment: Alignment.centerLeft,
//                           padding: EdgeInsets.only(left: 16),
//                           child: Row(
//                             children: [
//                               Text(
//                                 item.title,
//                                 style: TextStyle(color: AppColor.colorB9C9, fontSize: 14.sp),
//                               ),
//                               if (isSelect) Icon(Icons.check) else Container()
//                             ],
//                           ),
//                         ),
//                         onTap: () {
//                           if (selectList.contains(item.title)) {
//                             selectList.remove(item.title);
//                           } else {
//                             selectList.add(item.title);
//                           }
//                         },
//                       );
//                     }),
//                     separatorBuilder: (BuildContext context, int index) {
//                       return Divider(
//                         color: AppColor.background,
//                         height: 1,
//                       );
//                     },
//                   )),
//             )),
//       ],
//     );
//   }
// }

class CsDropDownMulitSelectDialog extends StatefulWidget {
  CsDropDownMulitSelectDialog({
    Key? key,
    required this.optionContext,
    // required this.onTap,
    required this.onSelect,
    this.ancesterHeight = 0,
    this.itemList = const [],
    this.initSelectList = const [],
  }) : super(key: key);

  final BuildContext optionContext;
  double ancesterHeight = 0;

  List<DropDownModel> itemList = [];
  List<String> initSelectList = [];

  // final Function(int index, String value) onTap;

  final Function(String value) onSelect;

  @override
  State<CsDropDownMulitSelectDialog> createState() => _CsDropDownMulitSelectDialogState();
}

class _CsDropDownMulitSelectDialogState extends State<CsDropDownMulitSelectDialog> {
  final _cellHeight = 40.h;
  List<String> selectList = [];

  @override
  void initState() {
    // TODO: implement initState
    selectList.addAll(widget.initSelectList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final RenderBox box = widget.optionContext.findRenderObject()! as RenderBox;
    final Offset target = box.localToGlobal(
      box.size.bottomLeft(Offset.zero),
    );
    double viewHeight = min(160, _cellHeight * widget.itemList.length);
    double? positionTop = target.dy;
    double? positionBottom = Get.height - target.dy;

    if (target.dy + viewHeight >= Get.height) {
      positionTop = null;
    } else {
      positionBottom = null;
    }
    debugPrint("left:${target.dx} top:${target.dy}, paddingTop:${MediaQuery.of(Get.context!).padding.top}");
    return Stack(
      children: [
        Positioned(
          left: target.dx,
          top: positionTop! + 1.0,
          bottom: positionBottom,
          child: Container(
              height: viewHeight,
              width: box.size.width,
              decoration: BoxDecoration(
                color: AppColor.itemBg2,
              ),
              // decoration: CommonWidget.whiteShadowDecoration,
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: widget.itemList.length,
                itemBuilder: ((context, index) {
                  final item = widget.itemList[index];
                  bool isSelect = selectList.contains(item.title);
                  return InkWell(
                    child: Container(
                      height: _cellHeight,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        children: [
                          Text(
                            item.title,
                            style: TextStyle(color: AppColor.colorB9C9, fontSize: 14.sp),
                          ),
                          Spacer(),
                          if (isSelect)
                            Icon(
                              Icons.check,
                              color: Colors.white,
                            )
                        ],
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        if (selectList.contains(item.title)) {
                          selectList.remove(item.title);
                        } else {
                          selectList.add(item.title);
                        }
                      });
                      widget.onSelect(selectList.join(","));
                    },
                  );
                }),
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    color: AppColor.background,
                    height: 1,
                  );
                },
              )),
        ),
      ],
    );
  }
}
