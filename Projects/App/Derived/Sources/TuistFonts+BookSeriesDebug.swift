// swiftlint:disable:this file_name
// swiftlint:disable all
// swift-format-ignore-file
// swiftformat:disable all
// Generated using tuist — https://github.com/tuist/tuist

#if os(macOS)
  import AppKit.NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
  import UIKit.UIFont
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Fonts

// swiftlint:disable identifier_name line_length type_body_length
public enum BookSeriesDebugFontFamily: Sendable {
  public enum PretendardVariable: Sendable {
    public static let black = BookSeriesDebugFontConvertible(name: "PretendardVariable-Black", family: "Pretendard Variable", path: "PretendardVariable.ttf")
    public static let bold = BookSeriesDebugFontConvertible(name: "PretendardVariable-Bold", family: "Pretendard Variable", path: "PretendardVariable.ttf")
    public static let extraBold = BookSeriesDebugFontConvertible(name: "PretendardVariable-ExtraBold", family: "Pretendard Variable", path: "PretendardVariable.ttf")
    public static let extraLight = BookSeriesDebugFontConvertible(name: "PretendardVariable-ExtraLight", family: "Pretendard Variable", path: "PretendardVariable.ttf")
    public static let light = BookSeriesDebugFontConvertible(name: "PretendardVariable-Light", family: "Pretendard Variable", path: "PretendardVariable.ttf")
    public static let medium = BookSeriesDebugFontConvertible(name: "PretendardVariable-Medium", family: "Pretendard Variable", path: "PretendardVariable.ttf")
    public static let regular = BookSeriesDebugFontConvertible(name: "PretendardVariable-Regular", family: "Pretendard Variable", path: "PretendardVariable.ttf")
    public static let semiBold = BookSeriesDebugFontConvertible(name: "PretendardVariable-SemiBold", family: "Pretendard Variable", path: "PretendardVariable.ttf")
    public static let thin = BookSeriesDebugFontConvertible(name: "PretendardVariable-Thin", family: "Pretendard Variable", path: "PretendardVariable.ttf")
    public static let all: [BookSeriesDebugFontConvertible] = [black, bold, extraBold, extraLight, light, medium, regular, semiBold, thin]
  }
  public static let allCustomFonts: [BookSeriesDebugFontConvertible] = [PretendardVariable.all].flatMap { $0 }
  public static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

public struct BookSeriesDebugFontConvertible: Sendable {
  public let name: String
  public let family: String
  public let path: String

  #if os(macOS)
  public typealias Font = NSFont
  #elseif os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
  public typealias Font = UIFont
  #endif

  public func font(size: CGFloat) -> Font {
    guard let font = Font(font: self, size: size) else {
      fatalError("Unable to initialize font '\(name)' (\(family))")
    }
    return font
  }

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  public func swiftUIFont(size: CGFloat) -> SwiftUI.Font {
    guard let font = Font(font: self, size: size) else {
      fatalError("Unable to initialize font '\(name)' (\(family))")
    }
    #if os(macOS)
    return SwiftUI.Font.custom(font.fontName, size: font.pointSize)
    #elseif os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
    return SwiftUI.Font(font)
    #endif
  }
  #endif

  public func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate var url: URL? {
    // swiftlint:disable:next implicit_return
    return Bundle.module.url(forResource: path, withExtension: nil)
  }
}

public extension BookSeriesDebugFontConvertible.Font {
  convenience init?(font: BookSeriesDebugFontConvertible, size: CGFloat) {
    #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
    if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
      font.register()
    }
    #elseif os(macOS)
    if let url = font.url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      font.register()
    }
    #endif

    self.init(name: font.name, size: size)
  }
}
// swiftformat:enable all
// swiftlint:enable all
