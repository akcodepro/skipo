# SKIPO: Database

**Version:** 0.2
**Status:** Draft

## Purpose

This document describes the data model for SKIPO.

The database stores:

- users and profiles
- AI-generated workouts
- exercises and workout structure
- completed workout sessions
- optionally shared workouts
- social likes

PostgreSQL is used as the database.

Images uploaded by users (profile pictures, workout photos) are stored with Active Storage and Cloudinary. They are attachments, not columns (see Decision #7).

---

## Core Entities

### User

Represents a SKIPO user and their profile.

**Key fields**

- id
- email
- display_name
- username
- created_at
- updated_at

**Attachments**

- profile photo (Active Storage)

A user can:

- create workouts
- complete workout sessions
- share completed workouts
- like shared workouts

---

### Workout

Represents a generated workout plan.

**Key fields**

- id
- user_id
- focus: the focus categories chosen by the user (multi-select, stored as an array)
- title
- description
- difficulty: integer, 1 to 3
- duration_seconds
- created_at
- updated_at

A workout belongs to one user and contains one or more exercises through WorkoutExercise.

A workout is the planned workout, not the user's actual performance.

The user's generation inputs (focus, duration, difficulty) are stored directly on the workout. There is no separate table for them (see Decision #10).

---

### Exercise

Represents a reusable jump-rope exercise from the global exercise library.

**Key fields**

- id
- name (unique)
- description
- instructions
- category: integer enum, one home category per exercise
- difficulty: integer, 1 to 3
- created_at
- updated_at

Exercises are global and shared by all workouts. There is one record per exercise, and names are unique.

The AI can only pick exercises from this library.

**Categories**

Stored as integers. Labels are defined in the UI, so they can be renamed without changing data.

1. Fundamentals
2. Footwork
3. Rhythm & Coordination
4. Power
5. Technical
6. Freestyle

Users never "graduate": every category stays available to every user (see Decision #11).

---

### WorkoutExercise

Joins a workout with an exercise and defines how that exercise is used in the workout.

**Key fields**

- id
- workout_id
- exercise_id
- position
- duration_seconds
- repetitions
- rest_seconds

position determines the order of exercises within a workout.

A workout cannot contain two exercises with the same position.

---

### WorkoutSession

Represents an actual attempt at completing a workout.

**Key fields**

- id
- workout_id
- user_id
- status
- started_at
- completed_at
- actual_duration_seconds
- created_at
- updated_at

This is intentionally separate from Workout.

A Workout describes what was planned.

A WorkoutSession describes what actually happened.

A user can potentially have multiple sessions for the same workout.

**Status values**

- in_progress
- completed
- stopped

Pausing and resuming happen in the browser only and are not stored. A session cannot be resumed after leaving the workout screen: the user finishes or stops (see Decision #8).

Only completed sessions can be shared.

---

### SharedWorkout

Represents a completed workout that a user has chosen to publish to the social feed.

**Key fields**

- id
- workout_session_id
- user_id
- caption
- created_at
- deleted_at

**Attachments**

- photo (Active Storage, optional)

Sharing is optional.

A shared workout belongs to one user and one workout session.

deleted_at allows a shared post to be removed without necessarily deleting the underlying workout or workout session.

---

### Like

Represents a user's positive reaction to a shared workout.

**Key fields**

- id
- user_id
- shared_workout_id
- created_at

A user can like a shared workout only once.

The unique combination of user_id and shared_workout_id prevents duplicate likes.

A user can remove their like.

---

## Relationships

```
User
 ├── has many Workouts
 ├── has many WorkoutSessions
 ├── has many SharedWorkouts
 ├── has many Likes
 └── has one attached profile photo
Workout
 ├── belongs to User
 ├── has many WorkoutExercises
 └── has many Exercises through WorkoutExercises
Exercise
 └── has many Workouts through WorkoutExercises
WorkoutSession
 ├── belongs to Workout
 ├── belongs to User
 └── can have one SharedWorkout
SharedWorkout
 ├── belongs to WorkoutSession
 ├── belongs to User
 ├── has many Likes
 └── has one attached photo (optional)
Like
 ├── belongs to User
 └── belongs to SharedWorkout
```

---

## Key Rules & Constraints

- Every workout belongs to a user.
- Every workout exercise belongs to one workout and one exercise.
- Exercise order is defined by WorkoutExercise.position.
- A workout cannot have duplicate exercise positions.
- Exercise names are unique. The AI can only use exercises from the library.
- A workout session belongs to both a workout and a user.
- A workout session is in progress, completed or stopped.
- Sharing a workout is optional.
- Only a completed workout session belonging to the user can be shared.
- A workout session can have at most one shared workout.
- A shared workout can optionally contain a photo and caption.
- Users can like shared workouts.
- A user can only like a particular shared workout once.
- Users can unlike a workout they previously liked.
- Deleting a shared workout should not delete the underlying workout session.

---

## Design Decisions

### Workout vs WorkoutSession

These are deliberately separate.

Workout = the generated plan.

WorkoutSession = the user's actual attempt.

This allows SKIPO to keep the generated workout while recording whether and when the user actually completed it.

### SharedWorkout vs WorkoutSession

Sharing is treated as a separate social action rather than making every completed workout public.

A user can complete a workout without sharing it.

### Likes

Likes are intentionally positive-only.

There is no dislike/downvote relationship in V1.

### Completed vs stopped

Both statuses are kept on purpose: "you finish or you don't". A stopped session still records its actual duration, so the user's effort appears in their history, but it cannot be shared (Decision #8).

### Category and difficulty are separate

An exercise's category describes what kind of move it is. Its difficulty describes how hard it is. A Double Under is not "advanced": it is a Power move with a high difficulty (Decision #11).

### Resolved decisions

| Issue | Decision |
|-------|----------|
| #7 Photo storage | Active Storage + Cloudinary for user uploads |
| #8 Session status values | in_progress, completed, stopped. Pause is browser-only, no resume |
| #10 Generation inputs | Stored on the workout (focus, duration_seconds, difficulty) |
| #11 Exercises | Global library, one home category and a difficulty per exercise |

---

## Open Decisions

These decisions may change as the application is implemented:

- Whether AI-generated workouts can be edited before starting.
- Whether progress metrics need additional persisted data.
- Whether stopped sessions count toward progress stats.
- How stale in_progress sessions are handled.
- Whether deleted shared workouts should be soft-deleted permanently or physically removed.
- Whether additional achievement/streak data is required later.
