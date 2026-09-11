import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../config/icon_font.dart';
import '../../../../controller/user_controller.dart';
import '../../../../image_utils.dart';
import '../../main_page.dart';

const _background = Color(0xFF090909);
const _surface = Color(0xFF171719);
const _surfaceRaised = Color(0xFF222226);
const _line = Color(0x1AFFFFFF);
const _muted = Color(0xFFAAA8AD);
const _soft = Color(0xFF747278);
const _yellow = Color(0xFFFFB20E);
const _orange = Color(0xFFED5A24);
const _green = Color(0xFF6ED49A);

class NewUserWelcomePage extends StatelessWidget {
  const NewUserWelcomePage({
    super.key,
    this.nickName = '',
    this.memberCode = '',
  });

  final String nickName;
  final String memberCode;

  String get _displayName {
    if (nickName.trim().isNotEmpty) return nickName.trim();
    if (!Get.isRegistered<UserController>()) return 'Player'.tr;
    final userController = UserController.find;
    if (userController.userProfile.nickName.trim().isNotEmpty) {
      return userController.userProfile.nickName.trim();
    }
    if (userController.user.value.firstName.trim().isNotEmpty) {
      return userController.user.value.firstName.trim();
    }
    return 'Player'.tr;
  }

  String get _displayMemberCode {
    if (memberCode.trim().isNotEmpty) return memberCode.trim();
    if (!Get.isRegistered<UserController>()) return '';
    final userController = UserController.find;
    if (userController.user.value.memberCode.trim().isNotEmpty) {
      return userController.user.value.memberCode.trim();
    }
    return userController.userProfile.uk.trim();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: _background,
        body: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.62),
              radius: 0.72,
              colors: [Color(0x1CFFB20E), _background],
              stops: [0, 0.68],
            ),
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxHeight < 760;
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    compact ? 12 : 20,
                    20,
                    compact ? 14 : 22,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - (compact ? 26 : 42),
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _topBar(),
                          _CelebrationMark(compact: compact),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: '${'Welcome to'.tr} '),
                                TextSpan(
                                  text: 'SideQuest',
                                  style: const TextStyle(color: _yellow),
                                ),
                                TextSpan(text: ', $_displayName!'),
                              ],
                            ),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: compact ? 27 : 30,
                              height: 1.05,
                              fontFamily: FONT_BLACK,
                              letterSpacing: -0.8,
                            ),
                          ),
                          SizedBox(height: compact ? 7 : 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'Your account is ready. Find your next place to play, book a session, and start earning rewards.'
                                  .tr,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: _muted,
                                fontSize: 13,
                                height: 1.48,
                              ),
                            ),
                          ),
                          if (_displayMemberCode.isNotEmpty) ...[
                            SizedBox(height: compact ? 14 : 20),
                            _memberId(context),
                          ],
                          SizedBox(height: compact ? 17 : 22),
                          const _Possibilities(),
                          const Spacer(),
                          SizedBox(height: compact ? 18 : 25),
                          _startButton(),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Text(
                              'You can update your profile and account settings at any time.'
                                  .tr,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: _soft,
                                fontSize: 9,
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _topBar() {
    return SizedBox(
      height: 36,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Image.asset(ImageUtils.default_logo, width: 30, height: 30),
          ),
          const SizedBox(width: 9),
          const Text(
            'SideQuest',
            style: TextStyle(
              color: Color(0xFFF4F3F5),
              fontSize: 13,
              fontFamily: FONT_BLACK,
            ),
          ),
          const Spacer(),
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: _green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'Account ready'.tr.toUpperCase(),
            style: const TextStyle(
              color: _green,
              fontSize: 10,
              fontFamily: FONT_MEDIUM,
              letterSpacing: 0.7,
            ),
          ),
        ],
      ),
    );
  }

  Widget _memberId(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 57),
      padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
      decoration: BoxDecoration(
        color: const Color(0x09FFFFFF),
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your member ID'.tr,
                  style: const TextStyle(color: _soft, fontSize: 10),
                ),
                const SizedBox(height: 3),
                Text(
                  _displayMemberCode,
                  style: const TextStyle(
                    color: Color(0xFFF4F3F5),
                    fontSize: 14,
                    fontFamily: FONT_MEDIUM,
                    letterSpacing: 0.65,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: _surfaceRaised,
            borderRadius: BorderRadius.circular(11),
            child: InkWell(
              onTap: () => _copyMemberCode(context),
              borderRadius: BorderRadius.circular(11),
              child: const SizedBox(
                width: 36,
                height: 36,
                child: Icon(Icons.copy_rounded, size: 17, color: _muted),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _copyMemberCode(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: _displayMemberCode));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Member ID copied'.tr),
          duration: const Duration(milliseconds: 1400),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF173022),
        ),
      );
  }

  Widget _startButton() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(colors: [_orange, Color(0xFFD49C21)]),
        boxShadow: const [
          BoxShadow(
            color: Color(0x47000000),
            offset: Offset(0, 10),
            blurRadius: 24,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(25),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Get.offAll(() => MainPage()),
          child: Center(
            child: Text(
              'Start exploring'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: FONT_BLACK,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CelebrationMark extends StatelessWidget {
  const _CelebrationMark({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final areaHeight = compact ? 150.0 : 188.0;
    final outerSize = compact ? 138.0 : 164.0;
    final innerSize = compact ? 108.0 : 126.0;
    final logoSize = compact ? 75.0 : 86.0;
    return SizedBox(
      height: areaHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: outerSize,
            height: outerSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0x21FFB20E)),
            ),
          ),
          Container(
            width: innerSize,
            height: innerSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0x21FFB20E)),
            ),
          ),
          Positioned(left: 54, top: compact ? 42 : 54, child: const _Spark()),
          Positioned(
            right: 51,
            top: compact ? 58 : 79,
            child: const _Spark(height: 10, width: 4),
          ),
          Positioned(
            left: 82,
            bottom: compact ? 16 : 24,
            child: const _Spark(height: 3, width: 9),
          ),
          Positioned(
            right: 85,
            bottom: compact ? 22 : 32,
            child: const _Spark(color: _orange),
          ),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.92, end: 1),
            duration: const Duration(milliseconds: 460),
            curve: Curves.easeOutCubic,
            builder: (context, scale, child) =>
                Transform.scale(scale: scale, child: child),
            child: Transform.rotate(
              angle: -0.052,
              child: Container(
                width: logoSize,
                height: logoSize,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0x6BFFB20E)),
                  borderRadius: BorderRadius.circular(compact ? 23 : 27),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF29251C), _surface],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x6B000000),
                      offset: Offset(0, 18),
                      blurRadius: 42,
                    ),
                  ],
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Center(
                      child: Transform.rotate(
                        angle: 0.052,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            compact ? 16 : 18,
                          ),
                          child: Image.asset(
                            ImageUtils.default_logo,
                            width: compact ? 51 : 58,
                            height: compact ? 51 : 58,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: -9,
                      bottom: -7,
                      child: Container(
                        width: 27,
                        height: 27,
                        decoration: BoxDecoration(
                          color: _green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF111113),
                            width: 4,
                          ),
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: Color(0xFF0C2416),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Spark extends StatelessWidget {
  const _Spark({this.width = 5, this.height = 5, this.color = _yellow});

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}

class _Possibilities extends StatelessWidget {
  const _Possibilities();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _Possibility(
            icon: Icons.location_on_outlined,
            title: 'Discover hubs'.tr,
            subtitle: 'Near you'.tr,
          ),
        ),
        const _Divider(),
        Expanded(
          child: _Possibility(
            icon: Icons.calendar_today_outlined,
            title: 'Book sessions'.tr,
            subtitle: 'In seconds'.tr,
          ),
        ),
        const _Divider(),
        Expanded(
          child: _Possibility(
            icon: Icons.star_border_rounded,
            title: 'Earn rewards'.tr,
            subtitle: 'As you play'.tr,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 43,
      margin: const EdgeInsets.only(top: 2),
      color: _line,
    );
  }
}

class _Possibility extends StatelessWidget {
  const _Possibility({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 19, color: _yellow),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFFE8E7EA),
            fontSize: 11,
            height: 1.25,
            fontFamily: FONT_MEDIUM,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(color: _soft, fontSize: 9),
        ),
      ],
    );
  }
}
