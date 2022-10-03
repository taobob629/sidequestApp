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
  TextEditingController userNameCon = TextEditingController();
  int? sex;
  var sexList = [
    {'name': '保密', 'value': 0},
    {'name': '男', 'value': 1},
    {'name': '女', 'value': 2},
  ];
  var avatar;

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
      gamePhotos.addAll(photosDm.list.map((m) => {'thumb': m['thumb'], 'isUpload': 0, 'id': m['id']}).toList());
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
      userNameCon.text = userinfoDm.object['userNickname'];
      avatar = userinfoDm.object['avatar'];
      sex = userinfoDm.object['sex'];
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
          if (avatar == null) return EasyLoading.showToast('Please upload your avatar');
          if (userNameCon.text.isEmpty) return EasyLoading.showToast('Please enter user nickname');
          if (beGoodAtCon.text.isEmpty) return EasyLoading.showToast('Please enter personal profile');
          var data = {
            "signature": beGoodAtCon.text,
            "userNickname": userNameCon.text,
            "avatar": avatar,
            "sex": sex,
          };
          EasyLoading.show();
          await http.post('/peiwan/app/user/setUserinfo', data: data).then((v) {
            EasyLoading.dismiss();
          }).catchError((e) {
            EasyLoading.dismiss();
            EasyLoading.showToast('Network exception');
          });
          if (gamePhotos.isEmpty) return EasyLoading.showToast('Please upload you album');
          var gamePhotoList = gamePhotos.where((w) => w['isUpload'] == 1).toList();
          var jsonData = gamePhotoList.map((m) => {"thumb": m['thumb']}).toList();
          flog(jsonData);
          if (jsonData.isEmpty) {
            Get.back();
          } else {
            EasyLoading.show();
            await http.post('/peiwan/app/user/setPhoto', data: jsonData).then((v) {
              EasyLoading.dismiss();
              Get.back();
            }).catchError((e) {
              EasyLoading.dismiss();
              EasyLoading.showToast('Network exception');
            });
          }
        },
      ),
    );
  }

  ///修改头像
  Widget _buildAvatarEdit() {
    return Center(
      child: GestureDetector(
        onTap: () async {
          var url = await selectAvatar(context!);
          if (url != null) setState(() => avatar = url);
        },
        child: Container(
          width: 80,
          height: 80,
          child: Stack(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white54,
                radius: 40,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ClipOval(
                    child: avatar == null
                        ? Icon(Icons.person, size: 70, color: Colors.black38)
                        : CachedNetworkImage(
                            imageUrl: avatar,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.camera_alt_rounded, color: Colors.white, size: 12),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget itemBg(view, {Function? fun}) {
    return PWidget.container(view, [null, 48, Color(0xff282640)], {'br': 48, 'pd': PFun.lg(0, 0, 16, 16), 'fun': fun});
  }

  List<Widget> get item {
    return [
      _buildAvatarEdit(),
      gameMaterialsView(),
      iDPhotoView(),
    ];
  }

  Future<dynamic> selectAvatar(BuildContext context) async {
    var url;
    var status = await PermissionHelper.requestPhotosPermission(context);
    if (status == false) {
      return url;
    }
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      var _image = File(pickedFile.path);
      await Get.to<File?>(() => CropPage(image: _image))!.then((value) async {
        // flog(value!.path, 'selectAvatar');
        if (value == null) return;
        EasyLoading.show();
        url = await Common.uploadFile(value, (p0, p1) => flog("$p0,$p1"));
        EasyLoading.dismiss();
        // controller.setAvatar(value);
      });
    } else {
      print('No image selected.');
    }
    return url;
  }

  ///基本信息
  Widget gameMaterialsView() {
    return PWidget.column([
      PWidget.text('User Nickname', [Colors.white, 18, true], {'ff': 'DIN'}),
      PWidget.boxh(16),
      itemBg(PWidget.row([
        // PWidget.text('Be good at', [Colors.white]),
        // PWidget.boxw(8),
        buildTFView(context!, hintText: 'Please enter user nickname', hintColor: Colors.white24, textColor: Colors.white, con: userNameCon, isExp: true),
      ])),
      PWidget.boxh(16),
      itemBg(
        PWidget.row([
          PWidget.text('Sex', [Colors.white]),
          PWidget.boxw(8),
          PWidget.text(sex == null ? 'Please select' : sexList[sex!]['name'], [Color(0xff8291B4), 16], {'ali': 1, 'exp': true}),
          rightJtView(16, Colors.white54),
        ]),
        fun: () async {
          var res = await Get.dialog(
            SelectorDialog(
              items: List.generate(sexList.length, (i) {
                return VerifyField.fromJson({'name': '$i', 'label': sexList[i]['name']});
              }),
              title: "Select Sex",
              showInfo: true,
            ),
            barrierColor: Colors.black26,
          );
          if (res != null) setState(() => sex = int.parse(res.name));
        },
      ),
      PWidget.boxh(16),
      PWidget.text('Personal profile', [Colors.white, 18, true], {'ff': 'DIN'}),
      PWidget.boxh(16),
      itemBg(PWidget.row([
        // PWidget.text('Be good at', [Colors.white]),
        // PWidget.boxw(8),
        buildTFView(context!, hintText: 'Please enter personal profile', hintColor: Colors.white24, textColor: Colors.white, con: beGoodAtCon, isExp: true),
      ])),
    ]);
  }

  var gamePhotos = <Map>[];

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
                Positioned.fill(child: CachedNetworkImage(imageUrl: gamePhotos[i]['thumb'], fit: BoxFit.cover)),
                Positioned.fill(child: Container(color: Colors.black54)),
                PWidget.positioned(
                  PWidget.icon(
                    Icons.highlight_remove_rounded,
                    [Colors.white],
                    {
                      'pd': 8,
                      'fun': () async {
                        if (gamePhotos[i]['isUpload'] == 1) {
                          setState(() => gamePhotos.removeAt(i));
                        } else {
                          // var jsonData = gamePhotos.map((m) => {"thumb": m}).toList();
                          EasyLoading.show();
                          await http.post('/peiwan/app/user/delPhoto/${gamePhotos[i]['id']}').then((v) {
                            setState(() => gamePhotos.removeAt(i));
                          }).catchError((e) {
                            EasyLoading.showToast('Network exception');
                          });
                          EasyLoading.dismiss();
                        }
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
            {
              'crr': 16,
              'pd': 16,
              'ali': PFun.lg(0, 0),
              'fun': () async {
                var url = await this.selectAvatar(context!);
                if (url != null) setState(() => gamePhotos.add({'thumb': '$url', 'isUpload': 1, 'id': ''}));
              }
            },
          );
        },
      ),
    ]);
  }
}

// 性别和年龄组件
class SexAndAgeWidget extends StatefulWidget {
  final String sex;
  final String age;
  const SexAndAgeWidget({Key? key, this.sex = '0', this.age = '0'}) : super(key: key);
  @override
  _SexAndAgeWidgetState createState() => _SexAndAgeWidgetState();
}

class _SexAndAgeWidgetState extends State<SexAndAgeWidget> {
  @override
  Widget build(BuildContext context) {
    var isFemale = widget.sex == '2';
    var gd = PFun.tl2brGd(Color(0xff9DBDFD), Color(0xff76A3FD));
    if (isFemale) gd = PFun.tl2brGd(Color(0xffFF95D4), Color(0xffFF5BAA));
    return PWidget.container(
      PWidget.row([
        PWidget.icon(isFemale?Icons.female_rounded:Icons.male_rounded, [Colors.white,14]),
        PWidget.boxw(2),
        PWidget.text(widget.age, [Colors.white, 12]),
      ], '220'),
      [null, null, Colors.black],
      {
        'gd': gd,
        'pd': PFun.lg(2, 2, 4, 8),
        'br': 56,
      },
    );
  }
}
