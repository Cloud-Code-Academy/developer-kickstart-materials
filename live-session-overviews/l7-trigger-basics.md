# Lesson 7 – Instructor Guide: Introduction to CI/CD and Apex Trigger Basics

## Learning Objectives
By the end of this session, students will be able to:
- Understand the high-level concept of **Continuous Integration / Continuous Deployment (CI/CD)** in Salesforce.
- Recognize the benefits of CI/CD for code quality and team collaboration.
- Explain what an **Apex Trigger** is and when to use one.
- Identify the difference between **before** and **after** triggers.
- Access **trigger context variables** in Apex.
- Create a basic trigger in both **Developer Console** and **VS Code** without requiring custom objects or fields.

---

## Lesson Outline (1h 30m Total)

### 1. Welcome & Context (5 min)
- Briefly recap prior session topics.
- Introduce today's dual focus:
  1. CI/CD overview.
  2. Apex trigger fundamentals.

---

### 2. Introduction to CI/CD in Salesforce (10 min)
- **Definition:**  
  - **Continuous Integration (CI):** Regularly merging changes into a shared repository and verifying via automated tests.  
  - **Continuous Deployment (CD):** Automatically deploying tested changes to environments (e.g., UAT, Production).
- **Benefits:**
  - Early detection of integration issues.
  - Consistent deployment processes.
  - Reduced manual errors.
- **Salesforce Context:**
  - Metadata stored in source control (e.g., GitHub).
  - Deploy via Salesforce CLI (`sfdx force:source:deploy`) or automated pipelines (e.g., GitHub Actions, Azure DevOps).
- Keep discussion high-level; full CI/CD implementation will be covered in a future dedicated lesson.

---

### 3. Transition to Triggers (5 min)
- Position triggers as part of the **business logic layer** in Salesforce.
- Explain that while CI/CD supports quality and speed, understanding how triggers work ensures we're building automation that fits into a CI/CD workflow.

---

### 4. What is an Apex Trigger? (10 min)
- **Definition:** Code that executes before or after record changes in Salesforce.
- **Events:**
  - `before insert`, `before update`, `before delete`
  - `after insert`, `after update`, `after delete`, `after undelete`
- **Use Cases:**
  - Automatically setting field values.
  - Validating data before save.
  - Creating related records after save.
- **Important:** Triggers run in bulk — must handle collections, not just single records.

---

### 5. Trigger Context Variables (10 min)
- **Common Variables:**
  - `Trigger.new`, `Trigger.old`
  - `Trigger.isInsert`, `Trigger.isUpdate`, `Trigger.isDelete`
  - `Trigger.isBefore`, `Trigger.isAfter`
- Example debug usage:
  ```apex
  System.debug('Is Insert? ' + Trigger.isInsert);
  System.debug('New Records: ' + Trigger.new);
  ```

---

**Files for Reference (do not copy/paste):**  
- `force-app\live-coding\module7\triggers\BasicAccountTrigger.trigger` – Example trigger implementing a simple **before insert** rule to set a default Account name. Use this as the starting point for the live demonstration.  
- `force-app\live-coding\module7\classes\BasicAccountTriggerTest.cls` – Test class illustrating how to unit test trigger logic (optional for instructor reference).  

### 6. Live Demo – Creating a Trigger (25 min)
**Purpose:** Show both Developer Console and VS Code workflows.

**Click Path – Developer Console:**
1. In Salesforce, go to **Avatar → Developer Console**.
2. **File → New → Apex Trigger**.
3. Name: `AccountTrigger`, SObject: `Account`.
4. Paste/modify the minimal example below.

**Click Path – VS Code:**
1. Press **Ctrl+Shift+P** / **Cmd+Shift+P**.
2. Search for **SFDX: Create Apex Trigger**.
3. Enter `AccountTrigger`, choose `Account` object.
4. Open the generated file and replace with the example code.

**Minimal Safe Trigger Example (No Custom Fields):**
```apex
trigger AccountTrigger on Account (before insert) {
    for (Account acc : Trigger.new) {
        if (acc.Name == null) {
            acc.Name = 'Default Account Name';
        }
    }
}
```

**Steps in Demo:**
1. Create trigger from Developer Console.
2. Deploy and test by creating a new Account (no Name set).
3. Show that the default name is applied.
4. Repeat creation via VS Code.

---

### 7. Best Practices for Triggers (10 min)
- One trigger per object — delegate logic to handler classes.
- Keep triggers lean; no complex logic directly in the trigger body.
- Always handle bulk operations.
- Avoid hardcoding IDs.
- Test thoroughly with bulk and single-record scenarios.

---

### 8. Wrap-Up & Q&A (5 min)
- Recap:
  - CI/CD as a quality/deployment process.
  - Triggers as automation executed during record changes.
  - Context variables and minimal trigger creation.
- Field questions from students.

---

### Copyright

Copyright © 2023-2025 Cloud Code Academy, Inc. All rights reserved.

This material is proprietary and confidential. Unauthorized use, reproduction, distribution, or modification of this material is strictly prohibited. This material is intended for educational purposes only and may not be shared, distributed, or used for commercial activities without express written permission.

For licensing inquiries or permissions, contact: admin@cloudcodeacademy.com
