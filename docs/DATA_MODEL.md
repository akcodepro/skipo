https://dbdiagram.io/d

Project jump_rope_ai {
  database_type: "PostgreSQL"
}


// ============================================
// USERS
// ============================================

Table users {
  id integer [pk, increment]

  email varchar(255) [not null, unique]
  encrypted_password varchar(255) [not null]
  reset_password_token varchar(255)
  reset_password_sent_at timestamptz

  display_name varchar(100) [not null]
  username varchar(50) [unique]
  profile_photo_url varchar(500)

  created_at timestamptz [not null]
  updated_at timestamptz [not null]
}


// ============================================
// WORKOUTS
// ============================================

Table workouts {
  id integer [pk, increment]

  user_id integer [not null, ref: > users.id]

  goal varchar(50) [not null]

  title varchar(150) [not null]
  description text

  difficulty varchar(30) [not null]

  duration_seconds integer [not null]

  created_at timestamptz [not null]
  updated_at timestamptz [not null]

  indexes {
    user_id
    created_at
  }
}


// ============================================
// EXERCISES
// ============================================

Table exercises {
  id integer [pk, increment]

  name varchar(100) [not null]
  description text
  instructions text

  created_at timestamptz [not null]
  updated_at timestamptz [not null]
}


// ============================================
// WORKOUT EXERCISES
// ============================================

Table workout_exercises {
  id integer [pk, increment]

  workout_id integer [not null, ref: > workouts.id]
  exercise_id integer [not null, ref: > exercises.id]

  position integer [not null]

  duration_seconds integer
  repetitions integer
  rest_seconds integer

  created_at timestamptz [not null]
  updated_at timestamptz [not null]

  indexes {
    (workout_id, position) [unique]
    exercise_id
  }

  Note: "At least duration_seconds or repetitions should be present."
}


// ============================================
// WORKOUT SESSIONS
// ============================================

Table workout_sessions {
  id integer [pk, increment]

  workout_id integer [not null, ref: > workouts.id]
  user_id integer [not null, ref: > users.id]

  status varchar(30) [not null]

  started_at timestamptz
  completed_at timestamptz

  actual_duration_seconds integer

  created_at timestamptz [not null]
  updated_at timestamptz [not null]

  indexes {
    user_id
    workout_id
    status
    created_at
  }
}


// ============================================
// SHARED WORKOUTS
// ============================================

Table shared_workouts {
  id integer [pk, increment]

  workout_session_id integer [not null, unique, ref: > workout_sessions.id]
  user_id integer [not null, ref: > users.id]

  caption text
  photo_url varchar(500)

  created_at timestamptz [not null]
  deleted_at timestamptz

  indexes {
    user_id
    created_at
  }
}


// ============================================
// LIKES
// ============================================

Table likes {
  id integer [pk, increment]

  user_id integer [not null, ref: > users.id]
  shared_workout_id integer [not null, ref: > shared_workouts.id]

  created_at timestamptz [not null]

  indexes {
    (user_id, shared_workout_id) [unique]
    shared_workout_id
  }
}
