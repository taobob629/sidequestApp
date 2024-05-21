library simple_tags;

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/widget/tag/tag_bean.dart';
import 'package:sq_hub_app/widget/tag/tag_container.dart';

class SimpleTags extends StatelessWidget {
  final List<TagBean> content;

  var selectStr = <String>[].obs;
  final List<TagBean?> defaultSelect;

  // bool：true添加，false删除
  final Function(TagBean, bool)? onTagPress;

  final Function(String)? onTagDoubleTap;

  final Function(String)? onTagLongPress;

  final BoxDecoration? tagContainerDecoration;

  final BoxDecoration? tagContainerSelectDecoration;

  final Widget? tagIcon;

  final EdgeInsets tagContainerPadding;

  final EdgeInsets tagContainerMargin;

  final TextStyle? tagTextStyle;

  final TextStyle? tagSelectTextStyle;

  final int? tagTextMaxlines;

  final TextOverflow? tagTextOverflow;

  final TextAlign? tagTextAlign;

  final bool? tagTextSoftWrap;

  final Locale? tagTextLocale;

  final WrapCrossAlignment wrapCrossAxisAlignment;

  final WrapAlignment wrapAlignment;

  final double wrapRunSpacing;

  final double wrapSpacing;

  final WrapAlignment wrapRunAlignment;

  final Axis wrapDirection;

  final TextDirection? wrapTextDirection;

  final Clip wrapClipBehavior;

  final VerticalDirection wrapVerticalDirection;

  // 可以选择多少个
  final int selectSize;

  SimpleTags({
    Key? key,
    required this.content,
    this.onTagPress,
    this.onTagDoubleTap,
    this.onTagLongPress,
    this.tagContainerDecoration,
    this.tagContainerSelectDecoration,
    this.tagIcon,
    required this.defaultSelect,
    this.tagContainerPadding = EdgeInsets.zero,
    this.tagContainerMargin = EdgeInsets.zero,
    this.tagTextStyle,
    required this.selectSize,
    this.tagSelectTextStyle,
    this.tagTextSoftWrap,
    this.tagTextAlign,
    this.tagTextOverflow,
    this.tagTextMaxlines,
    this.tagTextLocale,
    this.wrapCrossAxisAlignment = WrapCrossAlignment.start,
    this.wrapAlignment = WrapAlignment.start,
    this.wrapRunSpacing = 0,
    this.wrapRunAlignment = WrapAlignment.start,
    this.wrapDirection = Axis.horizontal,
    this.wrapSpacing = 0,
    this.wrapTextDirection,
    this.wrapClipBehavior = Clip.none,
    this.wrapVerticalDirection = VerticalDirection.down,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    selectStr
        .assignAll(defaultSelect.map((e) => e != null ? e.name : "").toList());

    return Obx(
      () => Wrap(
        crossAxisAlignment: wrapCrossAxisAlignment,
        alignment: wrapAlignment,
        runSpacing: wrapRunSpacing,
        runAlignment: wrapRunAlignment,
        direction: wrapDirection,
        spacing: wrapSpacing,
        textDirection: wrapTextDirection,
        clipBehavior: wrapClipBehavior,
        verticalDirection: wrapVerticalDirection,
        children: _buildTagContent(),
      ),
    );
  }

  List<Widget> _buildTagContent() {
    List<Widget> toReturn = [];

    if (content.isNotEmpty) {
      for (int i = 0; i < content.length; i++) {
        String tag = content[i].name;
        toReturn.add(TagContainer(
          tag: tag,
          tagContainerDecoration: tagContainerDecoration,
          tagContainerMargin: tagContainerMargin,
          tagContainerPadding: tagContainerPadding,
          tagContainerSelectDecoration: tagContainerSelectDecoration,
          tagIcon: tagIcon as Icon?,
          tagTextStyle: tagTextStyle,
          tagSelectTextStyle: tagSelectTextStyle,
          tagTextAlign: tagTextAlign,
          tagTextLocale: tagTextLocale,
          tagTextOverflow: tagTextOverflow,
          tagTextMaxLines: tagTextMaxlines,
          tagTextSoftWrap: tagTextSoftWrap,
          selectStr: selectStr.value,
          onPressed: () {
            if (onTagPress != null) {
              if (!selectStr.contains(tag)) {
                if (1 == selectSize) {
                  // 单选
                  selectStr.clear();
                  selectStr.add(tag);
                  onTagPress!(content[i], true);
                } else {
                  // 多选
                  if (selectStr.length < selectSize) {
                    selectStr.add(tag);
                    onTagPress!(content[i], true);
                  }
                }
              } else {
                selectStr.remove(tag);
                onTagPress!(content[i], false);
              }
            }
          },
          onLongPressed: () {
            if (onTagLongPress != null) {
              onTagLongPress!(tag);
            }
          },
          onDoubleTap: () {
            if (onTagDoubleTap != null) {
              onTagDoubleTap!(tag);
            }
          },
        ));
      }
    }

    return toReturn;
  }
}
