import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:local_notifications_for_us/local_notifications_for_us.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/core_services.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/app.dart';
import 'package:wy/utils/platform_utils.dart';
import 'package:wy/utils/storage_manager.dart';

import 'app_color.dart';

var splashBg = 'https://sidequest-1307226287.cos.eu-frankfurt.myqcloud.com/APPcover/pic_bg.png';
var inviteUrl = 'https://sidequesthub.com/#/share';

class AppConfig {
  static final Http http = Http();
  static final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();

  static OverlayEntry? overlayEntry;

  static String? name;

  static String _devServer = 'http://114.117.203.137:8081';
  static String _devServer2 = 'http://1.14.75.127:8081';
  static String _testServer = 'http://43.136.135.198:8081';
  static String _prodServer = 'https://sidequestmeta.com';

  static final isProd = const bool.fromEnvironment('dart.vm.product');

  static final channel = const String.fromEnvironment("channel");

  static final String noImage = "https://www.cabletiesandmore.com/images/gallery/no-image.jpg";

  static final String cityJson =
      '[{"name":"Aberdeen","country_code":"GB"},{"name":"Aberdeenshire","country_code":"GB"},{"name":"Angus","country_code":"GB"},{"name":"Antrim","country_code":"GB"},{"name":"Antrim and Newtownabbey","country_code":"GB"},{"name":"Ards","country_code":"GB"},{"name":"Ards and North Down","country_code":"GB"},{"name":"Argyll and Bute","country_code":"GB"},{"name":"Armagh City and District Council","country_code":"GB"},{"name":"Armagh, Banbridge and Craigavon","country_code":"GB"},{"name":"Ascension Island","country_code":"GB"},{"name":"Ballymena Borough","country_code":"GB"},{"name":"Ballymoney","country_code":"GB"},{"name":"Banbridge","country_code":"GB"},{"name":"Barnsley","country_code":"GB"},{"name":"Bath and North East Somerset","country_code":"GB"},{"name":"Bedford","country_code":"GB"},{"name":"Belfast district","country_code":"GB"},{"name":"Birmingham","country_code":"GB"},{"name":"Blackburn with Darwen","country_code":"GB"},{"name":"Blackpool","country_code":"GB"},{"name":"Blaenau Gwent County Borough","country_code":"GB"},{"name":"Bolton","country_code":"GB"},{"name":"Bournemouth","country_code":"GB"},{"name":"Bracknell Forest","country_code":"GB"},{"name":"Bradford","country_code":"GB"},{"name":"Bridgend County Borough","country_code":"GB"},{"name":"Brighton and Hove","country_code":"GB"},{"name":"Buckinghamshire","country_code":"GB"},{"name":"Bury","country_code":"GB"},{"name":"Caerphilly County Borough","country_code":"GB"},{"name":"Calderdale","country_code":"GB"},{"name":"Cambridgeshire","country_code":"GB"},{"name":"Carmarthenshire","country_code":"GB"},{"name":"Carrickfergus Borough Council","country_code":"GB"},{"name":"Castlereagh","country_code":"GB"},{"name":"Causeway Coast and Glens","country_code":"GB"},{"name":"Central Bedfordshire","country_code":"GB"},{"name":"Ceredigion","country_code":"GB"},{"name":"Cheshire East","country_code":"GB"},{"name":"Cheshire West and Chester","country_code":"GB"},{"name":"City and County of Cardiff","country_code":"GB"},{"name":"City and County of Swansea","country_code":"GB"},{"name":"City of Bristol","country_code":"GB"},{"name":"City of Derby","country_code":"GB"},{"name":"City of Kingston upon Hull","country_code":"GB"},{"name":"City of Leicester","country_code":"GB"},{"name":"City of London","country_code":"GB"},{"name":"City of Nottingham","country_code":"GB"},{"name":"City of Peterborough","country_code":"GB"},{"name":"City of Plymouth","country_code":"GB"},{"name":"City of Portsmouth","country_code":"GB"},{"name":"City of Southampton","country_code":"GB"},{"name":"City of Stoke-on-Trent","country_code":"GB"},{"name":"City of Sunderland","country_code":"GB"},{"name":"City of Westminster","country_code":"GB"},{"name":"City of Wolverhampton","country_code":"GB"},{"name":"City of York","country_code":"GB"},{"name":"Clackmannanshire","country_code":"GB"},{"name":"Coleraine Borough Council","country_code":"GB"},{"name":"Conwy County Borough","country_code":"GB"},{"name":"Cookstown District Council","country_code":"GB"},{"name":"Cornwall","country_code":"GB"},{"name":"County Durham","country_code":"GB"},{"name":"Coventry","country_code":"GB"},{"name":"Craigavon Borough Council","country_code":"GB"},{"name":"Cumbria","country_code":"GB"},{"name":"Darlington","country_code":"GB"},{"name":"Denbighshire","country_code":"GB"},{"name":"Derbyshire","country_code":"GB"},{"name":"Derry City and Strabane","country_code":"GB"},{"name":"Derry City Council","country_code":"GB"},{"name":"Devon","country_code":"GB"},{"name":"Doncaster","country_code":"GB"},{"name":"Dorset","country_code":"GB"},{"name":"Down District Council","country_code":"GB"},{"name":"Dudley","country_code":"GB"},{"name":"Dumfries and Galloway","country_code":"GB"},{"name":"Dundee","country_code":"GB"},{"name":"Dungannon and South Tyrone Borough Council","country_code":"GB"},{"name":"East Ayrshire","country_code":"GB"},{"name":"East Dunbartonshire","country_code":"GB"},{"name":"East Lothian","country_code":"GB"},{"name":"East Renfrewshire","country_code":"GB"},{"name":"East Riding of Yorkshire","country_code":"GB"},{"name":"East Sussex","country_code":"GB"},{"name":"Edinburgh","country_code":"GB"},{"name":"England","country_code":"GB"},{"name":"Essex","country_code":"GB"},{"name":"Falkirk","country_code":"GB"},{"name":"Fermanagh and Omagh","country_code":"GB"},{"name":"Fermanagh District Council","country_code":"GB"},{"name":"Fife","country_code":"GB"},{"name":"Flintshire","country_code":"GB"},{"name":"Gateshead","country_code":"GB"},{"name":"Glasgow","country_code":"GB"},{"name":"Gloucestershire","country_code":"GB"},{"name":"Gwynedd","country_code":"GB"},{"name":"Halton","country_code":"GB"},{"name":"Hampshire","country_code":"GB"},{"name":"Hartlepool","country_code":"GB"},{"name":"Herefordshire","country_code":"GB"},{"name":"Hertfordshire","country_code":"GB"},{"name":"Highland","country_code":"GB"},{"name":"Inverclyde","country_code":"GB"},{"name":"Isle of Wight","country_code":"GB"},{"name":"Isles of Scilly","country_code":"GB"},{"name":"Kent","country_code":"GB"},{"name":"Kirklees","country_code":"GB"},{"name":"Knowsley","country_code":"GB"},{"name":"Lancashire","country_code":"GB"},{"name":"Larne Borough Council","country_code":"GB"},{"name":"Leeds","country_code":"GB"},{"name":"Leicestershire","country_code":"GB"},{"name":"Limavady Borough Council","country_code":"GB"},{"name":"Lincolnshire","country_code":"GB"},{"name":"Lisburn and Castlereagh","country_code":"GB"},{"name":"Lisburn City Council","country_code":"GB"},{"name":"Liverpool","country_code":"GB"},{"name":"London Borough of Barking and Dagenham","country_code":"GB"},{"name":"London Borough of Barnet","country_code":"GB"},{"name":"London Borough of Bexley","country_code":"GB"},{"name":"London Borough of Brent","country_code":"GB"},{"name":"London Borough of Bromley","country_code":"GB"},{"name":"London Borough of Camden","country_code":"GB"},{"name":"London Borough of Croydon","country_code":"GB"},{"name":"London Borough of Ealing","country_code":"GB"},{"name":"London Borough of Enfield","country_code":"GB"},{"name":"London Borough of Hackney","country_code":"GB"},{"name":"London Borough of Hammersmith and Fulham","country_code":"GB"},{"name":"London Borough of Haringey","country_code":"GB"},{"name":"London Borough of Harrow","country_code":"GB"},{"name":"London Borough of Havering","country_code":"GB"},{"name":"London Borough of Hillingdon","country_code":"GB"},{"name":"London Borough of Hounslow","country_code":"GB"},{"name":"London Borough of Islington","country_code":"GB"},{"name":"London Borough of Lambeth","country_code":"GB"},{"name":"London Borough of Lewisham","country_code":"GB"},{"name":"London Borough of Merton","country_code":"GB"},{"name":"London Borough of Newham","country_code":"GB"},{"name":"London Borough of Redbridge","country_code":"GB"},{"name":"London Borough of Richmond upon Thames","country_code":"GB"},{"name":"London Borough of Southwark","country_code":"GB"},{"name":"London Borough of Sutton","country_code":"GB"},{"name":"London Borough of Tower Hamlets","country_code":"GB"},{"name":"London Borough of Waltham Forest","country_code":"GB"},{"name":"London Borough of Wandsworth","country_code":"GB"},{"name":"Magherafelt District Council","country_code":"GB"},{"name":"Manchester","country_code":"GB"},{"name":"Medway","country_code":"GB"},{"name":"Merthyr Tydfil County Borough","country_code":"GB"},{"name":"Metropolitan Borough of Wigan","country_code":"GB"},{"name":"Mid and East Antrim","country_code":"GB"},{"name":"Mid Ulster","country_code":"GB"},{"name":"Middlesbrough","country_code":"GB"},{"name":"Midlothian","country_code":"GB"},{"name":"Milton Keynes","country_code":"GB"},{"name":"Monmouthshire","country_code":"GB"},{"name":"Moray","country_code":"GB"},{"name":"Moyle District Council","country_code":"GB"},{"name":"Neath Port Talbot County Borough","country_code":"GB"},{"name":"Newcastle upon Tyne","country_code":"GB"},{"name":"Newport","country_code":"GB"},{"name":"Newry and Mourne District Council","country_code":"GB"},{"name":"Newry, Mourne and Down","country_code":"GB"},{"name":"Newtownabbey Borough Council","country_code":"GB"},{"name":"Norfolk","country_code":"GB"},{"name":"North Ayrshire","country_code":"GB"},{"name":"North Down Borough Council","country_code":"GB"},{"name":"North East Lincolnshire","country_code":"GB"},{"name":"North Lanarkshire","country_code":"GB"},{"name":"North Lincolnshire","country_code":"GB"},{"name":"North Somerset","country_code":"GB"},{"name":"North Tyneside","country_code":"GB"},{"name":"North Yorkshire","country_code":"GB"},{"name":"Northamptonshire","country_code":"GB"},{"name":"Northern Ireland","country_code":"GB"},{"name":"Northumberland","country_code":"GB"},{"name":"Nottinghamshire","country_code":"GB"},{"name":"Oldham","country_code":"GB"},{"name":"Omagh District Council","country_code":"GB"},{"name":"Orkney Islands","country_code":"GB"},{"name":"Outer Hebrides","country_code":"GB"},{"name":"Oxfordshire","country_code":"GB"},{"name":"Pembrokeshire","country_code":"GB"},{"name":"Perth and Kinross","country_code":"GB"},{"name":"Poole","country_code":"GB"},{"name":"Powys","country_code":"GB"},{"name":"Reading","country_code":"GB"},{"name":"Redcar and Cleveland","country_code":"GB"},{"name":"Renfrewshire","country_code":"GB"},{"name":"Rhondda Cynon Taf","country_code":"GB"},{"name":"Rochdale","country_code":"GB"},{"name":"Rotherham","country_code":"GB"},{"name":"Royal Borough of Greenwich","country_code":"GB"},{"name":"Royal Borough of Kensington and Chelsea","country_code":"GB"},{"name":"Royal Borough of Kingston upon Thames","country_code":"GB"},{"name":"Rutland","country_code":"GB"},{"name":"Saint Helena","country_code":"GB"},{"name":"Salford","country_code":"GB"},{"name":"Sandwell","country_code":"GB"},{"name":"Scotland","country_code":"GB"},{"name":"Scottish Borders","country_code":"GB"},{"name":"Sefton","country_code":"GB"},{"name":"Sheffield","country_code":"GB"},{"name":"Shetland Islands","country_code":"GB"},{"name":"Shropshire","country_code":"GB"},{"name":"Slough","country_code":"GB"},{"name":"Solihull","country_code":"GB"},{"name":"Somerset","country_code":"GB"},{"name":"South Ayrshire","country_code":"GB"},{"name":"South Gloucestershire","country_code":"GB"},{"name":"South Lanarkshire","country_code":"GB"},{"name":"South Tyneside","country_code":"GB"},{"name":"Southend-on-Sea","country_code":"GB"},{"name":"St Helens","country_code":"GB"},{"name":"Staffordshire","country_code":"GB"},{"name":"Stirling","country_code":"GB"},{"name":"Stockport","country_code":"GB"},{"name":"Stockton-on-Tees","country_code":"GB"},{"name":"Strabane District Council","country_code":"GB"},{"name":"Suffolk","country_code":"GB"},{"name":"Surrey","country_code":"GB"},{"name":"Swindon","country_code":"GB"},{"name":"Tameside","country_code":"GB"},{"name":"Telford and Wrekin","country_code":"GB"},{"name":"Thurrock","country_code":"GB"},{"name":"Torbay","country_code":"GB"},{"name":"Torfaen","country_code":"GB"},{"name":"Trafford","country_code":"GB"},{"name":"United Kingdom","country_code":"GB"},{"name":"Vale of Glamorgan","country_code":"GB"},{"name":"Wakefield","country_code":"GB"},{"name":"Wales","country_code":"GB"},{"name":"Walsall","country_code":"GB"},{"name":"Warrington","country_code":"GB"},{"name":"Warwickshire","country_code":"GB"},{"name":"West Berkshire","country_code":"GB"},{"name":"West Dunbartonshire","country_code":"GB"},{"name":"West Lothian","country_code":"GB"},{"name":"West Sussex","country_code":"GB"},{"name":"Wiltshire","country_code":"GB"},{"name":"Windsor and Maidenhead","country_code":"GB"},{"name":"Wirral","country_code":"GB"},{"name":"Wokingham","country_code":"GB"},{"name":"Worcestershire","country_code":"GB"},{"name":"Wrexham County Borough","country_code":"GB"}]';
  static const String ACTION_WB = 'wb';
  static const String ACTION_PW = 'pw';
  static const String ACTION_DEFAULT = 'default';

  static Future<void> init(String name, {var action = ACTION_DEFAULT}) async {
    AppConfig.name = name;
    await StorageManager.init();

    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }

    if (!StorageManager.haveEnv()) {
      StorageManager.setEnv(default_server);
    }
    String env = StorageManager.getEnv();
    if (env.contains("dev") || env.contains("test")) {
      //网吧用:pk_test_51L1kPsBizrDMUWwg9A6jFjNOhdIDUtvUoMStTIv0RpfJx00EYC5fdICvH0UVyQM7mLBdt97T1GqU0P4mZbAVBQpj00mWsHoGvg
      //陪玩用:pk_test_51M6DucBH03z3upvwgMfC6ipat2P4VacM6PY7m3Hl3t3KBgXwqxZwUNdKffZ6aPjMq0xPlTmLosOIVMS6DtjzCysZ006kJYlUA9
      if (action == ACTION_DEFAULT) {
        Stripe.publishableKey = "pk_test_51L1kPsBizrDMUWwg9A6jFjNOhdIDUtvUoMStTIv0RpfJx00EYC5fdICvH0UVyQM7mLBdt97T1GqU0P4mZbAVBQpj00mWsHoGvg";
      } else {
        Stripe.publishableKey = "pk_test_51M6DucBH03z3upvwgMfC6ipat2P4VacM6PY7m3Hl3t3KBgXwqxZwUNdKffZ6aPjMq0xPlTmLosOIVMS6DtjzCysZ006kJYlUA9";
      }
    } else {
      //陪玩用：pk_live_51M2DJEB3wUGNV3o0sYDSmWc4taO50UAssHoZF962DboypII4XQFn1SyrwbIA3soc4V3MvLjXqotbUHPq2bHMxiOr00XzkcBdcO
      //网吧用:pk_live_51L2yYXIXDgiM7OYZrSLG5cd2s9TQmlmNCMZjjIXporezDYxYrFuEziACkmsXOVVq6eAmXh4bykLcPov7xuFTAiKB00FUsm5xFM
      if (action == ACTION_DEFAULT) {
        Stripe.publishableKey = "pk_live_51L2yYXIXDgiM7OYZrSLG5cd2s9TQmlmNCMZjjIXporezDYxYrFuEziACkmsXOVVq6eAmXh4bykLcPov7xuFTAiKB00FUsm5xFM";
      } else {
        Stripe.publishableKey = "pk_live_51M2DJEB3wUGNV3o0sYDSmWc4taO50UAssHoZF962DboypII4XQFn1SyrwbIA3soc4V3MvLjXqotbUHPq2bHMxiOr00XzkcBdcO";
      }
    }
    //flog('Stripe.publishableKey ${Stripe.publishableKey}');
    Stripe.merchantIdentifier = "merchant.com.sidequest";
    await Stripe.instance.applySettings();

    bool? initDone = await _coreInstance.init(
        sdkAppID:( env.contains("dev") || env.contains("test"))?40000072:40000072, // 控制台申请的 SDKAppID
        loglevel: LogLevelEnum.V2TIM_LOG_NONE,
        language: LanguageEnum.en,
        listener: V2TimSDKListener());
    if (initDone == true) {
      _coreInstance.setTheme(
        theme: TUITheme(
            textColor: Colors.white,
            chatBgColor: Colors.transparent,
            conversationItemTitleTextColor: Colors.white,
            conversationItemBorderColor: Colors.transparent,
            conversationItemBgColor: Colors.transparent,
            conversationItemPinedBgColor: Colors.transparent,
            chatMessageTongueBgColor: AppColor.color3033,
            lightPrimaryColor: AppColor.background,
            inputFillColor: AppColor.color3033,
            chatMessageItemFromSelfBgColor: AppColor.color302D,
            chatMessageItemFromOthersBgColor: AppColor.itemBg),
      );
    }
  }

  static String getBaseServer() {
    String env = StorageManager.getEnv();
    if (env == "dev137") {
      return _devServer;
    } else if (env == "dev127") {
      return _devServer2;
    } else if (env == "dev198") {
      return _testServer;
    }
    return _prodServer;
  }

  static Future<Widget> createApp() async {
    return App();
  }
}
