import clsx from "clsx";

export function GlassCard({
  children,
  className,
  hover = true,
}: {
  children: React.ReactNode;
  className?: string;
  hover?: boolean;
}) {
  return (
    <div className={clsx(hover ? "glass-hover" : "glass", "rounded-2xl p-6", className)}>
      {children}
    </div>
  );
}
