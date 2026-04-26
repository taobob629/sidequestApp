/**
    author:mac
    创建日期:2023/2/10
    描述:
 */
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

const int IMG_WEBP = 0;
const int IMG_PNG = 1;

class ImageUtil {
  ImageUtil._();

  static final _package = "sidequest_hub_app";

  static String _imageResStr(var name, {int type = IMG_WEBP}) =>
      "assets/images/$name${type == IMG_WEBP ? '.webp' : '.png'}";

  static Widget svg(
    String name, {
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
  }) {
    return SvgPicture.asset(
      "assets/images/$name.svg",
      width: width,
      height: height,
      color: color,
      package: _package,
    );
  }

  static Widget assetImage(String res,
      {double? width,
      double? height,
      BoxFit? fit,
      Color? color,
      int imageType = IMG_WEBP}) {
    return Image.asset(
      _imageResStr(res, type: imageType),
      width: width,
      height: height,
      fit: fit,
      color: color,
      // cacheWidth: width?.toInt(),
      //package: _package,
    );
  }

  static Widget error({
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
    int imageType = IMG_WEBP,
  }) =>
      Image.asset(
        _imageResStr('default_logo', type: imageType),
        width: width,
        height: height,
        fit: fit,
        color: color,
      );

  static Widget notDisturb() => assetImage(
        'ic_not_disturb',
        width: 20.h,
        height: 20.h,
      );

  static Widget lowMemoryNetworkImage({
    required String url,
    double? width,
    double? height,
    double border = 0,
    int? cacheWidth,
    int? cacheHeight,
    BoxFit? fit,
    bool loadProgress = true,
    bool clearMemoryCacheWhenDispose = true,
    bool lowMemory = true,
    Widget? errorWidget,
  }) =>
      _cachedNetworkImage(
        url: url,
        width: width,
        height: height,
        border: border,
        cacheWidth: cacheHeight,
        cacheHeight: cacheHeight,
        fit: fit,
        loadProgress: loadProgress,
        clearMemoryCacheWhenDispose: clearMemoryCacheWhenDispose,
        lowMemory: lowMemory,
        errorWidget: errorWidget,
      );

  static Widget networkImage({
    required String url,
    double? width,
    double? height,
    int? cacheWidth,
    int? cacheHeight,
    BoxFit? fit,
    double border = 0,
    bool loadProgress = true,
    bool clearMemoryCacheWhenDispose = false,
    bool lowMemory = true,
    Widget? errorWidget,
  }) =>
      lowMemoryNetworkImage(
        url: url,
        width: width,
        border: border,
        height: height,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        fit: fit,
        loadProgress: loadProgress,
        clearMemoryCacheWhenDispose: clearMemoryCacheWhenDispose,
        lowMemory: lowMemory,
        errorWidget: errorWidget,
      );

  static Widget _cachedNetworkImage({
    required String url,
    double? width,
    double? height,
    double border = 0,
    int? cacheWidth,
    int? cacheHeight,
    BoxFit? fit,
    bool loadProgress = true,
    bool clearMemoryCacheWhenDispose = true,
    bool lowMemory = true,
    Widget? errorWidget,
  }) {
    // 检查url是否为空
    if (url.isEmpty) {
      return errorWidget ?? error(width: width, height: height);
    }
    
    return border == 0
          ? CachedNetworkImage(
              imageUrl: url,
              width: width,
              height: height,
              fit: fit,
              // memCacheWidth: _calculateCacheWidth(width),
              // memCacheHeight: _calculateCacheHeight(height),
              // placeholder: (context,index){
              //   return Center(
              //     child: CircularProgressIndicator(
              //       strokeWidth: 1.5,
              //     ),
              //   );
              // },
              progressIndicatorBuilder: (context, url, progress) => Container(
                width: 10.0,
                height: 10.0,
                child: loadProgress
                    ? Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          value: progress.progress ?? 0,
                        ),
                      )
                    : null,
              ),
              errorWidget: (_, url, er) =>
                  errorWidget ?? error(width: width, height: height),
            )
          : Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(border)),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                imageUrl: url,
                width: width,
                height: height,
                fit: fit,
                // memCacheWidth: _calculateCacheWidth(width),
                // memCacheHeight: _calculateCacheHeight(height),
                // placeholder: placeholder,
                progressIndicatorBuilder: (context, url, progress) => Container(
                  width: 10.0,
                  height: 10.0,
                  child: loadProgress
                      ? Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            value: progress.progress ?? 0,
                          ),
                        )
                      : null,
                ),
                errorWidget: (_, url, er) =>
                    errorWidget ?? error(width: width, height: height),
              ),
            );
  }
}
