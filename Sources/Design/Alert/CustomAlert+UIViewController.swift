#if canImport(UIKit)
import UIKit

typealias CustomAlert = CustomAlertViewController

public extension UIViewController {
    func showAlert(
        title: String,
        message: String,
        action: AlertAction...
    ) {
        let content = AlertContent(
            base: self,
            title: title,
            message: message,
            action: action
        )
        CustomAlert.show(base: content)
    }
}

public struct AlertContent {
    public var baseViewController: UIViewController?
    public var alertTitle: String?
    public var message: String?
    public var actionList: [AlertAction] = []
    
    public init(
        base: UIViewController,
        title: String? = nil,
        message: String? = nil,
        action: [AlertAction] = []
    ) {
        self.baseViewController = base
        self.alertTitle = title
        self.message = message
        self.actionList = action
    }
}

public struct AlertAction {
    public let text: String
    public let color: UIColor
    public let action: (() -> Void)?
    
    public init(text: String, color: UIColor, action: (() -> Void)?) {
        self.text = text
        self.color = color
        self.action = action
    }
}

final class CustomAlertViewController: BaseViewController {
    private var alertTitle: String?
    private var message: String?
    private var actionList: [AlertAction] = []
    
    static func show(base content: AlertContent) {
        let alert = CustomAlertViewController()
        alert.modalPresentationStyle = .overFullScreen
        alert.modalTransitionStyle = .crossDissolve
        alert.alertTitle = content.alertTitle
        alert.message = content.message
        alert.actionList = content.actionList
        content.baseViewController?.present(alert, animated: true)
    }
    
    private let alertContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var alertTitleLabel: UILabel = {
        let label = UILabel()
        label.text = alertTitle
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var alertContentLabel: UILabel = {
        let label = UILabel()
        label.text = message
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.setLineSpacing(spacing: 8)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let horizontalDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func addChild() {
        view.addSubview(alertContainerView)
        [alertTitleLabel, alertContentLabel, horizontalDivider, buttonStackView].forEach {
            alertContainerView.addSubview($0)
        }
        for (index, alertAction) in actionList.enumerated() {
            let button = createButton(for: alertAction)
            buttonStackView.addArrangedSubview(button)
            if index < actionList.count - 1 {
                let verticalDivider = createVerticalDivider()
                buttonStackView.addArrangedSubview(verticalDivider)
                verticalDivider.widthAnchor.constraint(equalToConstant: 1).isActive = true
            }
        }
    }
    
    override func addAttributes() {
        view.backgroundColor = .black.withAlphaComponent(0.4)
    }
    
    override func addLayout() {
        NSLayoutConstraint.activate([
            alertContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            alertContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            alertTitleLabel.topAnchor.constraint(equalTo: alertContainerView.topAnchor, constant: 24),
            alertTitleLabel.leadingAnchor.constraint(equalTo: alertContainerView.leadingAnchor, constant: 20),
            alertTitleLabel.trailingAnchor.constraint(equalTo: alertContainerView.trailingAnchor, constant: -20),
            
            alertContentLabel.topAnchor.constraint(equalTo: alertTitleLabel.bottomAnchor, constant: 28),
            alertContentLabel.leadingAnchor.constraint(equalTo: alertContainerView.leadingAnchor, constant: 20),
            alertContentLabel.trailingAnchor.constraint(equalTo: alertContainerView.trailingAnchor, constant: -20),
            
            horizontalDivider.topAnchor.constraint(equalTo: alertContentLabel.bottomAnchor, constant: 28),
            horizontalDivider.leadingAnchor.constraint(equalTo: alertContainerView.leadingAnchor),
            horizontalDivider.trailingAnchor.constraint(equalTo: alertContainerView.trailingAnchor),
            horizontalDivider.heightAnchor.constraint(equalToConstant: 0.5),
            
            buttonStackView.topAnchor.constraint(equalTo: horizontalDivider.bottomAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: alertContainerView.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: alertContainerView.trailingAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: alertContainerView.bottomAnchor),
            buttonStackView.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func createButton(for alertAction: AlertAction) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(alertAction.text, for: .normal)
        button.setTitleColor(alertAction.color, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        
        let action = UIAction { [weak self] _ in
            self?.dismiss(animated: true) {
                alertAction.action?()
            }
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }
    
    private func createVerticalDivider() -> UIView {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
#endif
