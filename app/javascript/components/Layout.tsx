import { usePage } from "@inertiajs/react";
import Navbar from "./Navbar";
import { useNotifications } from "../hooks/useNotifications";
import type { SharedProps } from "../types";

interface LayoutProps {
  children: React.ReactNode
}

export default function Layout({ children }: LayoutProps) {
  const { currentUser } = usePage<SharedProps>().props;
  const { notification, dismiss } = useNotifications(currentUser?.email ?? null);

  return (
    <div className="min-h-screen bg-gray-50">
      <Navbar />
      {notification && (
        <div role="alert" className="bg-blue-600 text-white px-4 py-3 flex items-center justify-between gap-4">
          <span>
            <span className="font-semibold">{notification.shared_by}</span> shared a new video:{" "}
            <span className="font-semibold">{notification.title}</span>
          </span>
          <button
            onClick={dismiss}
            aria-label="Dismiss notification"
            className="shrink-0 text-white hover:text-blue-200 text-lg leading-none"
          >
            ✕
          </button>
        </div>
      )}
      <main className="max-w-7xl mx-auto px-4 py-8">
        {children}
      </main>
    </div>
  );
}
