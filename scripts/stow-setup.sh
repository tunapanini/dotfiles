#!/usr/bin/env bash
set -euo pipefail

# dotfiles 저장소 루트 디렉토리
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${HOME}"

echo "🚀 GNU Stow 기반 dotfiles 설정을 시작합니다..."

# GNU Stow 설치 확인
if ! command -v stow &> /dev/null; then
    echo "❌ GNU Stow가 설치되지 않았습니다."
    echo "설치 방법:"
    echo "  Ubuntu/Debian: sudo apt install stow"
    echo "  macOS: brew install stow"
    exit 1
fi

cd "${REPO_ROOT}"

# 사용 가능한 패키지들
PACKAGES=()
for dir in */; do
    if [ -d "$dir" ] && [ "$dir" != "scripts/" ] && [ "$dir" != ".git/" ]; then
        PACKAGES+=($(basename "$dir"))
    fi
done

echo "📦 발견된 패키지들: ${PACKAGES[*]}"

# 각 패키지에 대해 stow 실행
for package in "${PACKAGES[@]}"; do
    echo "🔗 $package 패키지 설정 중..."

    if stow "$package" --target="$TARGET_DIR" --verbose=2; then
        echo "✅ $package 설정 완료"
    else
        echo "⚠️  $package 설정 중 오류 발생 (이미 존재하는 파일이 있을 수 있습니다)"
        echo "   백업 후 다시 시도해보세요: mv ~/.config ~/.config.backup"
    fi
done

echo ""
echo "🎉 dotfiles 설정이 완료되었습니다!"
echo "설정된 패키지: ${PACKAGES[*]}"