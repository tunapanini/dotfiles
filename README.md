# Dotfiles 관리 시스템

GNU Stow + 기존 스크립트를 결합한 하이브리드 방식의 dotfiles 관리

## 🏗️ 구조

```
dotfiles/
├── git/
│   └── .gitconfig              # Git 설정 (Stow 관리)
├── claude/
│   ├── CLAUDE.md               # Claude 전역 설정 (Stow 관리)
│   ├── .claude/
│   │   ├── agents/             # Claude 에이전트들 (Stow 관리)
│   │   └── settings.local.json # Claude 로컬 설정
│   └── README.md
├── scripts/
│   ├── stow-setup.sh           # 통합 설정 스크립트 (Stow)
│   ├── stow-teardown.sh        # 통합 해제 스크립트 (Stow)
│   └── install-apps.sh         # 🆕 macOS 앱 설치 (Brew Cask + App Store 상태 확인)
└── macos/
    ├── default.sh              # macOS 설정
    └── appstore-apps.txt       # 🆕 App Store 앱 목록
```

## 🚀 사용법

### 1. 설정 적용 방법

#### 방법 A: GNU Stow 사용 (추천)

```bash
# 1. GNU Stow 설치
# Ubuntu/Debian
sudo apt install stow

# macOS
brew install stow

# 2. 전체 dotfiles 적용
./scripts/stow-setup.sh
```

### 3. 개별 패키지 관리

```bash
cd dotfiles

# 개별 패키지 적용
stow git --target=$HOME      # Git 설정만
stow claude --target=$HOME   # Claude 설정만

# 개별 패키지 해제
stow -D git --target=$HOME
stow -D claude --target=$HOME
```

### 4. macOS 앱 설치 관리

```bash
# 통합 앱 설치 스크립트 (추천)
./scripts/install-apps.sh

# Brew Cask로 설치 가능한 앱: 자동 설치
# App Store 전용 앱: 수동 설치 안내

# ⚠️ macOS Sequoia (15+) 제한사항:
# - mas로 새 앱 설치 불가
# - mas list (설치된 앱 확인)만 가능
# - App Store 앱은 수동 설치 필요

# 유용한 명령어:
brew search --cask "앱이름"    # Cask 앱 검색
brew list --cask              # 설치된 Cask 앱
mas list                      # 설치된 App Store 앱 (확인만)
```

### 5. 전체 해제

```bash
./scripts/stow-teardown.sh
```

## 📋 현재 관리 항목

- ✅ **Git 설정**
- ✅ **Claude 설정**
- ✅ **Brew Cask 앱** (자동 설치)
- ⚠️ **App Store 앱** (macOS 15+에서 수동 설치 필요)
- 📝 **향후 추가 예정**: zsh, vim, ssh, Homebrew 패키지 등

## 🔧 트러블슈팅

### Stow 에러가 날 때
```bash
# 기존 파일이 충돌하는 경우 백업 후 재시도
mv ~/.gitconfig ~/.gitconfig.backup
stow git --target=$HOME
```

## 📚 참고

- [GNU Stow 공식 문서](https://www.gnu.org/software/stow/)
- dotfiles 수정은 `dotfiles/` 디렉토리에서 진행
- 변경사항은 즉시 홈 디렉토리에 반영됨