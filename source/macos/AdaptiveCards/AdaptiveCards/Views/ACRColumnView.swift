import AdaptiveCards_bridge
import AppKit

enum ColumnWidth: Equatable {
    case stretch, auto, fixed(_ width: CGFloat), weighted(_ weight: Int)
    
    var isWeighted: Bool {
        switch self {
        case .weighted: return true
        default: return false
        }
    }
    
    var huggingPriority: NSLayoutConstraint.Priority {
        switch self {
        case .auto: return .init(252)
        case .stretch: return .init(249)
        default: return .defaultLow
        }
    }
    
    init(columnWidth: String?, pixelWidth: NSNumber?) {
        if let width = pixelWidth, let float = CGFloat(exactly: width), float > 0 {
            self = .fixed(float)
            return
        }
        if let width = columnWidth, let weight = Int(width) {
            self = .weighted(weight)
            return
        }
        self = columnWidth == "auto" ? .auto : .stretch
    }
    
    static func == (lhs: ColumnWidth, rhs: ColumnWidth) -> Bool {
        switch (lhs, rhs) {
        case (.stretch, .stretch),
             (.auto, .auto): return true
        case let (.fixed(widthA), .fixed(widthB)): return widthA == widthB
        case let (.weighted(weightA), .weighted(weightB)): return weightA == weightB
        default: return false
        }
    }
}

class ACRColumnView: ACRContentStackView {
    enum Constants {
        static let minWidth: CGFloat = 30
    }
    
    private lazy var widthConstraint = widthAnchor.constraint(equalToConstant: Constants.minWidth)
    private lazy var backgroundImageViewBottomConstraint = backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
    private (set) var columnWidth: ColumnWidth = .weighted(1)
    
    private (set) lazy var backgroundImageView: ACRBackgroundImageView = {
        let view = ACRBackgroundImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: ACSContainerStyle, parentStyle: ACSContainerStyle?, hostConfig: ACSHostConfig, superview: NSView?) {
        super.init(style: style, parentStyle: parentStyle, hostConfig: hostConfig, superview: superview)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        // Always to have some minimum width
        let minWidthConstraint = widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.minWidth)
        minWidthConstraint.priority = .defaultHigh
        minWidthConstraint.isActive = true
    }
    
    override func addArrangedSubview(_ subview: NSView) {
        manageWidth(of: subview)
        super.addArrangedSubview(subview)
        if subview is ACRContentStackView {
            subview.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        }
    }
    
    override func setupViews() {
        addSubview(backgroundImageView)
        super.setupViews()
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundImageViewBottomConstraint.isActive = true
    }
    
    override func anchorBottomConstraint(with anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>) {
        super.anchorBottomConstraint(with: anchor)
        backgroundImageViewBottomConstraint.isActive = false
        backgroundImageViewBottomConstraint = backgroundImageView.bottomAnchor.constraint(equalTo: anchor)
        backgroundImageViewBottomConstraint.isActive = true
    }
    
    func setupBackgroundImageProperties(_ properties: ACSBackgroundImage) {
        backgroundImageView.fillMode = properties.getFillMode()
        backgroundImageView.horizontalAlignment = properties.getHorizontalAlignment()
        backgroundImageView.verticalAlignment = properties.getVerticalAlignment()
        heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
    }
    
    func configureColumnProperties(for view: NSView) {
        manageWidth(of: view)
    }
    
    func setWidth(_ width: ColumnWidth) {
        columnWidth = width
        manageWidth(of: self)
        manageWidth(of: stackView)
    }
    
    private func manageWidth(of view: NSView) {
        switch columnWidth {
        case .fixed(let widthSize):
            widthConstraint.constant = widthSize
            widthConstraint.isActive = true
            
        case .auto:
            view.setContentHuggingPriority(columnWidth.huggingPriority, for: .horizontal)
            view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            widthConstraint.isActive = false
            
        case .stretch:
            view.setContentHuggingPriority(columnWidth.huggingPriority, for: .horizontal)
            view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            widthConstraint.isActive = false
            
        case .weighted:
            widthConstraint.isActive = false
        }
    }
}
