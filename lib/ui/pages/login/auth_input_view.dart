import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../config/app_color.dart';
import '../register/controller.dart';

class AuthInputView extends StatelessWidget {
  final String tips;
  final bool isRequired;
  final bool password;
  final TextInputType? keyboardType;
  final TextEditingController? editingController;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Function(String)? onSubmitted;
  final VoidCallback? onRightCallback;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final bool rightBtn;

  AuthInputView({
    required this.tips,
    this.isRequired = true,
    this.password = false,
    this.keyboardType,
    this.editingController,
    this.focusNode,
    this.textInputAction,
    this.inputFormatters,
    this.readOnly = false,
    this.rightBtn = false,
    this.onSubmitted,
    this.onRightCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.only(left: 16).r,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: const BorderRadius.all(Radius.circular(50)).w,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: editingController,
              focusNode: focusNode,
              maxLines: 1,
              keyboardType: keyboardType,
              obscureText: password,
              cursorColor: Colors.white70,
              textAlign: TextAlign.start,
              textInputAction: textInputAction,
              inputFormatters: inputFormatters,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              readOnly: readOnly,
              decoration: InputDecoration(
                  hintText: isRequired ? '* $tips' : tips,
                  hintStyle: TextStyle(fontSize: 14, color: AppColor.whiteGray),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: 0)),
              onSubmitted: onSubmitted,
            ),
          ),
          Visibility(
            visible: rightBtn,
            child: Obx(() => GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: onRightCallback,
                  child: Container(
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.w),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: RegisterPageController.find.codeCountDown.value == 60
                            ? [const Color(0xFFD49C21), const Color(0xFFE96524)]
                            : [Colors.grey, Colors.grey],
                      ),
                    ),
                    padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    margin: EdgeInsets.only(right: 6.w),
                    child: Text(
                      RegisterPageController.find.uid.value == ''
                          ? 'Send'
                          : RegisterPageController.find.codeCountDown.value != 60
                              ? '${RegisterPageController.find.codeCountDown.value.toString().padLeft(2, '0')}s'
                              : 'Resend',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
