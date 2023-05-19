import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/ui/order/refound/view.dart';
import 'package:wy/widget/stadium_button.dart';

class TextInputBottomSheet {
  static showTextInputBottomSheet(BuildContext context, String title,
      String tips, Function(String text) onSubmitted, TUITheme theme) {
    TextEditingController _selectionController = TextEditingController();

    showModalBottomSheet(
        isScrollControlled: true, // !important
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
              child: Container(
                color: theme.weakBackgroundColor,
                padding: EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 30,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16)),
                    ),
                    Divider(height: 2, color: theme.weakDividerColor),
                    TextField(
                      cursorColor: Colors.white70,
                      decoration: InputDecoration(
                        hintText: 'Please enter...',
                        counterText: '',
                        hintStyle: TextStyle(color: theme.weakTextColor),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 0, color: theme.weakDividerColor!!),
                        ),
                        //  contentPadding: EdgeInsets.only(bottom: 8)
                      ),

                      style: const TextStyle( fontSize: 14,),
                      controller: _selectionController,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          height: 40,
                          child: Text(
                            tips,
                            style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: StadiumButton(
                          'Confirm'.tr,
                          // style: ButtonStyle(
                          //   backgroundColor: AppColor.buttonGradientBg,
                          //   shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(5))),
                          // ),
                          onTap: () {
                            String text = _selectionController.text;
                            // if (text == "") {
                            //   _coreService.callOnCallback(TIMCallback(
                            //       type: TIMCallbackType.INFO,
                            //       infoRecommendText: TIM_t("输入不能为空"),
                            //       infoCode: 6661401));
                            //   return;
                            // }
                            onSubmitted(text);
                            Navigator.pop(context);
                          },
                      ),
                    ),
                  ],
                ),
              ));
        });
  }
}
