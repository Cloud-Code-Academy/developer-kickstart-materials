# Lesson 2 – Instructor Guide: Version Control & Programming Flow Control, Loops, Collections

## Lesson Summary
This session introduces two core areas of Salesforce development:  
1. **Version Control** (Git and GitHub basics).  
2. **Programming Foundations** (flow control, loops, and collections).  

Students first learn how version control fits into their workflow and practice Git/GitHub fundamentals. Then, they apply programming concepts to build logic with flow control, loops, and collections. By the end of the session, students will have both collaboration skills and foundational coding abilities.

---

## Learning Objectives
By the end of this session, students will be able to:

- Explain the difference between **Git** and **GitHub**.  
- Clone a repository and configure a local Git environment.  
- Stage, commit, push, and pull changes using both CLI and VS Code.  
- Recognize and avoid common pitfalls in Git workflows.  
- Use **flow control statements** (`if`/`else`) to guide program execution.  
- Write and apply **loops** (`for`, `while`, `do while`) to process data.  
- Create and manipulate **collections** (`List`, `Set`, `Map`) for storing values.  

---

## Lesson Outline (2h Total)

### Part A: Git & Version Control Foundations (60 min)

#### 1. Welcome, Recap, & Program Reminders (5 min)

#### 2. Git vs. GitHub Overview (10 min)
- Define **Git** (local version control) vs **GitHub** (remote hosting).  
- Real-world relevance for Salesforce projects.  

#### 3. Navigating GitHub (10 min)
- Repositories, branches, commit history, pull requests.  
- Common pitfall: downloading ZIP vs cloning repo.  

#### 4. Setting Up Local Git Environment (10 min)
- Install Git, configure username and email.  
- Verify with `git --version`.  

#### 5. Cloning a Repository (10 min)
- CLI and VS Code workflows.  
- Confirm `.git` folder exists locally.  

#### 6. Git Fundamentals in VS Code & CLI (10 min)
- **Staging, committing, pushing, pulling**.  
- Emphasize pulling before pushing.  

#### 7. Q&A & Transition (5 min)

---

### Part B: Programming Foundations (60 min)

#### 1. Flow Control (20 min)
- Introduce `if`/`else` statements.  
- Show nested conditionals.  
- Salesforce context: validation logic, branching workflows.  

```apex
Integer score = 85;
if (score >= 90) {
    System.debug('Grade A');
} else if (score >= 80) {
    System.debug('Grade B');
} else {
    System.debug('Grade C or lower');
}
```

---

#### 2. Loops (20 min)
- Explain loop types: `for`, `while`, `do while`.  
- Use cases: processing records, repeating tasks.  
- Common pitfalls: infinite loops, off-by-one errors.  

```apex
List<String> fruits = new List<String>{'Apple','Banana','Cherry'};
for (String f : fruits) {
    System.debug(f);
}
```

---

#### 3. Collections (20 min)
- **Lists:** Ordered, allow duplicates.  
- **Sets:** Unordered, unique values.  
- **Maps:** Key-value lookups.  

```apex
Map<String, String> countryCodes = new Map<String, String>{
    'US' => 'United States',
    'CA' => 'Canada'
};
System.debug(countryCodes.get('US')); // United States
```

---

## Key Points for Instructors
- Keep Git demonstrations simple — focus on workflow, not complexity.  
- Reinforce that **version control** is foundational for collaboration, while **programming concepts** build problem-solving ability.  
- Demonstrate both CLI and GUI workflows for Git operations.  
- Connect code examples to Salesforce use cases (validation rules, iterating over records, data mapping).  

---

### Copyright

Copyright © 2023-2025 Cloud Code Academy, Inc. All rights reserved.

This material is proprietary and confidential. Unauthorized use, reproduction, distribution, or modification of this material is strictly prohibited. This material is intended for educational purposes only and may not be shared, distributed, or used for commercial activities without express written permission.

For licensing inquiries or permissions, contact: admin@cloudcodeacademy.com
