import clsx from "clsx";

export function GradientButton({
  children,
  href,
  variant = "primary",
  size = "md",
  className,
}: {
  children: React.ReactNode;
  href: string;
  variant?: "primary" | "secondary";
  size?: "sm" | "md" | "lg";
  className?: string;
}) {
  const sizeClasses = {
    sm: "px-4 py-2 text-sm",
    md: "px-6 py-3 text-base",
    lg: "px-8 py-4 text-lg",
  };

  return (
    <a
      href={href}
      target="_blank"
      rel="noopener noreferrer"
      className={clsx(
        "inline-flex items-center gap-2 rounded-xl font-medium transition-all duration-300",
        sizeClasses[size],
        variant === "primary"
          ? "gradient-button text-white"
          : "glass text-text-primary hover:bg-surface-hover",
        className
      )}
    >
      {children}
    </a>
  );
}
