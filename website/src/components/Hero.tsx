"use client";

import { Download, Github } from "lucide-react";
import { GradientButton } from "./ui/GradientButton";
import { MenuBarMockup } from "./ui/MenuBarMockup";
import { AnimateOnScroll } from "./ui/AnimateOnScroll";
import { SITE } from "@/lib/constants";

export function Hero() {
  return (
    <section className="pt-32 pb-20 px-6">
      <div className="max-w-4xl mx-auto text-center">
        <AnimateOnScroll>
          {/* Badge */}
          <div className="inline-flex items-center gap-2 glass rounded-full px-4 py-1.5 text-sm text-text-secondary mb-8">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <rect x="2" y="3" width="20" height="14" rx="2" />
              <path d="M8 21h8M12 17v4" />
            </svg>
            Native macOS Menu Bar App
          </div>
        </AnimateOnScroll>

        {/* Headline */}
        <AnimateOnScroll delay={0.1}>
          <h1 className="text-5xl md:text-7xl font-bold tracking-tight leading-[1.1] mb-6">
            Command Your{" "}
            <span className="gradient-text">Claude Sessions</span>
          </h1>
        </AnimateOnScroll>

        {/* Subtitle */}
        <AnimateOnScroll delay={0.2}>
          <p className="text-lg md:text-xl text-text-secondary max-w-2xl mx-auto mb-10 leading-relaxed">
            A lightweight macOS menu bar app for managing multiple Claude Code sessions.
            Get notified when Claude needs your input, resume past sessions, and stay in control across all your projects.
          </p>
        </AnimateOnScroll>

        {/* CTAs */}
        <AnimateOnScroll delay={0.3}>
          <div className="flex flex-col sm:flex-row items-center justify-center gap-4">
            <GradientButton href={SITE.releases} size="lg">
              <Download size={18} />
              Download on GitHub
            </GradientButton>
            <GradientButton href={SITE.github} variant="secondary" size="lg">
              <Github size={18} />
              View Source
            </GradientButton>
          </div>
        </AnimateOnScroll>

        {/* Hero Visual */}
        <AnimateOnScroll delay={0.5}>
          <div className="mt-16">
            <MenuBarMockup />
          </div>
        </AnimateOnScroll>
      </div>
    </section>
  );
}
