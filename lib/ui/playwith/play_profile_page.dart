import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:wy/api/common.dart';
import 'package:wy/api/user_api.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/model/data_model.dart';
import 'package:wy/model/login_model.dart';
import 'package:wy/ui/common/dialog_selector.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/profile/edit/crop_page.dart';
import 'package:wy/utils/permission_helper.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/view/views.dart';
import 'package:wy/widget/mylistview.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/scaffold_widget.dart';

///个人资料
class PlayProfilePage extends StatefulWidget {
  @override
  _PlayProfilePageState createState() => _PlayProfilePageState();
}

class _PlayProfilePageState extends State<PlayProfilePage> {
  TextEditingController beGoodAtCon = TextEditingController();

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.getUserinfo();
    await this.getPhotos();
  }

  ///相册
  var photosDm = DataModel();
  Future<int> getPhotos() async {
    await http.get('/peiwan/app/user/getPhotos').then((res) async {
      photosDm.addList(res.data, true, 0);
      gamePhotos.addAll(photosDm.list.map((m) => m['thumb']).toList());
    }).catchError((e) {
      photosDm.toError(e.toString());
    });
    flog(photosDm.toJson(), 'photosDm');
    setState(() {});
    return photosDm.flag;
  }

  ///个人信息
  var userinfoDm = DataModel();
  Future<int> getUserinfo() async {
    await http.get('/peiwan/app/user/getUserinfo').then((res) async {
      userinfoDm.object = res.data;
      beGoodAtCon.text = userinfoDm.object['signature'];
      userinfoDm.setTime();
    }).catchError((e) {
      userinfoDm.toError(e.toString());
    });
    flog(userinfoDm.toJson(), 'userinfoDm');
    setState(() {});
    return userinfoDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: AppBar(
        title: Text('Play Profile', style: TextStyle(fontSize: 18)),
        centerTitle: true,
        elevation: 0,
      ),
      body: PWidget.column([
        if (1 != 1)
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
      btnBar: FloatingButton(
        label: "OK",
        onTap: () async {
          if (beGoodAtCon.text.isEmpty) return EasyLoading.showToast('Please enter personal profile');
          var data = {"signature": beGoodAtCon.text};
          await http.post('/peiwan/app/user/setUserinfo', data: data).then((v) {
            EasyLoading.showToast('Saved successfully');
          }).catchError((e) {
            EasyLoading.showToast('Network exception');
          });
          if (gamePhotos.isEmpty) return EasyLoading.showToast('Please upload you album');
          // EasyLoading.showToast('Under development');
          // return;
          var jsonData = gamePhotos.map((m) => {"thumb": m}).toList();
          await http.post('/peiwan/app/user/setPhoto', data: jsonData).then((v) {
            EasyLoading.showToast('Submitted successfully');
          }).catchError((e) {
            EasyLoading.showToast('Network exception');
          });
        },
      ),
    );
  }

  Widget itemBg(view, {Function? fun}) {
    return PWidget.container(view, [null, 48, Color(0xff282640)], {'br': 48, 'pd': PFun.lg(0, 0, 16, 16), 'fun': fun});
  }

  List<Widget> get item {
    return [gameMaterialsView(), iDPhotoView()];
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
      Get.to<File?>(() => CropPage(image: _image))!.then((value) async {
        // flog(value!.path, 'selectAvatar');
        var url = await Common.uploadFile(value!, (p0, p1) => flog("$p0,$p1"));
        setState(() => gamePhotos.add('$url'));
        // controller.setAvatar(value);
      });
    } else {
      print('No image selected.');
    }
  }

  ///技能录入
  Widget gameMaterialsView() {
    return PWidget.column([
      PWidget.text('Personal profile', [Colors.white, 18, true], {'ff': 'DIN'}),
      PWidget.boxh(16),
      itemBg(PWidget.row([
        // PWidget.text('Be good at', [Colors.white]),
        // PWidget.boxw(8),
        buildTFView(context!, hintText: 'Please enter personal profile', hintColor: Colors.white24, textColor: Colors.white, con: beGoodAtCon, isExp: true),
      ])),
    ]);
  }

  var gamePhotos = [];

  ///游戏图像
  iDPhotoView() {
    return PWidget.column([
      PWidget.text('Personal Photo', [Colors.white, 20], {'ff': 'DIN'}),
      GridView.builder(
        padding: EdgeInsets.only(top: 16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 13,
          mainAxisSpacing: 13,
        ),
        itemCount: 9,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (_, i) {
          if (gamePhotos.length > i) {
            return PWidget.container(
              Stack(children: [
                Positioned.fill(child: CachedNetworkImage(imageUrl: gamePhotos[i])),
                Positioned.fill(child: Container(color: Colors.black54)),
                PWidget.positioned(
                  PWidget.icon(
                    Icons.highlight_remove_rounded,
                    [Colors.white],
                    {
                      'pd': 8,
                      'fun': () async {
                        // var jsonData = gamePhotos.map((m) => {"thumb": m}).toList();
                        // await http.post('/peiwan/app/user/delPhoto/[]', data: jsonData).then((v) {
                        //   EasyLoading.showToast('Submitted successfully');
                        // }).catchError((e) {
                        //   EasyLoading.showToast('Network exception');
                        // });
                        setState(() => gamePhotos.removeAt(i));
                      }
                    },
                  ),
                  [0, null, null, 0],
                ),
              ]),
              {'crr': 16},
            );
          }
          return PWidget.container(
            PWidget.image('assets/images/paly_add.png', [32, 32]),
            [null, null, Color(0xff282640)],
            {'crr': 16, 'pd': 16, 'ali': PFun.lg(0, 0), 'fun': () => this.selectAvatar(context!)},
          );
        },
      ),
    ]);
  }
}
