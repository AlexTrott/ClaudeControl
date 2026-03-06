import { Navbar } from "@/components/Navbar";
import { Hero } from "@/components/Hero";
import { Features } from "@/components/Features";
import { HowItWorks } from "@/components/HowItWorks";
import { DownloadCTA } from "@/components/DownloadCTA";
import { Footer } from "@/components/Footer";

export default function Home() {
  return (
    <main className="relative overflow-x-hidden">
      {/* Background gradient orbs */}
      <div className="orb orb-coral" style={{ width: 600, height: 600, top: -200, left: -100 }} />
      <div className="orb orb-amber" style={{ width: 500, height: 500, top: 700, right: -200 }} />
      <div className="orb orb-teal" style={{ width: 400, height: 400, bottom: 400, left: -150 }} />

      <Navbar />
      <Hero />
      <Features />
      <HowItWorks />
      <DownloadCTA />
      <Footer />
    </main>
  );
}
