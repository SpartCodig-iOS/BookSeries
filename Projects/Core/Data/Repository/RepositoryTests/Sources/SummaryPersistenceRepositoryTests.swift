//
//  SummaryPersistenceRepositoryTests.swift
//  RepositoryTests
//
//  Created by Wonji Suh on 9/11/25.
//

import Testing
import Foundation
@testable import Repository
@testable import DomainInterface

struct SummaryPersistenceRepositoryTests {

  // MARK: - Mock Data
  
  private let mockBooks = [
    ("클린 코드", "로버트 C. 마틴"),
    ("이펙티브 자바", "조슈아 블로크"),
    ("스위프트 프로그래밍", "야곰"),
    ("디자인 패턴", "GoF"),
    ("리팩토링", "마틴 파울러")
  ]
  
  // MARK: - Tests
  
  @Test("SummaryPersistenceRepositoryImpl 초기화 테스트", .tags(.repositoryTest, .summaryPersistenceTest, .realImplementationTest))
  func testSummaryPersistenceRepositoryInitialization() {
    // When
    let repository = SummaryPersistenceRepositoryImpl()
    
    // Then
    #expect(repository != nil)
  }
  
  @Test("DefaultSummaryPersistenceRepository 초기화 테스트", .tags(.repositoryTest, .summaryPersistenceTest, .defaultImplementationTest))
  func testDefaultSummaryPersistenceRepositoryInitialization() {
    // When
    let repository = DefaultSummaryPersistenceRepository()
    
    // Then
    #expect(repository != nil)
  }
  
  @Test("DefaultSummaryPersistenceRepository 로드 테스트", .tags(.repositoryTest, .summaryPersistenceTest, .defaultImplementationTest))
  func testDefaultRepositoryLoad() {
    // Given
    let repository = DefaultSummaryPersistenceRepository()
    
    // When & Then (미리 설정된 목데이터 확인)
    let cleanCodeResult = repository.loadSummaryExpanded(for: "클린 코드", author: "로버트 C. 마틴")
    let effectiveJavaResult = repository.loadSummaryExpanded(for: "이펙티브 자바", author: "조슈아 블로크")
    let swiftResult = repository.loadSummaryExpanded(for: "스위프트 프로그래밍", author: "야곰")
    
    #expect(cleanCodeResult == true)
    #expect(effectiveJavaResult == false)
    #expect(swiftResult == true)
    
    // 설정되지 않은 책은 false 반환
    let unknownResult = repository.loadSummaryExpanded(for: "알 수 없는 책", author: "알 수 없는 작가")
    #expect(unknownResult == false)
  }
  
  @Test("DefaultSummaryPersistenceRepository 저장 테스트", .tags(.repositoryTest, .summaryPersistenceTest, .defaultImplementationTest))
  func testDefaultRepositorySave() {
    // Given
    let repository = DefaultSummaryPersistenceRepository()
    
    // When & Then (예외가 발생하지 않으면 성공)
    for (title, author) in mockBooks {
      repository.saveSummaryExpanded(true, for: title, author: author)
      repository.saveSummaryExpanded(false, for: title, author: author)
    }
  }
  
  @Test("SummaryPersistenceRepositoryImpl UserDefaults 기본 테스트", .tags(.repositoryTest, .summaryPersistenceTest, .userDefaultsTest, .realImplementationTest))
  func testRealRepositoryUserDefaults() {
    // Given
    let repository = SummaryPersistenceRepositoryImpl()
    let (title, author) = mockBooks[0]
    
    // When
    repository.saveSummaryExpanded(true, for: title, author: author)
    let result1 = repository.loadSummaryExpanded(for: title, author: author)
    
    repository.saveSummaryExpanded(false, for: title, author: author)
    let result2 = repository.loadSummaryExpanded(for: title, author: author)
    
    // Then
    #expect(result1 == true)
    #expect(result2 == false)
    
    // Cleanup
    UserDefaults.standard.removeObject(forKey: "SummaryExpanded.\(title)|\(author)")
  }
  
  @Test("여러 책의 독립적인 상태 관리 테스트", .tags(.repositoryTest, .summaryPersistenceTest, .userDefaultsTest, .realImplementationTest))
  func testMultipleBooksIndependentState() {
    // Given
    let testDefaults = UserDefaults(suiteName: "SummaryPersistenceTests")!
    testDefaults.removePersistentDomain(forName: "SummaryPersistenceTests")

    let repository = SummaryPersistenceRepositoryImpl(userDefaults: testDefaults)
    let testStates = [true, false, true, false, true]

    // When
    for (index, (title, author)) in mockBooks.enumerated() {
      repository.saveSummaryExpanded(testStates[index], for: title, author: author)
    }

    // Then
    for (index, (title, author)) in mockBooks.enumerated() {
      let result = repository.loadSummaryExpanded(for: title, author: author)
      #expect(result == testStates[index], "Expected \(testStates[index]) for \(title) by \(author), but got \(result)")
    }

    // Cleanup
    testDefaults.removePersistentDomain(forName: "SummaryPersistenceTests")
  }

  @Test("상태 변경 추적 테스트", .tags(.repositoryTest, .summaryPersistenceTest, .userDefaultsTest, .realImplementationTest))
  func testStateChangeTracking() {
    // Given
    let repository = SummaryPersistenceRepositoryImpl()
    let (title, author) = mockBooks[1]
    
    // When & Then
    let states = [false, true, false, true, true, false]
    
    for state in states {
      repository.saveSummaryExpanded(state, for: title, author: author)
      let currentState = repository.loadSummaryExpanded(for: title, author: author)
      #expect(currentState == state)
    }
    
    // Cleanup
    UserDefaults.standard.removeObject(forKey: "SummaryExpanded.\(title)|\(author)")
  }
  
  @Test("SummaryPersistenceRepositoryInterface 프로토콜 준수 테스트", .tags(.repositoryTest, .summaryPersistenceTest))
  func testSummaryPersistenceInterfaceConformance() {
    // Given
    let defaultRepo: SummaryPersistenceRepositoryInterface = DefaultSummaryPersistenceRepository()
    let realRepo: SummaryPersistenceRepositoryInterface = SummaryPersistenceRepositoryImpl()
    
    // Then
    #expect(defaultRepo != nil)
    #expect(realRepo != nil)
  }
  
  @Test("Key 생성 일관성 테스트", .tags(.repositoryTest, .summaryPersistenceTest, .userDefaultsTest, .realImplementationTest))
  func testKeyGenerationConsistency() {
    // Given
    let repository = SummaryPersistenceRepositoryImpl()
    let (title, author) = mockBooks[2]
    
    // When
    repository.saveSummaryExpanded(true, for: title, author: author)
    let result1 = repository.loadSummaryExpanded(for: title, author: author)
    let result2 = repository.loadSummaryExpanded(for: title, author: author)
    let result3 = repository.loadSummaryExpanded(for: title, author: author)
    
    // Then
    #expect(result1 == result2)
    #expect(result2 == result3)
    #expect(result1 == true)

    // Cleanup
    UserDefaults.standard.removeObject(forKey: "SummaryExpanded.\(title)|\(author)")
  }
  
  @Test("특수 문자가 포함된 제목과 작가 테스트", .tags(.repositoryTest, .summaryPersistenceTest, .dataValidationTest, .userDefaultsTest))
  func testSpecialCharactersInTitleAndAuthor() {
    // Given
    let repository = SummaryPersistenceRepositoryImpl()
    let specialCases = [
      ("Special!@#$%^&*()", "Author한글テスト"),
      ("Title with spaces and numbers 123", "Author with 中文"),
      ("", ""),
      ("Title|With|Pipes", "Author:With:Colons"),
      ("Very Long Title That Contains Many Characters And Numbers 123456789", "Very Long Author Name With Special Characters !@#$%^&*()")
    ]
    
    // When & Then
    for (title, author) in specialCases {
      repository.saveSummaryExpanded(true, for: title, author: author)
      let result = repository.loadSummaryExpanded(for: title, author: author)
      #expect(result == true)
      
      // Cleanup
      UserDefaults.standard.removeObject(forKey: "SummaryExpanded.\(title)|\(author)")
    }
  }
  
  @Test("빈 문자열 처리 테스트", .tags(.repositoryTest, .summaryPersistenceTest, .dataValidationTest, .userDefaultsTest))
  func testEmptyStringHandling() {
    // Given (테스트 전용 UserDefaults 권장)
    let defaults = UserDefaults(suiteName: "SummaryPersistenceTests")!
    defaults.removePersistentDomain(forName: "SummaryPersistenceTests")
    let repository = SummaryPersistenceRepositoryImpl(userDefaults: defaults)

    let testCases = [
         ("", ""),
         ("Title", ""),
         ("", "Author"),
         ("Normal Title", "Normal Author")
       ]

    // When & Then
    for (title, author) in testCases {
      repository.saveSummaryExpanded(true, for: title, author: author)
      let result = repository.loadSummaryExpanded(for: title, author: author)
      #expect(result == true, "(\(title)|\(author))  but got \(result)")
    }

    // Cleanup
    defaults.removePersistentDomain(forName: "SummaryPersistenceTests")
  }

  @Test("대량 데이터 처리 테스트", .tags(.repositoryTest, .summaryPersistenceTest, .performanceTest, .userDefaultsTest))
  func testLargeDataHandling() {
    // Given
    let repository = SummaryPersistenceRepositoryImpl()
    let bookCount = 100
    var testBooks: [(String, String)] = []
    
    for i in 0..<bookCount {
      testBooks.append(("Book \(i)", "Author \(i)"))
    }
    
    // When
    for (index, (title, author)) in testBooks.enumerated() {
      let state = index % 2 == 0
      repository.saveSummaryExpanded(state, for: title, author: author)
    }
    
    // Then
    for (index, (title, author)) in testBooks.enumerated() {
      let expectedState = index % 2 == 0
      let actualState = repository.loadSummaryExpanded(for: title, author: author)
      #expect(actualState == expectedState)
    }
    
    // Cleanup
    for (title, author) in testBooks {
      UserDefaults.standard.removeObject(forKey: "SummaryExpanded.\(title)|\(author)")
    }
  }
}
