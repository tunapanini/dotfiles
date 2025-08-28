#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_MD_SRC="${REPO_ROOT}/claude/CLAUDE.md"
CLAUDE_MD_TARGET="${HOME}/CLAUDE.md"
AGENTS_SRC="${REPO_ROOT}/claude/agents"
AGENTS_TARGET="${HOME}/.claude/agents"
TIMESTAMP="$(date +%Y%m%dT%H%M%S)"

# CLAUDE.md 파일 확인
if [ ! -e "${CLAUDE_MD_SRC}" ]; then
  echo "오류: 리포지토리 파일 없음: ${CLAUDE_MD_SRC}" >&2
  exit 1
fi

# agents 폴더 확인
if [ ! -d "${AGENTS_SRC}" ]; then
  echo "오류: 리포지토리 폴더 없음: ${AGENTS_SRC}" >&2
  exit 1
fi

# ~/.claude 디렉토리가 없으면 생성
mkdir -p "${HOME}/.claude"

# CLAUDE.md 심볼릭 링크 처리
if [ -L "${CLAUDE_MD_TARGET}" ] && [ "$(readlink "${CLAUDE_MD_TARGET}")" = "${CLAUDE_MD_SRC}" ]; then
  echo "이미 CLAUDE.md 링크가 설정되어 있습니다: ${CLAUDE_MD_TARGET} -> ${CLAUDE_MD_SRC}"
else
  # 기존 파일이 있으면 백업
  if [ -e "${CLAUDE_MD_TARGET}" ] && [ ! -L "${CLAUDE_MD_TARGET}" ]; then
    mv "${CLAUDE_MD_TARGET}" "${CLAUDE_MD_TARGET}.bak.${TIMESTAMP}"
    echo "기존 파일을 백업: ${CLAUDE_MD_TARGET}.bak.${TIMESTAMP}"
  fi

  # 기존 링크(다른 대상) 삭제
  if [ -L "${CLAUDE_MD_TARGET}" ]; then
    rm "${CLAUDE_MD_TARGET}"
  fi

  ln -s "${CLAUDE_MD_SRC}" "${CLAUDE_MD_TARGET}"
  echo "심볼릭 링크 생성: ${CLAUDE_MD_TARGET} -> ${CLAUDE_MD_SRC}"
fi

# agents 폴더 심볼릭 링크 처리
if [ -L "${AGENTS_TARGET}" ] && [ "$(readlink "${AGENTS_TARGET}")" = "${AGENTS_SRC}" ]; then
  echo "이미 agents 링크가 설정되어 있습니다: ${AGENTS_TARGET} -> ${AGENTS_SRC}"
else
  # 기존 폴더가 있으면 백업
  if [ -e "${AGENTS_TARGET}" ] && [ ! -L "${AGENTS_TARGET}" ]; then
    mv "${AGENTS_TARGET}" "${AGENTS_TARGET}.bak.${TIMESTAMP}"
    echo "기존 폴더를 백업: ${AGENTS_TARGET}.bak.${TIMESTAMP}"
  fi

  # 기존 링크(다른 대상) 삭제
  if [ -L "${AGENTS_TARGET}" ]; then
    rm "${AGENTS_TARGET}"
  fi

  ln -s "${AGENTS_SRC}" "${AGENTS_TARGET}"
  echo "심볼릭 링크 생성: ${AGENTS_TARGET} -> ${AGENTS_SRC}"
fi