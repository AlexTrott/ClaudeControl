import clsx from "clsx";

export function SectionWrapper({
  children,
  className,
  id,
}: {
  children: React.ReactNode;
  className?: string;
  id?: string;
}) {
  return (
    <section id={id} className={clsx("max-w-6xl mx-auto px-6", className)}>
      {children}
    </section>
  );
}
