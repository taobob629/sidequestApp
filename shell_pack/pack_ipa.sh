#!/bin/bash
###
# @Descripttion:
# @version:
# @Author: TT
# @Date: 2022-08-31 09:48:31
# @LastEditors: TT
# @LastEditTime: 2022-10-23 17:29:58
###

# shellcheck disable=SC1091
# shellcheck disable=SC2154
source ./pack_tool.sh
source ./pgyer_upload.sh

chmod a+x pgyer_upload.sh

buidIos() {
    echomsg "修改.plist"

    #CPU架构
    # cpu_architecture=$(uname -m)
    # 获取对应版本的export_options_plist文件
    if [[ $upload_type == 1 ]]; then
        export_options_plist=$export_options_plist_store
        build_type="release"
        configuration="Release"
    elif [[ $project_build_type == 1 ]]; then
        export_options_plist=$export_options_plist_hoc
        build_type="release"
        configuration="Release"
    else
        build_type="debug"
        configuration="Debug"
        export_options_plist=$export_options_plist_dev
    fi
    echomsg "选择plist文件路径${export_options_plist}"
    if [ -e "${project_path}"/pubspec.yaml ]; then
        echomsg "编译FLUTTER"
        flutter build ios --$build_type
    fi
    echomsg "编译IOS:${build_type}"
    generic='generic/platform=iOS'
    echomsg "开始archive"
    xcodebuild archive \
        -workspace "${project_workspace_path}" \
        -scheme "$project_scheme" \
        -configuration $configuration \
        -archivePath "${export_xcarchive_path}${xcarchive_name}" \
        -destination "$generic" -quiet || exit

    echomsg "archive成功"
    echomsg "读取APP信息"
    info_plist="$export_xcarchive_path$xcarchive_name/Products/Applications/Runner.app/Info.plist"
    ipa_name=$(/usr/libexec/PlistBuddy -c "Print CFBundleName" "$info_plist")
    run_plist="$export_xcarchive_path$xcarchive_name/Info.plist"
    ipa_teamID=$(/usr/libexec/PlistBuddy -c "Print ApplicationProperties:Team" "$run_plist")
    echo "app名字:$ipa_name"
    echo "teamID:$ipa_teamID"

    # 通过 plutil 工具进行对 plist文件修改
    plutil -replace teamID -string "$ipa_teamID" "$export_options_plist"
    echomsg "开始导出ipa"
    # 导出上传商店的ipa
    xcodebuild \
        -exportArchive -archivePath "$export_xcarchive_path$xcarchive_name" \
        -exportPath "${export_ipa_path}" \
        -exportOptionsPlist "${export_options_plist}" \
        -destination "$generic" \
        -allowProvisioningUpdates -quiet || exit

    if [ -e "${export_ipa_path}" ]; then
        echomsg "ipa导出成功"

        if [ "$upload_type" == 1 ]; then
            echomsg "开始验证app"
            validate=$(xcrun altool \
                --validate-app \
                -f "$export_ipa_path/$ipa_name.ipa" \
                -u "$xcrun_u" \
                -p "$xcrun_p" \
                -t ios)
            if $validate; then
                echomsg "开始上传app到商店 "
                uploadapp=$(xcrun altool \
                    --upload-app \
                    -f "$export_ipa_path/$ipa_name.ipa" \
                    -u "$xcrun_u" \
                    -p "$xcrun_p" \
                    -t ios)
                if $uploadapp; then
                    echomsg "app已上传到商店 "
                else
                    echomsg "app上传到商店失败 "
                fi
            else
                echomsg "app验证失败"
            fi
        else
            echomsg "开始上传ipa到蒲公英"
            uploadPgyer "$api_key" "$export_ipa_path/$ipa_name".ipa
        fi
    else
        echomsg "ipa包导出失败"
    fi
}
