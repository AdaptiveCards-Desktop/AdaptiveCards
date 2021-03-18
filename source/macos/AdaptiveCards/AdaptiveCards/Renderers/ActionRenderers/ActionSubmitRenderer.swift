import AdaptiveCards_bridge
import AppKit

class ActionSubmitRenderer: BaseActionElementRendererProtocol {
    static let shared = ActionSubmitRenderer()
    
    func render(action: ACSBaseActionElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView, parentView: NSView, inputs: [BaseInputHandler]) -> NSView {
        guard let submitAction = action as? ACSSubmitAction else {
            logError("Element is not of type ACSOpenUrlAction")
            return NSView()
        }
        
        let button = ACRButton()
        button.title = submitAction.getTitle() ?? ""
        
        let target = ActionSubmitTarget(element: submitAction, delegate: rootView)
        target.configureAction(for: button)
        rootView.addTarget(target)
//        let target = ActionOpenURLTarget(element: openURLAction, delegate: rootView)
//        target.configureAction(for: button)
//        rootView.addTarget(target)
        
        return button
    }
}
