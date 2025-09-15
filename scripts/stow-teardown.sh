#!/usr/bin/env bash
set -euo pipefail

# dotfiles 저장소 루트 디렉토리
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${HOME}"

echo "🗑️  GNU Stow 기반 dotfiles 설정을 해제합니다..."

cd "${REPO_ROOT}"

# 사용 가능한 패키지들
PACKAGES=()
for dir in */; do
    if [ -d "$dir" ] && [ "$dir" != "scripts/" ] && [ "$dir" != ".git/" ]; then
        PACKAGES+=($(basename "$dir"))
    fi
done

echo "📦 발견된 패키지들: ${PACKAGES[*]}"

# 각 패키지에 대해 stow 해제 실행
for package in "${PACKAGES[@]}"; do
    echo "🔓 $package 패키지 해제 중..."

    if stow -D "$package" --target="$TARGET_DIR" --verbose=2; then
        echo "✅ $package 해제 완료"
    else
        echo "⚠️  $package 해제 중 오류 발생 (심볼릭 링크가 없을 수 있습니다)"
    fi
done

echo ""
echo "🎉 dotfiles 해제가 완료되었습니다!"
echo "해제된 패키지: ${PACKAGES[*]}"