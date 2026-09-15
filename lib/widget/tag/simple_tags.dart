library simple_tags;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:sq_hub_app/widget/tag/tag_bean.dart';
import 'package:sq_hub_app/widget/tag/tag_container.dart';

class SimpleTags extends StatefulWidget {
  final List<TagBean> content;

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
  State<SimpleTags> createState() => _SimpleTagsState();
}

class _SimpleTagsState extends State<SimpleTags> {
  late List<String> _selectedNames;

  List<String> _selectionNames(List<TagBean?> values) => values
      .whereType<TagBean>()
      .map((tag) => tag.name)
      .where((name) => name.isNotEmpty)
      .toList();

  List<String> _contentNames(List<TagBean> values) =>
      values.map((tag) => tag.name).toList(growable: false);

  @override
  void initState() {
    super.initState();
    _selectedNames = _selectionNames(widget.defaultSelect);
  }

  @override
  void didUpdateWidget(covariant SimpleTags oldWidget) {
    super.didUpdateWidget(oldWidget);
    final defaultsChanged = !listEquals(
      _selectionNames(oldWidget.defaultSelect),
      _selectionNames(widget.defaultSelect),
    );
    final contentChanged = !listEquals(
      _contentNames(oldWidget.content),
      _contentNames(widget.content),
    );
    if (defaultsChanged || contentChanged) {
      _selectedNames = _selectionNames(widget.defaultSelect);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: widget.wrapCrossAxisAlignment,
      alignment: widget.wrapAlignment,
      runSpacing: widget.wrapRunSpacing,
      runAlignment: widget.wrapRunAlignment,
      direction: widget.wrapDirection,
      spacing: widget.wrapSpacing,
      textDirection: widget.wrapTextDirection,
      clipBehavior: widget.wrapClipBehavior,
      verticalDirection: widget.wrapVerticalDirection,
      children: _buildTagContent(),
    );
  }

  List<Widget> _buildTagContent() {
    List<Widget> toReturn = [];

    if (widget.content.isNotEmpty) {
      for (int i = 0; i < widget.content.length; i++) {
        String tag = widget.content[i].name;
        toReturn.add(
          TagContainer(
            tag: tag,
            tagContainerDecoration: widget.tagContainerDecoration,
            tagContainerMargin: widget.tagContainerMargin,
            tagContainerPadding: widget.tagContainerPadding,
            tagContainerSelectDecoration: widget.tagContainerSelectDecoration,
            tagIcon: widget.tagIcon as Icon?,
            tagTextStyle: widget.tagTextStyle,
            tagSelectTextStyle: widget.tagSelectTextStyle,
            tagTextAlign: widget.tagTextAlign,
            tagTextLocale: widget.tagTextLocale,
            tagTextOverflow: widget.tagTextOverflow,
            tagTextMaxLines: widget.tagTextMaxlines,
            tagTextSoftWrap: widget.tagTextSoftWrap,
            selectStr: _selectedNames,
            onPressed: () {
              if (widget.onTagPress != null) {
                if (!_selectedNames.contains(tag)) {
                  if (widget.selectSize != 1 &&
                      _selectedNames.length >= widget.selectSize) {
                    return;
                  }
                  setState(() {
                    if (1 == widget.selectSize) {
                      // 单选
                      _selectedNames
                        ..clear()
                        ..add(tag);
                    } else {
                      // 多选
                      _selectedNames.add(tag);
                    }
                  });
                  widget.onTagPress!(widget.content[i], true);
                } else {
                  setState(() => _selectedNames.remove(tag));
                  widget.onTagPress!(widget.content[i], false);
                }
              }
            },
            onLongPressed: () {
              if (widget.onTagLongPress != null) {
                widget.onTagLongPress!(tag);
              }
            },
            onDoubleTap: () {
              if (widget.onTagDoubleTap != null) {
                widget.onTagDoubleTap!(tag);
              }
            },
          ),
        );
      }
    }

    return toReturn;
  }
}
