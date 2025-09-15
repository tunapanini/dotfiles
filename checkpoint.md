# Checkpoint Slash Command

## 사용법
```
/checkpoint [brief description]
```

## 기능
Claude Code 세션의 체크포인트를 생성하여 현재 작업 상태를 git commit으로 저장합니다.

## 동작
1. 현재 Claude Code 세션 ID 획득
2. 사용자가 제공한 간략한 설명과 함께 commit 메시지 생성
3. 형식: "checkpoint: [session-id] - [description]"
4. 모든 변경사항을 자동으로 스테이징하고 커밋

## 예시
```
/checkpoint "dotfiles 설정 완료"
```

결과 커밋 메시지:
```
checkpoint: claude-session-abc123 - dotfiles 설정 완료
```