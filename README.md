# Remitano YouTube

## Introduction

A web app for sharing YouTube videos. Users register or log in, paste a YouTube URL to share a video, and browse the community feed. When a video is shared, all other logged-in users receive a real-time notification showing the video title and the sharer's name — powered by WebSockets (ActionCable) and background jobs (Solid Queue).

**Key features:**
- User registration & login (single combined form — no separate sign-up page)
- Share a YouTube video by URL — title is fetched automatically via YouTube oEmbed (no API key required)
- Home feed listing all shared videos (newest first) with embedded player
- Real-time notifications to other logged-in users on each new share (coming soon)

**Stack:** Rails 8.1 · React 19 · Inertia.js · Tailwind CSS v4 · PostgreSQL · ActionCable · Solid Queue · Vite

---

## Prerequisites

| Tool | Version |
|------|---------|
| Ruby | 3.4.1 |
| Node.js | ≥ 22 |
| npm | ≥ 10 |
| PostgreSQL | 14+ |

> **Docker users:** Docker + Docker Compose is all you need — skip to [Docker Deployment](#docker-deployment).

---

## Installation & Configuration

```bash
git clone https://github.com/Adenhall/remitano-youtube.git
cd remitano-youtube
bundle install
npm install
```

No extra credentials configuration is required for local development.

---

## Database Setup

```bash
bin/rails db:create db:migrate
```

No seed data is required; the app starts with an empty video feed.

---

## Running the Application

```bash
bin/dev
```

Starts both the Rails server and the Vite dev server (with HMR) via `Procfile.dev`. Open [http://localhost:3000](http://localhost:3000).

### Running Tests

```bash
bin/rails test           # unit + integration tests
bin/rails test:system    # system tests (requires Chrome)
```

---

## Docker Deployment

Docker Compose orchestrates the Rails app and a PostgreSQL database. Vite assets are compiled at image build time — no separate frontend server is needed at runtime.

### 1. Create the environment file

```bash
cp .env.example .env
```

Open `.env` and replace the placeholder with a real secret key:

```bash
openssl rand -hex 64   # copy the output into .env as SECRET_KEY_BASE
```

### 2. Build and start

```bash
docker-compose up --build
```

The first run compiles the image (installs gems, runs Vite, precompiles assets), starts PostgreSQL, and launches the Rails app. Database creation and migrations run automatically on startup.

Open [http://localhost:3000](http://localhost:3000).

### Stopping and cleaning up

```bash
docker-compose down        # stop containers, keep the database volume
docker-compose down -v     # stop containers and delete all data
```

---

## Usage

1. **Register or log in** — enter an email and password in the top-right form and click **Login / Register**. New email addresses are automatically registered; existing ones are authenticated.
2. **Share a video** — click **Share a movie**, paste a YouTube URL, and click **Share**. The title is fetched automatically.
3. **Browse the feed** — shared videos appear on the home page newest-first, each with an embedded player and the sharer's email.
4. **Real-time notifications** — when another user shares a video, a notification appears in your browser (coming soon).

---

## Troubleshooting

**`PG::ConnectionBad` on startup**
PostgreSQL is not running or the connection URL is wrong. For local dev, ensure the PostgreSQL service is running. For Docker, check that the `db` container is healthy: `docker-compose ps`.

**`Vite server not found` / blank page in development**
Always use `bin/dev` instead of `bin/rails server` — it starts both Rails and Vite together.

**`npm install` or `bundle install` fails**
Confirm the required tool versions are active:
```bash
ruby -v    # should be 3.4.1
node -v    # should be ≥ 22
```

**Docker build fails at `npm ci`**
The `package-lock.json` must be committed and up-to-date. Run `npm install` locally and commit the updated lockfile.

**`SECRET_KEY_BASE` is not set (Docker)**
Copy `.env.example` to `.env` and fill in `SECRET_KEY_BASE` with the output of `openssl rand -hex 64` before running `docker-compose up`.
