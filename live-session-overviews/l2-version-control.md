# Lesson 2 – Instructor Guide: Git & Version Control Foundations

## Lesson Summary
This session provides a **practical introduction to Git and GitHub** for Salesforce development.  
Students learn how version control fits into their workflow, the differences between Git and GitHub, and how to set up their local environment for source control.  
The lesson includes both **CLI commands** and **step-by-step click-paths** in VS Code, preparing students to confidently manage their code changes in later, more advanced Salesforce projects.

---

## Learning Objectives
By the end of this session, students will be able to:

- Explain the difference between **Git** (version control system) and **GitHub** (remote repository hosting).
- Navigate GitHub repositories and understand their structure.
- Configure **Visual Studio Code** to work with Git and GitHub.
- Clone a repository to a local environment.
- Stage, commit, push, and pull changes using both CLI and VS Code GUI workflows.
- Identify and avoid common pitfalls in Git workflows.

---

## Lesson Outline (2h Total)

### 1. Welcome, Recap, & Program Reminders (10 min)
- Greet students and recap Session 1 key points:
  - IDE setup.
  - Org authentication.
- Remind students to complete pre-work before sessions.
- Address any setup issues from previous week.

---

### 2. Git vs. GitHub Overview (15 min)
- **Git:** Local version control system — tracks changes to code.
- **GitHub:** Cloud-based hosting service for Git repositories.
- Analogy: Git is your personal notebook, GitHub is the cloud backup and collaboration hub.
- Real-world relevance in Salesforce projects:
  - Managing metadata in multi-developer teams.
  - Tracking deployments between sandboxes and production.

---

### 3. Navigating GitHub (15 min)
- **Repository Structure:**
  - Code tab.
  - Branch list.
  - Commit history.
  - Pull requests.
- Viewing files and commit diffs in the browser.
- Download options:
  - ZIP file.
  - Clone URL (HTTPS or SSH).
- **Common Pitfall:** Confusing “Download ZIP” with cloning — ZIP doesn’t include version control history.

---

### 4. Setting Up Local Git Environment (15 min)
- Install Git (if not already installed):
  - **Windows:** `https://git-scm.com/download/win`
  - **Mac:** `brew install git` (if using Homebrew) or Xcode Command Line Tools.
- Configure Git user:
  ```bash
  git config --global user.name "Your Name"
  git config --global user.email "you@example.com"
  ```
- Verify installation:  
  ```bash
  git --version
  ```

---

### 5. Cloning a Repository (15 min)
- **CLI Method:**
  ```bash
  git clone https://github.com/username/repo-name.git
  ```
- **VS Code Click-Path:**
  1. Open VS Code.
  2. **Ctrl+Shift+P** (Windows) or **Cmd+Shift+P** (Mac) → Type **Git: Clone**.
  3. Paste the repository URL.
  4. Choose a local folder for the clone.
  5. Open the cloned project when prompted.
- Confirm `.git` folder exists locally to verify version control is active.

---

### 6. Git Fundamentals in VS Code & CLI (25 min)

#### **Staging Changes**
- **CLI:**
  ```bash
  git add .
  ```
- **VS Code Click-Path:**
  - Go to **Source Control** tab.
  - Click `+` next to file(s) or use “Stage All Changes”.

#### **Committing Changes**
- **CLI:**
  ```bash
  git commit -m "Describe changes here"
  ```
- **VS Code Click-Path:**
  - Enter a commit message in the Source Control input box.
  - Click the ✓ (Commit) icon.

#### **Pushing to Remote**
- **CLI:**
  ```bash
  git push origin main
  ```
- **VS Code Click-Path:**
  - Click “Sync Changes” in the Source Control tab.

#### **Pulling Updates**
- **CLI:**
  ```bash
  git pull origin main
  ```
- **VS Code Click-Path:**
  - Click “Pull” in the Source Control tab menu.

**Common Pitfalls:**
- Forgetting to pull before pushing — can cause merge conflicts.
- Working on the wrong branch without realizing it.

---

### 7. Real-World Context for Git in Salesforce Development (10 min)
- Git tracks changes to metadata files (Apex, LWC, config).
- Prevents overwriting other developers’ work.
- Facilitates code review via pull requests.
- Useful for deployment planning — comparing environments before moving changes.

---

### 8. Hands-On Practice & Walkthrough (20 min)
- Clone a practice repo from GitHub Classroom.
- Make a small change (e.g., edit README).
- Stage, commit, and push change using both CLI and VS Code.
- Verify the commit appears on GitHub.

---

### 9. Q&A & Wrap-Up (5 min)
- Address common Git setup and usage questions.
- Encourage students to practice both CLI and GUI methods.
- Remind them that Git will be used extensively in later projects.

---

## Key Points for Instructors
- Demonstrate both **CLI and GUI** for all Git operations.
- Emphasize pulling before pushing to avoid merge conflicts.
- Show how GitHub commit history can serve as a project timeline.
- Keep practice examples simple — focus on process, not complex code.
- Relate Git usage back to collaborative Salesforce development.

---

### Copyright
Copyright © 2023-2025 Cloud Code Academy, Inc. All rights reserved.  

This material is proprietary and confidential. Unauthorized use, reproduction, distribution, or modification of this material is strictly prohibited.  
This material is intended for educational purposes only and may not be shared, distributed, or used for commercial activities without express written permission.  

For licensing inquiries or permissions, contact: **admin@cloudcodeacademy.com**