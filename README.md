# SKIPO

AI-generated jump rope workouts, built around what you actually want to train.

**[Live demo](https://skipo-app-3be98c580ead.herokuapp.com)** · Demo account: `demo@example.com` / `password`

![SKIPO screens: landing, workout builder, generated workout, active session](docs/screenshots.webp)

## Why SKIPO

I looked for jump rope workout apps but never found one that did what I wanted. Just Tabata timers or Pomodoro timers, nothing simple, flexible, or personalisable enough. I built an Apple Shortcut that worked great, but it got repetitive over time, and I couldn't really share it with friends who were looking for the same thing. So I started building Skipo.

You pick a duration, the moves you want to work on and a difficulty. SKIPO generates a structured workout and coaches you through it with work and rest timers.

## Status

SKIPO is a solo project in active development.

**Works today**
- Sign up, log in and password reset
- AI workout generation from duration, focus and difficulty
- Active workout with work and rest timers, pause and stop

**Known issue**
- The workout timer resets if you leave the page and come back

**Not built yet**
- Progress and workout history
- Sharing completed workouts and the social feed
- Profile and settings

## Stack

Ruby on Rails 8.1, PostgreSQL, Devise, Stimulus, Turbo, Sass/SCSS with Bootstrap, importmap, RubyLLM with Mistral, Solid Queue, Solid Cable, Solid Cache, Active Storage with Cloudinary, Minitest, GitHub Actions, Heroku.

## How generation works

### 1. Ruby builds the frame first

Before the LLM is called, Ruby decides which exercises can be used, based on the selected focus categories, Fundamentals, and the chosen difficulty (or below). It also sets the acceptable duration range for the workout (for example, 5 minutes allows 4:30 to 6:00) and calculates the number of exercises by dividing the requested duration into 75-second blocks.

This was necessary because the LLM used to generate workouts that were way outside the requested duration, sometimes by 40%. These answers often failed validation, meaning users had to generate again, wait longer, and potentially waste more LLM tokens without any guarantee that the next attempt would work. The idea was to give the AI clear boundaries to work within, then let Ruby check whether the result actually meets the requirements.

### 2. The schema constrains the output

The JSON schema restricts the `name` field to an enum containing only the candidate exercises. Before this, the LLM would return the same exercise under several spellings, which failed validation. The schema prevents it from returning variations like `"criss cross"` or `"Criss-Crosses"` when they're not in the list.

This matters because every exercise maps to a single row in the library. Keeping names consistent means its instructions, category, and future history all stay associated with the same exercise, rather than ending up with duplicates.

### 3. Ruby repairs, then validates

Before validation, `adjust_timings` checks whether the total duration is off by 20% or less. If it is, it scales the work and rest periods proportionally and rounds them to 5-second increments. If the difference is greater than 20%, the result is left as is, and validation rejects it.

Then `validate!` checks that there's at least one exercise, every exercise exists in the library, the total duration is within the acceptable range, and Fundamentals make up no more than 50% of the workout (unless Fundamentals was the selected focus).

### 4. The job handles retries and failures

Generation runs in a background job because an LLM call can take several seconds. Keeping the web request open for that long risks hitting Heroku's request timeout and leaves the user waiting on a page that appears frozen.

The `retry_on ... attempts: 2` setting means two attempts in total: the initial attempt and one retry. If both attempts fail, a Turbo Stream replaces the loading screen with an error message.

**In short:** Ruby sets the boundaries, the schema limits what the AI can return, the code repairs or rejects the result, and the background job handles retries and failures.

## Saving workouts

A `Workout` is a generated plan, while a `WorkoutSession` represents an attempt at that plan. The workout is saved as soon as generation and validation succeed, with `WorkoutGenerator#save!` creating it and its associated `WorkoutExercise` rows inside a transaction. A session is only created when the user hits Start, and failed or invalid generations never touch the database.

Saving the workout straight away means it has its own page (`/train/:id`) and can be referenced by a session later. The trade-off is that workouts the user never starts still accumulate in the database. How to handle those is something I'll need to decide alongside the planned regenerate feature.

For the full data model, see [schema.dbml](docs/schema.dbml) and [DB.md](docs/DB.md).

## Engineering decisions

- **Solid Cache, Queue and Cable share one database.** Rails 8 defaults to separate databases for each, but I configured all three to use the primary database so the app can run on a single Postgres instance on Heroku. Solid Queue runs the generation job, while Solid Cable pushes updates to the page via Turbo Streams.
- **BEM for SCSS.** I use BEM naming to keep styles organised and avoid naming conflicts. See [CSS.md](docs/CSS.md).
- **One branch and PR per card.** This keeps changes in smaller, reviewable chunks and makes progress visible.
- **CI on every PR.** The pipeline runs RuboCop for style checks, bundler-audit and importmap audit for vulnerable dependencies, Brakeman for security analysis, the full test suite, and a check that seeds load cleanly on a fresh database. It runs on every PR and every push to `main`.
- **Tests across the main flows.** Coverage includes models, controllers, the generator service, the background job, and integration tests for sign-up and the workout flow.

Product, design and brand decisions live in [docs/](docs).

## Run it locally

**Requirements:** Ruby 3.3.5, PostgreSQL, a Mistral API key, and a Cloudinary account for image uploads.

```bash
git clone https://github.com/akcodepro/skipo.git
cd skipo
bin/setup --skip-server
```

`bin/setup` installs the gems, creates the database and seeds the exercise library.

Create a `.env` file at the root:

```bash
MISTRAL_API_KEY=your_mistral_key
CLOUDINARY_URL=cloudinary://your_key:your_secret@your_cloud_name
```

Start the app:

```bash
bin/dev
```

Run the tests, or the full CI pipeline:

```bash
bin/rails test
bin/ci
```

## Roadmap

- Progress tab: workout history and personal progress
- Workout complete screen, then sharing with an optional photo, the social feed and likes
- Keep the timer running across page reloads
- Regenerate a workout with the same settings
- How-to instructions for every exercise
