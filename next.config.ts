import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: "export",
  basePath: "/ClaudeControl",
  images: {
    unoptimized: true,
  },
};

export default nextConfig;
