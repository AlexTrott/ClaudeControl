"use client";

import { Layers, BellRing, History, Monitor, Activity, Zap } from "lucide-react";
import { GlassCard } from "./ui/GlassCard";
import { SectionWrapper } from "./ui/SectionWrapper";
import { AnimateOnScroll } from "./ui/AnimateOnScroll";
import { FEATURES } from "@/lib/constants";

const iconMap = {
  Layers,
  BellRing,
  History,
  Monitor,
  Activity,
  Zap,
};

export function Features() {
  return (
    <SectionWrapper id="features" className="py-24">
      <AnimateOnScroll>
        <p className="text-accent-purple text-sm font-medium tracking-wider uppercase mb-4">
          Features
        </p>
        <h2 className="text-3xl md:text-4xl font-bold mb-4">
          Everything you need to stay in control
        </h2>
        <p className="text-text-secondary text-lg max-w-2xl mb-16">
          Built for developers who run multiple Claude Code sessions across projects.
        </p>
      </AnimateOnScroll>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {FEATURES.map((feature, i) => {
          const Icon = iconMap[feature.icon];
          return (
            <AnimateOnScroll
              key={feature.title}
              delay={i * 0.1}
              className={feature.colSpan === 2 ? "lg:col-span-2" : ""}
            >
              <GlassCard className="h-full md:p-8">
                <div
                  className="w-10 h-10 rounded-xl flex items-center justify-center mb-4"
                  style={{
                    background: "linear-gradient(135deg, rgba(168,85,247,0.15), rgba(59,130,246,0.15))",
                  }}
                >
                  <Icon size={20} className="text-accent-purple" />
                </div>
                <h3 className="text-lg font-semibold mb-2 text-text-primary">
                  {feature.title}
                </h3>
                <p className="text-text-secondary text-sm leading-relaxed">
                  {feature.description}
                </p>
              </GlassCard>
            </AnimateOnScroll>
          );
        })}
      </div>
    </SectionWrapper>
  );
}
