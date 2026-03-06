import SwiftUI

struct SettingsView: View {
    @State private var settings = AppSettings.shared
    @State private var newPatternText = ""

    var body: some View {
        Form {
            Section("General") {
                Toggle("Launch at Login", isOn: $settings.launchAtLogin)
            }

            Section("Notifications") {
                Toggle("Show notifications when input is needed", isOn: $settings.notificationsEnabled)
                Toggle("Tint menu bar icon when awaiting input", isOn: $settings.iconTintEnabled)
            }

            Section("Input Detection") {
                Picker("Idle threshold", selection: $settings.idleThresholdSeconds) {
                    Text("Sensitive (1s)").tag(1.0)
                    Text("Balanced (2s)").tag(2.0)
                    Text("Relaxed (4s)").tag(4.0)
                }
                .pickerStyle(.segmented)
            }

            Section("Claude CLI") {
                TextField("Custom path (leave empty for auto-detect)", text: $settings.customClaudePath)
                    .textFieldStyle(.roundedBorder)
                if !settings.customClaudePath.isEmpty {
                    let exists = FileManager.default.fileExists(atPath: settings.customClaudePath)
                    Label(
                        exists ? "Path is valid" : "File not found",
                        systemImage: exists ? "checkmark.circle.fill" : "xmark.circle.fill"
                    )
                    .foregroundStyle(exists ? .green : .red)
                    .font(.caption)
                }
            }

            Section("Default Session Directory") {
                HStack {
                    TextField("Default directory (optional)", text: $settings.defaultSessionDirectory)
                        .textFieldStyle(.roundedBorder)
                    Button("Browse...") {
                        let panel = NSOpenPanel()
                        panel.canChooseFiles = false
                        panel.canChooseDirectories = true
                        panel.allowsMultipleSelection = false
                        if panel.runModal() == .OK, let url = panel.url {
                            settings.defaultSessionDirectory = url.path
                        }
                    }
                }
                if !settings.defaultSessionDirectory.isEmpty {
                    Button("Clear") {
                        settings.defaultSessionDirectory = ""
                    }
                    .foregroundStyle(.secondary)
                }
            }

            Section("Terminal Window Size") {
                Picker("Size preset", selection: terminalSizePresetBinding) {
                    Text("Small (600×400)").tag("small")
                    Text("Medium (800×600)").tag("medium")
                    Text("Large (1200×800)").tag("large")
                    Text("Custom").tag("custom")
                }
                if isCustomSize {
                    HStack {
                        TextField("Width", value: $settings.terminalWidth, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 80)
                        Text("×")
                        TextField("Height", value: $settings.terminalHeight, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 80)
                    }
                }
            }

            Section("Custom Prompt Patterns") {
                Text("Additional patterns that trigger \"awaiting input\" detection. Built-in patterns are always active.")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                ForEach(settings.customPromptPatterns, id: \.self) { pattern in
                    HStack {
                        Text(pattern)
                            .font(.system(.body, design: .monospaced))
                        Spacer()
                        Button {
                            settings.customPromptPatterns.removeAll { $0 == pattern }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundStyle(.red)
                        }
                        .buttonStyle(.plain)
                    }
                }

                HStack {
                    TextField("New pattern...", text: $newPatternText)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit { addPattern() }
                    Button("Add") { addPattern() }
                        .disabled(newPatternText.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
        .formStyle(.grouped)
        .frame(minWidth: 480, idealWidth: 480, maxWidth: 480, minHeight: 500)
    }

    // MARK: - Helpers

    private func addPattern() {
        let trimmed = newPatternText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, !settings.customPromptPatterns.contains(trimmed) else { return }
        settings.customPromptPatterns.append(trimmed)
        newPatternText = ""
    }

    private var isCustomSize: Bool {
        ![(600, 400), (800, 600), (1200, 800)].contains { $0.0 == settings.terminalWidth && $0.1 == settings.terminalHeight }
    }

    private var terminalSizePresetBinding: Binding<String> {
        Binding(
            get: {
                switch (settings.terminalWidth, settings.terminalHeight) {
                case (600, 400): return "small"
                case (800, 600): return "medium"
                case (1200, 800): return "large"
                default: return "custom"
                }
            },
            set: { preset in
                switch preset {
                case "small":
                    settings.terminalWidth = 600
                    settings.terminalHeight = 400
                case "medium":
                    settings.terminalWidth = 800
                    settings.terminalHeight = 600
                case "large":
                    settings.terminalWidth = 1200
                    settings.terminalHeight = 800
                default:
                    break
                }
            }
        )
    }
}
