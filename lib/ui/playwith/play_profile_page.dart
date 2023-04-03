import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:wy/api/common.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/model/data_model.dart';
import 'package:wy/model/login_model.dart';
import 'package:wy/model/user_info_model.dart';
import 'package:wy/res/index.dart';
import 'package:wy/ui/common/dialog_selector.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/playwith/filter_widget.dart';
import 'package:wy/ui/playwith/game_comment.dart';
import 'package:wy/ui/profile/edit/crop_page.dart';
import 'package:wy/utils/permission_helper.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/view/views.dart';
import 'package:wy/widget/city_picker/csc_picker.dart';
import 'package:wy/widget/city_picker/model/select_status_model.dart';
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
  List language = [];
  var sexList = [
    // {'name': '保密', 'value': 0},
    {'name': 'Male'.tr, 'value': 0},
    {'name': 'Female'.tr, 'value': 1},
    {'name': 'Non-binary'.tr, 'value': 2},
  ];
  var avatar;
  Rxn<String?> _country = Rxn();
  Rxn<String?> _state = Rxn();
  Rxn<String?> _city = Rxn();
  RxBool _hasInited = false.obs;

  bool get hasInited => _hasInited.value;

  set hasInited(bool value) {
    _hasInited.value = value;
  }

  String? get state => _state.value;

  String? get country => _country.value;

  String? get city => _city.value;

  set country(String? value) {
    _country.value = value;
  }

  set state(String? value) {
    _state.value = value;
  }

  set city(String? value) {
    _city.value = value;
  }

  ///是否正在上传文件
  bool isUploadFile = false;

  @override
  void dispose() {
    countries.clear();
  }

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  RxList<Country> _countries = RxList();

  List<Country> get countries => _countries.value;

  set countries(List<Country> value) {
    _countries.value = value;
  }

  initLocation() async {
    if (countries.isNotEmpty) return countries;
    countries.clear();
    var res = await rootBundle.loadString('assets/data/country.json');
    countries = (jsonDecode(res) as List).map((json) => Country.fromJson(json)).toList();
  }

  ///初始化函数
  Future initData() async {
    initLocation();
    getUserinfo();
    getPhotos();
  }

  ///相册
  var photosDm = DataModel();

  void getPhotos() async {
    await http.get('/peiwan/app/user/getPhotos').then((res) async {
      photosDm.addList(res.data, true, 0);
      gamePhotos.addAll(
          photosDm.list.map((m) => {'thumb': m['thumb'], 'isUpload': 0, 'id': m['id']}).toList());
    }).catchError((e) {
      photosDm.toError(e.toString());
    });
  }

  ///个人信息
  var userinfoDm = DataModel();

  Future<int> getUserinfo() async {
    EasyLoading.show();
    http.get('/peiwan/app/user/getUserinfo').then((res) async {
      userinfoDm.object = res.data['userInfo'];
      Location location = Location.fromStr(userinfoDm.object['location']);
      city = location.city;
      country = location.country;
      state = location.state;
      if (country != null) {
        _curCountry =
            countries.firstWhereOrNull((element) => '${element.emoji}${element.name}' == country);
        _curState = _curCountry?.state.firstWhereOrNull((item) => item.name == state);
        //   flog('找到了state$_curState  counrty $_curCountry');
      }
      hasInited = true;
      userinfoDm.addList(res.data['initLanguage'], true, 0);
      beGoodAtCon.text = userinfoDm.object['signature'];
      userNameCon.text = userinfoDm.object['userNickname'];
      avatar = userinfoDm.object['avatar'];
      if (avatar == '') avatar = null;
      sex = userinfoDm.object['sex'];
      var userLanguage = (userinfoDm.object['language']);
      if (userLanguage != null) {
        language = userLanguage.toString().split('/');
      }
      backgroundImage = userinfoDm.object['avatarThumb'];
      userinfoDm.setTime();
      setState(() {});
      EasyLoading.dismiss();
    }).catchError((e) {
      EasyLoading.dismiss();
      userinfoDm.toError(e.toString());
    });
    return userinfoDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: AppBar(
        title: Text('Play Profile'.tr, style: TextStyle(fontSize: 18)),
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
                  'The following items are required. To ensure your interests, please fill them out truthfully'
                      .tr,
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
        label: "OK".tr,
        onTap: () async {
          if (avatar == null) return EasyLoading.showToast('Please upload your avatar'.tr);
          if (userNameCon.text.isEmpty)
            return EasyLoading.showToast('Please enter user nickname'.tr);
          if (userNameCon.text.length > 26)
            return EasyLoading.showToast('The nick name cannot exceed 26 characters'.tr);
          if (language.isEmpty) return EasyLoading.showToast('Please select language'.tr);
          if (beGoodAtCon.text.isEmpty)
            return EasyLoading.showToast('Please enter your signature'.tr);
          if (beGoodAtCon.text.length > 255)
            return EasyLoading.showToast('Signature cannot exceed 255 characters'.tr);
          if (backgroundImage == null)
            return EasyLoading.showToast('Please upload your background image'.tr);
          if (country == null) {
            return EasyLoading.showToast('Please select your country'.tr);
          }
          // if(state!=null&&state!='*State'){
          //   flog('state ${state!=null&&state!='*State'}');
          //   if(city==null){
          //     return EasyLoading.showToast('Please select your city');
          //   }
          // }
          /* if (_curCountry != null) {
            if (_curCountry?.state.isNotEmpty == true) {
              if (_curState == null) {
                return EasyLoading.showToast('Please select your state');
              } else {
                //已经选择了State,看State下是否有city
                if (_curState?.city.isNotEmpty == true) {
                  if (city == null || city == '*City')
                    return EasyLoading.showToast('Please select your city');
                }
              }
            }
          }*/
          var data = {
            "signature": beGoodAtCon.text,
            "userNickname": userNameCon.text,
            "avatar": avatar,
            "sex": sexList[sex!]['value'],
            "location": json.encode({
              'country': '${_curCountry?.emoji}${_curCountry?.name}',
              'emoji': '${_curCountry?.emoji}',
              'city': city == '*City' ? null : city,
              'state': state == '*State' ? null : state,
            }),
            "language": language.join('/'),
          };
          // return;
          EasyLoading.show();
          await http.post('/peiwan/app/user/setUserinfo', data: data).then((v) {
            EasyLoading.dismiss();
          }).catchError((e) {
            EasyLoading.dismiss();
            EasyLoading.showToast('Network exception'.tr);
          });
          if (gamePhotos.isEmpty) return EasyLoading.showToast('Please upload your album'.tr);
          var gamePhotoList = gamePhotos.where((w) => w['isUpload'] == 1).toList();
          var jsonData = gamePhotoList.map((m) => {"thumb": m['thumb']}).toList();
          if (jsonData.isEmpty) {
            Get.back();
          } else {
            EasyLoading.show();
            await http.post('/peiwan/app/user/setPhoto', data: jsonData).then((v) {
              EasyLoading.dismiss();
              Get.back();
            }).catchError((e) {
              EasyLoading.dismiss();
              EasyLoading.showToast('Network exception'.tr);
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
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: CircleAvatar(
                  backgroundColor: Colors.white54,
                  radius: 40,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: avatar == null
                        ? Icon(Icons.person, size: 70, color: Colors.black38)
                        : CachedNetworkImage(imageUrl: avatar, fit: BoxFit.cover),
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
    return InkWell(
      child: Container(
        padding: itemPadding(),
        height: 45.h,
        decoration: listItemDecoration(),
        child: view,
      ),
      onTap: () => fun?.call(),
    );
  }

  List<Widget> get item {
    return [
      _buildAvatarEdit(),
      gameMaterialsView(),
      backgroundImageView(),
      iDPhotoView(),
    ];
  }

  var backgroundImage;

  ///背景图像
  Widget backgroundImageView() {
    return PWidget.column([
      lableText('Background'.tr),
      GridView.builder(
        padding: EdgeInsets.only(top: 6),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 13,
          mainAxisSpacing: 13,
        ),
        itemCount: 1,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (_, i) {
          if (backgroundImage != null && backgroundImage != '') {
            return PWidget.container(
              Stack(children: [
                Positioned.fill(
                    child: CachedNetworkImage(imageUrl: backgroundImage, fit: BoxFit.cover)),
                Positioned.fill(child: Container(color: Colors.black54)),
                PWidget.positioned(
                  PWidget.icon(
                    Icons.highlight_remove_rounded,
                    [Colors.white],
                    {
                      'pd': 8,
                      'fun': () async {
                        setState(() => backgroundImage = null);
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
                if (url != null) {
                  setState(() => backgroundImage = url);
                  EasyLoading.show();
                  await http.post('/peiwan/app/user/setUserBackGround',
                      data: {"avatarThumb": backgroundImage}).then((v) {
                    EasyLoading.dismiss();
                  }).catchError((e) {
                    EasyLoading.dismiss();
                    EasyLoading.showToast('Network exception'.tr);
                  });
                }
              }
            },
          );
        },
      ),
    ]);
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
        isUploadFile = true;
        url = await Common.uploadFile(value, (p0, p1) => flog("$p0,$p1"));
        isUploadFile = false;
        EasyLoading.dismiss();
        // controller.setAvatar(value);
      });
    } else {}
    return url;
  }

  lableText(var text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10, top: 16).h,
      child: Text(
        '$text',
        style: TextStyle(color: Colors.white, fontFamily: FONT_MEDIUM),
      ),
    );
  }

  ///基本信息
  Widget gameMaterialsView() {
    return PWidget.column([
      lableText('Nickname'),
      itemBg(PWidget.row([
        // PWidget.text('Be good at', [Colors.white]),
        // PWidget.boxw(8),
        buildTFView(context!,
            hintText: 'Please enter user nickname'.tr,
            hintColor: Colors.white24,
            textColor: textColor,
            con: userNameCon,
            isExp: true,
            maxLength: 26),
      ])),
      PWidget.boxh(16),
      itemBg(
        PWidget.row([
          PWidget.text('Gender'.tr, [textColor]),
          PWidget.boxw(8),
          PWidget.text(sex == null ? 'Please select'.tr : sexList[sex!]['name'],
              [textColor, 16], {'ali': 1, 'exp': true}),
          rightJtView(16, Colors.white54),
        ]),
        fun: () async {
          var res = await Get.dialog(
            SelectorDialog(
              items: List.generate(sexList.length, (i) {
                return VerifyField.fromJson({'name': '$i', 'label': sexList[i]['name']});
              }),
              title: "Select Gender".tr,
              showInfo: true,
            ),
            barrierColor: Colors.black26,
          );
          if (res != null) setState(() => sex = int.parse(res.name));
        },
      ),
      PWidget.boxh(16),
      itemBg(
        PWidget.row([
          PWidget.text('Language'.tr, [Colors.white]),
          PWidget.boxw(8),
          PWidget.text(language.isEmpty ? 'Please language'.tr : language.join('/'),
              [textColor, 16], {'ali': 1, 'exp': true}),
          rightJtView(16, textColor),
        ]),
        fun: () async {
          var languageList = userinfoDm.list;
          if (languageList.isEmpty) return EasyLoading.showToast('No language to choose'.tr);
          FilterWidget.show(
            list: languageList,
            seleList: language,
            title: 'Select Language'.tr,
            fun: (v) => setState(() => language = v),
          );
        },
      ),
      lableText('Signature'.tr),
      itemBg(PWidget.row([
        // PWidget.text('Be good at', [Colors.white]),
        // PWidget.boxw(8),
        buildTFView(context!,
            hintText: 'Please enter Signature'.tr,
            hintColor: Colors.white24,
            textColor: textColor,
            con: beGoodAtCon,
            isExp: true),
      ])),
      lableText('Location'.tr),
      cityWidget(),
    ]);
  }

  showState() {
    if (_curCountry != null) {
      return _curCountry?.state.isNotEmpty == true;
    }
    if (_curState == null) return false;
    return country?.isNotEmpty == true;
  }

  showCity() {
    if (_curState == null) return false;
    if (_curCountry != null) {
      if (_curCountry?.state.isEmpty == true) return false;
    }
    //   if (state == null||state=='*State') return false;
    if (_curState == null) {
      return false;
    }
    return _curState?.city.isNotEmpty == true;
  }

  Country? _curCountry;
  Region? _curState;

  cityWidget() {
    return Obx(() => countries.isEmpty
        ? Container()
        : Visibility(
            visible: hasInited && countries.isNotEmpty,
            child: CSCPicker(
              countries: countries,
              arrowColor: Colors.white60,
              showStates: false,
              showCities: false,
              currentCountry:
                  _curCountry == null ? null : '${_curCountry?.emoji}  ${_curCountry?.name}',
              currentState: state == null ? null : state,
              currentCity: city == null ? null : city,
              // flagState: CountryFlag.DISABLE,
              //  disabledDropdownDecoration: BoxDecoration(
              //      borderRadius: BorderRadius.all(Radius.circular(10)),
              //      color: AppColor.itemBg,
              //      border: Border.all(color: AppColor.itemBg, width: 1)),
              dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: AppColor.itemBg2,
                  border: Border.all(color: AppColor.itemBg2, width: 1)),
              countrySearchPlaceholder: "Country".tr,
              stateSearchPlaceholder: "State".tr,
              citySearchPlaceholder: "City".tr,
              countryDropdownLabel: "*${'Country'.tr}",
              stateDropdownLabel: "*${'State'.tr}",
              cityDropdownLabel: "*${'City'.tr}",
              //  defaultCountry: DefaultCountry.United_States,
              selectedItemStyle: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              dropdownDialogRadius: 10.0,
              searchBarRadius: 10.0,
              onCountryChanged: (value) {
                //  flog('onCountryChanged${value.name}');
                country = value?.name;
                _curCountry = value;
              },
              onStateChanged: (value) {
                // flog('onStateChanged$value');
                if (value == null && value == '*${'State'.tr}') {
                  state = null;
                  _curState = null;
                } else {
                  state = value;
                  _curState = _curCountry?.state.firstWhereOrNull((item) => item.name == state);
                }
              },
              onCityChanged: (value) {
                //   flog('onCityChanged$value');
                //  if (value == null) return;
                if (value == null && value == '*${'City'.tr}') {
                  city = null;
                } else {
                  city = value;
                }
              },
            )));
  }

  RxList<Map> _gamePhotos = RxList();

  List<Map> get gamePhotos => _gamePhotos.value;

  set gamePhotos(List<Map> value) {
    _gamePhotos.value = value;
  }

  var textColor = Color(0xffb2b9c9);

  ///游戏图像
  iDPhotoView() {
    return PWidget.column([
      Obx(() => lableText('${'Album'.tr} (${20 - gamePhotos.length})')),
      Obx(() => GridView.builder(
            padding: EdgeInsets.only(top: 6).h,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 13,
              mainAxisSpacing: 13,
            ),
            itemCount: gamePhotos.length == 20 ? gamePhotos.length : gamePhotos.length + 1,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (_, i) {
              if (gamePhotos.length > i) {
                return PWidget.container(
                  Stack(children: [
                    Positioned.fill(
                        child: CachedNetworkImage(
                            imageUrl: gamePhotos[i]['thumb'], fit: BoxFit.cover)),
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
                              await http
                                  .post('/peiwan/app/user/delPhoto/${gamePhotos[i]['id']}')
                                  .then((v) {
                                setState(() => gamePhotos.removeAt(i));
                              }).catchError((e) {
                                EasyLoading.showToast('Network exception'.tr);
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
                    if (isUploadFile)
                      return EasyLoading.showToast('Uploading failed, please try again later'.tr);
                    var url = await this.selectAvatar(context!);
                    if (url != null)
                      setState(() => gamePhotos.add({'thumb': '$url', 'isUpload': 1, 'id': ''}));
                  }
                },
              );
            },
          )),
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
    var isFemale = widget.sex == '1';
    var gd = PFun.tl2brGd(Color(0xff9DBDFD), Color(0xff76A3FD));
    var icoin = PWidget.icon(Icons.female_rounded, [Colors.white, 12]);
    if (widget.sex == '1') {
      gd = PFun.tl2brGd(Color(0xffFF95D4), Color(0xffFF5BAA));
      icoin = PWidget.icon(Icons.female_rounded, [Colors.white, 12]);
    } else if (widget.sex == '0') {
      gd = PFun.tl2brGd(Color(0xff9DBDFD), Color(0xff76A3FD));
      icoin = PWidget.icon(Icons.male_rounded, [Colors.white, 12]);
    } else {
      gd = PFun.tl2brGd(Color(0xffc5c7cd), Color(0xffa1a4ab));
      icoin = PWidget.icon(Icons.question_mark, [Colors.white, 12]);
    }
    // if (isFemale) gd = PFun.tl2brGd(Color(0xffFF95D4), Color(0xffFF5BAA));
    return PWidget.container(
      PWidget.row([
        icoin,
        PWidget.boxw(2),
        PWidget.text(widget.age, [Colors.white, 10]),
      ], '220'),
      [null, null, Colors.black],
      {
        'gd': gd,
        'pd': PFun.lg(2, 2, 4, 4),
        'br': 56,
      },
    );
  }
}

// 游戏级别
class PlayLevelWidget extends StatefulWidget {
  final String level;
  final int isauth;
  final String userId;

  const PlayLevelWidget({Key? key, this.level = '1', required this.isauth, required this.userId})
      : super(key: key);

  @override
  _PlayLevelWidgetState createState() => _PlayLevelWidgetState();
}

class _PlayLevelWidgetState extends State<PlayLevelWidget> {
  var levelMap = {
    '1': 'assets/images/play/level_1.png',
    '2': 'assets/images/play/level_2.png',
    '3': 'assets/images/play/level_3.png',
    '4': 'assets/images/play/level_4.png',
    '5': 'assets/images/play/level_5.png',
  };

  var titleMap = {
    '1': 'assets/images/play/titles_1.png',
    '2': 'assets/images/play/titles_2.png',
    '3': 'assets/images/play/titles_3.png',
    '4': 'assets/images/play/titles_4.png',
    '5': 'assets/images/play/titles_5.png',
  };

  @override
  Widget build(BuildContext context) {
    return widget.isauth != TYPE_VIP
        ? Container()
        : GestureDetector(
            onTap: () =>
                widget.userId == Get.find<UserController>().userProfile.pwId.toString()
                    ? Get.toNamed(AppPages.Grade)
                    : null,
            child: Stack(alignment: Alignment.bottomRight, children: [
              PWidget.image(
                (widget.isauth == 1 ? levelMap : titleMap)[widget.level] ??
                    'assets/images/play/level_1.png',
              ),
              // if (widget.isauth == 1)
              //   PWidget.container(
              //     PWidget.text('${widget.level}', [Colors.white, 8], {'ct': true}),
              //     [10, 10, Color(0xffefbd6d)],
              //   ),
            ]),
          );
  }
}

///接单数和评分
class OrdersAndStarWidget extends StatefulWidget {
  final Map data;
  final Color? bgColor;
  final Color? tColor;
  final bool? isTran;
  final List margin;
  final Function? fun;

  const OrdersAndStarWidget(this.data,
      {Key? key, this.bgColor, this.tColor, this.isTran = false, this.margin = const [8], this.fun})
      : super(key: key);

  @override
  _OrdersAndStarWidgetState createState() => _OrdersAndStarWidgetState();
}

class _OrdersAndStarWidgetState extends State<OrdersAndStarWidget> {
  @override
  Widget build(BuildContext context) {
    return PWidget.container(
      PWidget.row([
        if (widget.data['star'] != 0)
          Image.asset("assets/images/play/score1.png", width: 10, height: 10),
        if (widget.data['star'] != 0) PWidget.boxw(8),
        if (widget.data['star'] != 0) PWidget.text('${widget.data['star']}', [Colors.white70, 12]),
        if (widget.data['orders'] != 0) PWidget.boxw(4),
        if (widget.data['orders'] != 0)
          PWidget.text('(${widget.data['orders']})', [Colors.white54, 12]),
      ], '220'),
      [null, null, Colors.black12],
      {
        'crr': 56,
        'mg': widget.margin,
        'pd': PFun.lg(4, 4, 8, 8),
        if (widget.fun != null) 'fun': () => widget.fun!(),
      },
    );
  }
}
