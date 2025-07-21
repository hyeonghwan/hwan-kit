

#if canImport(UIKit)
import UIKit

public extension UILabel {
    func isTruncated(with constrainedHeight: CGFloat) -> Bool {
        guard let labelText = self.text else { return false }
        let requiredSize = CGSize(
            width: self.frame.width,
            height: CGFloat.greatestFiniteMagnitude
        )
        let attributes: [NSAttributedString.Key: Any] = [.font: self.font!]
        let requiredRect = labelText.boundingRect(
            with: requiredSize,
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
        )
        return requiredRect.height > constrainedHeight
    }
    
    func setLineSpacing(spacing: CGFloat) {
        guard let text = text else { return }
        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        attributeString.addAttribute(
            .paragraphStyle,
            value: style,
            range: NSRange(location: 0, length: attributeString.length)
        )
        attributedText = attributeString
    }
}

#endif
