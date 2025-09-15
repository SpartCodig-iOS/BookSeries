# 📚 BookSeries - Harry Potter Series App

> **내일배움 캠프 iOS 개발 과제**  
> Clean Architecture와 TCA를 활용한 해리포터 시리즈 정보 앱

해리포터 7부작의 상세 정보를 제공하는 iOS 애플리케이션입니다.  
Clean Architecture 기반의 모듈화된 구조와 Composable Architecture(TCA)를 사용하여 안정적이고 확장 가능한 앱을 구현했습니다.

## 주요 기능

-  **해리포터 시리즈 탐색**: 7권의 책 정보를 시리즈 버튼으로 쉽게 전환
-  **반응형 UI**: 기기 회전에 대응하는 적응형 레이아웃  
-  **스켈레톤 로딩**: 부드러운 로딩 경험 제공
-  **요약 토글**: 책 요약을 펼치고 접을 수 있는 인터랙티브 UI
- **종합 테스트**: Unit Test, UI Test로 안정성 보장

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


## 🏗 프로젝트 아키텍처

### Clean Architecture + TCA
```
📱 Presentation Layer
   ├── BookListViewController    # TCA Store 연결
   ├── BookListView             # UI 컴포넌트 조립
   └── Components/              # 재사용 가능한 UI 컴포넌트
       ├── SeriesButtonsView    # 시리즈 선택 버튼 (기기 회전 대응)
       ├── BookCardView         # 책 정보 카드
       ├── BookDetailsView      # 상세 정보 (요약 토글)
       └── ChaptersView         # 목차 리스트

🧠 Domain Layer  
   ├── UseCase/                 # 비즈니스 로직
   │   ├── BookListUseCaseImpl
   │   └── SummaryPersistenceUseCaseImpl
   └── Model/                   # 도메인 엔티티
       ├── Book                 # 책 정보 모델
       └── BookDisplayData      # UI 표시용 데이터

💾 Data Layer
   ├── Repository/              # 데이터 소스 추상화
   │   ├── BookListRepositoryImpl
   │   └── SummaryPersistenceRepositoryImpl  
   └── Service/                 # JSON 파일 읽기
       └── JSONManager

🔧 Infrastructure
   ├── Network/                 # 네트워크 설정
   ├── DesignSystem/           # 디자인 토큰, 공통 UI
   └── Shared/                 # 유틸리티, 확장
```

### 모듈 구조
```
BookSeries/
├── Workspace.swift
├── Projects/
│   ├── App/                    # 앱 진입점 & DI 설정
│   ├── Presentation/           # UI Layer (TCA)
│   ├── Core/
│   │   ├── Domain/            # UseCase, Model, Interface
│   │   ├── Data/              # Repository, Model 구현
│   │   └── Network/           # Service, JSONManager
│   └── Shared/
│       ├── DesignSystem/      # BaseView, 컬러, 폰트
│       ├── ThirdParty/        # TCA, SnapKit, Then 등
│       └── Util/              # 공통 유틸리티
└── Tuist/                     # 프로젝트 설정
```

## 🚀 시작하기

### 필수 요구사항
- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+
- Tuist 4.50+

### 개발환경 설정
```bash
# Tuist 설치 (Homebrew)
brew install tuist

# 의존성 및 플러그인 설치
tuist up

# 환경 검증
tuist doctor
```

### 프로젝트 생성 및 실행
```bash
# Xcode 프로젝트 생성
tuist generate

# 빌드 및 실행
tuist build
open BookSeries.xcworkspace
```


## 주요 기술 스택

### 아키텍처 & 상태 관리
- ** Clean Architecture**: 레이어 분리로 유지보수성 향상
- ** TCA (Composable Architecture)**: 단방향 데이터 플로우
- ** Dependency Injection**: 의존성 주입으로 테스트 용이성 확보

### UI & 레이아웃  
- ** SnapKit**: AutoLayout DSL
- ** Then**: 선언적 UI 구성
- ** BaseView**: 공통 UI 컴포넌트 아키텍처
- ** Adaptive Layout**: 기기 회전 대응 반응형 UI

### 데이터 & 네트워킹
- ** JSONManager**: 로컬 JSON 파일 파싱
- ** Repository Pattern**: 데이터 소스 추상화
- ** UseCase Pattern**: 데이터 소스 추상화
- ** UserDefaults**: 요약 펼침 상태 지속성

## 🎯 핵심 구현 기능

### 1. **반응형 시리즈 버튼**
```swift
// SeriesButtonsView - 기기 회전 대응
private func updateLayoutForOrientation() {
    let availableWidth = frame.width
    let minTotalWidth = totalButtonsWidth + spacing
    
    if minTotalWidth <= availableWidth {
        // 중앙 정렬
        seriesScrollView.isScrollEnabled = false
        seriesButtonStack.distribution = .equalSpacing
    } else {
        // 스크롤 활성화  
        seriesScrollView.isScrollEnabled = true
    }
}
```

### 2. **TCA 상태 관리**
```swift
// BookList Reducer - 단방향 데이터 플로우
public struct BookList: Reducer {
    public struct State {
        var book: [Book] = []
        var selectedBookIndex: Int = 0
        var displayData: BookDisplayData?
        var isLoading: Bool = false
    }
    
    public enum Action {
        case view(ViewAction)
        case async(AsyncAction)
    }
}
```

### 3. **의존성 주입**
```swift
// Repository Factory Pattern
extension RepositoryModuleFactory {
    func resolve() -> BookListRepositoryInterface {
        return BookListRepositoryImpl(service: JSONManager())
    }
}
```
## 📸 앱 스크린샷

| 메인 화면 | 시리즈 전환 | 요약 펼치기 |
|:---:|:---:|:---:|
| ![메인](docs/screenshots/main.png) | ![시리즈](docs/screenshots/series.png) | ![요약](docs/screenshots/summary.png) |

## 🔧 개발 도구 & 설정

### Tuist 설정
```swift
// Workspace.swift
let workspace = Workspace(
    name: "BookSeries",
    projects: ["Projects/**"]
)

// 모듈별 독립적인 빌드 설정
// 의존성 그래프 최적화
```

### 폴더 구조 가이드
```
📁 BookList/
├── 📄 BookListViewController.swift    # TCA Store 연결점
├── 📄 BookListView.swift             # 메인 UI 조립
├── 📄 BookList.swift                 # TCA Reducer
├── 📁 View/Components/               # 재사용 컴포넌트
│   ├── 📄 SeriesButtonsView.swift
│   ├── 📄 BookCardView.swift
│   └── 📄 BookDetailsView.swift
└── 📁 Coordinator/                   # 화면 전환 로직
```

## 📚 참고 자료

- [Clean Architecture (Uncle Bob)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture)
- [Tuist Documentation](https://docs.tuist.io/)
- [SnapKit Layout Guide](https://snapkit.github.io/SnapKit/)

---

