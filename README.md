# Useful Practice

Веб-приложение для управления проектами и задачами. Каждый пользователь ведёт свои проекты с канбан-доской задач по статусам.

## Стек

- **Ruby on Rails 8.0**
- **PostgreSQL**
- **Tailwind CSS 4**
- **Devise** — аутентификация
- **Pundit** — авторизация
- **state_machines** — управление статусами задач
- **Hotwire (Turbo + Stimulus)**

## Функционал

- Регистрация и вход (Devise)
- CRUD проектов — у каждого проекта есть имя, цель и описание
- CRUD задач внутри проекта
- Канбан-доска задач по статусам: **To Do → In Progress → In Testing → Done / Rejected**
- Поиск проектов по имени
- Авторизация через Pundit — пользователь видит и управляет только своими данными

## Локальный запуск

**Зависимости:** Ruby 3.3.5, PostgreSQL

```bash
git clone <repo>
cd useful_practice

bundle install

bin/rails db:create db:migrate

bin/dev
```

Приложение будет доступно на `http://localhost:3000`.

## Тесты

```bash
bundle exec rspec
```

Покрыты контроллеры, модели, переходы state machine и авторизация Pundit.
