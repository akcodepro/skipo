# SKIPO — Design

**Version:** 0.7
**Status:** Exploratory

## Product

A mobile-first AI coach that generates personalised jump-rope workouts and lets users optionally share their completed workouts with the community.

The core experience is:

**Goal → Generate → Workout → Complete → Share**

The social feed is part of V1 but should remain secondary to the workout experience.

---

## Design Principles

### 1. Mobile first

The primary experience is designed for a phone and should not depend on desktop layouts.

### 2. Immediate understanding

The user should quickly understand:

- What they can do
- What the current workout is
- What they need to do next
- How much time remains

### 3. Action over information

The interface should prioritise the next action rather than presenting large amounts of workout data.

### 4. Focus during workouts

The active workout experience should remain visually focused and readable while the user is moving.

### 5. Social without pressure

Sharing a workout should be encouraged but never required.

The app should not make the user feel that every workout needs to become a social post.

### 6. Positive-only feedback

The app should use positive social signals rather than negative ones.

Users can like workouts, but there is no dislike, downvote or other negative reaction.

The goal is to encourage participation and effort rather than create a judgement-oriented environment.

---

## Core Screens

### Home

Purpose:

- Introduce the app
- Let the user choose a goal
- Start the workout-generation flow
- Provide access to the main areas of the app

Primary action:

**Choose a goal**

---

### Workout Generation

Purpose:

- Collect the minimum information needed to generate a workout
- Make the AI feel like a coach rather than a chatbot

The interaction should remain structured and quick.

The user tells the coach what they want. The AI decides the details.

The screen opens with a personal greeting using the user's display name and a short, cheeky subtitle picked at random. If a workout is still in progress, a resume banner sits under the greeting.

Inputs (V1):

- **Duration:** a stepper with a large number and −/+ buttons, from 5 to 30 min in steps of 5. Defaults to 15 min. The buttons disable at each end
- **Focus:** a grid of square icon tiles, multi-select. Fundamentals is shown as a double-width golden tile with a lock: it is always included and cannot be toggled. A short note under the grid explains why. "Mixed" is planned but needs a backend decision first
- **Difficulty:** three stops on a track (Easy, Medium, Hard). Defaults to Medium

Primary action:

**Build my workout**

Work/rest intervals, tempo and volume are decided by the AI, not the user.

Later: "anything to include" preferences, a first-use comfort question, Quick Start / Surprise me, adaptive coaching from history.

---

### Generated Workout

Purpose:

- Explain what the AI generated
- Let the user understand the workout before starting

Layout (decided October 2026):

- **Full-bleed Forest hero** reaching the top of the screen, bottom corners rounded. The header sits inside it in its inverse version. It holds the focus chips (Fundamentals always shown, in yellow), the title, three stats (total minutes, moves, level) and the AI's short description. A large tone-on-tone blob adds depth without hurting readability
- **Rhythm strip** under the hero: one bar for the whole workout, jump blocks in Forest and rest blocks in yellow, widths proportional to seconds. Its place on this screen is still under review (see Open Questions)
- **Timeline of moves:** a dot, the exercise name and the jump time per move, with the rest shown as a dashed connector between moves. No rest after the last move
- **Exercise detail sheet:** tapping a move opens a bottom sheet with its category, level, jump and rest times, "What it is", "How to do it" (when written) and a "Demo video coming soon" slot for future visuals
- **Sticky action bar** above the navbar with the orange **Start workout** button, always visible. A regenerate button joins it later

Primary action:

**Start workout**

---

### Active Workout

The most important screen.

Context drives every decision: the user is jumping, and the phone usually sits on a window sill or on the floor a couple of metres away, leaning on whatever is around. Everything must read in half a second from a distance.

Layout (decided October 2026):

- **Full-screen colour by phase:** Get Ready and Cooldown in calm porcelain, Jump in Forest, Rest in yellow. The phase reads from the corner of the eye, without words
- **Draining fill:** the phase colour fills the screen and its level drops as the countdown runs, like a battery. The top edge of the fill is wavy and gently animated: the blob identity lives in the progress itself. Reduced motion is respected
- **Giant countdown:** the biggest element in every phase, with the phase label written once, above it
- **Jump:** the current exercise name only. No "Up next", to keep the screen calm
- **Rest and Get Ready:** "Up next" and the next move. This is where future illustrations will go
- **Cooldown:** "Nice work. Breathe it out."
- **Progress:** one dot per move (done, current larger, upcoming faded) plus "x / xx"
- **Controls:** small round icon buttons, no words. × (leave) top left, pause top right. They are possibilities on the screen, not calls to action
- **No header and no navbar.** The × is the exit

Pause and resume happen in the browser only. Leaving the workout screen ends the session: the user finishes or stops.

Stopping before the end asks for confirmation in a styled sheet, and explains that a stopped workout cannot be shared, so there is no surprise.

The screen stays awake for the whole workout (wake lock). Otherwise the phone locks, and nothing can be seen or heard.

Sound (planned): beeps in the last 3 seconds of every phase except the final one, and the next exercise and the completion message announced with the phone's own voice (Web Speech API). One toggle switches all sound on or off. It lives on the workout screen for now and moves to the profile later.

---

### Workout Complete

Purpose:

- Confirm completion
- Give the user a sense of achievement
- Show useful results
- Offer the option to share the workout

The user should be prompted to share, but sharing must remain optional.

Only completed workouts can be shared. A stopped workout shows a neutral, positive summary of what the user did (for example, the minutes completed), without a share prompt. Final wording to be defined.

The moment should feel joyful (confetti or similar), without overdoing it.

Primary actions:

**Share workout**

**Done**

---

### Social Feed

A community feed containing workouts shared by users.

A feed post can contain:

- User profile picture
- User name
- Publication time
- Workout title
- Workout duration
- Workout information
- Optional user photo
- Exercise details
- Like action

A workout post may contain a carousel when both a user photo and workout details are available.

Comments are intentionally outside the V1 scope.

The feed should feel like an extension of the workout experience rather than a separate social-media product.

---

### History / Progress

Purpose:

- Let the user see previous workouts
- Show meaningful personal progress over time

This is primarily private user data and should remain secondary to the workout experience.

Stopped sessions still appear in history and progress, visually distinct from completed ones: a dot on a chart is more motivating than nothing.

---

## Primary User Flow

**Home**
↓
**Choose goal**
↓
**Generate workout**
↓
**Review workout**
↓
**Start workout**
↓
**Active workout**
↓
**Complete workout**
↓
**Share?**
↙        ↘
**Share**   **Skip**
↓           ↓
**Feed**    **Done**

Sharing is optional and should never block completion of the workout.

---

## Social Feed Flow

**Complete workout**
↓
**Share prompt**
↓
**Optional photo**
↓
**Publish**
↓
**Workout appears in public feed**

Users can browse the feed independently from completing their own workouts.

### V1 social scope

Include:

- Public feed
- Workout posts
- User identity
- Optional workout photo
- Workout details
- Likes

Defer:

- Comments
- Direct messaging
- Following / followers
- Complex social profiles
- Social notifications
- Advanced feed algorithms

The goal is to establish the basic community experience without turning V1 into a social-network project.

---

## UI Direction

- Strong visual hierarchy
- Large, prominent numbers
- Generous but controlled spacing
- Rounded UI elements
- Simple icons
- Clear primary actions
- Minimal visual clutter
- Subtle purposeful motion
- High readability during active workouts

### Navigation

Mobile-native bottom tab bar, styled close to Apple's Liquid Glass.

- Tabs: **Progress · Train · Feed** (Train in the centre, same size as the others)
- Profile accessed via the avatar in the header
- Hidden during workout generation and the active workout, shown again on the complete screen
- Logged-out users see a landing page with sign up / log in, and no tab bar
- Desktop: same mobile layout in a centred column for V1 (the `.screen` component)
- Glass effect on the nav bar only. It must stay readable over any content and look right on iPhone Safari, where refraction effects may not render
- Active tab set server-side, tap interactions only (no hover-driven behaviour)

### Components

Reusable UI pieces and their naming live in CSS.md. Interactive controls are touch-first: press feedback on tap, no hover-only states.

Avoid:

- Excessive cards
- Excessive shadows
- Excessive gradients
- Excessive glassmorphism
- Excessive pills
- Decorative UI without purpose

---

## Illustration & Iconography

The visual system should eventually include distinctive illustrations and supporting graphic elements.

Illustrations should be:

- Expressive
- Dynamic
- Organic
- Playful
- Consistent with the brand palette

For early implementation, large icons such as Font Awesome can be used as placeholders.

Each focus category has its own icon, reused wherever that category appears (Train form tiles, generated workout chips, exercise detail sheet).

Planned spots for exercise illustrations: the exercise detail sheet ("Demo video coming soon" slot) and the Rest and Get Ready phases of the active workout, next to "Up next".

Final illustrations may be created specifically for the project, potentially with external illustration support.

The priority is to establish the product and interaction first rather than blocking development on custom artwork.

---

## Brand Symbol

SKIPO uses a custom, organic S as its primary brand symbol.

The symbol has a bold, dynamic silhouette and can be used independently or alongside the SKIPO wordmark.

### App Icon

The standalone S is the current app icon design.

The editable master is maintained in Affinity.

Colour treatment: see BRAND.md.

### Train tab icon

The Train tab uses the brand S symbol, inline as SVG so it follows the tab's text colour. It reads clearly at tab size (20px).

Progress and Feed keep conventional icons (a chart, a group of people), matching their placeholder pages.

The brand symbol should not be forced into contexts where a conventional icon communicates the action more clearly.

---

## AI Experience

The AI should feel like a **coach**, not a chatbot.

Workout generation should primarily use structured UI rather than a conventional chat interface.

The generated result should clearly communicate:

- What the workout is
- Why it was generated
- How long it takes
- What the user needs to do
- How difficult it is

The AI should encourage without becoming cheesy or overly verbose.

### Exercise library

The AI can only pick exercises from a global library. Each exercise has one home category and a difficulty (1 to 3).

Categories: Fundamentals · Footwork · Rhythm & Coordination · Power · Technical · Freestyle

Fundamentals exercises are always part of the candidate pool, whatever the user picks.

Users never "graduate": every category stays available, whatever their experience. Category labels live in the UI and can change without touching data (for example, "Rhythm & Coordination" shows as "Rhythm" on the Train form).

---

## Achievement

Completion should feel rewarding without turning the app into a game.

Useful achievement signals include:

- Completed workout
- Workout duration
- Progress
- Streaks
- Personal bests

Achievement should support motivation rather than distract from the workout.

---

## Visual Content

Early visual explorations are intended to establish overall coherence between:

- Colour
- Typography
- Layout
- Hierarchy
- Personality

They are not intended to define exact content, copy, navigation or final component structure.

Content and UI details should be refined during implementation.

Mockups for the generated workout and the active workout live on the "SKIPO generated workout options" canvas.

---

## Current Decisions

- Mobile-first
- AI-generated jump-rope workouts
- Structured coach experience rather than chat-first
- Public social feed included in V1
- Sharing is optional
- Workout sharing prompted after completion
- Likes included in V1
- Comments deferred
- Large numbers are visually important
- Active workout is the highest-priority experience
- Short, clear primary flows
- Energetic but focused interface
- Achievement without excessive gamification
- Custom illustrations are desirable but not a development blocker
- Placeholder icons can be used during early implementation
- Bottom tab bar navigation: Progress · Train · Feed, Liquid Glass style
- Generation inputs: duration stepper (default 15 min), focus tiles (multi-select, Fundamentals always included), difficulty picker (default Medium)
- Allowed durations are defined once, on the Workout model, and validated server-side
- Global exercise library with categories and difficulty
- Pause/resume in the browser only; stopped workouts cannot be shared
- AI: RubyLLM with Mistral, structured output validated in code
- Custom organic S established as the primary brand symbol
- Train tab uses the S symbol; Progress and Feed use conventional icons
- Front-end conventions (BEM, one block per file, components) documented in CSS.md
- Generated workout: full-bleed Forest hero, timeline of moves, exercise detail sheet, sticky Start button
- Active workout: full-screen colour by phase, draining fill with an animated wavy edge, giant countdown, move dots, icon controls, no header or navbar, screen kept awake
- Sound: countdown beeps and spoken exercise names, behind one on/off toggle

---

## Open Questions

- Exact home screen structure
- Feed ordering / pagination
- Exact feed post layout
- Progress visualisation
- Rhythm strip on the generated workout: keep, rework or remove? It may read as stripes and feels decorative on a preview screen
- AI coach interaction
- History / progress scope
- Final illustration approach
- Error and loading states
- What "Mixed" focus means for the generator
