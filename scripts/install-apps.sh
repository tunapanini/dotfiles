#!/bin/bash

# 맥 앱 설치 스크립트 (brew cask + mas 하이브리드 방식)
# brew cask로 설치 가능한 앱은 cask로, 불가능한 앱은 mas로 설치

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 로그 함수
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Homebrew 설치 확인
check_homebrew() {
    if ! command -v brew &> /dev/null; then
        log_error "Homebrew가 설치되어 있지 않습니다."
        echo "설치 방법: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi
    log_success "Homebrew가 설치되어 있습니다."
}

# mas 설치 확인
check_mas() {
    if ! command -v mas &> /dev/null; then
        log_info "mas를 설치합니다..."
        brew install mas
        log_success "mas 설치 완료!"
    else
        log_success "mas가 이미 설치되어 있습니다."
    fi
}

# Cask 앱 설치
install_cask_app() {
    local app_name=$1
    local app_display_name=$2
    local app_path=$3  # 앱 설치 경로 (옵션)

    # 먼저 brew list로 확인
    if brew list --cask "$app_name" &> /dev/null; then
        log_info "이미 설치됨: $app_display_name (Homebrew)"
        return
    fi

    # 앱 경로가 지정되었고 이미 존재하면 설치됨으로 처리
    if [[ -n "$app_path" ]] && [[ -d "$app_path" ]]; then
        log_info "이미 설치됨: $app_display_name (수동 설치)"
        return
    fi

    # 설치 시도
    log_info "설치 중: $app_display_name..."
    if brew install --cask "$app_name" 2>/dev/null; then
        log_success "설치 완료: $app_display_name"
    else
        log_warning "설치 실패: $app_display_name"
    fi
}

# MAS 앱 설치
install_mas_app() {
    local app_id=$1
    local app_name=$2

    # macOS Sequoia 이상에서는 새 앱 설치 제한
    if [[ $(sw_vers -productVersion | cut -d. -f1) -ge 15 ]]; then
        log_warning "macOS Sequoia에서는 mas로 새 앱 설치가 제한됩니다."
        log_info "$app_name ($app_id)는 App Store에서 직접 설치해주세요."
        return
    fi

    if mas list | grep -q "^$app_id"; then
        log_info "이미 설치됨: $app_name"
    else
        log_info "설치 중: $app_name..."
        if mas install "$app_id"; then
            log_success "설치 완료: $app_name"
        else
            log_warning "설치 실패: $app_name - App Store에서 직접 설치 필요"
        fi
    fi
}

# 설치된 앱 확인
check_installed_apps() {
    echo ""
    echo "================================================"
    echo "              설치된 앱 확인"
    echo "================================================"
    echo ""

    echo -e "${BLUE}[Brew Cask 앱]${NC}"
    if brew list --cask 2>/dev/null | head -5; then
        local cask_count=$(brew list --cask 2>/dev/null | wc -l)
        echo "... 총 $cask_count개"
    else
        echo "설치된 Cask 앱 없음"
    fi

    echo ""
    echo -e "${BLUE}[App Store 앱]${NC}"
    if command -v mas &> /dev/null && mas list 2>/dev/null | head -5; then
        local mas_count=$(mas list 2>/dev/null | wc -l)
        echo "... 총 $mas_count개"
    else
        echo "설치된 App Store 앱 없음"
    fi
}

# 메인 함수
main() {
    echo "================================================"
    echo "          맥 앱 자동 설치 스크립트"
    echo "================================================"
    echo ""

    # Homebrew 확인
    check_homebrew

    # mas 설치 (App Store 전용 앱용)
    check_mas

    echo ""
    echo "================================================"
    echo "             Brew Cask 앱 설치"
    echo "================================================"
    echo ""

    # Brew Cask로 설치 가능한 앱들
    install_cask_app "the-unarchiver" "The Unarchiver" "/Applications/The Unarchiver.app"
    install_cask_app "1password-cli" "1Password CLI"
    install_cask_app "android-commandlinetools" "Android Command Line Tools"
    install_cask_app "stravu-crystal" "Stravu Crystal"

    # 개발 도구 (옵션)
    # install_cask_app "visual-studio-code" "Visual Studio Code"
    # install_cask_app "docker" "Docker Desktop"
    # install_cask_app "iterm2" "iTerm2"

    echo ""
    echo "================================================"
    echo "      App Store 전용 앱 확인"
    echo "================================================"
    echo ""

    # App Store 앱 목록 정의 (ID:NAME:DESCRIPTION 형식)
    local appstore_apps=(
        "937984704:Amphetamine:Mac 절전 방지"
        "640199958:Developer:Apple Developer 앱"
        "497799835:Xcode:Apple IDE"
        "869223134:카카오톡:메신저"
        "1661733229:LocalSend:로컬 파일 전송"
    )

    # 현재 설치된 App Store 앱 확인
    local installed_mas_ids=""
    if command -v mas &> /dev/null; then
        installed_mas_ids=$(mas list 2>/dev/null | awk '{print $1}')
    fi

    # 설치 상태 확인 및 표시
    local missing_apps=()

    echo -e "${BLUE}[App Store 앱 상태]${NC}"
    for app_entry in "${appstore_apps[@]}"; do
        IFS=':' read -r app_id app_name app_desc <<< "$app_entry"

        if echo "$installed_mas_ids" | grep -q "^$app_id$"; then
            echo -e "  ${GREEN}✓${NC} $app_name - $app_desc"
        else
            echo -e "  ${YELLOW}✗${NC} $app_name - $app_desc ${YELLOW}(미설치)${NC}"
            missing_apps+=("$app_id:$app_name")
        fi
    done

    # 미설치 앱이 있으면 설치 안내
    if [ ${#missing_apps[@]} -gt 0 ]; then
        echo ""
        log_warning "macOS Sequoia에서는 App Store에서 직접 설치가 필요합니다."
        echo ""
        echo -e "${BLUE}[설치 방법]${NC}"
        echo "1. App Store 열기: open -a 'App Store'"
        echo "2. 앱 검색 후 설치"
        echo ""
        echo -e "${BLUE}[App Store 직접 열기 링크]${NC}"

        for app_info in "${missing_apps[@]}"; do
            IFS=':' read -r app_id app_name <<< "$app_info"
            echo "  • $app_name: open 'macappstore://apps.apple.com/app/id$app_id'"
        done

        echo ""
        read -p "App Store를 열까요? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            open -a 'App Store'
        fi
    else
        log_success "모든 App Store 앱이 설치되어 있습니다!"
    fi

    # 설치된 앱 확인
    check_installed_apps

    echo ""
    echo "================================================"
    log_success "설치 프로세스가 완료되었습니다!"
    echo ""
    echo "참고:"
    echo "  • Brew Cask 앱 검색: brew search --cask <앱이름>"
    echo "  • App Store 앱 검색: mas search <앱이름> (Sequoia 이전)"
    echo "  • 설치된 Cask 앱 확인: brew list --cask"
    echo "  • 설치된 App Store 앱 확인: mas list"
    echo "================================================"
}

# 스크립트 실행
main "$@"