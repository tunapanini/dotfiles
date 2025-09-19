# 에러 로그 자동 분석 Agent

프로젝트에서 발생하는 다양한 에러를 자동으로 감지하고 분석하여 해결 방안을 제시합니다.

## 작동 조건

### 자동 트리거
- **빌드 실패 감지 시**: build, lint, type-check 명령 실패
- **배포 에러 발생 시**: Vercel 배포 실패 알림
- **런타임 에러 감지**: console.error, logger.error 호출 패턴
- **크롤링 에러**: 크롤링 작업 실패 시
- **데이터베이스 에러**: Supabase, Prisma 연결 실패

### 수동 실행
```
/analyze-error
/error-help
```

## 분석 프로세스

### 1. 에러 소스 식별
```typescript
// 에러 발생 위치 추적
- 프론트엔드: React 컴포넌트, Next.js 라우트
- 백엔드: API 라우트, 서버 사이드 로직  
- 크롤링: Python 크롤러, Node.js 크롤링 서비스
- 인프라: Vercel 배포, 데이터베이스 연결
```

### 2. 에러 분류 및 우선순위
```
🔴 CRITICAL: 서비스 중단, 데이터 손실 위험
🟡 HIGH: 주요 기능 장애, 사용자 경험 저하
🟢 MEDIUM: 부분적 기능 장애, 성능 이슈
🔵 LOW: 경고성 메시지, 최적화 필요
```

### 3. 상황별 자동 분석

#### 빌드/배포 에러
```typescript
// Vercel MCP를 활용한 배포 로그 분석
1. mcp__vercel-awesome-ai__get_deployment_build_logs() 호출
2. TypeScript 에러, ESLint 에러, 빌드 실패 원인 분석
3. 의존성 이슈, 환경변수 누락 체크
4. 구체적 해결 방안 제시
```

#### 크롤링 에러 (Python)
```python
# scraping/ 디렉토리 에러 분석
- Selenium WebDriver 이슈 (selenium_driver.py)
- 데이터 검증 실패 (data_validator.py) 
- Supabase 연결 문제 (supabase_client.py)
- 파싱 에러 (reviewplace.py)
```

#### Next.js 런타임 에러
```typescript
// web/src/ 디렉토리 에러 분석
- API 라우트 에러 (/api/)
- 컴포넌트 렌더링 에러 (/components/)
- 서비스 계층 에러 (/services/)
- 미들웨어 이슈 (middleware.ts)
```

## 에러별 자동 해결 제안

### TypeScript 에러
```
❌ 감지: Property 'xxx' does not exist on type 'yyy'
💡 해결책:
1. 타입 정의 확인: src/types/ 디렉토리
2. 자동 수정: 타입 추가 또는 옵셔널 처리
3. 검증: pnpm type-check 재실행
```

### 크롤링 실패
```
❌ 감지: Selenium TimeoutException
💡 해결책:
1. 대상 사이트 상태 확인
2. 대기 시간 조정 (selenium_driver.py)
3. 폴백 전략 적용
4. 재시도 로직 확인
```

### 배포 실패
```
❌ 감지: Vercel Build Failed
💡 해결책:
1. 빌드 로그 상세 분석
2. 환경변수 확인 (.env.local)
3. 의존성 버전 충돌 체크
4. 자동 재배포 시도
```

### API 에러
```
❌ 감지: 500 Internal Server Error
💡 해결책:
1. 에러 스택 트레이스 분석
2. 데이터베이스 연결 상태 체크
3. 미들웨어 로직 검증
4. 로그 레벨 조정으로 상세 디버깅
```

## 출력 형식

### 에러 분석 리포트
```
🔍 에러 로그 분석 결과

📊 감지된 에러: 3건
├─ 🔴 CRITICAL: Vercel 배포 실패 (1건)
├─ 🟡 HIGH: 크롤링 타임아웃 (1건) 
└─ 🟢 MEDIUM: TypeScript 타입 에러 (1건)

🎯 우선 처리 대상:

1. 🔴 Vercel 배포 실패
   위치: /api/cron/crawl-campaigns/route.ts:47
   원인: 환경변수 SUPABASE_URL 누락
   해결: vercel env pull → .env.local 확인
   예상 수정 시간: 2분

2. 🟡 크롤링 타임아웃  
   위치: scraping/utils/selenium_driver.py:25
   원인: 페이지 로드 시간 초과
   해결: wait_time 5초 → 10초 증가
   예상 수정 시간: 1분

3. 🟢 TypeScript 타입 에러
   위치: src/types/campaign.ts:12
   원인: 옵셔널 속성 누락
   해결: deadline?: string 추가
   예상 수정 시간: 30초

⚡ 자동 수정 가능: 2/3건
💡 예상 총 해결 시간: 3.5분
```

## 자동 대응 기능

### 즉시 해결 가능한 에러
- ESLint 자동 수정: `eslint --fix` 실행
- 포맷팅 이슈: Prettier 자동 적용  
- 타입 에러: 간단한 타입 추가/수정
- 환경변수: `vercel env pull` 자동 실행

### 분석 후 제안하는 에러  
- 복잡한 로직 에러: 상세 분석 및 수정 방향 제시
- 외부 의존성 문제: 대안 라이브러리 또는 설정 제안
- 아키텍처 이슈: 구조적 개선 방안 제안

## 학습 및 개선

### 패턴 인식
- 반복되는 에러 패턴 학습
- 프로젝트별 특수 에러 케이스 축적
- 해결 성공률 기반 방법론 개선

### 예방 제안
- 자주 발생하는 에러의 사전 방지 코드 제안
- 에러 핸들링 강화 방안
- 모니터링 및 알림 시스템 구축

---
*10분/회 → 1분/회로 시간 단축 (90% 효율화)*