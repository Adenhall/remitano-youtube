# Agent Guidelines — Remitano YouTube

## Project overview

A YouTube video-sharing web app. Users register/log in, share YouTube video URLs, browse the shared-video feed, and receive real-time notifications when another user posts a new video.

**Stack:** Rails 8.1 · React 19 · Inertia.js 3 · Tailwind CSS v4 · PostgreSQL · ActionCable · Solid Queue · Vite

---

## Features

| # | Feature | Status |
|---|---------|--------|
| 1 | User registration & login | In progress (PR #4) |
| 2 | Share a YouTube video (URL → title/embed) | Pending |
| 3 | Home feed — list of shared videos, newest first | Pending |
| 4 | Real-time notification when any user shares a video | Pending |
| 5 | Docker + docker-compose for local orchestration | Pending |

Out of scope: likes/dislikes are not part of the core spec (the wireframes show the button but the requirements explicitly say "no need to display up/down votes").

---

## Tech stack decisions

- **No Redis.** ActionCable uses Solid Cable (DB-backed). Background jobs use Solid Queue. Keep it that way.
- **Inertia.js** is the glue layer — Rails controllers call `render inertia:` with props; React components receive them as regular props via `usePage`. No separate API layer.
- **Vite** bundles the frontend (`vite_rails` gem + `@vitejs/plugin-react`). Run `bin/dev` to start both Rails and Vite together.
- **Tailwind CSS v4** via `@tailwindcss/vite` — no config file needed, import in CSS.

---

## Repository layout

```
app/
  controllers/          # Rails controllers — thin, delegate to models/services
  javascript/
    components/         # Shared React components (Navbar, Layout)
    entrypoints/        # inertia.tsx — Inertia app bootstrap
    pages/              # One directory per page: pages/Home/index.tsx
    types/              # Shared TypeScript types (SharedProps, etc.)
  models/               # ActiveRecord models
test/
  controllers/          # Integration tests (ActionDispatch::IntegrationTest)
  models/               # Unit tests
  system/               # Capybara system tests
```

---

## Coding conventions

### General
- Conventional Commits (`feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`).
- One logical change per commit. Open a PR per feature.
- No commented-out code. No `TODO` left in production files.

### TDD — non-negotiable
1. Write the failing test first.
2. Run it — confirm it fails for the right reason.
3. Write the minimal production code to pass.
4. Run the suite — all green before committing.

### Rails
- Keep controllers thin. Business logic belongs in models or plain service objects.
- `inertia_share` in `ApplicationController` for data every page needs (`currentUser`, `flash`).
- `allow_unauthenticated_access` marks public actions. `resume_session` runs as a separate `before_action` so `Current.user` is always populated on public pages too.
- All redirects from `SessionsController` go to `root_path` (Inertia SPA pattern — no separate login page).
- Use `params.permit(...)` explicitly; never `params.require(...).permit!`.

### React / TypeScript
- Page components live in `pages/<Name>/index.tsx`.
- Wrap every page in `<Layout>` (which renders `<Navbar>`).
- Read shared props with `usePage<SharedProps>().props`.
- Use `useForm` from `@inertiajs/react` for all form submissions.
- Prefer `router.delete` / `router.post` for non-form navigations (e.g., logout).

### Testing
- Controller tests use `ActionDispatch::IntegrationTest`.
- Assert Inertia props with `inertia.props[:key]` (provided by `InertiaRails::Testing::Helpers`).
- Fixtures go in `test/fixtures/`. Use `users(:one)` / `users(:two)` for existing users.
- The fixture password for both users is `"password"` — use that in login tests.
- Valid test passwords for new-user creation must meet the password policy: ≥ 8 chars, one digit, one special character (e.g. `"Password1!"`).
- Minitest 6 (bundled with Rails 8) has no `Minitest::Mock`. Use `define_singleton_method` / `define_method` with an `ensure` block to patch and restore class-level behavior in tests.

---

## Authentication

- `has_secure_password` + Rails 8 `Authentication` concern.
- `Current.session` and `Current.user` are set by `resume_session` on every request.
- `require_authentication` blocks unauthenticated access; `allow_unauthenticated_access` exempts specific actions.
- Registration and login share a single `POST /session` endpoint — if the email exists, authenticate; otherwise create the account.
- Password policy: minimum 8 characters, at least one digit, at least one special character.

---

## Real-time notifications (ActionCable)

When a video is shared, broadcast a notification to all connected clients except the sharer. Use a background job (Solid Queue) to enqueue the broadcast so the HTTP response is not delayed.

- Channel: `NotificationsChannel` — streams from `"notifications"`.
- Payload: `{ title:, shared_by: }`.
- Frontend: subscribe in a React hook on mount, display a dismissible banner/toast.

---

## CI pipeline (`.github/workflows/ci.yml`)

Jobs: `scan_ruby` (Brakeman + bundler-audit), `scan_js` (npm audit), `lint` (RuboCop), `test`, `system-test`.

Before pushing, run locally:
```bash
bin/brakeman --no-pager
bin/rubocop
bin/rails test
bin/rails test:system
```

The `test` and `system-test` jobs require Node + `npm ci` — both are wired up in CI already.

---

## Environment

| Tool | Version |
|------|---------|
| Ruby | 3.4.1 |
| Node.js | ≥ 22 |
| PostgreSQL | 14+ |

Use `bin/dev` for development (starts Rails + Vite via `Procfile.dev`).

Database: `bin/rails db:create db:migrate` — no seed data required for development.
