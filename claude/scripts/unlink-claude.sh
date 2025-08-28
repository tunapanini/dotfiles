#!/usr/bin/env bash
set -euo pipefail

TARGET="${HOME}/CLAUDE.md"

if [ ! -L "${TARGET}" ]; then
  echo "심볼릭 링크가 아님: ${TARGET}"
  exit 1
fi

rm "${TARGET}"
echo "심볼릭 링크 제거: ${TARGET}"

# 백업이 있으면 가장 최근 것으로 복원 (선택)
LATEST_BACKUP=$(ls -1t "${TARGET}.bak."* 2>/dev/null | head -n1 || true)
if [ -n "${LATEST_BACKUP}" ]; then
  mv "${LATEST_BACKUP}" "${TARGET}"
  echo "백업 복원: ${LATEST_BACKUP} -> ${TARGET}"
fi