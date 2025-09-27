#!/bin/bash

# App Store 앱 설치 스크립트
# mas (Mac App Store CLI)를 사용한 자동화

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APPS_FILE="$DOTFILES_DIR/macos/appstore-apps.txt"

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

# mas 설치 확인 및 설치
check_and_install_mas() {
    if ! command -v mas &> /dev/null; then
        log_warning "mas가 설치되어 있지 않습니다."

        if command -v brew &> /dev/null; then
            log_info "Homebrew를 통해 mas를 설치합니다..."
            brew install mas
            log_success "mas 설치 완료!"
        else
            log_error "Homebrew가 설치되어 있지 않습니다. 먼저 Homebrew를 설치해주세요."
            echo "설치 방법: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
            exit 1
        fi
    else
        log_success "mas가 이미 설치되어 있습니다."
    fi
}

# App Store 로그인 확인
check_app_store_login() {
    if ! mas account &> /dev/null; then
        log_error "App Store에 로그인되어 있지 않습니다."
        echo "App Store 앱을 열고 로그인한 후 다시 시도해주세요."
        exit 1
    else
        local account=$(mas account)
        log_success "App Store 계정: $account"
    fi
}

# 현재 설치된 앱 목록 가져오기
get_installed_apps() {
    mas list | awk '{print $1}'
}

# 앱 설치 함수
install_app() {
    local app_id=$1
    local app_name=$2

    # 이미 설치되어 있는지 확인
    if get_installed_apps | grep -q "^${app_id}$"; then
        log_info "이미 설치됨: $app_name ($app_id)"
    else
        log_info "설치 중: $app_name ($app_id)..."
        if mas install "$app_id"; then
            log_success "설치 완료: $app_name"
        else
            log_warning "설치 실패: $app_name - 수동으로 설치가 필요할 수 있습니다."
        fi
    fi
}

# 동기화 상태 확인 함수
sync_status() {
    echo ""
    echo "================================================"
    echo "         App Store 앱 동기화 상태 확인          "
    echo "================================================"
    echo ""

    # 설치된 앱 ID 목록
    local installed_ids=$(mas list | awk '{print $1}')

    # 파일에 있는 앱 확인
    echo -e "${BLUE}[목록 파일의 앱]${NC}"
    local missing_apps=()

    while IFS= read -r line; do
        # 빈 줄과 주석 무시
        if [[ -z "$line" ]] || [[ "$line" =~ ^# ]]; then
            continue
        fi

        local app_id=$(echo "$line" | awk '{print $1}')
        local app_name=$(echo "$line" | sed "s/^[0-9]*[[:space:]]*\([^#]*\).*/\1/" | sed 's/[[:space:]]*$//')

        if echo "$installed_ids" | grep -q "^$app_id$"; then
            echo -e "  ${GREEN}✓${NC} $app_name ($app_id)"
        else
            echo -e "  ${YELLOW}✗${NC} $app_name ($app_id) - 미설치"
            missing_apps+=("$app_id:$app_name")
        fi
    done < "$APPS_FILE"

    echo ""
    echo -e "${BLUE}[설치되었지만 목록에 없는 앱]${NC}"
    local found_unlisted=false
    while IFS= read -r id; do
        if ! grep -q "^$id" "$APPS_FILE" 2>/dev/null; then
            local name=$(mas list | grep "^$id" | sed "s/^[0-9]*[[:space:]]*//" | sed "s/[[:space:]]*(.*)$//")
            echo -e "  ${YELLOW}+${NC} $name ($id)"
            found_unlisted=true
        fi
    done <<< "$installed_ids"

    if [ "$found_unlisted" = false ]; then
        echo -e "  ${GREEN}없음${NC}"
    fi

    # 미설치 앱이 있으면 설치 여부 확인
    if [ ${#missing_apps[@]} -gt 0 ]; then
        echo ""
        echo -e "${YELLOW}미설치 앱이 ${#missing_apps[@]}개 있습니다.${NC}"
        read -p "지금 설치하시겠습니까? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            return 0  # 설치 진행
        else
            exit 0
        fi
    else
        echo ""
        log_success "모든 앱이 동기화되어 있습니다!"
        exit 0
    fi
}

# 메인 함수
main() {
    # 명령줄 인자 처리
    case "${1:-install}" in
        sync|status|--sync|-s)
            # mas 설치 확인
            check_and_install_mas
            # App Store 로그인 확인
            check_app_store_login
            # 앱 리스트 파일 확인
            if [ ! -f "$APPS_FILE" ]; then
                log_error "앱 리스트 파일을 찾을 수 없습니다: $APPS_FILE"
                exit 1
            fi
            # 동기화 상태만 확인
            sync_status
            ;;
        install|--install|-i|"")
            # 기본 설치 모드
            ;;
        help|--help|-h)
            echo "사용법: $0 [옵션]"
            echo ""
            echo "옵션:"
            echo "  install  - App Store 앱 설치 (기본값)"
            echo "  sync     - 동기화 상태 확인"
            echo "  help     - 이 도움말 표시"
            echo ""
            echo "예시:"
            echo "  $0           # 앱 설치"
            echo "  $0 sync      # 동기화 상태 확인"
            exit 0
            ;;
        *)
            log_error "알 수 없는 옵션: $1"
            echo "도움말: $0 help"
            exit 1
            ;;
    esac

    echo "================================================"
    echo "       Mac App Store 앱 자동 설치 스크립트       "
    echo "================================================"
    echo ""

    # 1. mas 설치 확인
    check_and_install_mas

    # 2. App Store 로그인 확인
    check_app_store_login

    # 3. 앱 리스트 파일 확인
    if [ ! -f "$APPS_FILE" ]; then
        log_error "앱 리스트 파일을 찾을 수 없습니다: $APPS_FILE"
        exit 1
    fi

    # 4. 동기화 상태 확인 (설치 전에 보여주기)
    sync_status

    # 5. 앱 설치
    echo ""
    log_info "앱 설치를 시작합니다..."
    echo ""

    while IFS= read -r line; do
        # 빈 줄과 주석 무시
        if [[ -z "$line" ]] || [[ "$line" =~ ^# ]]; then
            continue
        fi

        # APP_ID와 APP_NAME 추출
        app_id=$(echo "$line" | awk '{print $1}')
        app_name=$(echo "$line" | sed "s/^[0-9]*[[:space:]]*\([^#]*\).*/\1/" | sed 's/[[:space:]]*$//')

        if [[ -n "$app_id" ]]; then
            install_app "$app_id" "$app_name"
        fi
    done < "$APPS_FILE"

    echo ""
    echo "================================================"
    log_success "모든 작업이 완료되었습니다!"
    echo ""

    # 설치된 앱 목록 표시
    log_info "현재 설치된 App Store 앱 목록:"
    mas list
}

# 스크립트 실행
main "$@"