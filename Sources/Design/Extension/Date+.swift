
import Foundation

fileprivate enum DateResolver {
    static let formatter = DateFormatter()
}

public extension Date {
    /// format 형식에 맞는 String값을 반환함
    /// - Parameter format: return String Format
    /// - Returns: Date -> String
    /// local = ko_KR
    func toFormatted(_ format: String = "yyyy년 MM월 dd일") -> String {
        let formatter = DateResolver.formatter
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

public extension String {
    /// 날짜형식 String 을 새로운 Date Format String으로 변환하는 함수
    /// - Parameter current: self 의 Date 형식
    /// - Parameter after:  반환할 Date형식
    /// - Returns: Date Format String
    func toFormattedString(current: String, after: String = "yyyy년 MM월 dd일") -> Self {
        self.toDate(current)?.toFormatted(after) ?? Date.now.toFormatted(after)
    }
    
    /// String to Date
    /// - Parameter format: 현재 Date format
    /// - Returns: Date?
    func toDate(_ format: String = "yyMMdd") -> Date? {
        let formatter = DateResolver.formatter
        formatter.dateFormat = format
        formatter.locale = Locale(identifier:"ko_KR")
        return formatter.date(from: self)
    }
}

