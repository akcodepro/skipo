# SKIPO: CSS conventions

**Version:** 0.1

## Naming: BEM

- **Block:** a thing that makes sense on its own and could live on another page. `.resume-banner`
- **Element:** a part that only makes sense inside its block, joined with `__`. `.resume-banner__text`
- **Modifier:** a variant or state of a block or element, joined with `--`. `.button--small`, `.choice-tile--locked`
- Name by what it **is** or **does**, never by how it looks. `.button--primary`, not `.button--orange`
- Style classes only. No tag selectors inside a block (`.resume-banner p`), give the element a class instead
- A block never styles another block. Combine them in the HTML: `class="button button--secondary button--small"`
- **Mix** for spacing: a parent's element can sit on a child block (`class="button button--primary auth__action"`) to position it. The parent's element only does positioning (margin, alignment), never colours or sizes
- States are modifiers too (`__link--active`, `field--invalid`), never `is-active`. Build conditional classes with `class_names`

## Files

- One block per file, file name = block name: `.resume-banner` lives in `_resume_banner.scss`
- `components/`: blocks reused, or likely to be reused, across pages
- `pages/`: blocks used on one page only
- `config/`: variables only (colours, fonts, Bootstrap overrides). Produces no CSS on its own
- Every new file gets imported in its folder's `_index.scss`

## Gotchas

- simple_form wraps each item of `f.collection_check_boxes` / `f.collection_radio_buttons` in a `<span>`. Pass `{ item_wrapper_tag: false }` as the options hash to remove it
- simple_form's `f.button :submit` adds Bootstrap's `btn` class. Use Rails' `f.submit` with our `.button` classes instead
- simple_form forms use our own `:field` wrapper (`simple_form_for ..., wrapper: :field`), defined once in the simple_form initializer. It outputs `.field` BEM classes instead of Bootstrap's. Initializer changes need a server restart
- `link_to` takes `class:` directly. `html: { class: }` is a `simple_form_for` option, and on `link_to` it just outputs an `html` attribute
- When CSS "should work" but doesn't, read the real DOM tree in DevTools, not the ERB
- Sizing a child is the parent's job: prefer making the parent flex or grid over `height: 100%`
- Grow or shrink things on state changes with `transform: scale()`, not `width`/`height`, so nothing around them moves
- Full-screen layouts: `min-height: 100dvh` (with a `100vh` fallback), never `height: 100vh`, which hides content behind Safari's toolbars
- A base rotation that must survive `animation: none` goes in the standalone `rotate` property; keyframes then hold only the movement
- Decorative layers behind content: `isolation: isolate` on the block plus `z-index: -1` on the decoration, or it slides behind the block's own background
- Position decorations with px, not `%`: `top: -4%` is a percentage of the container's height, so it moves when the page gets taller
- Inputs need `font-size: 16px` minimum, or iPhone Safari zooms in on tap
- Icons: Font Awesome is sized with `font-size`, inline SVGs with `width`/`height`. An icon class used for both sets all three to the same value
- Inline SVG icons: export the shape alone from Affinity (not the artboard), keep only the `viewBox` and `<path>`, and use `fill="currentColor"` so the icon follows the text colour

## Colours

| Variable | Hex | Use |
|---|---|---|
| `$deep-forest` | #25483E | Main text, selected states, secondary buttons |
| `$warm-porcelain` | #F7F5EF | Page background, text on Forest |
| `$warm-orange` | #F27C45 | Primary actions, progress, active difficulty |
| `$golden-yellow` | #F4CF45 | Fundamentals (always included) |
| `$dusty-lilac` | #AAA3AB | Surfaces, borders, tracks. **Never for text** (2.3:1 on Porcelain) |
| `$smoky-mauve` | #6B636D | Secondary text, inactive tabs (5.3:1 on Porcelain) |
| `$deep-brick` | #A6382B | **Errors only**: invalid field borders and error messages (6:1 on Porcelain). Always paired with an icon or text, never colour alone |

Forest text on Orange only at 18.66px bold or larger (3.7:1, large text only).

## Components

| Block | Elements | Modifiers |
|---|---|---|
| `.button` | | `--primary` (orange), `--secondary` (forest), `--small`, `--block` (full width) |
| `.pill` | `__icon`, `__dot` | `--duration`, `--status`, `--focus`, `--difficulty`, `--rest` |
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
| `.landing` (`__blob` with `--lilac` / `--yellow`, `__hero`, `__title`, `__tagline`, `__actions`) | Logged-out home (hides the header via `content_for :hide_header`) |
| `.workout-builder` (`__header`, `__title`, `__subtitle`, `__form`, `__section`, `__section-title`, `__note`) | Train form |
| `.generated-workout` | Generated workout |
| `.workout-state` | Generating and generation failed |
| `.workout-session` | Active workout and summary |
