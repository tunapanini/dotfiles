#!/usr/bin/env bash
set -euo pipefail

CLAUDE_MD_TARGET="${HOME}/CLAUDE.md"
AGENTS_TARGET="${HOME}/.claude/agents"

# CLAUDE.md 심볼릭 링크 제거
if [ -L "${CLAUDE_MD_TARGET}" ]; then
  rm "${CLAUDE_MD_TARGET}"
  echo "심볼릭 링크 제거: ${CLAUDE_MD_TARGET}"

  # 백업이 있으면 가장 최근 것으로 복원 (선택)
  LATEST_BACKUP=$(ls -1t "${CLAUDE_MD_TARGET}.bak."* 2>/dev/null | head -n1 || true)
  if [ -n "${LATEST_BACKUP}" ]; then
    mv "${LATEST_BACKUP}" "${CLAUDE_MD_TARGET}"
    echo "백업 복원: ${LATEST_BACKUP} -> ${CLAUDE_MD_TARGET}"
  fi
else
  echo "CLAUDE.md 심볼릭 링크가 없습니다: ${CLAUDE_MD_TARGET}"
fi

# agents 폴더 심볼릭 링크 제거
if [ -L "${AGENTS_TARGET}" ]; then
  rm "${AGENTS_TARGET}"
  echo "심볼릭 링크 제거: ${AGENTS_TARGET}"

  # 백업이 있으면 가장 최근 것으로 복원 (선택)
  LATEST_AGENTS_BACKUP=$(ls -1t "${AGENTS_TARGET}.bak."* 2>/dev/null | head -n1 || true)
  if [ -n "${LATEST_AGENTS_BACKUP}" ]; then
    mv "${LATEST_AGENTS_BACKUP}" "${AGENTS_TARGET}"
    echo "백업 복원: ${LATEST_AGENTS_BACKUP} -> ${AGENTS_TARGET}"
  fi
else
  echo "agents 심볼릭 링크가 없습니다: ${AGENTS_TARGET}"
fi