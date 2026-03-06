import { Github } from "lucide-react";
import { SITE } from "@/lib/constants";

export function Footer() {
  return (
    <footer className="border-t border-surface-border">
      <div className="max-w-6xl mx-auto px-6 py-8 flex flex-col md:flex-row items-center justify-between gap-4 text-text-tertiary text-sm">
        <span className="font-medium text-text-secondary">ClaudeControl</span>
        <span>Built with SwiftUI for macOS</span>
        <div className="flex items-center gap-4">
          <a
            href={SITE.github}
            target="_blank"
            rel="noopener noreferrer"
            className="hover:text-text-secondary transition-colors"
            aria-label="GitHub"
          >
            <Github size={16} />
          </a>
          <span>Made by Alex Trott</span>
        </div>
      </div>
    </footer>
  );
}
