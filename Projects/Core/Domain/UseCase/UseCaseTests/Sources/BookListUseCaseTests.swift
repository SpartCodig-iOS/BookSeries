//
//  BookListUseCaseTests.swift
//  UseCaseTests
//
//  Created by Wonji Suh on 9/11/25.
//

import Testing
import Foundation
@testable import UseCase
@testable import DomainInterface
@testable import Model
@testable import Repository

@MainActor
struct BookListUseCaseTests {
  
  // MARK: - Tests
  
  @Test("목데이터를 사용한 북 리스트 조회 성공 테스트", .tags(.useCaseTest, .bookListTest, .mockDataTest))
  func testGetBookListSuccessWithMockData() async throws {
    // Given
    let mockRepository = DefaultBookListRepositoryImpl()
    let useCase = BookListUseCaseImpl(repository: mockRepository)
    
    // When
    let result = try await useCase.getBookList()
    
    // Then
    #expect(result.count == 5)
    #expect(mockRepository.getCallCount() == 1)
    #expect(result[0].title == "클린 코드")
    #expect(result[1].title == "이펙티브 자바")
    #expect(result[2].title == "스위프트 프로그래밍")
    #expect(result[3].title == "디자인 패턴")
    #expect(result[4].title == "리팩토링")
  }
  
  @Test("빈 북 리스트 조회 테스트", .tags(.useCaseTest, .bookListTest, .unitTest))
  func testGetEmptyBookList() async throws {
    // Given
    let mockRepository = DefaultBookListRepositoryImpl()
    mockRepository.setMockBooks([])
    let useCase = BookListUseCaseImpl(repository: mockRepository)
    
    // When
    let result = try await useCase.getBookList()
    
    // Then
    #expect(result.isEmpty)
    #expect(mockRepository.getCallCount() == 1)
  }
  
  @Test("북 리스트 조회 실패 테스트", .tags(.useCaseTest, .bookListTest, .errorHandlingTest))
  func testGetBookListFailure() async throws {
    // Given
    let mockRepository = DefaultBookListRepositoryImpl()
    mockRepository.setShouldThrowError(true, error: DefaultBookListRepositoryImpl.MockError.networkError)
    let useCase = BookListUseCaseImpl(repository: mockRepository)
    
    // When & Then
    await #expect(throws: DefaultBookListRepositoryImpl.MockError.self) {
      try await useCase.getBookList()
    }
    
    #expect(mockRepository.getCallCount() == 1)
  }
  
  @Test("여러 번 호출 테스트", .tags(.useCaseTest, .bookListTest, .integrationTest))
  func testMultipleCallsToGetBookList() async throws {
    // Given
    let mockRepository = DefaultBookListRepositoryImpl()
    let useCase = BookListUseCaseImpl(repository: mockRepository)
    
    // When
    let result1 = try await useCase.getBookList()
    let result2 = try await useCase.getBookList()
    let result3 = try await useCase.getBookList()
    
    // Then
    #expect(result1 == result2)
    #expect(result2 == result3)
    #expect(result1.count == 5)
    #expect(mockRepository.getCallCount() == 3)
  }
  
  @Test("단일 책 조회 테스트", .tags(.useCaseTest, .bookListTest, .unitTest))
  func testGetSingleBookList() async throws {
    // Given
    let mockRepository = DefaultBookListRepositoryImpl()
    let singleBook = [Book(
      title: "테스트 책",
      author: "테스트 작가",
      pages: 300,
      image: "test.jpg",
      releaseDate: "2023-01-01",
      dedication: "테스트",
      summary: "테스트 요약",
      wiki: "https://test.com",
      chapters: ["테스트 챕터"]
    )]
    mockRepository.setMockBooks(singleBook)
    let useCase = BookListUseCaseImpl(repository: mockRepository)
    
    // When
    let result = try await useCase.getBookList()
    
    // Then
    #expect(result.count == 1)
    #expect(result[0].title == "테스트 책")
    #expect(result[0].author == "테스트 작가")
    #expect(result[0].pages == 300)
  }
  
  @Test("DefaultRepository를 사용한 테스트", .tags(.useCaseTest, .bookListTest, .defaultImplementationTest))
  func testWithDefaultRepository() async throws {
    // Given
    let defaultRepository = DefaultBookListRepositoryImpl()
    let useCase = BookListUseCaseImpl(repository: defaultRepository)
    
    // When
    let result = try await useCase.getBookList()
    
    // Then
    #expect(result.count == 5)
    #expect(result[0].title == "클린 코드")
    #expect(result[1].title == "이펙티브 자바")
    #expect(result[2].title == "스위프트 프로그래밍")
    #expect(result[3].title == "디자인 패턴")
    #expect(result[4].title == "리팩토링")
  }
  
  @Test("UseCase 초기화 테스트", .tags(.useCaseTest, .unitTest))
  func testUseCaseInitialization() {
    // Given
    let repository = DefaultBookListRepositoryImpl()
    
    // When
    let testUseCase = BookListUseCaseImpl(repository: repository)
    
    // Then
    #expect(testUseCase != nil)
  }
  
  @Test("Repository 호출 횟수 추적 테스트", .tags(.useCaseTest, .bookListTest, .integrationTest))
  func testRepositoryCallCountTracking() async throws {
    // Given
    let mockRepository = DefaultBookListRepositoryImpl()
    let useCase = BookListUseCaseImpl(repository: mockRepository)
    
    // When
    _ = try await useCase.getBookList()
    _ = try await useCase.getBookList()
    _ = try await useCase.getBookList()
    
    // Then
    #expect(mockRepository.getCallCount() == 3)
  }
  
  @Test("Repository 리셋 기능 테스트", .tags(.useCaseTest, .bookListTest, .unitTest))
  func testRepositoryReset() async throws {
    // Given
    let mockRepository = DefaultBookListRepositoryImpl()
    let useCase = BookListUseCaseImpl(repository: mockRepository)
    
    // When
    _ = try await useCase.getBookList()
    #expect(mockRepository.getCallCount() == 1)
    
    mockRepository.reset()
    
    // Then
    #expect(mockRepository.getCallCount() == 0)
    let result = try await useCase.getBookList()
    #expect(result.count == 5) // 기본 책 목록이 복원됨
  }
}
