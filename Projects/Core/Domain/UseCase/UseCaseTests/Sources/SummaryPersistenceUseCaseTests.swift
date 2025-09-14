//
//  SummaryPersistenceUseCaseTests.swift
//  UseCaseTests
//
//  Created by Wonji Suh on 9/11/25.
//

import Testing
import Foundation
@testable import UseCase
@testable import DomainInterface
@testable import Repository

@MainActor
struct SummaryPersistenceUseCaseTests {

  // MARK: - Tests
  
  @Test("목 저장소를 사용한 요약 상태 저장 및 로드 테스트", .tags(.useCaseTest, .summaryPersistenceTest, .mockDataTest))
  func testSaveAndLoadWithMockRepository() {
    // Given
    let mockRepository = DefaultSummaryPersistenceRepository()
    let useCase = SummaryPersistenceUseCaseImpl(repository: mockRepository)
    let title = "클린 코드"
    let author = "로버트 C. 마틴"
    
    // When
    let initialState = useCase.loadSummaryExpanded(for: title, author: author)
    useCase.saveSummaryExpanded(false, for: title, author: author)
    let changedState = useCase.loadSummaryExpanded(for: title, author: author)
    useCase.saveSummaryExpanded(true, for: title, author: author)
    let finalState = useCase.loadSummaryExpanded(for: title, author: author)
    
    // Then
    #expect(initialState == true) // 기본값으로 설정됨
    #expect(changedState == false)
    #expect(finalState == true)
    #expect(mockRepository.getLoadCallCount() == 3)
    #expect(mockRepository.getSaveCallCount() == 2)
  }
  
  @Test("여러 책의 요약 상태 독립적 관리 테스트", .tags(.useCaseTest, .summaryPersistenceTest, .integrationTest))
  func testMultipleBooksIndependentState() {
    // Given
    let mockRepository = DefaultSummaryPersistenceRepository()
    let useCase = SummaryPersistenceUseCaseImpl(repository: mockRepository)
    let testBooks = [
      ("클린 코드", "로버트 C. 마틴"),
      ("이펙티브 자바", "조슈아 블로크"),
      ("스위프트 프로그래밍", "야곰"),
      ("새로운 책", "새로운 작가")
    ]
    
    // When
    useCase.saveSummaryExpanded(true, for: testBooks[0].0, author: testBooks[0].1)
    useCase.saveSummaryExpanded(false, for: testBooks[1].0, author: testBooks[1].1)
    useCase.saveSummaryExpanded(true, for: testBooks[2].0, author: testBooks[2].1)
    useCase.saveSummaryExpanded(false, for: testBooks[3].0, author: testBooks[3].1)
    
    let result1 = useCase.loadSummaryExpanded(for: testBooks[0].0, author: testBooks[0].1)
    let result2 = useCase.loadSummaryExpanded(for: testBooks[1].0, author: testBooks[1].1)
    let result3 = useCase.loadSummaryExpanded(for: testBooks[2].0, author: testBooks[2].1)
    let result4 = useCase.loadSummaryExpanded(for: testBooks[3].0, author: testBooks[3].1)
    
    // Then
    #expect(result1 == true)
    #expect(result2 == false)
    #expect(result3 == true)
    #expect(result4 == false)
    #expect(mockRepository.getSaveCallCount() == 4)
    #expect(mockRepository.getLoadCallCount() == 4)
  }
  
  @Test("상태 변경 이력 테스트", .tags(.useCaseTest, .summaryPersistenceTest, .integrationTest))
  func testStateChangeHistory() {
    // Given
    let mockRepository = DefaultSummaryPersistenceRepository()
    let useCase = SummaryPersistenceUseCaseImpl(repository: mockRepository)
    let title = "리팩토링"
    let author = "마틴 파울러"
    
    // When & Then
    let states = [false, true, false, true, true, false]
    
    for state in states {
      useCase.saveSummaryExpanded(state, for: title, author: author)
      let currentState = useCase.loadSummaryExpanded(for: title, author: author)
      #expect(currentState == state)
    }
    
    #expect(mockRepository.getSaveCallCount() == 6)
    #expect(mockRepository.getLoadCallCount() == 6)
  }
  
  @Test("특수 문자가 포함된 제목과 작가 테스트", .tags(.useCaseTest, .summaryPersistenceTest, .dataValidationTest))
  func testSpecialCharactersInTitleAndAuthor() {
    // Given
    let mockRepository = DefaultSummaryPersistenceRepository()
    let useCase = SummaryPersistenceUseCaseImpl(repository: mockRepository)
    let specialCases = [
      ("Special!@#$%^&*()", "Author한글テスト"),
      ("", ""),
      ("Very Long Title That Contains Many Characters", "Very Long Author Name")
    ]
    
    // When & Then
    for (title, author) in specialCases {
      useCase.saveSummaryExpanded(true, for: title, author: author)
      let result = useCase.loadSummaryExpanded(for: title, author: author)
      #expect(result == true)
    }
  }
  
  @Test("DefaultRepository를 사용한 테스트", .tags(.useCaseTest, .summaryPersistenceTest, .defaultImplementationTest))
  func testWithDefaultRepository() {
    // Given
    let defaultRepository = DefaultSummaryPersistenceRepository()
    let useCase = SummaryPersistenceUseCaseImpl(repository: defaultRepository)
    
    // When & Then (미리 설정된 목데이터 확인)
    let cleanCodeExpanded = useCase.loadSummaryExpanded(for: "클린 코드", author: "로버트 C. 마틴")
    let effectiveJavaExpanded = useCase.loadSummaryExpanded(for: "이펙티브 자바", author: "조슈아 블로크")
    let swiftExpanded = useCase.loadSummaryExpanded(for: "스위프트 프로그래밍", author: "야곰")
    let designPatternExpanded = useCase.loadSummaryExpanded(for: "디자인 패턴", author: "GoF")
    let refactoringExpanded = useCase.loadSummaryExpanded(for: "리팩토링", author: "마틴 파울러")
    
    #expect(cleanCodeExpanded == true)
    #expect(effectiveJavaExpanded == false)
    #expect(swiftExpanded == true)
    #expect(designPatternExpanded == false)
    #expect(refactoringExpanded == true)
    
    // 새로운 책 저장 테스트
    useCase.saveSummaryExpanded(true, for: "새로운 책", author: "새로운 작가")
    let newBookExpanded = useCase.loadSummaryExpanded(for: "새로운 책", author: "새로운 작가")
    #expect(newBookExpanded == true)
  }
  
  @Test("UseCase 초기화 테스트", .tags(.useCaseTest, .unitTest))
  func testUseCaseInitialization() {
    // Given
    let repository = DefaultSummaryPersistenceRepository()
    
    // When
    let testUseCase = SummaryPersistenceUseCaseImpl(repository: repository)
    
    // Then
    #expect(testUseCase != nil)
  }
  
  @Test("빈 제목과 작가로 테스트", .tags(.useCaseTest, .summaryPersistenceTest, .dataValidationTest))
  func testEmptyTitleAndAuthor() {
    // Given
    let mockRepository = DefaultSummaryPersistenceRepository()
    let useCase = SummaryPersistenceUseCaseImpl(repository: mockRepository)
    
    // When
    useCase.saveSummaryExpanded(true, for: "", author: "")
    let result = useCase.loadSummaryExpanded(for: "", author: "")
    
    // Then
    #expect(result == true)
  }
  
  @Test("Repository 호출 횟수 추적 테스트", .tags(.useCaseTest, .summaryPersistenceTest, .integrationTest))
  func testRepositoryCallCountTracking() {
    // Given
    let mockRepository = DefaultSummaryPersistenceRepository()
    let useCase = SummaryPersistenceUseCaseImpl(repository: mockRepository)
    
    // When
    _ = useCase.loadSummaryExpanded(for: "책1", author: "작가1")
    _ = useCase.loadSummaryExpanded(for: "책2", author: "작가2")
    useCase.saveSummaryExpanded(true, for: "책3", author: "작가3")
    useCase.saveSummaryExpanded(false, for: "책4", author: "작가4")
    
    // Then
    #expect(mockRepository.getLoadCallCount() == 2)
    #expect(mockRepository.getSaveCallCount() == 2)
  }
  
  @Test("Repository 리셋 기능 테스트", .tags(.useCaseTest, .summaryPersistenceTest, .unitTest))
  func testRepositoryReset() {
    // Given
    let mockRepository = DefaultSummaryPersistenceRepository()
    let useCase = SummaryPersistenceUseCaseImpl(repository: mockRepository)
    
    // When
    useCase.saveSummaryExpanded(false, for: "클린 코드", author: "로버트 C. 마틴")
    #expect(mockRepository.getSaveCallCount() == 1)
    
    mockRepository.reset()
    
    // Then
    #expect(mockRepository.getSaveCallCount() == 0)
    #expect(mockRepository.getLoadCallCount() == 0)
    
    // 리셋 후 기본값 확인
    let result = useCase.loadSummaryExpanded(for: "클린 코드", author: "로버트 C. 마틴")
    #expect(result == true) // 기본값으로 복원됨
  }
}
