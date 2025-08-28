...existing code...

## CLAUDE.md 동기화 (심볼릭 링크)

리포지토리의 정본: claude/CLAUDE.md  
홈 파일: ~/CLAUDE.md (심볼릭 링크 방식으로 동기화)

스크립트

- scripts/link-claude.sh : 리포지토리 파일을 ~/CLAUDE.md로 심볼릭 링크 생성. 기존 ~/CLAUDE.md가 있으면 자동으로 백업(.bak.YYYYMMDDTHHMMSS).
- scripts/unlink-claude.sh : 심볼릭 링크 제거. 가능한 경우 최신 백업을 복원.

사용법 (macOS)

1. 실행권한 부여:

```
chmod +x scripts/link-claude.sh scripts/unlink-claude.sh
```

2. 링크 생성:

```sh
./scripts/link-claude.sh
```

3. 링크 제거 및 복원 시도:

```sh
./scripts/unlink-claude.sh
```

주의

- 기존 홈 파일을 덮어쓰기 전에 백업이 생성됩니다.
- 편집은 리포지토리 내 파일(claude/CLAUDE.md)에서 하거나 ~/CLAUDE.md에서 해도 동일 파일을 편집하게 됩니다.
