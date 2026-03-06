import { Github, Download } from "lucide-react";
import { SITE } from "@/lib/constants";

export function Navbar() {
  return (
    <nav className="fixed top-0 left-0 right-0 z-50 border-b border-surface-border" style={{ background: "rgba(10, 10, 15, 0.8)", backdropFilter: "blur(24px)", WebkitBackdropFilter: "blur(24px)" }}>
      <div className="max-w-6xl mx-auto px-6 h-16 flex items-center justify-between">
        {/* Logo */}
        <div className="flex items-center gap-2.5">
          <div className="w-7 h-7 rounded-lg flex items-center justify-center" style={{ background: "linear-gradient(135deg, rgba(230,113,78,0.2), rgba(230,168,78,0.2))" }}>
            <svg width="14" height="14" viewBox="0 0 16 16" fill="none">
              <circle cx="8" cy="8" r="7" stroke="url(#nav-gradient)" strokeWidth="1.5" fill="none" />
              <circle cx="8" cy="8" r="3" fill="url(#nav-gradient)" />
              <defs>
                <linearGradient id="nav-gradient" x1="0" y1="0" x2="16" y2="16">
                  <stop stopColor="#E6714E" />
                  <stop offset="1" stopColor="#E6A84E" />
                </linearGradient>
              </defs>
            </svg>
          </div>
          <span className="text-lg font-semibold text-text-primary">ClaudeControl</span>
        </div>

        {/* Right side */}
        <div className="flex items-center gap-3">
          <a
            href={SITE.github}
            target="_blank"
            rel="noopener noreferrer"
            className="text-text-secondary hover:text-text-primary transition-colors p-2"
            aria-label="View on GitHub"
          >
            <Github size={20} />
          </a>
          <a
            href={SITE.releases}
            target="_blank"
            rel="noopener noreferrer"
            className="gradient-button inline-flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-medium text-white"
          >
            <Download size={14} />
            Download
          </a>
        </div>
      </div>
    </nav>
  );
}
