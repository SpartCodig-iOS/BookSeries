//
//  TestTags.swift
//  UseCaseTests
//
//  Created by Wonji Suh on 9/11/25.
//

import Testing

extension Tag {
    @Tag static var useCaseTest: Self
    @Tag static var repositoryTest: Self
    @Tag static var mockDataTest: Self
    @Tag static var integrationTest: Self
    @Tag static var unitTest: Self
    @Tag static var bookListTest: Self
    @Tag static var summaryPersistenceTest: Self
    @Tag static var defaultImplementationTest: Self
    @Tag static var realImplementationTest: Self
    @Tag static var errorHandlingTest: Self
    @Tag static var dataValidationTest: Self
    @Tag static var tcaReducerTest: Self
    @Tag static var stateManagementTest: Self
    @Tag static var effectTest: Self
    @Tag static var actionTest: Self
}
