//
//  BookListRepositoryTests.swift
//  RepositoryTests
//
//  Created by Wonji Suh on 9/11/25.
//

import Testing
import Foundation
@testable import Repository
@testable import DomainInterface
@testable import Model

@MainActor
struct BookListRepositoryTests {
  
  // MARK: - Mock Data
  
  private let mockBooks = [
    Book(
      title: "클린 코드",
      author: "로버트 C. 마틴",
      pages: 464,
      image: "clean_code.jpg",
      releaseDate: "2013-12-24",
      dedication: "프로그래밍 장인들에게",
      summary: "애자일 소프트웨어 장인 정신",
      wiki: "https://ko.wikipedia.org/wiki/클린_코드",
      chapters: ["깨끗한 코드", "의미 있는 이름", "함수", "주석", "형식 맞추기"]
    ),
    Book(
      title: "이펙티브 자바",
      author: "조슈아 블로크",
      pages: 416,
      image: "effective_java.jpg",
      releaseDate: "2018-10-26",
      dedication: "자바 개발자들을 위하여",
      summary: "자바 플랫폼 모범 사례 78가지",
      wiki: "https://ko.wikipedia.org/wiki/이펙티브_자바",
      chapters: ["객체 생성과 파괴", "모든 객체의 공통 메서드", "클래스와 인터페이스"]
    ),
    Book(
      title: "스위프트 프로그래밍",
      author: "야곰",
      pages: 792,
      image: "swift_programming.jpg",
      releaseDate: "2019-10-10",
      dedication: "스위프트를 사랑하는 모든 개발자들에게",
      summary: "Swift 5를 다루는 기본서의 바이블",
      wiki: "https://ko.wikipedia.org/wiki/스위프트_(프로그래밍_언어)",
      chapters: ["스위프트 기초", "데이터 타입", "연산자", "흐름 제어", "함수"]
    )
  ]
  
  // MARK: - Tests
  
  @Test("BookListRepositoryImpl 초기화 테스트", .tags(.repositoryTest, .bookListTest, .realImplementationTest))
  func testBookListRepositoryInitialization() {
    // When
    let repository = BookListRepositoryImpl()
    
    // Then
    #expect(repository != nil)
  }
  
  @Test("DefaultBookListRepositoryImpl 초기화 테스트", .tags(.repositoryTest, .bookListTest, .defaultImplementationTest))
  func testDefaultBookListRepositoryInitialization() {
    // When
    let repository = DefaultBookListRepositoryImpl()
    
    // Then
    #expect(repository != nil)
  }
  
  @Test("DefaultBookListRepositoryImpl 북 리스트 조회 테스트", .tags(.repositoryTest, .bookListTest, .defaultImplementationTest))
  func testDefaultRepositoryGetBookList() async throws {
    // Given
    let repository = DefaultBookListRepositoryImpl()
    
    // When
    let result = try await repository.getBookList()
    
    // Then
    #expect(result.count == 5)
    #expect(result[0].title == "클린 코드")
    #expect(result[1].title == "이펙티브 자바")
    #expect(result[2].title == "스위프트 프로그래밍")
  }
  
  @Test("DefaultBookListRepositoryImpl 여러 번 호출 일관성 테스트", .tags(.repositoryTest, .bookListTest, .defaultImplementationTest))
  func testDefaultRepositoryConsistency() async throws {
    // Given
    let repository = DefaultBookListRepositoryImpl()
    
    // When
    let result1 = try await repository.getBookList()
    let result2 = try await repository.getBookList()
    let result3 = try await repository.getBookList()
    
    // Then
    #expect(result1 == result2)
    #expect(result2 == result3)
    #expect(result1.count == 5)
    #expect(result1[0].title == "클린 코드")
  }
  
  @Test("BookListInterface 프로토콜 준수 테스트", .tags(.repositoryTest, .bookListTest))
  func testBookListInterfaceConformance() {
    // Given
    let defaultRepo: BookListInterface = DefaultBookListRepositoryImpl()
    let realRepo: BookListInterface = BookListRepositoryImpl()
    
    // Then
    #expect(defaultRepo != nil)
    #expect(realRepo != nil)
  }
  
  @Test("Book 모델 구조 검증 테스트", .tags(.modelTest, .dataValidationTest))
  func testBookModelStructure() {
    // Given
    let book = mockBooks[0]
    
    // Then
    #expect(book.title == "클린 코드")
    #expect(book.author == "로버트 C. 마틴")
    #expect(book.pages == 464)
    #expect(book.image == "clean_code.jpg")
    #expect(book.releaseDate == "2013-12-24")
    #expect(book.dedication == "프로그래밍 장인들에게")
    #expect(book.summary == "애자일 소프트웨어 장인 정신")
    #expect(book.wiki == "https://ko.wikipedia.org/wiki/클린_코드")
    #expect(book.chapters.count == 5)
    #expect(book.chapters.contains("깨끗한 코드"))
  }
  
  @Test("Book 모델 Equatable 테스트", .tags(.modelTest, .dataValidationTest))
  func testBookEquatable() {
    // Given
    let book1 = mockBooks[0]
    let book2 = Book(
      title: "클린 코드",
      author: "로버트 C. 마틴",
      pages: 464,
      image: "clean_code.jpg",
      releaseDate: "2013-12-24",
      dedication: "프로그래밍 장인들에게",
      summary: "애자일 소프트웨어 장인 정신",
      wiki: "https://ko.wikipedia.org/wiki/클린_코드",
      chapters: ["깨끗한 코드", "의미 있는 이름", "함수", "주석", "형식 맞추기"]
    )
    let book3 = mockBooks[1]
    
    // Then
    #expect(book1 == book2)
    #expect(book1 != book3)
  }
  
  @Test("여러 책 데이터 검증 테스트", .tags(.modelTest, .dataValidationTest))
  func testMultipleBooksData() {
    // Given
    let books = mockBooks
    
    // Then
    #expect(books.count == 3)
    #expect(books[0].author == "로버트 C. 마틴")
    #expect(books[1].author == "조슈아 블로크")
    #expect(books[2].author == "야곰")
    
    // 모든 책이 고유한 제목을 가지는지 확인
    let titles = Set(books.map { $0.title })
    #expect(titles.count == books.count)
  }
  
  @Test("Book 배열 정렬 테스트", .tags(.modelTest, .performanceTest))
  func testBookArraySorting() {
    // Given
    let books = mockBooks
    
    // When
    let sortedByTitle = books.sorted { $0.title < $1.title }
    let sortedByAuthor = books.sorted { $0.author < $1.author }
    let sortedByPages = books.sorted { $0.pages < $1.pages }
    
    // Then
    #expect(sortedByTitle[0].title == "스위프트 프로그래밍")
    #expect(sortedByAuthor[0].author == "로버트 C. 마틴")
    #expect(sortedByPages[0].pages == 416)
    #expect(sortedByPages[2].pages == 792)
  }
  
  @Test("Book 필터링 테스트", .tags(.modelTest, .performanceTest))
  func testBookFiltering() {
    // Given
    let books = mockBooks
    
    // When
    let longBooks = books.filter { $0.pages > 500 }
    let koreanAuthors = books.filter { $0.author.contains("한글") || $0.author == "야곰" }
    let booksWithManyChapters = books.filter { $0.chapters.count > 4 }
    
    // Then
    #expect(longBooks.count == 1)
    #expect(longBooks[0].title == "스위프트 프로그래밍")
    #expect(koreanAuthors.count == 1)
    #expect(booksWithManyChapters.count == 2)
  }
}
