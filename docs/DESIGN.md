# SKIPO — Design

**Version:** 0.2
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

---

### Generated Workout

Purpose:

- Explain what the AI generated
- Let the user understand the workout before starting

Show:

- Workout duration
- Difficulty
- Focus
- Exercises / rounds
- Brief explanation

Primary action:

**Start workout**

---

### Active Workout

The most important screen.

Priority:

1. Current exercise
2. Timer
3. Work / rest state
4. Current round
5. Overall progress
6. Controls

The interface should feel focused rather than like a dashboard.

---

### Workout Complete

Purpose:

- Confirm completion
- Give the user a sense of achievement
- Show useful results
- Offer the option to share the workout

The user should be prompted to share, but sharing must remain optional.

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

Navigation is expected to use a mobile-native approach, potentially inspired by Apple's Liquid Glass aesthetic.

The exact navigation structure is still open.

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

Final illustrations may be created specifically for the project, potentially with external illustration support.

The priority is to establish the product and interaction first rather than blocking development on custom artwork.

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

---

## Open Questions

- Exact home screen structure
- Workout generation inputs
- Navigation structure
- Feed placement in navigation
- Feed ordering / pagination
- Exact feed post layout
- Progress visualisation
- Active workout controls
- Animation behaviour
- AI coach interaction
- History / progress scope
- Final illustration approach
- Backend / AI architecture
- Error and loading states
