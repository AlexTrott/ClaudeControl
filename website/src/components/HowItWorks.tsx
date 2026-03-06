"use client";

import { Download, Rocket, Sliders } from "lucide-react";
import { GlassCard } from "./ui/GlassCard";
import { SectionWrapper } from "./ui/SectionWrapper";
import { AnimateOnScroll } from "./ui/AnimateOnScroll";
import { STEPS } from "@/lib/constants";

const iconMap = {
  Download,
  Rocket,
  Sliders,
};

export function HowItWorks() {
  return (
    <SectionWrapper id="how-it-works" className="py-24">
      <AnimateOnScroll>
        <p className="text-accent-blue text-sm font-medium tracking-wider uppercase mb-4">
          Getting Started
        </p>
        <h2 className="text-3xl md:text-4xl font-bold mb-4">
          Up and running in seconds
        </h2>
        <p className="text-text-secondary text-lg max-w-2xl mb-16">
          Three simple steps to take control of your Claude Code workflow.
        </p>
      </AnimateOnScroll>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-8 relative">
        {/* Connecting line (desktop only) */}
        <div
          className="hidden md:block absolute top-1/2 left-[16.67%] right-[16.67%] h-px -translate-y-1/2 z-0"
          style={{
            background: "linear-gradient(90deg, rgba(168,85,247,0.3), rgba(59,130,246,0.3), rgba(20,184,166,0.3))",
          }}
        />

        {STEPS.map((step, i) => {
          const Icon = iconMap[step.icon];
          return (
            <AnimateOnScroll key={step.title} delay={i * 0.15}>
              <GlassCard className="relative text-center z-10" hover={false}>
                {/* Step number */}
                <span className="absolute -top-3 -left-1 text-6xl font-bold text-accent-purple/10 select-none pointer-events-none">
                  {step.number}
                </span>
                {/* Icon */}
                <div
                  className="w-12 h-12 rounded-xl flex items-center justify-center mx-auto mb-4"
                  style={{
                    background: "linear-gradient(135deg, rgba(168,85,247,0.15), rgba(59,130,246,0.15))",
                  }}
                >
                  <Icon size={22} className="text-accent-blue" />
                </div>
                <h3 className="text-lg font-semibold mb-2 text-text-primary">
                  {step.title}
                </h3>
                <p className="text-text-secondary text-sm leading-relaxed">
                  {step.description}
                </p>
              </GlassCard>
            </AnimateOnScroll>
          );
        })}
      </div>
    </SectionWrapper>
  );
}
