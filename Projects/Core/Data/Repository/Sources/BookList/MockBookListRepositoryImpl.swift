//
//  DefaultBookListRepositoryImpl.swift
//  Repository
//
//  Created by Wonji Suh  on 9/8/25.
//

import DomainInterface
import Model

final public class DefaultBookListRepositoryImpl: BookListInterface {
  
  public enum MockError: Error {
    case networkError
    case parseError
    case notFound
  }
  
  private var mockBooks: [Book] = []
  private var shouldThrowError = false
  private var errorToThrow: Error = MockError.networkError
  private var callCount = 0
  
  public init() {
    setupDefaultBooks()
  }
  
  private func setupDefaultBooks() {
    mockBooks = [
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
      ),
      Book(
        title: "디자인 패턴",
        author: "GoF",
        pages: 395,
        image: "design_patterns.jpg",
        releaseDate: "1994-10-31",
        dedication: "객체지향 설계를 위하여",
        summary: "재사용 가능한 객체지향 소프트웨어의 핵심 요소",
        wiki: "https://ko.wikipedia.org/wiki/디자인_패턴",
        chapters: ["생성 패턴", "구조 패턴", "행위 패턴"]
      ),
      Book(
        title: "리팩토링",
        author: "마틴 파울러",
        pages: 418,
        image: "refactoring.jpg",
        releaseDate: "2018-11-23",
        dedication: "코드 품질 향상을 위하여",
        summary: "기존 코드를 안전하게 개선하는 방법",
        wiki: "https://ko.wikipedia.org/wiki/리팩토링",
        chapters: ["리팩토링 원칙", "코드에서 나는 악취", "테스트 구축"]
      )
    ]
  }

  public func getBookList() async throws -> [Book] {
    callCount += 1
    
    if shouldThrowError {
      throw errorToThrow
    }
    
    return mockBooks
  }
  
  // MARK: - Test Helper Methods
  
  public func setMockBooks(_ books: [Book]) {
    self.mockBooks = books
  }
  
  public func setShouldThrowError(_ shouldThrow: Bool, error: Error = MockError.networkError) {
    self.shouldThrowError = shouldThrow
    self.errorToThrow = error
  }
  
  public func getCallCount() -> Int {
    return callCount
  }
  
  public func reset() {
    setupDefaultBooks()
    shouldThrowError = false
    errorToThrow = MockError.networkError
    callCount = 0
  }
}
