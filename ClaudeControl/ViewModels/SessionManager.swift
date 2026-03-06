import Foundation
import Combine

class SessionManager: ObservableObject {
    @Published var sessions: [Session] = []
    let historyService = SessionHistoryService()
    private var cancellables = Set<AnyCancellable>()

    var hasAnyAwaitingInput: Bool {
        sessions.contains { $0.isAwaitingInput }
    }

    func createSession(directory: String) {
        let dirURL = URL(fileURLWithPath: directory)
        let name = dirURL.lastPathComponent
        let session = Session(name: name, directory: directory)

        let panelController = TerminalPanelController(session: session)
        session.panelController = panelController

        session.$isAwaitingInput
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)

        session.$isRunning
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)

        sessions.append(session)
        panelController.startProcess()
        panelController.showWindow()
    }

    func showSession(_ session: Session) {
        session.panelController?.showWindow()
    }

    func resumeSession(_ previousSession: PreviousSession) {
        let session = Session(name: previousSession.projectName, directory: previousSession.directory)

        let panelController = TerminalPanelController(session: session, resumeSessionId: previousSession.id)
        session.panelController = panelController

        session.$isAwaitingInput
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)

        session.$isRunning
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)

        sessions.append(session)
        panelController.startProcess()
        panelController.showWindow()
    }

    func removeSession(_ session: Session) {
        session.panelController?.stopProcess()
        session.panelController?.hideWindow()
        sessions.removeAll { $0.id == session.id }
    }
}
