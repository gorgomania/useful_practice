# Useful Practice

A web application for managing projects and tasks. Each user maintains their own projects with a kanban board of tasks organized by status.

## Stack

- **Ruby on Rails 8.0**
- **PostgreSQL**
- **Tailwind CSS 4**
- **Devise** — authentication
- **Pundit** — authorization
- **state_machines** — task status management
- **Hotwire (Turbo + Stimulus)**

## Features

- Sign up and sign in (Devise)
- Project CRUD — each project has a name, goal, and description
- Task CRUD within a project
- Kanban board with task statuses: **To Do → In Progress → In Testing → Done / Rejected**
- Project search by name
- Authorization via Pundit — users can only see and manage their own data

## Local Setup

**Requirements:** Ruby 3.3.5, PostgreSQL

```bash
git clone <repo>
cd useful_practice

bundle install

bin/rails db:create db:migrate

bin/dev
```

The app will be available at `http://localhost:3000`.

## Tests

```bash
bundle exec rspec
```

Controllers, models, state machine transitions, and Pundit authorization are covered.
