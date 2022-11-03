#!/bin/bash
#
# 通过shell脚本来实现将本地app文件通过API上传到蒲公英
# https://www.pgyer.com/doc/view/api#fastUploadApp
##
# 参数说明：
# $1: 蒲公英api_key
# $2: 要上传的文件路径(ipa/apk)
#

printHelp() {
    echo "Usage: $0 api_key file"
    echo "Example: $0 <your_api_key> <your_apk_or_ipa_path>"
}

uploadPgyer() {
    api_key=$1
    file=$2
    # check api_key exists
    if [ -z "$api_key" ]; then
        echo "api_key is empty"
        printHelp
        exit 1
    fi

    # check file exists
    if [ ! -f "$file" ]; then
        echo "file not exists"
        printHelp
        exit 1
    fi

    if [[ $file =~ ipa$ ]]; then
        app_type="ios"
    elif [[ $file =~ apk$ ]]; then
        app_type="android"
    else
        echo "file type not support"
        printHelp
        exit 1
    fi

    # ---------------------------------------------------------------
    # functions
    # ---------------------------------------------------------------

    execCommand() {
        echomsg "$@"
        result=$(eval $@)

    }

    # ---------------------------------------------------------------
    # 获取上传凭证
    # ---------------------------------------------------------------

    echomsg "获取凭证"

    execCommand "curl -s -F '_api_key=${api_key}' -F 'buildType=${app_type}' http://www.pgyer.com/apiv2/app/getCOSToken"

    [[ "${result}" =~ \"endpoint\":\"([\:\_\.\/\\A-Za-z0-9\-]+)\" ]] && endpoint=$(echo ${BASH_REMATCH[1]} | sed 's!\\\/!/!g')
    [[ "${result}" =~ \"key\":\"([\.a-z0-9]+)\" ]] && key=$(echo ${BASH_REMATCH[1]})
    [[ "${result}" =~ \"signature\":\"([\=\&\_\;A-Za-z0-9\-]+)\" ]] && signature=$(echo ${BASH_REMATCH[1]})
    [[ "${result}" =~ \"x-cos-security-token\":\"([\_A-Za-z0-9\-]+)\" ]] && x_cos_security_token=$(echo ${BASH_REMATCH[1]})

    if [ -z "$key" ] || [ -z "$signature" ] || [ -z "$x_cos_security_token" ] || [ -z "$endpoint" ]; then
        echomsg "get upload token failed"
        exit 1
    fi

    # ---------------------------------------------------------------
    # 上传文件
    # ---------------------------------------------------------------

    echomsg "上传文件"

    execCommand "curl -s -o /dev/null -w '%{http_code}' --form-string 'key=${key}' --form-string 'signature=${signature}' --form-string 'x-cos-security-token=${x_cos_security_token}' -F 'file=@${file}' ${endpoint}"
    if [ "$result" -ne 204 ]; then
        echomsg "Upload failed"
        exit 1
    fi

    # ---------------------------------------------------------------
    # 检查结果
    # ---------------------------------------------------------------

    echomsg "检查结果"

    for i in {1..60}; do
        execCommand "curl -s http://www.pgyer.com/apiv2/app/buildInfo?_api_key=${api_key}\&buildKey=${key}"
        [[ "${result}" =~ \"code\":([0-9]+) ]] && code=$(echo ${BASH_REMATCH[1]})
        [[ "${result}" =~ \"buildQRCodeURL\":\"([\:\_\.\/\\A-Za-z0-9\-]+)\" ]] && buildQRCodeURL=$(echo ${BASH_REMATCH[1]} | sed 's!\\\/!/!g')
        if [ "$code" -eq 0 ]; then
            echo "$result"
            if [ "$app_type" == "ios" ]; then
                pgyer_ios_code_url=$buildQRCodeURL
                echo "$pgyer_ios_code_url"
            else
                pgyer_android_code_url=$buildQRCodeURL
                echo "$pgyer_android_code_url"
            fi
            open "$buildQRCodeURL"
            echomsg "蒲公英上传成功"
            break
        else
            sleep 1
        fi
    done
}
