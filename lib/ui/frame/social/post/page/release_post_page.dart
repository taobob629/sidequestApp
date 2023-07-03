import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/frame/social/post/contorller/release_post_controller.dart';
import 'package:wy/utils/global_key_constants.dart';

import '../../../../../utils/image_util.dart';
import '../../../../../utils/storage_manager.dart';

class ReleasePostPage extends StatelessWidget {
  ReleasePostPage({Key? key}) : super(key: key);

  final t = Get.put(ReleasePostController());

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      autoPlay: true,
      autoPlayDelay: Duration(seconds: 5),
      onFinish: () => StorageManager.setBoolValue('postContentKey', true),
      builder: Builder(builder: (builder) {
        t.myContext = builder;
        return Scaffold(
          appBar: AppBar(
            title: Text("Post".tr),
            leading: Showcase(
              key: GlobalKeyConstants.postBackKey,
              description: 'Post later'.tr,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Icon(Icons.arrow_back_ios),
              ),
            ),
          ),
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    child: Text(
                      "Post content".tr,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Showcase(
                    key: GlobalKeyConstants.postContentKey,
                    description:
                        'Improve your content, you can receive a reward if the content is good, and you can withdraw the pound directly for the reward!'
                            .tr,
                    targetPadding:
                        EdgeInsets.only(left: -20, right: -20, top: -10),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: 150, maxHeight: 400),
                      child: Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xff313033),
                          // border: Border.all(color: Color(0xFFDCDCE4)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Obx(() => TextField(
                              controller: t.textController,
                              cursorColor: Colors.white,
                              maxLines: 6,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(70)
                              ],
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Add content'.tr,
                                hintStyle: TextStyle(
                                    fontSize: 14, color: Color(0xFFC5C3C6)),
                                counterText: "${t.textLength.value}/70",
                                counterStyle: TextStyle(color: Colors.white),
                              ),
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: Colors.white),
                              onChanged: (value) {
                                t.textLength.value =
                                    t.textController.text.length;
                                // controller.valueChange();
                              },
                            )),
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                    child: Text(
                      "Post photos(Optional)".tr,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Obx(() => t.type == TYPE_INVITE
                        ? Container(
                            width: (Get.width - 40 - 20) / 3,
                            height: (Get.width - 40 - 20) / 3,
                            alignment: Alignment.center,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11),
                              color: Color(0xff313033),
                            ),
                            child: QrImage(
                              foregroundColor: Colors.white,
                              data: t.gid,
                            ),
                          )
                        : Wrap(
                            runSpacing: 10,
                            spacing: 10,
                            children: [
                              ...t.photoList.map(
                                (photoUrl) {
                                  return Container(
                                    width: (Get.width - 40 - 20) / 3,
                                    height: (Get.width - 40 - 20) / 3,
                                    alignment: Alignment.center,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(11),
                                      color: Color(0xff313033),
                                    ),
                                    child: Stack(
                                      alignment: AlignmentDirectional.center,
                                      fit: StackFit.expand,
                                      children: [
                                        ImageUtil.networkImage(
                                          url: photoUrl,
                                          fit: BoxFit.cover,
                                        ),
                                        Positioned(
                                            right: 0,
                                            top: 0,
                                            child: GestureDetector(
                                              onTap: () {
                                                t.delPhoto(photoUrl);
                                              },
                                              child: Icon(
                                                Icons.delete_forever,
                                                color: Colors.amber,
                                                size: 24,
                                              ),
                                            ))
                                      ],
                                    ),
                                  );
                                },
                              ).toList(),
                              if (t.photoList.length < 9)
                                GestureDetector(
                                  onTap: t.pickUploadPhoto,
                                  child: Container(
                                    width: (Get.width - 40 - 20) / 3,
                                    height: (Get.width - 40 - 20) / 3,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(11),
                                      color: Color(0xff313033),
                                    ),
                                    child: Image.asset(
                                      "assets/images/add_pic.png",
                                      fit: BoxFit.cover,
                                      width: 30,
                                      height: 30,
                                    ),
                                  ),
                                )
                            ],
                          )),
                  ),
                  SizedBox(height: 20),
                  SafeArea(
                    child: Showcase(
                      key: GlobalKeyConstants.postSendKey,
                      description: 'Post now',
                      targetPadding:
                          EdgeInsets.symmetric(horizontal: -15, vertical: -10),
                      child: FloatingButton(
                        label: "Submit".tr,
                        onTap: () => t.submit(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
