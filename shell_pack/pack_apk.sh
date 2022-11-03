#!/bin/bash
###
# @Descripttion:
# @version:
# @Author: TT
# @Date: 2022-08-31 09:48:41
# @LastEditors: TT
# @LastEditTime: 2022-09-26 11:07:43
###

# shellcheck disable=SC1091
# shellcheck disable=SC2154
source ./pack_config.sh
source ./pgyer_upload.sh

chmod a+x pgyer_upload.sh

flutterBuild() {
  echo "$build_type"
  echomsg "$upload_type"
  flutter build apk --no-shrink --dart-define=CHANNEL="$1" --dart-define=DEBUG="$build_type" --"$build_type"
  if [[ $project_build_type == 1 ]]; then
    cp -R "$flutter_release_apk_path"*.apk "$export_apk_release_path"
  else
    cp -R "$flutter_debug_apk_path"*.apk "$export_apk_debug_path"
  fi

}

# 构建渠道包
apkBuild() {
  echomsg "开始打包"
  if [[ $apk_chanhels_length == 0 || $upload_type == 2 ]]; then
    flutterBuild "Normal"
  elif [[ $pack_apk_channel == 0 && $apk_chanhels_length != 0 ]]; then
    echomsg "开始构建: 全部渠道包"
    for ((i = 0; i < "$apk_chanhels_length"; i++)); do
      echomsg "正在构建: ${apk_channels[$i]}渠道包"
      flutterBuild apk_channels["$i"]
    done
  else
    flutterBuild apk_channels["$pack_apk_channe"]
  fi
}

# 打包apk
buidApk() {
  mycmd=apkBuild
  echo "$mycmd"

  if $mycmd; then
    if [ "$project_build_type" == 1 ]; then
      expord_path="$export_apk_release_path"
    else
      expord_path="$export_apk_debug_path"
    fi
    echomsg "$upload_type"
    if [ "$upload_type" == 2 ]; then
      # echo 开始上传蒲公英
      for f in "$expord_path"*.apk; do
        [[ -e "$f" ]] || break
        echo "$f"
        uploadPgyer "$api_key" "$f"
      done
    else
      echomsg "apk 打包成功"
      open "$export_apk_release_path"
    fi
  else
    echomsg "apk 打包失败"
  fi
}
