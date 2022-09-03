import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/playwith/play_with_page.dart';
import 'package:wy/ui/profile/edit/crop_page.dart';
import 'package:wy/utils/permission_helper.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/view/views.dart';
import 'package:wy/widget/code_widget.dart';
import 'package:wy/widget/mylistview.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/route.dart';
import 'package:wy/widget/scaffold_widget.dart';

// 认证页面
class AccompanyCertificationPage extends StatefulWidget {
  @override
  _AccompanyCertificationPageState createState() => _AccompanyCertificationPageState();
}

class _AccompanyCertificationPageState extends State<AccompanyCertificationPage> {
  TextEditingController phoneCon = TextEditingController();
  TextEditingController codeCon = TextEditingController();
  TextEditingController textCon1 = TextEditingController();
  TextEditingController textCon2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: AppBar(
        title: Text('Accompany Certification', style: TextStyle(fontSize: 18)),
        centerTitle: true,
        elevation: 0,
      ),
      body: PWidget.column([
        PWidget.container(
          PWidget.row([
            PWidget.image('assets/images/hall_ic_notice.png', [24, 24]),
            PWidget.boxw(8),
            Expanded(
              child: TextScroll(
                'The following items are required. To ensure your interests, please fill them out truthfully',
                style: TextStyle(color: Color(0xff4488FF)),
              ),
            ),
          ]),
          [null, null, Color(0xffDEEAFF).withOpacity(0.1)],
          {'pd': 8},
        ),
        Expanded(
          child: MyListView(
            isShuaxin: false,
            flag: false,
            item: (i) => item[i],
            itemCount: item.length,
            padding: EdgeInsets.all(16),
            divider: Divider(height: 16, color: Colors.transparent),
          ),
        ),
      ]),
      btnBar: FloatingButton(label: "Reserve", onTap: () => jumpPage(PlayWithPage())),
    );
  }

  Widget itemBg(view) {
    return PWidget.container(view, [null, 48, Color(0xff282640)], {'br': 48, 'pd': PFun.lg(0, 0, 16, 16)});
  }

  List<Widget> get item {
    return [
      PWidget.text('Basic information', [Colors.white, 18, true], {'ff': 'DIN'}),
      itemBg(buildTFView(context!, con: phoneCon, hintText: 'your phone number', hintColor: Colors.white24, textColor: Colors.white)),
      itemBg(
        PWidget.row([
          buildTFView(
            context!,
            hintText: 'verification code',
            hintColor: Colors.white24,
            textColor: Colors.white,
            con: codeCon,
            isExp: true,
          ),
          CodeWidget(
            text: 'Get code',
            phoneCon: phoneCon,
            successColor: const Color(0xff59C4FA),
            errorColor: const Color(0xff59C4FA),
            callApi: (v, e, s) async {
              // return await Request.post(
              //   '/home/code',
              //   isLoading: true,
              //   data: {"aesText": encryptedFun(getTime()), "phone": v, "type": widget.isRegister ? 2 : 1},
              //   catchError: (v) => e.call(v),
              //   success: (v) => s.call(null),
              // );
            },
            childBuilder: (s, c) {
              return PWidget.text('$s', [c], {'pd': 8});
            },
          ),
        ]),
      ),
      itemBg(PWidget.row([
        PWidget.text('Real name', [Colors.white]),
        PWidget.boxw(8),
        buildTFView(context!, hintText: 'Real name', hintColor: Colors.white24, textColor: Colors.white, con: textCon1, isExp: true),
      ])),
      PWidget.text('Basic information', [Colors.white, 18, true], {'ff': 'DIN'}),
      itemBg(PWidget.row([
        PWidget.text('ID number', [Colors.white]),
        PWidget.boxw(8),
        buildTFView(context!, hintText: 'ID number', hintColor: Colors.white24, textColor: Colors.white, con: textCon2, isExp: true),
      ])),
      PWidget.text('ID Photo', [Colors.white, 20], {'ff': 'DIN'}),
      PWidget.row([
        PWidget.container(
          PWidget.ccolumn([
            PWidget.image('assets/images/paly_add.png', [32, 32]),
            PWidget.boxh(16),
            PWidget.text('Upload ID photo front', [Colors.white, 12]),
          ]),
          [null, null, Color(0xff282640)],
          {'br': 16, 'pd': 16, 'exp': true},
        ),
        PWidget.boxw(16),
        PWidget.container(
          PWidget.ccolumn([
            PWidget.image('assets/images/paly_add.png', [32, 32]),
            PWidget.boxh(16),
            PWidget.text('Upload ID photo back', [Colors.white, 12]),
          ]),
          [null, null, Color(0xff282640)],
          {'br': 16, 'pd': 16, 'exp': true},
        ),
      ]),
    ];
  }

  void selectAvatar(BuildContext context) async {
    var status = await PermissionHelper.requestPhotosPermission(context);
    if (status == false) {
      return;
    }
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      var _image = File(pickedFile.path);
      Get.to<File?>(() => CropPage(image: _image))!.then((value) {
        flog(value!.path);
        // await UserApi.uploadAvatar(avatar.value, (p0, p1) => print("$p0,$p1"));
        // controller.setAvatar(value);
      });
    } else {
      print('No image selected.');
    }
  }
}
