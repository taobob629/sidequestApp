// ignore_for_file: dead_code, implementation_imports

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sq_hub_app/widget/paixs_widget.dart';
import 'package:sq_hub_app/widget/widget_tap.dart';

import '../model/data_model.dart';
import 'anima_switch_widget.dart';
import 'my_classicHeader.dart' as myh;

import '../common/styles.dart';
import '../utils/platform_utils.dart';
import '../utils/utils.dart';
import 'custom_loading_widget.dart';

Color get aColor => Theme.of(context!).colorScheme.secondary;


///屏幕宽高
Size size(context) => MediaQuery.of(context).size;

///屏幕顶部和底部
EdgeInsets padd(context) => MediaQuery.of(context).padding;

///屏幕宽高
Size get pmSize => MediaQuery.of(context!).size;

///屏幕顶部和底部
EdgeInsets get pmPadd => MediaQuery.of(context!).padding;

///加载框
Widget buildLoad({
  ///大小
  double size = 40,
  double radius = 10,

  ///粗细
  double width = 2,

  ///是否居中
  bool isCenter = true,

  ///颜色
  Color? color,
}) {
  if (isCenter) {
    // return Center(
    //   child: CupertinoActivityIndicator(radius: radius),
    // );
    return Container(
      width: Get.width,
      child: Center(
        child: SizedBox(
          height: size,
          width: size,
          child: Center(
            child: CustomLoadingWidget(
              backgroundColor: Colors.transparent,
              color: Colors.white,
              size: 40.sp,
            ),
            // child: CircularProgressIndicator(
            //   strokeWidth: 2,
            //   valueColor: AlwaysStoppedAnimation<Color>(color ?? Theme.of(context!).primaryColor),
            // ),
          ),
        ),
      ),);
  } else {
    // return CupertinoActivityIndicator(radius: radius);
    return SizedBox(
      height: size,
      width: size,
      child: Center(
        child: CustomLoadingWidget(
          backgroundColor: Colors.transparent,
          color: Colors.white,
          size: 40.sp,
        ),
        // child: CircularProgressIndicator(
        //   strokeWidth: 2,
        //   valueColor: AlwaysStoppedAnimation<Color>(color ?? Theme.of(context!).primaryColor),
        // ),
      ),
    );
  }
}

///底部悬浮菜单
Future<dynamic> showSheet({
  List<Widget> children = const <Widget>[],
  Widget Function(ScrollController?)? builder,
  bool? isScrollControlled,
  bool isDraggableList = !true,
  bool isClose = false,
  Color? barrierColor,
}) {
  FocusScope.of(Get.context!).requestFocus(FocusNode());
  return showModalBottomSheet(
    context: Get.context!,
    isDismissible: !isClose,
    enableDrag: !isClose,
    barrierColor: barrierColor,
    backgroundColor: Colors.transparent,
    isScrollControlled: isScrollControlled ?? true,
    builder: (_) {
      return WillPopScope(
        child: AnimatedPadding(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          // padding: Platform.version.contains('2.13') ? EdgeInsets.zero : MediaQuery.of(context).viewInsets,
          padding: Platform.version.contains('2.13') ? EdgeInsets.zero : EdgeInsets.zero,
          child: builder!(null),
        ),
        onWillPop: () async => !isClose,
      );
    },
  );
}

///右箭头
Widget rightJtView([size, color]) {
  return PWidget.icon(
    Icons.arrow_forward_ios_rounded,
    [color ?? aColor.withOpacity(0.25), size ?? 16],
  );
}

///底部箭头
Widget bottomJtView([size, color]) {
  return Transform.rotate(
    angle: pi / 2,
    child: PWidget.icon(
      Icons.arrow_forward_ios_rounded,
      [color ?? aColor.withOpacity(0.25), size ?? 16],
    ),
  );
}

///向上箭头
Widget topJtView([size, color]) {
  return Transform.rotate(
    angle: pi / -2,
    child: PWidget.icon(
      Icons.arrow_forward_ios_rounded,
      [color ?? aColor.withOpacity(0.25), size ?? 16],
    ),
  );
}

///构建文本框
Widget buildTFView(
    BuildContext context, {
      bool isExp = false,
      TextInputType keyboardType = TextInputType.text,
      bool obscureText = false,
      @required String? hintText,
      void Function(String)? onChanged,
      void Function()? onTap,
      void Function(String)? onSubmitted,
      TextStyle? textStyle,
      TextStyle? hintStyle,
      FocusNode? focusNode,
      TextInputAction? textInputAction,
      double hintSize = 14,
      Color? hintColor,
      double textSize = 14,
      Color? textColor,
      EdgeInsetsGeometry? padding,
      TextEditingController? con,
      TextAlign? textAlign,
      bool isInt = false,
      bool isDouble = false,
      bool isAz = false,
      bool isEdit = true,
      bool isBankCode = false,
      bool autofocus = false,
      int maxLines = 1,
      double height = 20,
      int? maxLength,
      int doubleCount = 10000,
    }) {
  return [
    Expanded(
      child: WidgetTap(
        onTap: onTap,
        child: Container(
          padding: padding ?? EdgeInsets.zero,
          height: height,
          child: TextField(
            focusNode: focusNode ?? null,
            controller: con,
            maxLines: maxLines,
            enabled: isEdit,
            maxLength: maxLength,
            inputFormatters: [
              // ignore: deprecated_member_use
              if (isAz) FilteringTextInputFormatter(RegExp("[a-zA-Z]"), allow: true), //只允许输入字母
              // ignore: deprecated_member_use
              if (isInt) FilteringTextInputFormatter.digitsOnly, //只允许输入数字
              // ignore: deprecated_member_use
              if (isDouble) FilteringTextInputFormatter(RegExp("[0-9.0-9]"), allow: true), //只允许输入小数
              if (isDouble) PrecisionLimitFormatter(doubleCount),
              if (isBankCode) TextInputFormatter.withFunction(
                      (oldValue, newValue) => _addSeparator(newValue.text)),
            ],
            style: (textStyle ?? TextStyle(fontSize: textSize, color: textColor)).copyWith(height: 1.5),
            cursorColor: Theme.of(context).primaryColor,
            textInputAction: textInputAction,
            keyboardType: keyboardType,
            obscureText: obscureText,
            textAlign: textAlign ?? TextAlign.start,
            autofocus: autofocus,
            decoration: InputDecoration(
              hintStyle: TextStyle(fontSize: hintSize, color: hintColor ?? Color(0x80666666), height: 1.5),
              counterText: '',
              hintText: hintText,
              border: OutlineInputBorder(borderSide: BorderSide.none),
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: onChanged,
            onTap: onTap,
            onSubmitted: onSubmitted,
          ),
        ),
      ),
    ),
    WidgetTap(
      onTap: onTap,
      child: Container(
        padding: padding ?? EdgeInsets.zero,
        height: height,
        child: TextField(
          focusNode: focusNode ?? null,
          style: (textStyle ?? TextStyle(fontSize: textSize, color: textColor)).copyWith(height: 1.5),
          cursorColor: Theme.of(context).primaryColor,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          maxLength: maxLength,
          controller: con,
          enabled: isEdit,
          autofocus: autofocus,
          inputFormatters: [
            // ignore: deprecated_member_use
            if (isAz) FilteringTextInputFormatter(RegExp("[a-zA-Z]"), allow: true), //只允许输入字母
            // ignore: deprecated_member_use
            if (isInt) FilteringTextInputFormatter.digitsOnly, //只允许输入数字
            // ignore: deprecated_member_use
            if (isDouble) FilteringTextInputFormatter(RegExp("[0-9.0-9]"), allow: true), //只允许输入小数
            if (isDouble) PrecisionLimitFormatter(doubleCount),
            if (isBankCode) TextInputFormatter.withFunction(
                    (oldValue, newValue) => _addSeparator(newValue.text)),
          ],
          textAlign: textAlign ?? TextAlign.start,
          decoration: InputDecoration(
            counterText: '',
            hintStyle: (hintStyle ??
                TextStyle(
                  fontSize: hintSize,
                  color: hintColor ?? Color(0x80666666),
                ))
                .copyWith(height: 1.5),
            border: OutlineInputBorder(borderSide: BorderSide.none),
            hintText: hintText,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: onChanged,
          onTap: onTap,
          onSubmitted: onSubmitted,
        ),
      ),
    )
  ][isExp ? 0 : 1];
}
///银行卡号每四位加一个分隔符
TextEditingValue _addSeparator(String text, {String separator = "-"}) {
  if (text.isEmpty) {
    return TextEditingValue(text: text);
  }
  ///移除了分隔符
  var removeSeparator = text.replaceAll(separator, "");
  var list = removeSeparator.split("");
  int separatorCount = 0;
  for (var i = 0; i < removeSeparator.length; i = i + 2) {
    if (i == 0) continue;
    list.insert(i + separatorCount, separator);
    separatorCount++;
  }
  var endText = list.join("");
  return TextEditingValue(
    text: endText,
    selection: TextSelection(
      baseOffset: endText.length,
      extentOffset: endText.length,
      affinity: TextAffinity.upstream,
    ),
  );
}


class PrecisionLimitFormatter extends TextInputFormatter {
  int _scale;

  PrecisionLimitFormatter(this._scale);

  RegExp exp = new RegExp("[0-9.]");
  static const String POINTER = ".";
  static const String DOUBLE_ZERO = "00";

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.startsWith(POINTER) && newValue.text.length == 1) {
      //第一个不能输入小数点
      return oldValue;
    }

    ///输入完全删除
    if (newValue.text.isEmpty) {
      return TextEditingValue();
    }

    ///只允许输入小数
    if (!exp.hasMatch(newValue.text)) {
      return oldValue;
    }

    ///包含小数点的情况
    if (newValue.text.contains(POINTER)) {
      ///包含多个小数
      if (newValue.text.indexOf(POINTER) != newValue.text.lastIndexOf(POINTER)) {
        return oldValue;
      }
      String input = newValue.text;
      int index = input.indexOf(POINTER);

      ///小数点后位数
      int lengthAfterPointer = input.substring(index, input.length).length - 1;

      ///小数位大于精度
      if (lengthAfterPointer > _scale) {
        return oldValue;
      }
    } else if (newValue.text.startsWith(POINTER) || newValue.text.startsWith(DOUBLE_ZERO)) {
      ///不包含小数点,不能以“00”开头
      return oldValue;
    }
    return newValue;
  }
}
Widget itemLable(var lable) {
  return Padding(
    padding: EdgeInsets.only(bottom: 10).h,
    child: Text(
      "$lable",
      style: PageStyle.labelStyle,
    ),
  );
}

///下拉刷新的头部
myh.MyClassicHeader buildClassicHeader({
  Color? color,
  String? text,
}) {
  color = color ?? Colors.white54;
  return myh.MyClassicHeader(
    height: 56.0,
    textStyle: TextStyle(color: color),
    releaseText: 'release refresh!',
    releaseIcon: null,
    completeText: 'refresh succeeded!',
    completeIcon: null,
    failedText: text ?? 'refresh failed!',
    failedIcon: null,
    idleText: 'pull down refresh!',
    idleIcon: null,
    refreshingText: null,
    refreshStyle: RefreshStyle.Follow,
    // refreshingIcon: Container(
    //   height: 24,
    //   child: LoadingIndicator(
    //     color: color.withOpacity(0.5),
    //     colors: [color.withOpacity(0.5)],
    //     indicatorType: Indicator.circleStrokeSpin,
    //   ),
    // ),
    refreshingIcon: SizedBox(
      height: 40,
      width: 40,
      child: Center(
        child: CustomLoadingWidget(
          backgroundColor: Colors.transparent,
          color: Colors.white,
          size: 40.sp,
        ),
      ),
    ),
  );
}

///上拉加载更多的底部
CustomFooter buildCustomFooter({
  Color? color,
  String? text,
}) {
  color = color ?? Colors.white54;
  var dataModel = DataModel(flag: 3);
  return CustomFooter(
    builder: (BuildContext context, LoadStatus? mode) {
      Widget? body;
      if (mode == LoadStatus.idle) {
        body = Text("pull up to load more!", style: TextStyle(color: color), key: ValueKey(1));
      } else if (mode == LoadStatus.loading) {
        body = SizedBox(
          height: 40,
          width: 40,
          child: Center(
            child: CustomLoadingWidget(
              backgroundColor: Colors.transparent,
              color: Colors.white,
              size: 40.sp,
            ),
            // child: CircularProgressIndicator(
            //   strokeWidth: 2,
            //   valueColor: AlwaysStoppedAnimation<Color>(color!.withOpacity(1)),
            // ),
          ),
        );
      } else if (mode == LoadStatus.canLoading) {
        body = Text("release", style: TextStyle(color: color), key: ValueKey(2));
      } else if (mode == LoadStatus.failed) {
        body = Text(text ?? "load failed", style: TextStyle(color: color));
      } else if (mode == LoadStatus.noMore) {
        body = Text("release", style: TextStyle(color: color));
      }
      return Container(
        height: 56,
        child: AnimatedSwitchBuilder(
          value: dataModel,
          alignment: Alignment.center,
          defaultBuilder: () => body!,
          errorOnTap: () async => getTime(),
        ),
      );
    },
  );
}
