# SKIPO — User Stories

**Version:** 0.2
**Status:** Draft

## Purpose

Define the core things users should be able to accomplish in V1.

The product should prioritise the workout experience first, with social sharing as a secondary experience.

Story IDs (US-01 to US-27) match the issue titles on the SKIPO GitHub Project board.

---

## 1. Account & Profile

| ID    | Story             | As a user, I want                                  | so that                                                  |
|-------|-------------------|----------------------------------------------------|----------------------------------------------------------|
| US-01 | Create an account | to create an account                               | I can save my workouts and participate in the community |
| US-02 | Manage my profile | to have a profile with my name and profile picture | other users can recognise me in the feed                 |

---

## 2. Workout Generation

| ID    | Story                              | As a user, I want                                                             | so that                                                                   |
|-------|------------------------------------|-------------------------------------------------------------------------------|---------------------------------------------------------------------------|
| US-03 | Choose a workout goal              | to choose what I want to achieve                                              | the AI can generate a relevant workout                                    |
| US-04 | Configure my workout               | to provide basic information such as duration, difficulty or focus            | the generated workout matches what I want to do                           |
| US-05 | Generate a workout                 | the AI to generate a jump-rope workout based on my goals and preferences      | I don't have to design the workout myself                                 |
| US-06 | Review the generated workout       | to see the exercises, duration, difficulty and focus of the generated workout | I know what I'm about to do                                               |
| US-07 | Start the workout                  | to start the generated workout                                                | I can begin exercising immediately                                        |
| US-08 | Recover from AI generation failure | to be clearly informed if workout generation failed or times out              | I know what happened and can retry instead of being left waiting or stuck |

---

## 3. Active Workout

| ID    | Story                          | As a user, I want                                    | so that                                                                      |
|-------|--------------------------------|------------------------------------------------------|------------------------------------------------------------------------------|
| US-09 | Follow the workout             | to see which exercise I should currently perform     | I know what to do without thinking about the workout structure               |
| US-10 | Follow work and rest intervals | clear timers for work and rest periods               | I can focus on jumping instead of tracking time myself                       |
| US-11 | See workout progress           | to see my current round and overall progress         | I know how far I am through the workout                                      |
| US-12 | Control the workout            | to pause, resume or stop my workout                  | I can handle an unexpected interruption without losing my progress           |
| US-13 | Complete a workout             | the workout to clearly indicate when I have finished | I get a clear stopping point instead of wondering if I'm meant to keep going |

---

## 4. Completion & Progress

| ID    | Story                       | As a user, I want                                                                 | so that                                                                             |
|-------|-----------------------------|-----------------------------------------------------------------------------------|-------------------------------------------------------------------------------------|
| US-14 | See workout results         | to see a summary after completing a workout                                       | I can understand what I accomplished                                                |
| US-15 | Save completed workouts     | my completed workouts to be saved                                                 | I can look back at my training history                                              |
| US-16 | See my progress             | to see meaningful information about my previous workouts                          | I can track my progress over time                                                   |
| US-17 | See an empty progress state | the progress / history screen to explain what I will see once I complete workouts | an empty screen still feels useful and gives me a reason to start my first workout |

---

## 5. Sharing

| ID    | Story                                    | As a user, I want                                       | so that                                                          |
|-------|------------------------------------------|---------------------------------------------------------|------------------------------------------------------------------|
| US-18 | Choose whether to share                  | to be prompted to share my completed workout            | I can decide whether I want to post it publicly                  |
| US-19 | Add a photo                              | to optionally add a photo to my workout post            | other users can see what I did                                   |
| US-20 | Delete a shared workout                  | to delete a workout I previously shared                 | I can remove something from the public feed if I change my mind |
| US-21 | Confirm before deleting a shared workout | to be asked to confirm before deleting a shared workout | I don't accidentally remove something I wanted to keep           |

US-18 includes the full publish flow from DESIGN.md (share prompt, optional photo, publish, post appears in the feed). Only a completed workout session belonging to the user can be shared.

---

## 6. Social Feed

| ID    | Story                            | As a user, I want                                               | so that                                                         |
|-------|----------------------------------|-----------------------------------------------------------------|-----------------------------------------------------------------|
| US-22 | Browse the feed                  | to see workouts shared by other users                           | I can discover what the community is doing                      |
| US-23 | View workout details in the feed | to see the workout title, duration and exercises                | I can understand what someone completed                         |
| US-24 | Like a workout                   | to like another user's workout                                  | I can show appreciation for their effort                        |
| US-25 | Unlike a workout                 | to unlike a workout I previously liked                          | I can undo an accidental tap                                    |
| US-26 | See workout popularity           | to see how many people liked a workout                          | I can gauge how well it resonated with the community            |
| US-27 | See an empty feed state          | the empty feed to explain that no workouts have been shared yet | I understand why the feed is empty and know what I can do next |

---

## 7. V1 Scope

### Must have

- Account creation
- User profile
- Workout goal selection
- Workout configuration
- AI workout generation
- Workout review
- Active workout
- Work/rest timers
- Workout progress
- Workout completion
- Workout history
- Basic progress
- Optional workout sharing
- Optional photo
- Public social feed
- Likes

### Later

- Comments
- Following / followers
- Direct messaging
- Social notifications
- Advanced feed algorithms
- Complex profiles
- Advanced statistics
- Personalised long-term AI coaching
- Advanced achievements / gamification
