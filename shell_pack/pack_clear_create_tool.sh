#!/bin/bash

# shellcheck disable=SC1091
# shellcheck disable=SC2154
source ./pack_config.sh
chmod a+x pack_config.sh
# =========================== 清除模块 =========================== #

# 清理iOS文件
clearIosLib() {
    echomsg "清理IOS文件夹"
    if [ -d "${export_ios_path}" ]; then
        rm -rf "${export_ios_path}"
    fi

    echomsg "清理IOS文件夹成功"
}

# 清理iOS Build缓存
clearIosBuild() {
    if [ -d "${project_path}"/ios ]; then
        echomsg "清理XCODE"
        xcodebuild clean -workspace "${project_workspace_path}" -scheme "${project_scheme}" -configuration $build_type -quiet || exit
    fi
}
# 清理 Android文件
clearAndroidLib() {
    echomsg "清理Android文件"
    if [[ $project_build_type == 1 ]]; then
        if [ -d "${export_apk_release_path}" ]; then
            rm -rf "${export_apk_release_path}"
        fi

    else
        if [ -d "${export_apk_debug_path}" ]; then
            rm -rf "${export_apk_debug_path}"
        fi
    fi
}

# 清理 Flutter缓存
clearFlutter() {
    if [ -e "${project_path}"/pubspec.yaml ]; then
        echo '清理FLUTTER'
        flutter clean
    fi
}
# 清理iOS
clearIos() {
    clearIosLib
    clearIosBuild
}

# 清理Android
clearAndroid() {
    clearAndroidLib
}

# 清理工程
cleanFun() {
    echomsg "$project_is_clear"
    if [ "$project_is_clear" == 1 ]; then
        if [ "$pack_os" == 0 ]; then
            clearIos
            clearAndroid
        elif [ "$pack_os" == 1 ]; then
            clearAndroid
        else
            clearIos
        fi
        clearFlutter
        echo "清理END"
    fi
}

# =========================== 构建模块 =========================== #

# 构建Android文件夹
createAndroidLib() {
    echomsg "创建Android文件中"
    if [[ $project_build_type == 1 ]]; then
        if [ ! -d "${export_apk_release_path}" ]; then
            mkdir -p "${export_apk_release_path}"
        fi
    else
        if [ ! -d "${export_apk_debug_path}" ]; then
            mkdir -p "${export_apk_debug_path}"
        fi
    fi
}

# 构建iOS文件夹
createIosLib() {
    echomsg "创建IOS文件中"
    if [ ! -d "${export_xcarchive_path}" ]; then
        mkdir -p "${export_xcarchive_path}"
    fi
    if [ ! -d "${export_ipa_path}" ]; then
        mkdir -p "${export_ipa_path}"
    fi
    echo "$export_xcarchive_path"
}

createLib() {
    if [ "$pack_os" == 0 ]; then
        createIosLib
        createAndroidLib
    elif [ "$pack_os" == 1 ]; then
        createAndroidLib
    else
        createIosLib
    fi
    echomsg "文件创建完成"
}
