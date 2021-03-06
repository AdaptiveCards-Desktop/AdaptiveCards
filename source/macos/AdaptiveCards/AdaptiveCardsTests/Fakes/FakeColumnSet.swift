import AdaptiveCards_bridge

class FakeColumnSet: ACSColumnSet {
    var columns: [ACSColumn] = []
    var style: ACSContainerStyle = .default
    var id: String? = ""
    var selectAction: ACSBaseActionElement?
    var horizontalAlignment: ACSHorizontalAlignment = .left
    var padding: Bool = false
    
    override func getColumns() -> [ACSColumn] {
        return columns
    }
    
    override func getStyle() -> ACSContainerStyle {
        return style
    }
    
    override func setStyle(_ value: ACSContainerStyle) {
        style = value
    }
    
    override func getId() -> String? {
        return id
    }
    
    override func getSelectAction() -> ACSBaseActionElement? {
        return selectAction
    }
    
    override func getHorizontalAlignment() -> ACSHorizontalAlignment {
        return horizontalAlignment
    }
    
    override func setHorizontalAlignment(_ value: ACSHorizontalAlignment) {
        horizontalAlignment = value
    }
    
    override func getPadding() -> Bool {
        return padding
    }
}

extension FakeColumnSet {
    static func make(columns: [ACSColumn] = [], style: ACSContainerStyle = .default, selectAction: ACSBaseActionElement? = nil, horizontalAlignment: ACSHorizontalAlignment = .left, padding: Bool = false) -> FakeColumnSet {
       let fakeColumnSet = FakeColumnSet()
        fakeColumnSet.columns = columns
        fakeColumnSet.style = style
        fakeColumnSet.selectAction = selectAction
        fakeColumnSet.horizontalAlignment = horizontalAlignment
        fakeColumnSet.padding = padding
        return fakeColumnSet
    }
}
