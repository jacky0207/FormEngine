//
//  FormGeneratorTests.swift
//  FormEngineTests
//
//  Created by Jacky Lam on 2023-04-14.
//

import XCTest
@testable import FormEngine

final class FormGeneratorTests: XCTestCase {
    var validator: (any FormGeneratorValidation)!
    let form = ModelData().form

    override func setUpWithError() throws {
        try super.setUpWithError()
        validator = FormGeneratorValidator()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        validator.errorMessages.removeAll()
    }

    func testValidator_withValidData_shouldNoError() throws {
        validator.validateForm(form, with: [
            "user_name": "jacky0207",
            "password": "Password1",
            "confirm_password": "Password1",
            "first_name": "Jacky",
            "last_name": "Lam",
            "gender": 0,
        ])
        XCTAssertEqual(validator.errorMessages, [:])
    }

    func testValidator_withEmptyData_shouldReturnFirstError() throws {
        validator.validateForm(form, with: [:])
        XCTAssertEqual(validator.errorMessages, [
            "user_name": "Please enter",
            "password": "Please enter",
            "confirm_password": "Please enter",
            "first_name": "Please enter",
            "last_name": "Please enter",
            "gender": "Please select",
        ])
    }

    func testValidator_withNotValidData_shouldReturnRelatedError() throws {
        validator.validateForm(form, with: [
            "user_name": "jacky0207",
            "password": "a1",
            "confirm_password": "a1",
            "first_name": "Jacky",
            "last_name": "Lam",
            "gender": 0,
        ])
        XCTAssertEqual(validator.errorMessages, [
            "password": "Password should contain at least 1 uppercase character",
        ])
    }
}
