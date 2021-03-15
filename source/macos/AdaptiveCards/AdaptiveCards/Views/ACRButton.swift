import AppKit

class ACRButton: FlatButton {
    public var backgroundColor: NSColor = .init(red: 0.35216, green: 0.823529412, blue: 1, alpha: 1)
    public var hoverBackgroundColor: NSColor = .linkColor
    public var activeBackgroundColor: NSColor = .gray
    public var iconImage: String = ""
    public var iconPos: NSControl.ImagePosition = .imageLeft
    public var chev: Bool = false {
        didSet {
            chevronDraw(par: "arrowdown")
        }
    }
    public var text: NSMutableAttributedString = .init(string: "")
    
    override init(frame: NSRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    init(frame: NSRect, chevron: Bool = false, icon: Bool = false, iconName: String = "", iconPosition: NSControl.ImagePosition = .imageLeft) {
        super.init(frame: frame)
        initialize()
        if chevron {
            chev = chevron
        }
        if icon {
            ico = icon
            iconImage = iconName
            iconPos = iconPosition
        }
    }
    
    private func initialize() {
        cornerRadius = containerLayer.frame.height / 2
        borderWidth = 0
        borderColor = backgroundColor
        buttonColor = backgroundColor
        activeBorderColor = activeBackgroundColor
        activeButtonColor = activeBackgroundColor
        textColor = NSColor.white
        activeTextColor = NSColor.white
        onAnimationDuration = 0.0
        offAnimationDuration = 0.0
        iconColor = NSColor.white
        activeIconColor = NSColor.white
        momentary = true
        if ico {
            guard let bundle = Bundle(identifier: "com.test.test.AdaptiveCards"),
                  let path = bundle.path(forResource: iconImage, ofType: "png") else {
                logError("Image Not Found")
                return
            }
            image = NSImage(byReferencing: URL(fileURLWithPath: path))
            imagePosition = iconPos
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }

    override open func mouseEntered(with event: NSEvent) {
        buttonColor = hoverBackgroundColor
        borderColor = hoverBackgroundColor
        if mouseDown {
            setOn(state != .on)
        }
    }
    
    override open func mouseExited(with event: NSEvent) {
        buttonColor = backgroundColor
        borderColor = backgroundColor
        if mouseDown {
            setOn(state != .on)
            mouseDown = false
        }
    }
}
