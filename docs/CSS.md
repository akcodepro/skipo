# SKIPO: CSS conventions

**Version:** 0.1

## Naming: BEM

- **Block:** a thing that makes sense on its own and could live on another page. `.resume-banner`
- **Element:** a part that only makes sense inside its block, joined with `__`. `.resume-banner__text`
- **Modifier:** a variant or state of a block or element, joined with `--`. `.button--small`, `.choice-tile--locked`
- Name by what it **is** or **does**, never by how it looks. `.button--primary`, not `.button--orange`
- Style classes only. No tag selectors inside a block (`.resume-banner p`), give the element a class instead
- A block never styles another block. Combine them in the HTML: `class="button button--secondary button--small"`

## Files

- One block per file, file name = block name: `.resume-banner` lives in `_resume_banner.scss`
- `components/`: blocks reused, or likely to be reused, across pages
- `pages/`: blocks used on one page only
- `config/`: variables only (colours, fonts, Bootstrap overrides). Produces no CSS on its own
- Every new file gets imported in its folder's `_index.scss`

## Colours

| Variable | Hex | Use |
|---|---|---|
| `$deep-forest` | #25483E | Main text, selected states, secondary buttons |
| `$warm-porcelain` | #F7F5EF | Page background, text on Forest |
| `$warm-orange` | #F27C45 | Primary actions, progress, active difficulty |
| `$golden-yellow` | #F4CF45 | Fundamentals (always included) |
| `$dusty-lilac` | #AAA3AB | Surfaces, borders, tracks. **Never for text** (2.3:1 on Porcelain) |
| `$smoky-mauve` | #6B636D | Secondary text (5.3:1 on Porcelain) |

Forest text on Orange only at 18.66px bold or larger (3.7:1, large text only).

## Components

| Block | Elements | Modifiers |
|---|---|---|
| `.button` | | `--primary` (orange), `--secondary` (forest), `--small`, `--block` (full width) |
| `.pill` | `__icon`, `__dot` | `--duration`, `--status`, `--focus`, `--difficulty`, `--rest` |
| `.resume-banner` | `__text` | |
| `.stepper` | `__control`, `__value`, `__unit` | |
| `.choice-grid` | | |
| `.choice-tile` | `__icon`, `__label` | `--locked`, `--wide` |
| `.level-picker` | `__track`, `__fill`, `__stop`, `__labels` | |

## Page blocks

| Block | Page |
|---|---|
| `.workout-builder` (`__header`, `__title`, `__subtitle`, `__section`, `__section-title`, `__note`) | Train form |
| `.generated-workout` | Generated workout |
| `.workout-state` | Generating and generation failed |
| `.workout-session` | Active workout and summary |
