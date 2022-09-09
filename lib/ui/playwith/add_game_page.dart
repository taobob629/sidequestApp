import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:text_scroll/text_scroll.dart';
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

///添加游戏
class AddGamePage extends StatefulWidget {
  @override
  _AddGamePageState createState() => _AddGamePageState();
}

class _AddGamePageState extends State<AddGamePage> {
  TextEditingController beGoodAtCon = TextEditingController();
  var platform;
  var platformIndex;
  var game;
  var gameIndex;
  var gameLv;
  var gameLvIndex;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.skill();
  }

  ///游戏
  var skillDm = DataModel();
  Future<int> skill({int page = 1, bool isRef = false}) async {
    await http.get('/peiwan/app/home/skill').then((res) async {
      skillDm.addList(res.data, true, 0);
    }).catchError((e) {
      skillDm.toError(e.toString());
    });
    flog(skillDm.toJson(), 'skillDm');
    setState(() {});
    return skillDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: AppBar(
        title: Text('add game', style: TextStyle(fontSize: 18)),
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
      btnBar: FloatingButton(
        label: "Reserve",
        onTap: () {
          if (platform == null) return EasyLoading.showToast('Please select platform');
          if (game == null) return EasyLoading.showToast('Please select game');
          // if (gameLv == null) return EasyLoading.showToast('Please select gameLv');
          if (beGoodAtCon.text.isEmpty) return EasyLoading.showToast('Please enter beGoodAt');
          if (gamePhotos.isEmpty) return EasyLoading.showToast('Please upload game photo');
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
        var url = await UserApi.uploadAvatar(value!, (p0, p1) => flog("$p0,$p1"));
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
      PWidget.text('Game materials', [Colors.white, 18, true], {'ff': 'DIN'}),
      PWidget.boxh(16),
      itemBg(
        PWidget.row([
          PWidget.text('Operating platform', [Colors.white]),
          PWidget.boxw(8),
          PWidget.text(platform == null ? 'Please select' : platform['name'], [Color(0xff8291B4), 16], {'ali': 1, 'exp': true}),
          rightJtView(16, Colors.white54),
        ]),
        fun: () async {
          if (skillDm.list.isEmpty) return EasyLoading.showToast('Please check the network settings');
          var res = await Get.dialog(
            SelectorDialog(
              items: List.generate(skillDm.list.length, (i) {
                return VerifyField.fromJson({'name': '$i', 'label': skillDm.list[i]['name']});
              }),
              title: "Select Platform",
              showInfo: true,
            ),
            barrierColor: Colors.black26,
          );
          if (res != null) {
            setState(() {
              platformIndex = int.parse(res.name);
              platform = skillDm.list[platformIndex];
              gameIndex = null;
              game = null;
              gameLvIndex = null;
              gameLv = null;
            });
          }
        },
      ),
      PWidget.boxh(16),
      itemBg(
        PWidget.row([
          PWidget.text('Game', [Colors.white]),
          PWidget.boxw(8),
          PWidget.text(game == null ? 'Please select' : game['name'], [Color(0xff8291B4), 16], {'ali': 1, 'exp': true}),
          rightJtView(16, Colors.white54),
        ]),
        fun: () async {
          if (platformIndex == null) return EasyLoading.showToast('Please select platform first');
          var list = skillDm.list[platformIndex]['skill'] as List;
          var res = await Get.dialog(
            SelectorDialog(
              items: List.generate(list.length, (i) {
                return VerifyField.fromJson({'name': '$i', 'label': list[i]['name']});
              }),
              title: "Select Game",
              showInfo: true,
            ),
            barrierColor: Colors.black26,
          );
          if (res != null) {
            setState(() {
              gameIndex = int.parse(res.name);
              game = list[gameIndex];
              gameLvIndex = null;
              gameLv = null;
            });
          }
        },
      ),
      PWidget.boxh(16),
      itemBg(
        PWidget.row([
          PWidget.text('Game LV', [Colors.white]),
          PWidget.boxw(8),
          PWidget.text(gameLv == null ? 'Please select' : gameLv['name'], [Color(0xff8291B4), 16], {'ali': 1, 'exp': true}),
          rightJtView(16, Colors.white54),
        ]),
        fun: () async {
          if (platformIndex == null) return EasyLoading.showToast('Please select platform first');
          var list = skillDm.list[platformIndex]['skill'] as List;
          if (gameIndex == null) return EasyLoading.showToast('Please select game first');
          var levels = list[gameIndex]['level'] as List;
          var res = await Get.dialog(
            SelectorDialog(
              items: List.generate(levels.length, (i) {
                return VerifyField.fromJson({'name': '$i', 'label': levels[i]['name']});
              }),
              title: "Select Game Lv",
              showInfo: true,
            ),
            barrierColor: Colors.black26,
          );
          if (res != null) {
            setState(() {
              gameLvIndex = int.parse(res.name);
              gameLv = levels[gameLvIndex];
            });
          }
        },
      ),
      PWidget.boxh(16),
      itemBg(PWidget.row([
        PWidget.text('Be good at', [Colors.white]),
        PWidget.boxw(8),
        buildTFView(context!, hintText: 'Be good at', hintColor: Colors.white24, textColor: Colors.white, con: beGoodAtCon, isExp: true),
      ])),
    ]);
  }

  var gamePhotos = ['12'];

  ///游戏图像
  iDPhotoView() {
    return PWidget.column([
      PWidget.text('Game Photo', [Colors.white, 20], {'ff': 'DIN'}),
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
                    {'pd': 8, 'fun': () => setState(() => gamePhotos.removeAt(i))},
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
