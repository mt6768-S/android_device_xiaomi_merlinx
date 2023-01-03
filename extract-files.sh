#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

function blob_fixup() {
    case "${1}" in
        vendor/lib*/libutinterface_custom_md.so)
            [ "$2" = "" ] && return 0
            "$PATCHELF" --add-needed "libutinterface_md.so" "$2"
            ;;
        vendor/lib64/libmi_watermark.so)
            [ "$2" = "" ] && return 0
            "$PATCHELF" --add-needed "libpiex_shim.so" "$2"
            ;;
        *)
            return 1
            ;;
    esac

    return 0
}

function blob_fixup_dry() {
    blob_fixup "$1" ""
}

# If we're being sourced by the common script that we called,
# stop right here. No need to go down the rabbit hole.
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    return
fi

set -e


export DEVICE=merlinx
export DEVICE_COMMON=mt6768-common
export VENDOR=xiaomi

"./../../${VENDOR}/${DEVICE_COMMON}/extract-files.sh" "$@"
