#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="${REPO_ROOT}/claude/CLAUDE.md"
TARGET="${HOME}/CLAUDE.md"
TIMESTAMP="$(date +%Y%m%dT%H%M%S)"

if [ ! -e "${SRC}" ]; then
  echo "오류: 리포지토리 파일 없음: ${SRC}" >&2
  exit 1
fi

# 이미 동일한 심볼릭 링크면 종료
if [ -L "${TARGET}" ] && [ "$(readlink "${TARGET}")" = "${SRC}" ]; then
  echo "이미 링크가 설정되어 있습니다: ${TARGET} -> ${SRC}"
  exit 0
fi

# 기존 파일이 있으면 백업
if [ -e "${TARGET}" ] && [ ! -L "${TARGET}" ]; then
  mv "${TARGET}" "${TARGET}.bak.${TIMESTAMP}"
  echo "기존 파일을 백업: ${TARGET}.bak.${TIMESTAMP}"
fi

# 기존 링크(다른 대상) 삭제
if [ -L "${TARGET}" ]; then
  rm "${TARGET}"
fi

ln -s "${SRC}" "${TARGET}"
echo "심볼릭 링크 생성: ${TARGET} -> ${SRC}"