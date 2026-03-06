"use client";

export function MenuBarMockup() {
  return (
    <div className="relative mx-auto max-w-sm animate-float">
      {/* Glow effect behind the mockup */}
      <div className="absolute inset-0 rounded-2xl bg-accent-purple/10 blur-3xl" />

      {/* Mockup container */}
      <div className="glass relative rounded-2xl p-1" style={{ boxShadow: "0 0 40px rgba(168, 85, 247, 0.15), 0 0 80px rgba(59, 130, 246, 0.08)" }}>
        <div className="rounded-xl overflow-hidden" style={{ background: "#13131f" }}>
          {/* Header */}
          <div className="flex items-center justify-between px-4 py-3 border-b border-surface-border">
            <div className="flex items-center gap-2">
              <ClaudeIcon />
              <span className="text-sm font-semibold text-text-primary">ClaudeControl</span>
            </div>
            <div className="flex items-center gap-2">
              <span className="text-xs font-medium px-2 py-0.5 rounded-full" style={{ background: "rgba(168, 85, 247, 0.15)", color: "#c084fc" }}>
                2
              </span>
              <button className="w-6 h-6 rounded-lg flex items-center justify-center text-text-secondary hover:text-text-primary transition-colors" style={{ background: "rgba(255,255,255,0.05)" }}>
                <PlusIcon />
              </button>
            </div>
          </div>

          {/* Session rows */}
          <div className="p-2 space-y-1">
            {/* Running session */}
            <div className="flex items-center gap-3 px-3 py-2.5 rounded-lg transition-colors" style={{ background: "rgba(255,255,255,0.02)" }}>
              <div className="w-[3px] h-8 rounded-full bg-status-running shrink-0" />
              <div className="flex-1 min-w-0">
                <div className="flex items-center justify-between">
                  <span className="text-sm font-medium text-text-primary">my-project</span>
                  <span className="text-[10px] text-text-tertiary">2m ago</span>
                </div>
                <span className="text-[11px] font-mono text-text-tertiary">~/Developer/my-project</span>
              </div>
            </div>

            {/* Awaiting input session */}
            <div className="flex items-center gap-3 px-3 py-2.5 rounded-lg transition-colors" style={{ background: "rgba(255,255,255,0.02)" }}>
              <div className="w-[3px] h-8 rounded-full bg-status-awaiting shrink-0 animate-glow-pulse" />
              <div className="flex-1 min-w-0">
                <div className="flex items-center justify-between">
                  <span className="text-sm font-medium text-text-primary">api-service</span>
                  <span className="inline-flex items-center gap-1 text-[10px] font-medium px-1.5 py-0.5 rounded-full" style={{ background: "rgba(249, 115, 22, 0.12)", color: "#fb923c" }}>
                    <span className="w-1.5 h-1.5 rounded-full bg-status-awaiting animate-pulse" />
                    Input needed
                  </span>
                </div>
                <span className="text-[11px] font-mono text-text-tertiary">~/Developer/api-service</span>
              </div>
            </div>
          </div>

          {/* Footer */}
          <div className="flex items-center justify-between px-4 py-2.5 border-t border-surface-border">
            <ClockIcon />
            <span className="text-[11px] text-text-tertiary">v1.0</span>
            <span className="text-[11px] text-text-tertiary cursor-pointer hover:text-text-secondary transition-colors">Quit</span>
          </div>
        </div>
      </div>
    </div>
  );
}

function ClaudeIcon() {
  return (
    <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
      <circle cx="8" cy="8" r="7" stroke="url(#icon-gradient)" strokeWidth="1.5" fill="none" />
      <circle cx="8" cy="8" r="3" fill="url(#icon-gradient)" />
      <defs>
        <linearGradient id="icon-gradient" x1="0" y1="0" x2="16" y2="16">
          <stop stopColor="#a855f7" />
          <stop offset="1" stopColor="#3b82f6" />
        </linearGradient>
      </defs>
    </svg>
  );
}

function PlusIcon() {
  return (
    <svg width="12" height="12" viewBox="0 0 12 12" fill="currentColor">
      <path d="M6 1v10M1 6h10" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" fill="none" />
    </svg>
  );
}

function ClockIcon() {
  return (
    <svg width="12" height="12" viewBox="0 0 12 12" fill="none" className="text-text-tertiary">
      <circle cx="6" cy="6" r="5" stroke="currentColor" strokeWidth="1" />
      <path d="M6 3v3l2 1" stroke="currentColor" strokeWidth="1" strokeLinecap="round" />
    </svg>
  );
}
