import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/config/app_color.dart';
import 'package:sq_hub_app/image_utils.dart';

import '../../../config/icon_font.dart';
import '../../../getx_ctr/bubble_confirm_order_ctr.dart';
import '../../../getx_ctr/bubble_tea_detail_ctr.dart';
import '../../../getx_ctr/tab_bubble_tea_ctr.dart';
import '../../../utils/toast_utils.dart';
import '../../../widget/tag/simple_tags.dart';
import '../../../widget/tag/tag_bean.dart';
import 'bubble_confirm_order_page.dart';

class BubbleTeaPreview {
  final String? name;
  final String? brief;
  final String? image;
  final String? price;

  const BubbleTeaPreview({this.name, this.brief, this.image, this.price});
}

class BubbleTeaDetailPage extends StatefulWidget {
  final int? productId;
  final BubbleTeaPreview? preview;

  const BubbleTeaDetailPage({super.key, this.productId, this.preview});

  static void open({required int? productId, BubbleTeaPreview? preview}) {
    Get.to(
      () => BubbleTeaDetailPage(productId: productId, preview: preview),
      transition: Transition.noTransition,
    );
  }

  @override
  State<BubbleTeaDetailPage> createState() => _BubbleTeaDetailPageState();
}

class _BubbleTeaDetailPageState extends State<BubbleTeaDetailPage> {
  late final BubbleTeaDetailCtr ctr;
  late final String _controllerTag;
  late final int? _productId;

  @override
  void initState() {
    super.initState();
    final dynamic arguments = Get.arguments;
    _productId =
        widget.productId ??
        (arguments is int ? arguments : int.tryParse('${arguments ?? ''}'));
    _controllerTag = 'bubble_tea_detail_${identityHashCode(this)}';
    ctr = Get.put(BubbleTeaDetailCtr(), tag: _controllerTag);
    ctr.requestData(_productId);
  }

  @override
  void dispose() {
    if (Get.isRegistered<BubbleTeaDetailCtr>(tag: _controllerTag)) {
      Get.delete<BubbleTeaDetailCtr>(tag: _controllerTag);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          if (!ctr.isLoading.value && ctr.loadError.value.isNotEmpty) {
            return _buildError();
          }
          return _buildContent(isLoading: ctr.isLoading.value);
        }),
      ),
      bottomNavigationBar: Builder(
        builder: (context) {
          ctr.cartContext = context;
          return SafeArea(top: false, child: addToCartWidget(16.w));
        },
      ),
    );
  }

  Widget _buildError() => ColoredBox(
    color: AppColor.background,
    child: Stack(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFF211D13),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.cloud_off_rounded,
                    color: const Color(0xFFFFB20E),
                    size: 28.sp,
                  ),
                ),
                18.verticalSpace,
                Text(
                  'Product unavailable',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontFamily: FONT_MEDIUM,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                8.verticalSpace,
                Text(
                  ctr.loadError.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFFAAA7A0),
                    fontSize: 13.sp,
                    height: 1.45,
                  ),
                ),
                22.verticalSpace,
                FilledButton(
                  onPressed: () => ctr.requestData(_productId),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB20E),
                    foregroundColor: const Color(0xFF111111),
                    minimumSize: Size(150.w, 46.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
        ),
        Positioned(top: 12.h, left: 16.w, child: _buildBackButton()),
      ],
    ),
  );

  Widget _buildContent({required bool isLoading}) {
    final preview = widget.preview;
    final name = isLoading ? preview?.name ?? '' : ctr.model.value.name ?? '';
    final brief = isLoading
        ? preview?.brief ?? ''
        : ctr.model.value.brief ?? '';
    final image = isLoading
        ? preview?.image ?? ''
        : ctr.model.value.image ?? '';
    final previewImage = preview?.image ?? '';
    final price = isLoading
        ? preview?.price ?? ''
        : ctr.model.value.price ?? '';

    return Stack(
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _buildHero(imageUrl: image, previewImageUrl: previewImage),
            ),
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: Offset(0, -18.h),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 34.h),
                  decoration: BoxDecoration(
                    color: AppColor.background,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(22.r),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (name.isNotEmpty)
                        Text(
                          name,
                          style: TextStyle(
                            color: const Color(0xFFF7F5F1),
                            fontSize: 24.sp,
                            height: 1.12,
                            fontFamily: FONT_MEDIUM,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      else
                        _loadingBlock(width: 220.w, height: 26.h),
                      if (brief.trim().isNotEmpty) ...[
                        8.verticalSpace,
                        Text(
                          brief,
                          style: TextStyle(
                            color: const Color(0xFFAAA7A0),
                            fontSize: 13.sp,
                            height: 1.45,
                            fontFamily: 'DIN',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ] else if (isLoading) ...[
                        10.verticalSpace,
                        _loadingBlock(width: 150.w, height: 14.h),
                      ],
                      20.verticalSpace,
                      _buildPriceAndQuantity(
                        isLoading: isLoading,
                        previewPrice: price,
                      ),
                      _buildOptions(isLoading: isLoading),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned(top: 12.h, left: 16.w, child: _buildBackButton()),
      ],
    );
  }

  Widget _buildHero({
    required String imageUrl,
    required String previewImageUrl,
  }) => Container(
    width: double.infinity,
    height: 330.h,
    color: const Color(0xFF171717),
    child: imageUrl.isEmpty
        ? _buildHeroFallback()
        : CachedNetworkImage(
            imageUrl: imageUrl,
            width: 1.sw,
            height: 330.h,
            fit: BoxFit.cover,
            fadeInDuration: Duration.zero,
            fadeOutDuration: Duration.zero,
            useOldImageOnUrlChange: true,
            placeholder: (_, __) =>
                previewImageUrl.isNotEmpty && previewImageUrl != imageUrl
                ? CachedNetworkImage(
                    imageUrl: previewImageUrl,
                    fit: BoxFit.cover,
                    fadeInDuration: Duration.zero,
                    fadeOutDuration: Duration.zero,
                    errorWidget: (_, __, ___) => _buildHeroFallback(),
                  )
                : _buildHeroFallback(),
            errorWidget: (_, __, ___) =>
                previewImageUrl.isNotEmpty && previewImageUrl != imageUrl
                ? CachedNetworkImage(
                    imageUrl: previewImageUrl,
                    fit: BoxFit.cover,
                    fadeInDuration: Duration.zero,
                    fadeOutDuration: Duration.zero,
                    errorWidget: (_, __, ___) => _buildHeroFallback(),
                  )
                : _buildHeroFallback(),
          ),
  );

  Widget _buildHeroFallback() => Container(
    color: const Color(0xFF171717),
    alignment: Alignment.center,
    child: Icon(
      Icons.local_cafe_outlined,
      color: const Color(0xFFFFB20E),
      size: 58.sp,
    ),
  );

  Widget _buildOptions({required bool isLoading}) => AnimatedSwitcher(
    duration: const Duration(milliseconds: 160),
    switchInCurve: Curves.easeOutCubic,
    switchOutCurve: Curves.easeOutCubic,
    transitionBuilder: (child, animation) =>
        FadeTransition(opacity: animation, child: child),
    child: isLoading
        ? SizedBox(key: const ValueKey('options-loading'), height: 28.h)
        : Obx(() {
            final revision = ctr.optionsRevision.value;
            return KeyedSubtree(
              key: ValueKey('options-ready-$revision'),
              child: paramsWidget(),
            );
          }),
  );

  Widget _loadingBlock({
    required double width,
    required double height,
    double? radius,
  }) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: const Color(0xFF222222),
      borderRadius: BorderRadius.circular(radius ?? 7.r),
    ),
  );

  Widget _buildBackButton() => Material(
    color: const Color(0xD91A1A1A),
    borderRadius: BorderRadius.circular(12.r),
    child: InkWell(
      onTap: () => Get.back(),
      borderRadius: BorderRadius.circular(12.r),
      child: SizedBox(
        width: 46.w,
        height: 46.w,
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 20.sp,
        ),
      ),
    ),
  );

  Widget _buildPriceAndQuantity({
    required bool isLoading,
    required String previewPrice,
  }) => Container(
    width: double.infinity,
    constraints: BoxConstraints(minHeight: 82.h),
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: const Color(0xFF161616),
      borderRadius: BorderRadius.circular(16.r),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Price',
                style: TextStyle(
                  color: const Color(0xFFAAA7A0),
                  fontSize: 12.sp,
                  fontFamily: FONT_MEDIUM,
                ),
              ),
              4.verticalSpace,
              Obx(() {
                final totalMoney = ctr.totalMoney.value;
                final displayPrice = isLoading ? previewPrice : totalMoney;
                return Text(
                  displayPrice.isEmpty ? '—' : '£$displayPrice',
                  style: TextStyle(
                    color: const Color(0xFFFFC229),
                    fontSize: 24.sp,
                    fontFamily: FONT_MEDIUM,
                    fontWeight: FontWeight.w700,
                  ),
                );
              }),
            ],
          ),
        ),
        Container(width: 1, height: 42.h, color: const Color(0xFF303030)),
        16.horizontalSpace,
        Obx(() {
          final showAddToCart = ctr.showAddToCart.value;
          if (!isLoading && !showAddToCart) {
            return qualityWidget();
          }
          return _buildAddToCartButton(enabled: !isLoading);
        }),
      ],
    ),
  );

  Widget _buildAddToCartButton({required bool enabled}) => Material(
    color: enabled ? const Color(0xFFFFB20E) : const Color(0xFF303030),
    borderRadius: BorderRadius.circular(12.r),
    child: InkWell(
      onTap: enabled ? ctr.addToCart : null,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        constraints: BoxConstraints(minWidth: 118.w),
        height: 44.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        alignment: Alignment.center,
        child: Text(
          'Add To Cart',
          style: TextStyle(
            color: enabled ? const Color(0xFF111111) : const Color(0xFF858585),
            fontSize: 13.sp,
            fontFamily: FONT_MEDIUM,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ),
  );

  Widget paramsWidget() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (ctr.sizeTags.isNotEmpty)
        commonWidget(
          title: "Size",
          selectSize: 1,
          tagList: ctr.sizeTags,
          isDefaultSelectFirst: true,
          defaultSelect: [ctr.model.value.selectSize],
          onTagPress: (tagBean, isAdd) => ctr.selectSize(tagBean, isAdd),
        ),
      if (ctr.iceTags.isNotEmpty)
        commonWidget(
          title: "Ice Level",
          selectSize: 1,
          isDefaultSelectFirst: true,
          tagList: ctr.iceTags,
          defaultSelect: [ctr.model.value.selectIce],
          onTagPress: (tagBean, isAdd) => ctr.selectIce(tagBean, isAdd),
        ),
      if (ctr.sugarTags.isNotEmpty)
        commonWidget(
          title: "Sugar",
          selectSize: 1,
          isDefaultSelectFirst: true,
          tagList: ctr.sugarTags,
          defaultSelect: [ctr.model.value.selectSugar],
          onTagPress: (tagBean, isAdd) => ctr.selectSugar(tagBean, isAdd),
        ),
      if (ctr.toppingTags.isNotEmpty)
        commonWidget(
          title: "Toppings",
          selectSize: 2,
          isDefaultSelectFirst: true,
          tagList: ctr.toppingTags,
          defaultSelect: ctr.model.value.selectTopping,
          onTagPress: (tagBean, isAdd) => ctr.selectToppings(tagBean, isAdd),
        ),
    ],
  );

  Widget commonWidget({
    required String title,
    required int selectSize,
    required bool isDefaultSelectFirst,
    required List<TagBean> tagList,
    required List<TagBean?> defaultSelect,
    required Function(TagBean, bool isAdd) onTagPress,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(top: 28.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: const Color(0xFFF7F5F1),
                  fontSize: 16.sp,
                  fontFamily: FONT_MEDIUM,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              selectSize == 1 ? 'Select one' : 'Choose up to $selectSize',
              style: TextStyle(
                color: const Color(0xFF77736D),
                fontSize: 11.sp,
                fontFamily: 'DIN',
              ),
            ),
          ],
        ),
      ),
      SimpleTags(
        key: ValueKey(title),
        content: tagList,
        selectSize: selectSize,
        defaultSelect: defaultSelect,
        wrapSpacing: 10.w,
        wrapRunSpacing: 10.h,
        onTagPress: (TagBean tagBean, bool isAdd) => onTagPress(tagBean, isAdd),
        tagContainerPadding: EdgeInsets.symmetric(
          vertical: 11.h,
          horizontal: 16.w,
        ),
        tagTextStyle: TextStyle(
          color: const Color(0xFFF2F0EC),
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
        ),
        tagSelectTextStyle: TextStyle(
          color: const Color(0xFF111111),
          fontSize: 13.sp,
          fontWeight: FontWeight.bold,
        ),
        tagContainerDecoration: BoxDecoration(
          color: const Color(0xFF181818),
          border: Border.all(color: const Color(0xFF343434), width: 1.w),
          borderRadius: BorderRadius.circular(8.r),
        ),
        tagContainerSelectDecoration: BoxDecoration(
          color: const Color(0xFFFFB20E),
          border: Border.all(color: const Color(0xFFFFB20E), width: 1.w),
          borderRadius: BorderRadius.circular(8.r),
        ),
      ).paddingOnly(top: 12.h),
    ],
  );

  Widget addToCartWidget(double horizontal) => Container(
    width: 1.sw,
    height: 72.h,
    decoration: BoxDecoration(
      color: const Color(0xFF141414),
      borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x80000000),
          offset: Offset(0, -6),
          blurRadius: 18,
        ),
      ],
    ),
    padding: EdgeInsets.symmetric(horizontal: horizontal),
    child: Row(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            TabBubbleTeaCtr.find.isShowDrinkNow.value = false;
            if (TabBubbleTeaCtr.find.isShowCartDialog) {
              dismissLoading();
            } else {
              if (TabBubbleTeaCtr.find.selectTeaList.isNotEmpty) {
                TabBubbleTeaCtr.find.isShowCartDialog = true;
                SmartDialog.showAttach(
                  targetContext: ctr.cartContext,
                  usePenetrate: false,
                  alignment: Alignment.topCenter,
                  builder: (_) => cartWidget(),
                  onDismiss: () {
                    TabBubbleTeaCtr.find.isShowDrinkNow.value = true;
                    TabBubbleTeaCtr.find.isShowCartDialog = false;
                    ctr.initParamsAndPrice();
                  },
                );
              }
            }
          },
          child: Obx(
            () => badges.Badge(
              showBadge: TabBubbleTeaCtr.find.totalCount.value > 0,
              badgeContent: Text(
                '${TabBubbleTeaCtr.find.totalCount.value}',
                style: TextStyle(color: Colors.white, fontSize: 12.sp),
              ),
              badgeColor: hexColor('FF4848'),
              position: badges.BadgePosition(top: -8.h),
              alignment: Alignment.topRight,
              child: Container(
                width: 46.w,
                height: 46.w,
                decoration: ShapeDecoration(
                  color: hexColor('141517'),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.w, color: hexColor('FFB20E')),
                    borderRadius: BorderRadius.circular(60.r),
                  ),
                ),
                child: Image.asset(ImageUtils.drink_now_icon, scale: 2),
              ),
            ),
          ),
        ),
        12.horizontalSpace,
        Expanded(
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cart total',
                  style: TextStyle(
                    color: const Color(0xFF8E8B85),
                    fontSize: 10.sp,
                    fontFamily: 'DIN',
                  ),
                ),
                2.verticalSpace,
                Text(
                  '£${TabBubbleTeaCtr.find.totalPrice.value}',
                  style: TextStyle(
                    color: const Color(0xFFF7F5F1),
                    fontSize: 20.sp,
                    fontFamily: FONT_MEDIUM,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        Obx(() {
          final enabled = TabBubbleTeaCtr.find.selectTeaList.isNotEmpty;
          return Material(
            color: enabled ? const Color(0xFFFFB20E) : const Color(0xFF303030),
            borderRadius: BorderRadius.circular(12.r),
            child: InkWell(
              onTap: enabled
                  ? () => Get.to(
                      () => BubbleConfirmOrderPage(),
                      transition: Transition.noTransition,
                    )
                  : null,
              borderRadius: BorderRadius.circular(12.r),
              child: SizedBox(
                width: 118.w,
                height: 48.h,
                child: Center(
                  child: Text(
                    'Order Now',
                    style: TextStyle(
                      color: enabled
                          ? const Color(0xFF111111)
                          : const Color(0xFF777777),
                      fontSize: 14.sp,
                      fontFamily: FONT_MEDIUM,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    ),
  );

  Widget cartWidget() => Container(
    constraints: BoxConstraints(
      maxHeight: 300.h,
      minHeight: 100.h,
      minWidth: 1.sw,
    ),
    decoration: ShapeDecoration(
      color: hexColor('141517'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.verticalSpace,
        Row(
          children: [
            Expanded(
              child: Obx(
                () => RichText(
                  text: TextSpan(
                    text: "${TabBubbleTeaCtr.find.selectTeaList.length}  ",
                    style: TextStyle(
                      color: hexColor('FFB20E'),
                      fontSize: 14.sp,
                      fontFamily: 'DIN',
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(
                        text: 'item in total',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14.sp,
                          fontFamily: 'DIN',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ).paddingOnly(left: 16.w),
              ),
            ),
            InkWell(
              onTap: () => ctr.clearCart(),
              child: Image.asset(ImageUtils.delete_icon),
            ),
            16.horizontalSpace,
          ],
        ),
        TabBubbleTeaCtr.find.selectTeaList.length <= 3
            ? Expanded(child: cartListWidget(true))
            : Expanded(child: cartListWidget(false)),
        addToCartWidget(16.w),
      ],
    ),
  );

  Widget cartListWidget(bool shrinkWrap) => Obx(
    () => ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: shrinkWrap,
      itemBuilder: (c, i) => Container(
        height: 70.h,
        child: Row(
          children: [
            16.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${TabBubbleTeaCtr.find.selectTeaList[i].name}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontFamily: FONT_MEDIUM,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Visibility(
                    visible:
                        TabBubbleTeaCtr.find.selectTeaList[i].brief != null,
                    child: Text(
                      '${TabBubbleTeaCtr.find.selectTeaList[i].brief}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 10.sp,
                        fontFamily: FONT_LIGHT,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '£ ${TabBubbleTeaCtr.find.getPrice(TabBubbleTeaCtr.find.selectTeaList[i])}',
              style: TextStyle(
                color: Color(0xFFFFB20E),
                fontSize: 16.sp,
                fontFamily: FONT_MEDIUM,
                fontWeight: FontWeight.w600,
              ),
            ).paddingSymmetric(horizontal: 10.w),
            InkWell(
              onTap: () => TabBubbleTeaCtr.find.minusMoney(i),
              child: Icon(Icons.remove_circle_outline, color: Colors.white),
            ),
            Obx(
              () => Text(
                '${TabBubbleTeaCtr.find.selectTeaList[i].count}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontFamily: FONT_LIGHT,
                  fontWeight: FontWeight.w600,
                ),
              ).paddingSymmetric(horizontal: 15.w),
            ),
            InkWell(
              onTap: () => TabBubbleTeaCtr.find.addMoney(i),
              child: Icon(Icons.add_circle_outline, color: hexColor('#FFB20E')),
            ),
            16.horizontalSpace,
          ],
        ),
      ),
      separatorBuilder: (c, i) => Container(
        height: 1.h,
        decoration: BoxDecoration(color: Color(0xFF2F2F2F)),
      ),
      itemCount: TabBubbleTeaCtr.find.selectTeaList.length,
    ),
  );

  Widget qualityWidget() => SizedBox(
    height: 42.h,
    child: Row(
      children: [
        _quantityButton(
          icon: Icons.remove_rounded,
          onTap: ctr.minusMoney,
          foregroundColor: const Color(0xFFF7F5F1),
          backgroundColor: const Color(0xFF282828),
        ),
        Obx(
          () => Text(
            '${ctr.quantity.value}',
            style: TextStyle(
              color: const Color(0xFFF7F5F1),
              fontSize: 16.sp,
              fontFamily: FONT_MEDIUM,
              fontWeight: FontWeight.w700,
            ),
          ).paddingSymmetric(horizontal: 12.w),
        ),
        _quantityButton(
          icon: Icons.add_rounded,
          onTap: ctr.addMoney,
          foregroundColor: const Color(0xFF111111),
          backgroundColor: const Color(0xFFFFB20E),
        ),
      ],
    ),
  );

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color foregroundColor,
    required Color backgroundColor,
  }) => Material(
    color: backgroundColor,
    borderRadius: BorderRadius.circular(10.r),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: SizedBox(
        width: 40.w,
        height: 40.w,
        child: Icon(icon, color: foregroundColor, size: 21.sp),
      ),
    ),
  );
}
