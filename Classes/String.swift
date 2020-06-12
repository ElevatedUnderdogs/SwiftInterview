//
//  String.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/1/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation
import UIKit

public extension String {
    
    init(scape value: String, equals secondValue: String) {
        self = "\(value.scaped ?? "")=\(secondValue.scaped ?? "")&"
    }
    
    // MARK - computed properties
    
    var hasACharacter: Bool {
        return count > 0
    }
    
    var isNotValidEmail: Bool {
        return !isValidEmail
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    static var generateBoundaryString: String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    // MARK - self variations
    
    var nonSpaceCharacters: String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    var lowercased: String {
        return lowercased()
    }
    
    var int: Int? {
        return Int(self)
    }
    
    var privacyDots: String {
        return String (self.map {_ in return Character("*")})
    }
    
    func times(_ int: Int) -> [String] {
        return Array(0...int - 1).map { _ in self}
    }
    
    var intBool: Bool {
        return self == "1"
    }
    
    var date: Date? {
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd HH:mm:ss"
        df.timeZone = TimeZone(identifier: "GMT")
        return df.date(from: self)
    }
    
    var dateFromAPI: Date? {
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd HH:mm:ss"
        df.timeZone = TimeZone(identifier: "GMT")
        return df.date(from: self)
    }
    
    var scaped: String? {
        return addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        )
    }
    
    typealias AttributedString = NSMutableAttributedString
    
    // MARK  - attributed versions
    
    var akinCellStyle: AttributedString {return typography(spacing: 6)}
    
    func typography(spacing: CGFloat) -> AttributedString {
        let str = AttributedString(string: self)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        str.addAttribute(
            .paragraphStyle,
            value: style,
            range: NSMakeRange(0, self.count)
        )
        return str
    }
    
    func bold(string boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(
            string: self,
            attributes: [
                NSAttributedString.Key.font: font
            ]
        )
        let boldFontAttribute: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(
                ofSize: font.pointSize
            )
        ]
        let range = (self as NSString).range(of: boldString)
        attributedString.addAttributes(
            boldFontAttribute,
            range: range
        )
        return attributedString
    }
    
    // MARK - initializers
    
    init(key: String, _ value: String) {
        self = "\(key)=\(value.scaped ?? "")&"
    }
    
    static var appVersion: String? {
        return Bundle.version
    }
    
    var url: URL? {
        return URL(string: self)
    }
    
    ///If the string is an absolute url  this will make the call and fetch the JSON.  If not, this will do nothing.
    func getJSON(_ jsonAction: DictionaryAction? = nil) {
        assert(url != nil)
        url?.sessionDataTask(provideJSON: jsonAction)?.resume()
    }
    
    ///If the string is an absolute url this will make the call and fetch the document as a string.
    func getString(_ stringAction: StringAction? = nil) {
        assert(url != nil)
        url?.sessionDataTask(provideString: stringAction)?.resume()
    }
}
