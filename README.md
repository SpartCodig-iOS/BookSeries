# BookSeries
내일배움 캠프 책시리즈 과제

내일배움 캠프 3주차  앱 개발 기초 과제

이 저장소는 Swift 문법 학습을 위해 작성된 과제 코드와 컨벤션을 포함하고 있습니다.  
코드를 작성할 때는 **컨벤션**과 **Git 전략**을 준수하며, 협업 시 일관된 개발 환경을 유지하는 것을 목표로 합니다.

---

## 📑 컨벤션
- [공통 컨벤션](./Convention/Common.md)  
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
