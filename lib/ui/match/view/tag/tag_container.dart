import 'package:flutter/cupertino.dart';

class TagContainer extends StatefulWidget {
  final String tag;
  final EdgeInsets? tagContainerPadding;
  final EdgeInsets? tagContainerMargin;
  final TextStyle? tagTextStyle;
  final TextStyle? tagSelectTextStyle;

  final int? tagTextMaxLines;
  final TextOverflow? tagTextOverflow;
  final TextAlign? tagTextAlign;
  final List<String> selectStr;
  final bool? tagTextSoftWrap;
  final Locale? tagTextLocale;

  final GestureTapCallback? onPressed;
  final GestureTapCallback? onLongPressed;
  final GestureTapCallback? onDoubleTap;
  final Icon? tagIcon;
  final BoxDecoration? tagContainerDecoration;
  final BoxDecoration? tagContainerSelectDecoration;

  TagContainer(
      {Key? key,
      required this.tag,
      required this.selectStr,
      this.onPressed,
      this.onDoubleTap,
      this.onLongPressed,
      this.tagIcon,
      this.tagContainerMargin,
      this.tagContainerPadding,
      this.tagTextStyle,
      this.tagSelectTextStyle,
      this.tagTextMaxLines,
      this.tagTextOverflow,
      this.tagTextAlign,
      this.tagTextLocale,
      this.tagTextSoftWrap,
      this.tagContainerDecoration,
      this.tagContainerSelectDecoration})
      : super(key: key);

  @override
  _TagContainerState createState() => _TagContainerState();
}

class _TagContainerState extends State<TagContainer>
    with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onDoubleTap: widget.onDoubleTap,
      onLongPress: widget.onLongPressed,
      child: Container(
        margin: widget.tagContainerMargin,
        padding: widget.tagContainerPadding,
        decoration: widget.selectStr.contains(widget.tag)
            ? widget.tagContainerSelectDecoration
            : widget.tagContainerDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.tag,
              style: widget.selectStr.contains(widget.tag)
                  ? widget.tagSelectTextStyle
                  : widget.tagTextStyle,
              maxLines: widget.tagTextMaxLines,
              overflow: widget.tagTextOverflow,
              textAlign: widget.tagTextAlign,
              softWrap: widget.tagTextSoftWrap,
              locale: widget.tagTextLocale,
            ),
            widget.tagIcon != null ? widget.tagIcon! : SizedBox()
          ],
        ),
      ),
    );
  }
}
