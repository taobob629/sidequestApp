/*
  light_text
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
// ------------------------------------------------------
// author：AllenSu
// date  ：2021/12/12 4:52 下午
// usage ：搜索结果高亮显示组件
// ------------------------------------------------------

import 'package:flutter/material.dart';

import '../utils/utils.dart';

class LightTextWidget extends StatelessWidget {
  final String text; // 要显示的内容
  final String lightText; // 要显示的内容中，需要高亮显示的文字(默认为空字符串，即不高亮显示文本)
  final TextStyle? textStyle; // 要显示的内容的文本风格
  final TextStyle? lightStyle; // 要显示的内容中，需要高亮显示的文字的文本风格

  // 默认普通文本的样式
  final TextStyle _defTextStyle = TextStyle(fontSize: 16, color: Colors.white);

  // 默认高亮文本的样式
  final TextStyle _defLightStyle = TextStyle(fontSize: 16, color: Colors.blue);

  LightTextWidget({
    required this.text,
    this.lightText = "",
    this.textStyle,
    this.lightStyle,
  });

  @override
  Widget build(BuildContext context) {
    // 如果没有需要高亮显示的内容
    if (lightText.isEmpty) {
      return Text(text, style: textStyle ?? _defTextStyle);
    }
    // 如果有需要高亮显示的内容
    return _lightView();
  }

  /// 需要高亮显示的内容
  Widget _lightView() {
    List<TextSpan> spans = [];
    int start = 0; // 当前要截取字符串的起始位置
    int end; // end 表示要高亮显示的文本出现在当前字符串中的索引

    // 如果有符合的高亮文字
    while ((end = text.toUpperCase().indexOf(lightText, start)) != -1) {
      flog('start--$start  end  $end');
      // 第一步：添加正常显示的文本
      spans.add(TextSpan(text: text.substring(start, end), style: textStyle ?? _defTextStyle));
      // 第二步：添加高亮显示的文本
      spans.add(TextSpan(
          text: text.substring(end, end + lightText.length), style: lightStyle ?? _defLightStyle));
      // 设置下一段要截取的开始位置
      start = end + lightText.length;
    }
    // 下面这行代码的意思是
    // 如果没有要高亮显示的，则start=0，也就是返回了传进来的text
    // 如果有要高亮显示的，则start=最后一个高亮显示文本的索引，然后截取到text的末尾
    spans.add(
      TextSpan(text: text.substring(start, text.length), style: textStyle ?? _defTextStyle),
    );

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}
