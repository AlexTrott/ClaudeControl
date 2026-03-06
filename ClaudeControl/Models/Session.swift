import Foundation
import Combine

class Session: Identifiable, ObservableObject {
    let id = UUID()
    @Published var name: String
    let directory: String
    @Published var isAwaitingInput: Bool = false
    @Published var isRunning: Bool = false

    var panelController: TerminalPanelController?

    init(name: String, directory: String) {
        self.name = name
        self.directory = directory
    }
}
