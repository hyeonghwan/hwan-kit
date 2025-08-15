
#if canImport(UIKit)
import UIKit

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
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )
        return ceil(boundingBox.width)
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
#endif
