#!/bin/bash
###
# @Descripttion:
# @version:
# @Author: TT
# @Date: 2022-08-31 11:35:32
# @LastEditors: TT
# @LastEditTime: 2022-10-06 15:16:40
###

# shellcheck disable=SC2034
# shellcheck disable=SC2046

# ======================== 命令参数 ======================== #

# 打包系统 0 全部 1 apk 2 ipa
pack_os=0
# 上传类型 1 商店 2 蒲公英
upload_type=1
# 打包环境 1 Releas 2 Deubg
project_build_type=1
# 编译环境
build_type="release"
# 是否清理缓存 1 清理 0不清理
project_is_clear=1
# 0 全部市场 具体 123 是你自己修改apk_channels 对应的渠道
pack_apk_channel=0

# ======================== 工程配置项 ======================== #

# 工程相对路径
project_path=$(dirname $(pwd))

# ======================== Android ======================== #

# Flutter  android release 打包生成的路径
flutter_release_apk_path=$project_path/build/app/outputs/apk/release/
# Flutter  android debug 打包生成的路径
flutter_debug_apk_path=$project_path/build/app/outputs/apk/debug/
# 安卓打包根文件
export_android_path=$project_path/export/apk
# apk 最终Release存放的地方
export_apk_release_path=$export_android_path/release/
#  apk 最终Debug存放的地方
export_apk_debug_path=$export_android_path/debug/
# 安卓渠道HUAWEI VIVO YYB
apk_channels=(HUAWEI)
# 安卓渠道 个数
apk_chanhels_length=0

# ======================== IOS ======================== #

# # 工程名字
# project_name=Runner
# # scheme 名字
# project_scheme=$project_name
# # xcworkspace路径
# project_workspace_path=$project_path/ios/$project_name.xcworkspace
# # xcarchive 名字
# xcarchive_name=${project_name}.xcarchive
# # ipa 名字
# ipa_name=$project_name
# # ios 团队ID
# ios_teamID=""
# # 商店账号
# xcrun_u=""
# # 账号专属密码
# xcrun_p=""
# # 导出iOS文件路径
# export_ios_path=$project_path/export/ios
# # 导出 xcarchive路径
# export_xcarchive_path=$export_ios_path/xcarchive/
# # 导出ipa存放文件路径
# export_ipa_path=$export_ios_path/ipa/
# # ExportOptions.plist app-store路径
# export_options_plist_store=$project_path/shell_pack/ExportOptions.plist
# # ExportOptions.plist app-hoc路径
# export_options_plist_hoc=$project_path/shell_pack/ExportOptions_hoc.plist
# # ExportOptions.plist app-dev路径
# export_options_plist_dev=$project_path/shell_pack/ExportOptions_dev.plist
# # 最后选择的环境
# export_options_plist=$export_options_plist_store

# ======================== 蒲公英配置信息 ======================== #

# 蒲公英api_key
api_key=""
# 蒲公英iOS二维码地址
pgyer_ios_code_url=""
# 蒲公英安卓二维码地址
pgyer_android_code_url=""
