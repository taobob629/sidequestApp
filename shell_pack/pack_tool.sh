#!/bin/bash
###
# @Descripttion:
# @version:
# @Author: TT
# @Date: 2022-08-31 17:21:15
# @LastEditors: TT
# @LastEditTime: 2022-09-14 17:47:58
###

# shellcheck disable=SC1091
# shellcheck disable=SC2034
# shellcheck disable=SC2154
# shellcheck disable=SC2206
source ./pack_config.sh

# 统一输出内容
echomsg() {
    echo "================= $1 ================="
}

# 配置打包环境
configbuildType() {
    if [[ $project_build_type == 1 ]]; then
        build_type="release"
    else
        build_type="debug"
    fi
}

# 解析参数
funWithParam() {
    # 字符串分割
    array=(${1//:/ })
    length=${#array[@]}
    if [ "$length" == 2 ]; then
        p=${array[1]}
        if [[ $1 =~ "-o:" ]]; then
            if [ "$p" -gt 2 ] || [ "$p" -lt 0 ]; then
                echomsg "错误!-o:只能输入[0 全部,1 apk,2 ipa]"
                exit 0
            else
                pack_os=$p
            fi
        elif [[ $1 =~ "-u:" ]]; then
            if [[ $p -gt 2 || $p -lt 1 ]]; then
                echomsg "错误!-u:只能输入[1 商店 , 2 蒲公英]"
                exit 0
            else
                upload_type=$p
            fi
        elif [[ $1 =~ "-c:" ]]; then
            if [[ $p -gt 1 || $p -lt 0 ]]; then
                echomsg "错误!-c:只能输入[1 清 ,0 不]"
                exit 0
            else
                project_is_clear=$p
            fi
        elif [[ $1 =~ "-b:" ]]; then
            if [[ $p -gt 2 || $p -lt 1 ]]; then
                echomsg "错误!-b:只能输入[1 Release , 2 Debug]"
                exit 0
            else
                project_build_type=$p
            fi
        elif [[ $1 =~ "-a:" ]]; then
            al=$$apk_chanhels_length
            if [[ $p -gt $al || $p -lt 0 ]]; then
                configchannelTip "错误!-a:只能输入[0: All"
                exit 0
            else
                pack_apk_channel=$p
            fi
        fi
    else
        normalTip
    fi

}

configchannelTip() {
    tips=$1
    c_length=${#apk_channels[@]}
    if [[ $c_length == 0 ]]; then
        tips="${tips}]"
    else
        for ((i = 0; i < $((c_length - 1)); i++)); do
            if (("$i" < $((c_length - 2)))); then
                tips="${tips}$((i + 1)): ${apk_channels[i]}  "
            else
                tips="${tips} $((i + 1)): ${apk_channels[i]}]"
            fi
        done
    fi
    echo "$tips$2"
}

# 默认提示语
echoTip() {
    echo "系统类型[0 全部,1 apk,2 ipa]:  $pack_os"
    echo "上传类型[1 商店 2 蒲公英]: $upload_type "
    echo "打包环境[1 Release, 2 Debug]: $project_build_type"
    echo "清理缓存[1 清 ,0 不]:  ${project_is_clear}"
    configchannelTip "安卓渠道[0: All " " $pack_apk_channel"
}
# 帮助提示语
echoHelp() {
    echo "-h 获取帮助"
    echo "-o:0 系统类型[0 全部,1 apk,2 ipa],默认: 0 "
    echo '-u:1 上传类型[1 商店 , 2 蒲公英],默认: 1 '
    echo '-b:1 打包环境[1 Release, 2 Debug],默认: 1'
    echo '-c:1 清理本地缓存[1 清 ,0 不] 默认: 1'
    configchannelTip "-a:0 安卓渠道[0: All " ""
}

# 不填参数默认提示语
normalTip() {
    echo '由于你没有填写参数.将会按默认处理'
}
