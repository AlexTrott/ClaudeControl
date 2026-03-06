export const SITE = {
  name: "ClaudeControl",
  title: "ClaudeControl - Command Your Claude Sessions",
  description:
    "A native macOS menu bar app for managing multiple Claude Code terminal sessions. Get notified when Claude needs your input, resume past sessions, and stay in control.",
  github: "https://github.com/alextrott/ClaudeControl",
  releases: "https://github.com/alextrott/ClaudeControl/releases",
};

export const FEATURES = [
  {
    icon: "Layers" as const,
    title: "Multi-Session Management",
    description:
      "Run multiple Claude Code sessions simultaneously, each in its own floating terminal window. Switch between projects without losing context.",
    colSpan: 2,
  },
  {
    icon: "BellRing" as const,
    title: "Smart Input Detection",
    description:
      "Automatically detects when Claude is waiting for your input. Get native macOS notifications so you never miss a prompt.",
    colSpan: 1,
  },
  {
    icon: "History" as const,
    title: "Session History & Resume",
    description:
      "Browse previous sessions grouped by project. Resume any past conversation right where you left off with full context recovery.",
    colSpan: 2,
  },
  {
    icon: "Monitor" as const,
    title: "Native macOS Integration",
    description:
      "Lives in your menu bar, always one click away. Floating panels stay visible across all Spaces and desktops.",
    colSpan: 1,
  },
  {
    icon: "Activity" as const,
    title: "Real-Time Status",
    description:
      "See at a glance which sessions are running, which need input, and which have stopped. Color-coded indicators update in real time.",
    colSpan: 1,
  },
  {
    icon: "Zap" as const,
    title: "Zero Configuration",
    description:
      "No setup required. ClaudeControl automatically finds your Claude CLI and inherits your shell environment.",
    colSpan: 2,
  },
];

export const STEPS = [
  {
    number: "01",
    icon: "Download" as const,
    title: "Install",
    description:
      "Download the latest release from GitHub or build from source with Xcode.",
  },
  {
    number: "02",
    icon: "Rocket" as const,
    title: "Launch",
    description:
      "ClaudeControl appears in your menu bar. Click to open the session manager.",
  },
  {
    number: "03",
    icon: "Sliders" as const,
    title: "Control",
    description:
      "Create sessions, switch between projects, and get notified when Claude needs you.",
  },
];
