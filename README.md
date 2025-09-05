# BookSeries
내일배움 캠프 책시리즈 과제

내일배움 캠프 3주차  앱 개발 기초 과제

이 저장소는 Swift 문법 학습을 위해 작성된 과제 코드와 컨벤션을 포함하고 있습니다.  
코드를 작성할 때는 **컨벤션**과 **Git 전략**을 준수하며, 협업 시 일관된 개발 환경을 유지하는 것을 목표로 합니다.

---

## 📑 컨벤션
- [공통 컨벤션](.github/Convention/Common.md)  
모든 Swift 코드에서 반드시 준수해야 하는 컨벤션을 정의합니다.

---

## 🐈‍⬛ Git 전략

### 🔀 Branching Strategy
- **Origin(main branch)**
- **Origin(dev branch)**
- **Local(feature branch)**

#### Branch 종류
- `main`
- `dev`
- `feature/*`
- `fix/*`

#### 작업 순서
1. Origin의 **dev** 브랜치를 Pull  
2. Local에서 **feature/과제명** 브랜치를 생성  
3. **feature** 브랜치에서 개발 진행  
4. Local → Origin으로 **feature** 브랜치 Push  
5. Origin의 **feature** → Origin의 **dev** 로 Pull Request 생성  
6. Origin **dev** 브랜치에서 충돌 해결 및 Merge  
7. Local **dev** 브랜치에서 Origin **dev**를 Fetch & Rebase  

---

## 💾 Commit 가이드
- [Commit 메시지 규칙](./.github/.gitMessage.md)  
일관된 커밋 메시지를 작성하기 위한 가이드입니다.

---


## 프로젝트 구조

```
MultiModuleTemplate/
├── Workspace.swift
├── Tuist.swift
├── Projects/
│   ├── Presentation/         # 화면 및 ViewModel 구성
│   ├── Core/
│   │   ├── Network/          # API 통신 계층
│   │   │   └── Service/      # 실제 API 호출 서비스
│   │   ├── UseCase/          # 도메인 UseCase 정의
│   │   ├── Repository/       # UseCase와 Data 연결 계층
│   │   └── DomainInterface/  # 도메인 인터페이스 계층
│   │       └── Model/        # 엔티티/도메인 모델
│   └── Shared/
│       ├── DesignSystem/     # 공통 UI 컴포넌트, 폰트 등
│       ├── ThirdParty/       # 외부 라이브러리 래핑
│       └── Utill/            # 공통 유틸리티
├── Tuist/
│   ├── Package.swift
│   └── ProjectDescriptionHelpers/
└── Scripts/
```

## 시작하기

### 1) 개발환경 부트스트랩
```bash
tuist up        # 플러그인/툴 설치 등 환경 준비
tuist doctor    # 문제 진단
```

### 2) 프로젝트 생성
```bash
tuist generate
```

### 3) 빌드
```bash
tuist build
```

### 4) 테스트
```bash
tuist test
```

## 주요 모듈 설명

- **Presentation**: ViewController, ViewModel 등 UI 로직 담당  
- **Core**
  - **Network**: API 클라이언트 및 endpoint 관리
  - **Service**: Network 계층의 실제 요청 처리
  - **UseCase**: 도메인 규칙에 따른 비즈니스 로직 처리
  - **Repository**: UseCase와 실제 데이터 소스(API/DB 등) 연결
  - **DomainInterface/Model**: 도메인 객체 및 Interface 정의
- **Shared**
  - **DesignSystem**: 공통 UI 컴포넌트, 폰트, 색상 등 디자인 자산
  - **ThirdParty**: Alamofire, TCA, etc. 외부 라이브러리 래핑
  - **Utill**: 날짜, 문자열, 로깅 등 공용 유틸리티

## 개발 환경

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+
- Tuist 4.50+

## 사용 라이브러리

- **ComposableArchitecture**: 상태 관리
- **DiContainer**: 의존성 주입
- **SwiftLint**: 코드 스타일 체크
- **FlexLayout**: Ui 레이아웃
- **PinLayout**: Ui 레이아웃
- **Then**: Ui 레이아웃

---

