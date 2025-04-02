#!/bin/sh

#  ci_post_clone.sh
#  Interface
#
#  Created by 김도형 on 2023/09/06.
#

# 매크로 유효성 검사 비활성화
defaults write com.apple.dt.Xcode IDESkipMacroFingerprintValidation -bool YES
defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidation -bool YES

cd "/Volumes/workspace/repository/yappu-world-ios" || exit 1
# base64 디코딩 후 파일 생성
echo "$GOOGLESERVICE_BASE64" | base64 --decode > GoogleService-Info.plist
# 파일 생성 확인
if [ -f "GoogleService-Info.plist" ]; then
    echo "GoogleService-Info.plist successfully created."
else
    echo "Failed to create GoogleService-Info.plist" >&2
    exit 1
fi
