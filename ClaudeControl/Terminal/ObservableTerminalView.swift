import AppKit
import SwiftTerm

class ObservableTerminalView: LocalProcessTerminalView {
    weak var session: Session?
    var inputDetector: InputDetector?

    override func processTerminated(_ source: LocalProcess, exitCode: Int32?) {
        super.processTerminated(source, exitCode: exitCode)
        DispatchQueue.main.async { [weak self] in
            self?.session?.isRunning = false
            self?.session?.isAwaitingInput = false
        }
    }

    override func dataReceived(slice: ArraySlice<UInt8>) {
        inputDetector?.processOutput(slice)
        super.dataReceived(slice: slice)
    }
}
