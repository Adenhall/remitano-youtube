import { useState } from "react";
import { useForm, usePage, router } from "@inertiajs/react";
import type { SharedProps } from "../types";

export default function Navbar() {
  const { currentUser, flash } = usePage<SharedProps>().props;
  const [menuOpen, setMenuOpen] = useState(false);
  const { data, setData, post, processing } = useForm({
    email_address: "",
    password: "",
  });

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    post("/session", { preserveScroll: true });
    setMenuOpen(false);
  }

  function handleLogout() {
    router.delete("/session");
  }

  return (
    <header className="bg-white border-b border-gray-200">
      <div className="max-w-7xl mx-auto px-4 py-3 flex items-center justify-between gap-4">
        <a href="/" className="flex items-center gap-2 text-xl font-bold text-gray-900 shrink-0">
          🏠 Remitano YouTube
        </a>

        {/* Desktop nav */}
        {currentUser ? (
          <div className="hidden sm:flex items-center gap-3">
            <span className="text-sm text-gray-600">Welcome {currentUser.email}</span>
            <a
              href="/videos/new"
              className="px-3 py-1.5 text-sm border border-gray-900 rounded hover:bg-gray-100"
            >
              Share a movie
            </a>
            <button
              onClick={handleLogout}
              className="px-3 py-1.5 text-sm border border-gray-900 rounded hover:bg-gray-100"
            >
              Logout
            </button>
          </div>
        ) : (
          <form onSubmit={handleSubmit} className="hidden sm:flex items-center gap-2">
            <input
              type="email"
              placeholder="email"
              value={data.email_address}
              onChange={(e) => setData("email_address", e.target.value)}
              required
              className="border border-gray-300 rounded px-2 py-1.5 text-sm w-44"
            />
            <input
              type="password"
              placeholder="password"
              value={data.password}
              onChange={(e) => setData("password", e.target.value)}
              required
              className="border border-gray-300 rounded px-2 py-1.5 text-sm w-32"
            />
            <button
              type="submit"
              disabled={processing}
              className="px-3 py-1.5 text-sm border border-gray-900 rounded hover:bg-gray-100 disabled:opacity-50"
            >
              Login / Register
            </button>
          </form>
        )}

        {/* Hamburger button — mobile only */}
        <button
          className="sm:hidden p-2 rounded hover:bg-gray-100"
          onClick={() => setMenuOpen((o) => !o)}
          aria-label="Toggle menu"
          aria-expanded={menuOpen}
        >
          {menuOpen ? (
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
            </svg>
          ) : (
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
            </svg>
          )}
        </button>
      </div>

      {/* Mobile menu */}
      {menuOpen && (
        <div className="sm:hidden border-t border-gray-100 px-4 py-4">
          {currentUser ? (
            <div className="flex flex-col gap-3">
              <p className="text-sm text-gray-600">Welcome {currentUser.email}</p>
              <a
                href="/videos/new"
                className="px-3 py-2 text-sm border border-gray-900 rounded hover:bg-gray-100 text-center"
                onClick={() => setMenuOpen(false)}
              >
                Share a movie
              </a>
              <button
                onClick={handleLogout}
                className="px-3 py-2 text-sm border border-gray-900 rounded hover:bg-gray-100"
              >
                Logout
              </button>
            </div>
          ) : (
            <form onSubmit={handleSubmit} className="flex flex-col gap-3">
              <input
                type="email"
                placeholder="email"
                value={data.email_address}
                onChange={(e) => setData("email_address", e.target.value)}
                required
                className="border border-gray-300 rounded px-3 py-2 text-sm w-full"
              />
              <input
                type="password"
                placeholder="password"
                value={data.password}
                onChange={(e) => setData("password", e.target.value)}
                required
                className="border border-gray-300 rounded px-3 py-2 text-sm w-full"
              />
              <button
                type="submit"
                disabled={processing}
                className="px-3 py-2 text-sm border border-gray-900 rounded hover:bg-gray-100 disabled:opacity-50"
              >
                Login / Register
              </button>
            </form>
          )}
        </div>
      )}

      {(flash.notice || flash.alert) && (
        <div className={`text-center text-sm py-2 px-4 ${flash.notice ? "bg-green-50 text-green-800" : "bg-red-50 text-red-800"}`}>
          {flash.notice || flash.alert}
        </div>
      )}
    </header>
  );
}
