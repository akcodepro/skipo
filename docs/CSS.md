# SKIPO: CSS conventions

**Version:** 0.2

## Naming: BEM

- **Block:** a thing that makes sense on its own and could live on another page. `.resume-banner`
- **Element:** a part that only makes sense inside its block, joined with `__`. `.resume-banner__text`
- **Modifier:** a variant or state of a block or element, joined with `--` (two hyphens, always). `.button--small`, `.choice-tile--locked`
- Name by what it **is** or **does**, never by how it looks. `.button--primary`, not `.button--orange`
- Style classes only. No tag selectors inside a block (`.resume-banner p`), and no position-based selectors (`> span:first-child`). Give the element a class instead
- A block never styles another block. Combine them in the HTML: `class="button button--secondary button--small"`
- **Mix** for spacing: a parent's element can sit on a child block (`class="button button--primary auth__action"`) to position it. The parent's element only does positioning (margin, alignment), never colours or sizes
- States are modifiers too (`__link--active`, `field--invalid`), never `is-active`. Build conditional classes with `class_names`
- Elements live **inside** their block in the HTML. If a piece sits outside, wrap both in the block
- Different screens get different blocks, even when they share a page (the active workout and its summary)

## Files

- One block per file, file name = block name: `.resume-banner` lives in `_resume_banner.scss`
- `components/`: blocks reused, or likely to be reused, across pages
- `pages/`: blocks used on one page only
- `config/`: variables only (colours, fonts, layout, Bootstrap overrides). Produces no CSS on its own
- `_base.scss`: global element rules (`body`), imported after Bootstrap
- Every new file gets imported in its folder's `_index.scss`
- Inside a block: base declarations first, then modifiers, then elements (Sass warns about declarations after nested rules)

## Gotchas

- simple_form wraps each item of `f.collection_check_boxes` / `f.collection_radio_buttons` in a `<span>`. Pass `{ item_wrapper_tag: false }` as the options hash to remove it
- simple_form's `f.button :submit` adds Bootstrap's `btn` class. Use Rails' `f.submit` with our `.button` classes instead
- simple_form forms use our own `:field` wrapper (`simple_form_for ..., wrapper: :field`), defined once in the simple_form initializer. It outputs `.field` BEM classes instead of Bootstrap's. Initializer changes need a server restart
- `link_to` takes `class:` directly. `html: { class: }` is a `simple_form_for` option, and on `link_to` it just outputs an `html` attribute
- `button_to` generates a `<form>`: style it with `form: { class: "..." }`
- When CSS "should work" but doesn't, read the real DOM tree in DevTools, not the ERB
- Sizing a child is the parent's job: prefer making the parent flex or grid over `height: 100%`
- Grow or shrink things on state changes with `transform: scale()`, not `width`/`height`, so nothing around them moves
- Full-screen layouts: `min-height: 100dvh` (with a `100vh` fallback), never `height: 100vh`, which hides content behind Safari's toolbars. A screen that must cover everything: `position: fixed; inset: 0`
- A base rotation that must survive `animation: none` goes in the standalone `rotate` property; keyframes then hold only the movement
- Decorative layers behind content: `isolation: isolate` on the block plus `z-index: -1` on the decoration, or it slides behind the block's own background
- Position decorations with px, not `%`: `top: -4%` is a percentage of the container's height, so it moves when the page gets taller
- Inputs need `font-size: 16px` minimum, or iPhone Safari zooms in on tap
- Icons: Font Awesome is sized with `font-size`, inline SVGs with `width`/`height`. An icon class used for both sets all three to the same value
- Inline SVG icons: export the shape alone from Affinity (not the artboard), keep only the `viewBox` and `<path>`, and use `fill="currentColor"` so the icon follows the text colour
- Buttons and links styled from scratch need a reset first: `border: 0; background: transparent; padding: 0; font: inherit; color: inherit; text-align: left; text-decoration: none`
- Hiding something without moving the layout: `visibility: hidden` keeps its space, `display: none` removes it
- **Custom properties only flow down** to children. To affect a sibling, set the variable on a shared parent, for example with `body:has(.page-block)`
- Data from Ruby or JS to CSS: a custom property (`style="--seconds: 45"`, `element.style.setProperty("--remaining", 0.6)`), then `var()` in the stylesheet. The HTML carries the data, the CSS decides what to do with it
- A value animated with a 1s `transition` is always one second behind. Aim it at where the value will be when the transition ends (the workout fill looks one second ahead, and stops looking ahead while paused)
- Seamless looping wave: draw it twice as wide as the screen and slide it by `-50%` with a `linear` animation
- Respect `prefers-reduced-motion`: turn off transitions and animations inside it
- Numbers that change every second: `font-variant-numeric: tabular-nums` so they don't wobble
- **iOS status bar blur:** iOS blurs content scrolling under the status bar unless a fixed element touches the top edge. The `.status-bar-background` strip in the layout does that on every page. Tested on iPhone 13 (installed app): it needs at least 5px of height and must be painted (`transparent` brings the blur back), but `rgba($warm-porcelain, 0.01)` is enough, so it's invisible and needs no colour per page. Don't delete the "empty" div

## Colours

| Variable | Hex | Use |
|---|---|---|
| `$deep-forest` | #25483E | Main text, selected states, secondary buttons, Jump phase fill |
| `$warm-porcelain` | #F7F5EF | Page background, text on Forest |
| `$warm-orange` | #F27C45 | Primary actions, progress, active difficulty |
| `$golden-yellow` | #F4CF45 | Fundamentals (always included), Rest phase fill, rest blocks |
| `$dusty-lilac` | #AAA3AB | Surfaces, borders, tracks. **Never for text** (2.3:1 on Porcelain) |
| `$smoky-mauve` | #6B636D | Secondary text, inactive tabs (5.3:1 on Porcelain) |
| `$deep-brick` | #A6382B | **Errors only**: invalid field borders and error messages (6:1 on Porcelain). Always paired with an icon or text, never colour alone |
| `$mist` | #E4E0E5 | Secondary text on Forest (hero labels, description) |

Forest text on Orange only at 18.66px bold or larger (3.7:1, large text only).

Active workout phase tones (set as custom properties on `.workout-session`): Get Ready and Cooldown porcelain over #E9E4D8, Jump #4B6F64 over Forest, Rest #FBEBB0 over yellow.

## Layout variables (`config/_layout.scss`)

- `$screen-max-width`, `$screen-gutter`: used by `.screen` and the header, never hardcoded

## Components

| Block | Elements | Modifiers |
|---|---|---|
| `.screen` | | `--with-nav` (room above the navbar, plus the bottom safe area), `--bleed` (no max width or gutter) |
| `.button` | | `--primary` (orange), `--secondary` (forest), `--small`, `--block` (full width) |
| `.pill` | `__icon`, `__dot` | `--outline` (follows the text colour, works on dark and light), `--fundamentals`, `--duration`, `--status` |
| `.app-header` | `__logo`, `__action` | `--inverse` (porcelain on dark). Partial locals: `inverse`, `signed_in` |
| `.flash-stack` | | |
| `.flash` | `__message`, `__close` | `--notice`, `--alert` |
| `.timeline` | `__item`, `__move` (link that opens the sheet), `__dot`, `__name`, `__time`, `__chevron`, `__rest` | |
| `.action-bar` | `__form`, `__primary` (mix) | |
| `.sheet` | `__grabber`, `__close` | |
| `.exercise-detail` | `__chips`, `__title`, `__stats`, `__stat`, `__stat-value`, `__stat-label`, `__visual`, `__section`, `__heading`, `__text` | `__stat--jump` |
| `.status-bar-background` | | |
| `.resume-banner` | `__text` | |
| `.stepper` | `__control` (the −/+ buttons), `__display` (wraps number and unit), `__value` (the big number), `__unit` ("min") | |
| `.choice-grid` | `__item` (one grid cell, wraps a hidden input and its tile) | |
| `.choice-tile` | `__input` (the hidden checkbox, sits before the tile), `__icon`, `__label`, `__lock` | `--locked`, `--wide` |
| `.level-picker` | `__input` (the hidden radio), `__stop` (the label: dot + text), `__dot`, `__text` | |
| `.coming-soon` | `__icon`, `__title`, `__text`. Rendered by the `shared/_coming_soon` partial (locals: `icon`, `title`, `text`) | |
| `.field` | `__label`, `__input`, `__hint`, `__error` (with a Font Awesome icon via `::before`). Generated by the simple_form `:field` wrapper | `--invalid` (added by simple_form when the attribute has an error) |
| `.auth` | `__blob` (`--lilac` / `--yellow`), `__back`, `__header`, `__title`, `__subtitle`, `__form`, `__options`, `__remember`, `__checkbox`, `__link`, `__action` (mix on the submit button, spacing only), `__switch` | |
| `.liquid-navbar` | `__bar` (the glass pill), `__link` (one tab: icon above label), `__icon` (Font Awesome, or the S symbol SVG on Train), `__label` | `__link--active` |

## Page blocks

| Block | Page |
|---|---|
| `.landing` (`__blob` with `--lilac` / `--yellow`, `__hero`, `__title`, `__tagline`, `__actions`) | Logged-out home (hides the header via `content_for :hide_header`, full width via `content_for :bleed`) |
| `.workout-builder` (`__header`, `__title`, `__subtitle`, `__form`, `__section`, `__section-title`, `__note`) | Train form |
| `.generated-workout` (`__hero`, `__blob`, `__chips`, `__title`, `__stats`, `__stat`, `__stat-value` (`--level`), `__stat-number`, `__stat-unit`, `__stat-label`, `__description`, `__exercises`) | Generated workout |
| `.workout-state` | Generating and generation failed |
| `.workout-session` (`__fill`, `__wave`, `__controls`, `__control`, `__progress`, `__dots`, `__dot` (`--done`, `--current`), `__count`, `__main`, `__phase`, `__seconds`, `__next`, `__name`) with phase modifiers `--ready`, `--jump`, `--rest`, `--cooldown` set by the timer | Active workout (hides the header and navbar) |
| `.workout-summary` (`__title`, `__metadata`) | Finished or stopped session, until #81 redesigns it |
