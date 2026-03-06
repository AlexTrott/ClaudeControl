import Foundation
import ServiceManagement

@Observable
final class AppSettings {
    static let shared = AppSettings()

    private let defaults = UserDefaults.standard

    private enum Keys {
        static let notificationsEnabled = "notificationsEnabled"
        static let iconTintEnabled = "iconTintEnabled"
        static let idleThresholdSeconds = "idleThresholdSeconds"
        static let customClaudePath = "customClaudePath"
        static let defaultSessionDirectory = "defaultSessionDirectory"
        static let terminalWidth = "terminalWidth"
        static let terminalHeight = "terminalHeight"
        static let customPromptPatterns = "customPromptPatterns"
    }

    // MARK: - Launch at Login

    var launchAtLogin: Bool {
        get { SMAppService.mainApp.status == .enabled }
        set {
            try? newValue
                ? SMAppService.mainApp.register()
                : SMAppService.mainApp.unregister()
        }
    }

    // MARK: - Notifications

    var notificationsEnabled: Bool {
        didSet { defaults.set(notificationsEnabled, forKey: Keys.notificationsEnabled) }
    }

    var iconTintEnabled: Bool {
        didSet { defaults.set(iconTintEnabled, forKey: Keys.iconTintEnabled) }
    }

    // MARK: - Input Detection

    var idleThresholdSeconds: Double {
        didSet { defaults.set(idleThresholdSeconds, forKey: Keys.idleThresholdSeconds) }
    }

    // MARK: - Claude Path

    var customClaudePath: String {
        didSet { defaults.set(customClaudePath, forKey: Keys.customClaudePath) }
    }

    // MARK: - Default Directory

    var defaultSessionDirectory: String {
        didSet { defaults.set(defaultSessionDirectory, forKey: Keys.defaultSessionDirectory) }
    }

    // MARK: - Terminal Size

    var terminalWidth: Int {
        didSet { defaults.set(terminalWidth, forKey: Keys.terminalWidth) }
    }

    var terminalHeight: Int {
        didSet { defaults.set(terminalHeight, forKey: Keys.terminalHeight) }
    }

    // MARK: - Custom Prompt Patterns

    var customPromptPatterns: [String] {
        didSet { defaults.set(customPromptPatterns, forKey: Keys.customPromptPatterns) }
    }

    // MARK: - Init

    private init() {
        defaults.register(defaults: [
            Keys.notificationsEnabled: true,
            Keys.iconTintEnabled: true,
            Keys.idleThresholdSeconds: 2.0,
            Keys.customClaudePath: "",
            Keys.defaultSessionDirectory: "",
            Keys.terminalWidth: 800,
            Keys.terminalHeight: 600,
            Keys.customPromptPatterns: [String](),
        ])

        self.notificationsEnabled = defaults.bool(forKey: Keys.notificationsEnabled)
        self.iconTintEnabled = defaults.bool(forKey: Keys.iconTintEnabled)
        self.idleThresholdSeconds = defaults.double(forKey: Keys.idleThresholdSeconds)
        self.customClaudePath = defaults.string(forKey: Keys.customClaudePath) ?? ""
        self.defaultSessionDirectory = defaults.string(forKey: Keys.defaultSessionDirectory) ?? ""
        self.terminalWidth = defaults.integer(forKey: Keys.terminalWidth)
        self.terminalHeight = defaults.integer(forKey: Keys.terminalHeight)
        self.customPromptPatterns = defaults.stringArray(forKey: Keys.customPromptPatterns) ?? []
    }
}
