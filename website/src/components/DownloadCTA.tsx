"use client";

import { Download } from "lucide-react";
import { GradientButton } from "./ui/GradientButton";
import { SectionWrapper } from "./ui/SectionWrapper";
import { AnimateOnScroll } from "./ui/AnimateOnScroll";
import { SITE } from "@/lib/constants";

export function DownloadCTA() {
  return (
    <SectionWrapper className="py-24">
      <AnimateOnScroll>
        <div className="glass rounded-3xl p-12 md:p-16 text-center relative overflow-hidden">
          {/* Background orb */}
          <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[400px] h-[400px] rounded-full orb-purple opacity-10 pointer-events-none" />

          <h2 className="text-3xl md:text-4xl font-bold mb-4 relative z-10">
            Ready to take control?
          </h2>
          <p className="text-text-secondary text-lg mb-8 max-w-xl mx-auto relative z-10">
            ClaudeControl is free and open source. Download the latest release or build it yourself from source.
          </p>
          <div className="relative z-10 flex flex-col sm:flex-row items-center justify-center gap-4">
            <GradientButton href={SITE.releases} size="lg">
              <Download size={18} />
              Download from GitHub
            </GradientButton>
          </div>
          <p className="text-text-tertiary text-sm mt-6 relative z-10">
            Requires macOS 14.0+ and Claude Code CLI
          </p>
        </div>
      </AnimateOnScroll>
    </SectionWrapper>
  );
}
