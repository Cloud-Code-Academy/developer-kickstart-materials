# Lesson 6 – Instructor Guide: Git Branching & Collaboration + Troubleshooting & Debugging

## Lesson Summary
This session delivers an in-depth look at **Git branching and team collaboration on GitHub**, then reinforces a systematic approach to **troubleshooting and debugging** in Salesforce. Students will practice a feature-branch workflow, pull requests, and merge strategies aligned to the lecture slides, and then apply structured debugging tactics using logs and targeted experiments.The second half emphasizes narrowing scope, isolating causes, reading debug logs, and iterating fixes safely.  

---

## Learning Objectives
By the end of this session, students will be able to:

- Follow a **feature-branch workflow** from clone → branch → commit → push → PR → QA → merge.
- Write high-quality **commit messages** and open **pull requests** tied to a user story.
- Compare **branching strategies** and choose an appropriate merge strategy (merge commit vs. squash vs. rebase) for the team. 
- Diagnose issues using a structured **troubleshooting vs. debugging** approach.   
- Configure and interpret **debug logs** with the correct **log levels**; iterate fixes safely.  

---

## Lesson Outline (1h 30m Total)

### Part A: Git Branching & Collaboration (60 min)

#### 1. Welcome & Context (5 min)
- Why branching matters: **teamwork, code quality, accountability, feature management**; how Copilot fits in as assistive tooling.

---

#### 2. Feature-Branch Workflow (15 min)
- From **main**: create a short-lived, descriptive feature branch → commit → push → PR → QA → merge.

```bash
# Create and switch to a feature branch from main
git checkout -b feature/update-account-description

# Stage & commit your changes
git add .
git commit -m "Update Account descriptions when missing"

# Push the new branch to origin
git push origin feature/update-account-description
```

- Tie commits/PRs to the **user story**:  
  *Update Account Descriptions*  
  - If `Description` is empty, set `<Industry> + ' Account'`.  
  - If no `Industry`, set `'Missing Industry for Account'`.  
  - Return updated list of Accounts.

---

#### 3. Pull Requests & Code Review (10 min)
- What to include: concise title, context, screenshots (when applicable), risk notes, and test steps.  
- **QA approval** before merge (per slide flow).
- Instructor tip: enforce branch protection + required reviews.

---

#### 4. Branching Strategies & Merge Options (10 min)
- **Branching strategies:** lightweight feature branches (trunk-based), or longer-lived branches (GitFlow-style)—choose one, document it.  
- **Merge strategies:**  
  - **Squash & merge** for clean history,  
  - **Merge commit** to preserve branch history,  
  - **Rebase** (advanced) to linearize history.

---

#### 5. Staying Up-to-date & Conflict Resolution (15 min)
- Sync with main before opening/merging a PR:

```bash
# Update local tracking refs and rebase feature on latest main
git fetch --all --prune
git checkout feature/update-account-description
git rebase origin/main

# If conflicts appear:
# 1) Edit files to resolve
# 2) git add <resolved-file>
git rebase --continue

# As an alternative (if team prefers merges):
git merge origin/main
```

- Inspect history and status quickly:

```bash
git status
git log --oneline --graph --decorate -20
```

---

#### 6. Collaboration Extras (5 min)
- Use **draft PRs** early, **CODEOWNERS** for routing reviews, and **Copilot** for diffs/tests but never as a substitute for understanding.

---

### Part B: Troubleshooting & Debugging (30 min)

#### 1. Troubleshooting vs. Debugging (10 min)
- **Troubleshooting:** reproduce, narrow scope, check config & permissions, inspect data/changes/logs.   
- **Debugging:** compare *Expected vs Actual*, add targeted debugs, fix, **retest**, and keep changes small. 

---

#### 2. Debug Log Levels & Usage (10 min)
- Levels from **NONE → ERROR → WARN → INFO → DEBUG → FINE → FINER → FINEST**; choose the lowest verbosity that reveals the issue.   
- Practical steps: enable logs, reproduce, scan events by category/level, iterate.

---

#### 3. Common Error Types & Safe Fix Loops (5 min)
- **Syntax**, **Logic**, **Runtime**, and **Uncaught exceptions**; when and why to use `try/catch`.   
- Avoid masking problems with overly broad catches; log meaningfully.

---

#### 4. Q&A & Wrap-Up (5 min)
- Re-emphasize: branch early, PR often; debug with intention; **don’t change too much at once**. 

---

## Key Points for Instructors
- Keep branch names **short and descriptive**; reference the ticket ID (e.g., `CC-123`).
- Model the slide workflow end-to-end (clone → branch → commit → push → PR → QA).
- Show at least one **conflict resolution** path (rebase or merge) live.  
- Use **structured logs and minimal deltas** during debugging to isolate effects. 

---

### Copyright

Copyright © 2023-2025 Cloud Code Academy, Inc. All rights reserved.

This material is proprietary and confidential. Unauthorized use, reproduction, distribution, or modification of this material is strictly prohibited. This material is intended for educational purposes only and may not be shared, distributed, or used for commercial activities without express written permission.

For licensing inquiries or permissions, contact: admin@cloudcodeacademy.com
