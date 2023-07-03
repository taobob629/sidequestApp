import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/paixs_widget.dart';

import '../utils/toast_utils.dart';

///Verification code component
class CodeWidget extends StatefulWidget {
  final Widget Function(String, Color)? childBuilder;
  final String? text;
  final Color? successColor;
  final Color? errorColor;
  final String? successText;
  final String? errorText;
  final TextEditingController? phoneCon;
  final String? tips;
  final int time;
  final AlignmentGeometry alignment;
  final Future Function(String phone, Function(String) success, Function(String) error)? callApi;
  const CodeWidget({
    Key? key,
    this.childBuilder,
    this.phoneCon,
    this.text,
    this.tips,
    this.alignment = Alignment.centerRight,
    this.time = 30,
    this.successColor,
    this.errorColor = Colors.grey,
    this.callApi,
    this.successText = '已发送验证码，请注意查收！',
    this.errorText = '发送失败，请检查网络设置！',
  }) : super(key: key);

  @override
  State<CodeWidget> createState() => _CodeWidgetState();
}

class _CodeWidgetState extends State<CodeWidget> {
  ///显示文本
  var text = '';

  ///定时器
  Timer? timer;

  ///是否显示倒计时
  bool isShowCode = false;

  bool isSend = false;

  RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');

  @override
  void initState() {
    text = widget.text!;
    // bool matched = exp.hasMatch(widget.phoneCon!.text);
    bool matched = 1 == 1;
    flog(matched);
    if (!matched) {
      if (mounted) setState(() => isSend = false);
    } else {
      if (mounted) setState(() => isSend = true);
    }
    widget.phoneCon!.addListener(() {
      // bool matched = exp.hasMatch(widget.phoneCon!.text);
      bool matched = 1 == 1;
      flog(matched);
      if (!matched) {
        if (mounted) setState(() => isSend = false);
      } else {
        if (mounted) setState(() => isSend = true);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.alignment,
      child: PWidget.container(
        widget.childBuilder!(
          isShowCode ? '${widget.time - timer!.tick}${widget.tips}' : text,
          isSend ? (isShowCode ? widget.errorColor! : widget.successColor!) : widget.errorColor!,
        ),
        {
          'fun': () async {
            // RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
            // bool matched = exp.hasMatch(widget.phoneCon!.text);
            bool matched = 1 == 1;
            flog(matched);
            if (!matched) {
              if (mounted) return showToast('请输入手机号');
            } else {
              if (isShowCode) return showToast(widget.successText!);
              await widget.callApi!(
                widget.phoneCon!.text,
                (v) => showToast(widget.errorText!),
                (v) {
                  showToast(widget.successText!);
                  setState(() => isShowCode = true);
                  timer = Timer.periodic(const Duration(seconds: 1), (v) {
                    setState(() {
                      if (v.tick == widget.time) {
                        isShowCode = false;
                        timer?.cancel();
                      }
                    });
                  });
                },
              );
            }
          },
        },
      ),
    );
  }
}
