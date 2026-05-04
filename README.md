# Remitano YouTube

A web app for sharing YouTube videos with real-time notifications. When a user shares a video, all other logged-in users receive an instant notification with the video title and sharer's name.

**Stack:** Rails 8.1 · React · Inertia.js · Tailwind CSS · PostgreSQL · ActionCable · Solid Queue

## Prerequisites

| Tool | Version |
|------|---------|
| Ruby | 3.2.2 |
| Node.js | 22.x |
| npm | 10.x |
| PostgreSQL | 14+ |

## Installation & Configuration

```bash
git clone https://github.com/Adenhall/remitano-youtube.git
cd remitano-youtube
bundle install
npm install
```

Copy and configure credentials if needed (uses Rails encrypted credentials):

```bash
EDITOR=vim bin/rails credentials:edit
```

## Database Setup

```bash
bin/rails db:create db:migrate
# Optional: seed sample data
bin/rails db:seed
```

## Running the Application

```bash
bin/dev
```

Starts both the Rails server and Vite dev server (with HMR). Visit [http://localhost:3000](http://localhost:3000).

## Running Tests

```bash
bin/rails test          # unit + integration tests
bin/rails test:system   # system tests (requires a browser)
```

## Docker Deployment

A `Dockerfile` is included. Build and run the image:

```bash
docker build -t remitano-youtube .
docker run -e RAILS_MASTER_KEY=<key> -e DATABASE_URL=<url> -p 3000:3000 remitano-youtube
```

For full local orchestration with PostgreSQL, see the `docker-compose.yml` (coming soon).

## Usage

1. Register or log in
2. Paste a YouTube URL to share a video — all other logged-in users receive a real-time notification
3. Browse shared videos on the home feed

## Troubleshooting

**`PG::ConnectionBad`** — ensure PostgreSQL is running and the `DATABASE_URL` env var or `config/database.yml` points to your instance.

**`Vite server not found`** — run `bin/dev` instead of `bin/rails server`; it starts both Rails and Vite together.

**`npm install` fails** — ensure Node.js ≥ 22 is active (`node -v`).
