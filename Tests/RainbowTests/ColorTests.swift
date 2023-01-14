//
//  ColorTests.swift
//  
//
//  Created by 宋璞 on 2023/1/14.
//

import XCTest
@testable import Rainbow

final class ColorTests: XCTestCase {

   
    func testNamedColorConvertToNamedBackgroundColor() {
        let bgColors = NamedColor.allCases.map { $0.toBackgroundColor }
        XCTAssertEqual(bgColors, NamedBackgroundColor.allCases)
    }

    func testNamedBackgroundNamedColorConvertToColor() {
        let colors = NamedBackgroundColor.allCases.map { $0.toColor }
        XCTAssertEqual(colors, NamedColor.allCases)
    }

    func testBit8ColorConversion() {
        XCTAssertEqual(ColorType.bit8(100).toBackgroundColor, BackgroundColorType.bit8(100))
        XCTAssertEqual(BackgroundColorType.bit8(100).toColor, ColorType.bit8(100))
    }

    func testBit24ColorConversion() {
        XCTAssertEqual(ColorType.bit24((1,2,3)).toBackgroundColor, BackgroundColorType.bit24((1,2,3)))
        XCTAssertEqual(BackgroundColorType.bit24((1,2,3)).toColor, ColorType.bit24((1,2,3)))
    }

}
