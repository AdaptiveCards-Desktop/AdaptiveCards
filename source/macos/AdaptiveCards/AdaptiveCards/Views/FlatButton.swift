// This file is taken from GitHub - https://www.github.com/OskarGroth/FlatButton
// Needful changes were made to the original file
// swiftlint:disable all

import AppKit
import Cocoa
import QuartzCore

extension CALayer {
    internal func animate(color: CGColor, keyPath: String, duration: Double) {
        if value(forKey: keyPath) as! CGColor? != color {
            let animation = CABasicAnimation(keyPath: keyPath)
            animation.toValue = color
            animation.fromValue = value(forKey: keyPath)
            animation.duration = duration
            animation.isRemovedOnCompletion = false
            animation.fillMode = CAMediaTimingFillMode.forwards
            add(animation, forKey: keyPath)
            setValue(color, forKey: keyPath)
        }
    }
}

open class FlatButton: NSButton, CALayerDelegate {
    internal var containerLayer = CALayer()
    internal var iconLayer = CAShapeLayer()
    internal var alternateIconLayer = CAShapeLayer()
    internal var chevronLayer = CAShapeLayer()
    internal var titleLayer = CATextLayer()
    internal var mouseDown = Bool()
    public var ico: Bool = false
    internal var c = 1
    internal var a = 1
    public var momentary: Bool = true {
        didSet {
            animateColor(state == .on)
        }
    }
    public var onAnimationDuration: Double = 0
    public var offAnimationDuration: Double = 0.1
    public var glowRadius: CGFloat = 0 {
        didSet {
            containerLayer.shadowRadius = glowRadius
            animateColor(state == .on)
        }
    }
    public var glowOpacity: Float = 0 {
        didSet {
            containerLayer.shadowOpacity = glowOpacity
            animateColor(state == .on)
        }
    }
    public var cornerRadius: CGFloat = 16 {
        didSet {
            layer?.cornerRadius = cornerRadius
        }
    }
    public var borderWidth: CGFloat = 4 {
        didSet {
            layer?.borderWidth = borderWidth
        }
    }
    public var borderColor: NSColor = .darkGray {
        didSet {
            animateColor(state == .on)
        }
    }
    public var activeBorderColor: NSColor = .white {
        didSet {
            animateColor(state == .on)
        }
    }
    public var buttonColor: NSColor = .white {
        didSet {
            animateColor(state == .on)
        }
    }
    public var activeButtonColor: NSColor = .white {
        didSet {
            animateColor(state == .on)
        }
    }
    public var iconColor: NSColor = .gray {
        didSet {
            animateColor(state == .on)
        }
    }
    public var activeIconColor: NSColor = .black {
        didSet {
            animateColor(state == .on)
        }
    }
    public var textColor: NSColor = .gray {
        didSet {
            animateColor(state == .on)
        }
    }
    public var activeTextColor: NSColor = .gray {
        didSet {
            animateColor(state == .on)
        }
    }
    
    override open var title: String {
        didSet {
            setupTitle()
        }
    }
    override open var font: NSFont? {
        didSet {
            setupTitle()
        }
    }
    override open var frame: NSRect {
        didSet {
            positionTitleAndImage()
        }
    }
    override open var image: NSImage? {
        didSet {
            setupImage()
        }
    }
    override open var alternateImage: NSImage? {
        didSet {
            setupImage()
        }
    }
    open var chevron: Bool = false {
        didSet {
            chevronDraw(par: "arrowdown")
        }
    }
    override open var isEnabled: Bool {
        didSet {
            alphaValue = isEnabled ? 1 : 0.5
        }
    }

    // MARK: Setup & Initialization
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(frame: NSRect) {
        super.init(frame: frame)
        setup()
    }
    
    internal func setup() {
        wantsLayer = true
        layer?.masksToBounds = false
        containerLayer.masksToBounds = false
        containerLayer.masksToBounds = true
        layer?.cornerRadius = 4
        layer?.borderWidth = 1
        layer?.delegate = self
        titleLayer.delegate = self
        if let scale = window?.backingScaleFactor {
            titleLayer.contentsScale = scale
        }
        iconLayer.delegate = self
        chevronLayer.delegate = self
        alternateIconLayer.delegate = self
        iconLayer.masksToBounds = true
        chevronLayer.masksToBounds = true
        alternateIconLayer.masksToBounds = true
        containerLayer.shadowOffset = NSSize.zero
        containerLayer.shadowColor = NSColor.clear.cgColor
        containerLayer.frame = NSRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        containerLayer.addSublayer(iconLayer)
        containerLayer.addSublayer(chevronLayer)
        containerLayer.addSublayer(alternateIconLayer)
        containerLayer.addSublayer(titleLayer)
        layer?.addSublayer(containerLayer)
        setupTitle()
        setupImage()
        chevronDraw(par: "arrowdown")
    }
    
    internal func setupTitle() {
        guard let font = font else {
            return
        }
        titleLayer.string = title
        titleLayer.font = font
        titleLayer.fontSize = font.pointSize
        positionTitleAndImage()
    }
    
    func positionTitleAndImage() {
        let attributes = [NSAttributedString.Key.font: font as Any]
        let titleSize = title.size(withAttributes: attributes)
        var titleRect = NSRect(x: 0, y: 0, width: titleSize.width, height: titleSize.height)
        var imageRect = iconLayer.frame
        var chevronRect = chevronLayer.frame
        var length : Float = 0
        var divisions = 3
        var hSpacing = round(((bounds.width) - (imageRect.width + titleSize.width + chevronRect.width)) / CGFloat(divisions))
        let vSpacing = round(((bounds.height) - (imageRect.height + titleSize.height)) / 3)
        if iconLayer.frame.width > 0 && chevron && (imagePosition == .imageLeft || imagePosition == .imageRight) {
            divisions = 4
            hSpacing = round(((bounds.width) - (imageRect.width + titleSize.width + chevronRect.width)) / CGFloat(divisions))
        }
        length += chevron ? Float(chevronLayer.frame.width) : 0
        length += ico ? Float(iconLayer.frame.width) : 0
        length += Float(titleLayer.frame.width)
        length += Float(hSpacing * CGFloat(divisions))
        layer?.frame = NSRect(x: Int((layer?.frame.origin.x)!), y: Int((layer?.frame.origin.y)!), width: Int(length), height: Int(bounds.height))
        containerLayer.frame = NSRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        switch imagePosition {
        case .imageAbove:
            print("image setup above")
            titleRect.origin.y = (vSpacing * 1.75) + imageRect.height
            titleRect.origin.x = hSpacing + round(imageRect.width / 2)
            imageRect.origin.y = vSpacing * 1.75
            imageRect.origin.x = hSpacing + round((titleRect.width - imageRect.width) / 2) + round(imageRect.width / 2) + 5
            if chevron {
                chevronRect.origin.y = round((containerLayer.bounds.height - chevronRect.height) / 2)
                chevronRect.origin.x = round((hSpacing * 2) + titleSize.width + (imageRect.width / 2))
            }
        case .imageBelow:
            print("image setup below")
            print(vSpacing)
            titleRect.origin.y = round(vSpacing * 2.5)
            titleRect.origin.x = hSpacing + round(imageRect.width / 2) + 5
            imageRect.origin.y = round(vSpacing * 2.5) + titleRect.height
            imageRect.origin.x = hSpacing + round((titleRect.width - imageRect.width) / 2) + round(imageRect.width / 2)
            if chevron {
                chevronRect.origin.y = round((containerLayer.bounds.height - chevronRect.height) / 2)
                chevronRect.origin.x = round((hSpacing * 2) + titleSize.width + (imageRect.width / 2))
            }
        case .imageLeft:
            print("image setup left")
            titleRect.origin.y = round((containerLayer.bounds.height - titleSize.height) / 2)
            titleRect.origin.x = round((hSpacing * 2) + imageRect.width)
            imageRect.origin.y = round((containerLayer.bounds.height - imageRect.height) / 2)
            imageRect.origin.x = hSpacing
            if chevron {
                chevronRect.origin.y = round((containerLayer.bounds.height - chevronRect.height) / 2)
                chevronRect.origin.x = round((hSpacing * 3) + titleSize.width + imageRect.width)
                if c == 1 {
                    c = 0
                    containerLayer.frame.size.width += chevronRect.width
                }
            }
            
        case .imageRight:
            print("image setup right")
            titleRect.origin.y = round((containerLayer.bounds.height - titleSize.height) / 2)
            titleRect.origin.x = hSpacing
            imageRect.origin.y = round((containerLayer.bounds.height - imageRect.height) / 2)
            imageRect.origin.x = (hSpacing * 2) + titleRect.width
            if chevron {
                chevronRect.origin.y = round((containerLayer.bounds.height - chevronRect.height) / 2)
                chevronRect.origin.x = round((hSpacing * 3) + titleSize.width + imageRect.width)
                if c == 1 {
                    c = 0
                    containerLayer.frame.size.width += chevronRect.width
                }
            }
            
        default:
            print("Image setup default")
            if chevron {
                titleRect.origin.y = round((containerLayer.bounds.height - titleSize.height) / 2)
                titleRect.origin.x = round(hSpacing)
                chevronRect.origin.y = round((containerLayer.bounds.height - chevronRect.height) / 2)
                chevronRect.origin.x = round((hSpacing * 2) + titleSize.width)
            } else {
                titleRect.origin.y = round((containerLayer.bounds.height - titleSize.height) / 2)
                titleRect.origin.x = round((containerLayer.bounds.width - titleSize.width) / 2)
            }
        }
        iconLayer.frame = imageRect
        alternateIconLayer.frame = imageRect
        chevronLayer.frame = chevronRect
        titleLayer.frame = titleRect
    }
    
    internal func setupImage() {
        guard let image = image else {
            return
        }
        print("image setup")
        let maskLayer = CALayer()
        image.size.width = (bounds.height / image.size.height) * image.size.width * 0.5
        image.size.height = bounds.height * 0.5
        let imageSize = image.size
        let imageRect: NSRect = .init(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        let imageRef = image
        maskLayer.contents = imageRef
        iconLayer.frame = imageRect
        maskLayer.frame = imageRect
        iconLayer.mask = maskLayer
        if let alternateImage = alternateImage {
            let altMaskLayer = CALayer()
            alternateImage.size.width = (containerLayer.bounds.height / alternateImage.size.height) * alternateImage.size.width * 0.5
            alternateImage.size.height = containerLayer.bounds.height * 0.5
            let altImageSize = alternateImage.size
            let altImageRect: NSRect = .init(x: 0, y: 0, width: altImageSize.width, height: altImageSize.height)
            let altImageRef = alternateImage
            altMaskLayer.contents = altImageRef
            alternateIconLayer.frame = altImageRect
            altMaskLayer.frame = altImageRect
            alternateIconLayer.mask = altMaskLayer
            alternateIconLayer.frame = altImageRect
        }
        positionTitleAndImage()
    }
    
    func chevronDraw(par: String) {
        if chevron {
            print("Chevron Setup")
            guard let bundle = Bundle(identifier: "com.test.test.AdaptiveCards"),
                  let path = bundle.path(forResource: par, ofType: "png") else {
                logError("image not found")
                return
            }
            let chevIcon = NSImage(byReferencing: URL(fileURLWithPath: path))
            let maskLayer = CALayer()
            chevIcon.size.width = (bounds.height / chevIcon.size.height) * chevIcon.size.width * 0.5
            chevIcon.size.height = bounds.height * 0.5
            let chevIconSize = chevIcon.size
            let chevIconRect: NSRect = .init(x: 0, y: 0, width: chevIconSize.width, height: chevIconSize.height)
            let chevRef = chevIcon
            maskLayer.contents = chevRef
            chevronLayer.frame = chevIconRect
            maskLayer.frame = chevIconRect
            chevronLayer.mask = maskLayer
            chevronLayer.backgroundColor = NSColor.white.cgColor
        } else {
            return
        }
        positionTitleAndImage()
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        let trackingArea = NSTrackingArea(rect: bounds, options: [.activeAlways, .inVisibleRect, .mouseEnteredAndExited], owner: self, userInfo: nil)
        addTrackingArea(trackingArea)
    }
    
    // MARK: Animations
    
    internal func removeAnimations() {
        layer?.removeAllAnimations()
        if layer?.sublayers != nil {
            for subLayer in (layer?.sublayers)! {
                subLayer.removeAllAnimations()
            }
        }
    }
    
    public func animateColor(_ isOn: Bool) {
        removeAnimations()
        let duration = isOn ? onAnimationDuration : offAnimationDuration
        let bgColor = isOn ? activeButtonColor : buttonColor
        let titleColor = isOn ? activeTextColor : textColor
        let imageColor = isOn ? activeIconColor : iconColor
        let borderColor = isOn ? activeBorderColor : self.borderColor
        layer?.backgroundColor = bgColor.cgColor
        layer?.borderColor = borderColor.cgColor
        titleLayer.foregroundColor = titleColor.cgColor
        
        if alternateImage == nil {
            iconLayer.backgroundColor = imageColor.cgColor
        } else {
            iconLayer.backgroundColor = iconColor.cgColor
            alternateIconLayer.animate(color: isOn ? activeIconColor.cgColor : NSColor.clear.cgColor, keyPath: "backgroundColor", duration: duration)
        }
        
        // Shadows
        
        if glowRadius > 0, glowOpacity > 0 {
            containerLayer.animate(color: isOn ? activeIconColor.cgColor : NSColor.clear.cgColor, keyPath: "shadowColor", duration: duration)
        }
    }

    // MARK: Interaction
    
    public func setOn(_ isOn: Bool) {
        let nextState = isOn ? NSControl.StateValue.on : NSControl.StateValue.off
        if nextState != state {
            state = nextState
            animateColor(state == .on)
        }
    }
    
    override open func hitTest(_ point: NSPoint) -> NSView? {
        return isEnabled ? super.hitTest(point) : nil
    }
    
    override open func mouseDown(with event: NSEvent) {
        if isEnabled {
            mouseDown = true
            setOn(state == .on ? false : true)
        }
        if state == .on {
            chevronDraw(par: "arrowup")
        }
        else {
            chevronDraw(par: "arrowdown")
        }
    }
    
    override open func mouseEntered(with event: NSEvent) {
        if mouseDown {
            setOn(state == .on ? false : true)
        }
    }
    
    override open func mouseExited(with event: NSEvent) {
        if mouseDown {
            setOn(state == .on ? false : true)
            mouseDown = false
        }
    }
    
    override open func mouseUp(with event: NSEvent) {
        if mouseDown {
            mouseDown = false
            if momentary {
                setOn(state == .on ? false : true)
            }
            _ = target?.perform(action, with: self)
        }
    }
    
    // MARK: Drawing
    
    override open func viewDidChangeBackingProperties() {
        super.viewDidChangeBackingProperties()
        if let scale = window?.backingScaleFactor {
            titleLayer.contentsScale = scale
            layer?.contentsScale = scale
            iconLayer.contentsScale = scale
        }
    }
    
    open func layer(_ layer: CALayer, shouldInheritContentsScale newScale: CGFloat, from window: NSWindow) -> Bool {
        return true
    }
    
    override open func draw(_ dirtyRect: NSRect) {
    }
    
    override open func layout() {
        super.layout()
        positionTitleAndImage()
    }
    
    override open func updateLayer() {
        self.updateLayer()
    }
}
