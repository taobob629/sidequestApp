#!/bin/bash
###
# @Descripttion:
# @version:
# @Author: TT
# @Date: 2022-08-31 09:48:48
# @LastEditors: TT
# @LastEditTime: 2022-09-26 11:04:39
###

# shellcheck disable=SC1091
# shellcheck disable=SC2154
source ./pack_tool.sh
source ./pack_ipa.sh
source ./pack_apk.sh
source ./pack_config.sh
source ./pack_clear_create_tool.sh
# 为了可以执行 sh 文件所有的函数
chmod a+x pack_clear_create_tool.sh pack_tool.sh

echomsg "开始配置参数"
param_count=$#
if [ $param_count == 0 ]; then
    normalTip
else
    for i in "$@"; do
        if [[ $i == "-h" ]]; then
            echoHelp
            exit

        else
            funWithParam "$i"
        fi
    done
fi

configbuildType
echomsg "参数配置完成"
# 最终打包配置结果显示
echoTip

# 清楚缓存
cleanFun
# 构建打包需要配置项
createLib
# 打包
if [ "$pack_os" == 0 ]; then
    buidApk
    buidIos
elif [ "$pack_os" == 1 ]; then
    buidApk
else
    buidIos
fi
