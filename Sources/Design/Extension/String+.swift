
#if canImport(UIKit)
import UIKit
#endif
import Foundation

public extension String {
    var isNotEmpty: Bool { !isEmpty }
    var space: Self { " " }
    var empty: Self { "" }
    var removeAllWhiteSpace: String { self.components(separatedBy: .whitespacesAndNewlines).joined() }

    func highlightKeyword(_ keyword: String, foregroundColor: UIColor = .label, backgroundColor: UIColor = .systemYellow.withAlphaComponent(0.4)) -> NSAttributedString
    {
        let attributed = NSMutableAttributedString(string: self)

        let nsText = self.lowercased() as NSString
        var searchRange = NSRange(location: 0, length: nsText.length)

        while let foundRange = nsText.range(of: keyword, options: [], range: searchRange).nonEmpty {
            attributed.addAttributes(
                [
                    .foregroundColor: foregroundColor,
                    .backgroundColor: backgroundColor
                ],
                range: foundRange
            )
            let nextLocation: Int = foundRange.location + foundRange.length
            searchRange = NSRange(location: nextLocation, length: nsText.length - nextLocation)
        }
        return attributed
    }
}

private extension NSRange {
    var nonEmpty: NSRange? {
        location != NSNotFound && length > 0 ? self : nil
    }
}

extension NSAttributedString: @unchecked @retroactive Sendable {
    static let separator = NSAttributedString(string: ", ")
}

