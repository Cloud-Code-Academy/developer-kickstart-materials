# Lesson 1 – Instructor Guide: Salesforce Development Orientation

## Lesson Summary
This session serves as a **high-level orientation** to the program and an introduction to the essential tools students will use for Salesforce development.  
It establishes expectations, builds community rapport, and ensures that students leave prepared to participate in future, more technical sessions.  
While not a deep coding lesson, it introduces **IDE basics** and **Salesforce developer tools** so students can follow along in later live coding exercises.

---

## Learning Objectives
By the end of this session, students will be able to:

- Navigate the program structure, resources, and expectations.
- Understand the value of live session participation and the role of the Slack community.
- Set up and navigate **Visual Studio Code** for Salesforce development.
- Authenticate and connect to a **Salesforce Developer Org** using the Salesforce CLI **and** VS Code Command Palette click-path.
- Locate and complete pre-work in the learning portal to prepare for technical sessions.

---

## Lesson Outline (1h 45m Total)

### 1. Welcome & Instructor Introduction (10 min)
- Greet participants and encourage an open, collaborative learning environment.
- Share instructor’s career path into Salesforce, highlighting:
  - Transition from non-technical to technical roles.
  - Self-teaching through Trailhead, code review, and practice.
- Relate personal journey to student opportunities, reinforcing the achievable nature of the skills ahead.

---

### 2. Program Overview (10 min)
- **Structure:** 16 weeks of live sessions + 1-month capstone project.
- **Capstone:** Build and present a functional Salesforce application.
- **Resources:** Ongoing Slack community, recorded sessions, and a dedicated learning portal.
- **Participation:** Live attendance encouraged for interaction; recordings available for flexibility.

---

### 3. Learning Resources & Pre-Work (8 min)
- **Slack:** For Q&A, collaboration, code reviews, and job postings.
- **Learning Portal:** `learn.cloudcodeacademy.com` for lesson materials and pre-work.
- Stress the importance of **pre-work completion** before technical lessons.

---

### 4. IDE Basics: Visual Studio Code (12 min)
- **Installing VS Code** and required **Salesforce Extension Pack**:
  - Extensions → Search for “Salesforce Extension Pack” → Install.
- Navigating:
  - **Explorer View** for files, **Search**, **Source Control** tabs.
  - Opening/closing files.
  - Integrated Terminal:  
    - Open with ``Ctrl+` `` (Windows) or ``Cmd+` `` (Mac).
- Configuring workspace settings for Salesforce projects.
- **Common Pitfall:** Skipping extension installation, leading to missing Salesforce commands in Command Palette.

---

### 5. Salesforce Developer Tools (12 min)

#### **Authenticating a Salesforce Org**
- **Using CLI (SFDX):**
  ```bash
  sfdx auth:web:login
  ```
  - Follow the browser prompt to log into your Developer Org.
  - Close the browser tab after successful authentication.

- **Using VS Code Command Palette:**
  1. Press **Ctrl+Shift+P** (Windows) or **Cmd+Shift+P** (Mac) to open Command Palette.
  2. Type and select **SFDX: Authorize an Org**.
  3. Choose the login URL (usually `https://login.salesforce.com` for Developer Orgs).
  4. Enter an alias for the org (e.g., `DevOrg`).
  5. Log in via the browser window that opens.
  6. After successful login, return to VS Code — you should see a confirmation in the Output panel.

---

### 6. Live Demo – Anonymous Apex & HelloWorld Class (20 min)
**Purpose:** Give students a hands-on introduction to writing and running Apex code, starting with anonymous Apex and moving to a simple class.

**Files for Reference (do not copy/paste):**  
- `force-app\live-coding\module1\helloworld.apex` (Anonymous Apex example)  
- `force-app\live-coding\module1\classes\HelloWorld.cls` (Class example)  

**Flow:**

1. **Create Anonymous Apex**
   - Use `helloworld.apex` as a guide — students should type, not paste.
   - Demonstrate running anonymous Apex:
     - **From VS Code:** Open the file → Command Palette → `SFDX: Execute Anonymous Apex with Currently Selected Text`.
     - **From Salesforce Developer Console:** `Debug → Open Execute Anonymous Window` → type the code and execute.
   - Go over basic data types.
   - Discuss **primitives** (e.g., `String`, `Integer`, `Boolean`) and **collections** (`List`, `Set`, `Map`).

2. **Create HelloWorld Class**
   - Use `HelloWorld.cls` as a guide — type, do not paste.
   - Show creation:
     - **From VS Code:** Command Palette → `SFDX: Create Apex Class` → Name: `HelloWorld`.
     - **From Developer Console:** `File → New → Apex Class` → Name: `HelloWorld`.
   - Add a simple `say()` method returning `'Hello, Salesforce!'`.
   - Save and deploy the class.

3. **Update Anonymous Apex**
   - Modify the earlier anonymous Apex to include:
     ```apex
     System.debug(HelloWorld.say());
     ```
   - Run again (VS Code or Developer Console) and show output in the Debug Log.

### 7. Participation & Live Session Etiquette (8 min)
- Best practices for:
  - Asking questions in real time.
  - Using chat respectfully.
  - Requesting repetition or slower pacing.
- Benefits of live engagement vs passive recording review.

---

### 8. Career Path & Real-World Context (8 min)
- Salesforce use cases in nonprofits, higher education, and enterprise.
- Career transition opportunities for learners from non-technical roles.
- Examples of Salesforce-driven business solutions.

---

### 9. Course Success Strategies (7 min)
- Maintain consistent engagement with materials and community.
- Apply lessons immediately through practice.
- Leverage Slack and peer discussions for troubleshooting.

---

### 10. Q&A & Open Discussion (5 min)
- Address logistics, tools, and pre-work questions.
- Invite students to share personal learning goals.

---

## Key Points for Instructors
- Keep content **high-level**; avoid diving into complex Apex or SOQL here.
- Ensure every student leaves with:
  - A functioning VS Code setup.
  - Connected Salesforce Developer Org.
  - Awareness of where to find materials and submit questions.
- Demonstrate both **CLI and Command Palette authentication** for clarity.
- Establish a welcoming environment and highlight the support network.

---

### Copyright
Copyright © 2023-2025 Cloud Code Academy, Inc. All rights reserved.  

This material is proprietary and confidential. Unauthorized use, reproduction, distribution, or modification of this material is strictly prohibited.  
This material is intended for educational purposes only and may not be shared, distributed, or used for commercial activities without express written permission.  

For licensing inquiries or permissions, contact: **admin@cloudcodeacademy.com**