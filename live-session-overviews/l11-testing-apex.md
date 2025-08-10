# Lesson 11 – Instructor Guide: Introduction to Apex Testing

## Learning Objectives
By the end of this session, students will be able to:
- Explain the purpose of **Apex test classes** in Salesforce.
- Understand Salesforce requirements for test coverage before deployment.
- Write and run a basic test class using the `@isTest` annotation.
- Use `System.assert()` to validate expected outcomes.
- Create test data inside test methods and via `@testSetup` methods.
- Run tests from both **Developer Console** and **VS Code**.
- Apply best practices for bulk-safe, maintainable tests.

---

## Lesson Outline (1h 30m Total)

### 1. Welcome & Context (5 min)
- Recap recent topics (e.g., triggers, handler classes).
- Introduce today’s focus: **Testing Apex Code**.
- Emphasize that testing is a Salesforce deployment requirement, not just a best practice.

---

### 2. Why Testing Matters in Salesforce (10 min)
- Salesforce enforces **75% code coverage** across the org for production deployments.
- Benefits of unit tests:
  - Catching bugs early.
  - Verifying business logic correctness.
  - Supporting CI/CD pipelines.
- Tests run in an **isolated, temporary environment** — no changes persist.

---

### 3. Anatomy of a Test Class (10 min)
- **Annotations:**
  - `@isTest` — marks a class or method as a test.
  - `@testSetup` — creates data once per test class.
- **Structure:**
  - Test data setup.
  - Method(s) under test.
  - Assertions to validate results.
- Keep tests small and focused on a single behavior.

---

### 4. Live Demo – Target Class & Test Class (25 min)

**Files for Reference (do not copy/paste):**
- `force-app\live-coding\module11\classes\HelloTestTarget.cls`
- `force-app\live-coding\module11\classes\HelloTestTargetTest.cls`

**Step 1 – Create Target Class**
- **From VS Code:**
  1. Ctrl+Shift+P / Cmd+Shift+P → `SFDX: Create Apex Class`.
  2. Name: `HelloTestTarget`.
- **From Developer Console:**
  1. File → New → Apex Class → Name: `HelloTestTarget`.
- Add:
  ```apex
  public with sharing class HelloTestTarget {
      public static String getGreeting(String name) {
          return 'Hello, ' + name + '!';
      }
  }
  ```

**Step 2 – Create Test Class**
- **From VS Code:**
  1. Ctrl+Shift+P / Cmd+Shift+P → `SFDX: Create Apex Class`.
  2. Name: `HelloTestTargetTest`.
- **From Developer Console:**
  1. File → New → Apex Class → Name: `HelloTestTargetTest`.
- Add:
  ```apex
  @isTest
  private class HelloTestTargetTest {

      @isTest
      static void testGreeting() {
          String result = HelloTestTarget.getGreeting('Salesforce');
          System.assertEquals('Hello, Salesforce!', result, 'Greeting did not match expected output.');
      }
  }
  ```

---

### 5. Running Tests (10 min)

**Developer Console:**
1. Test → New Run.
2. Select `HelloTestTargetTest` → Run.
3. View results in Tests tab.

**VS Code:**
1. Open test class.
2. Right-click inside the method → `SFDX: Run Single Test`.
3. View output in the **Output** panel.

---

### 6. Using `@testSetup` for Data Creation (10 min)
- Demonstrate a `@testSetup` method:
  ```apex
  @testSetup
  static void setupData() {
      Account acc = new Account(Name='Test Account');
      insert acc;
  }
  ```
- Explain benefits:
  - Reduces duplication.
  - Ensures consistent data across tests.

---

### 7. Best Practices for Testing (10 min)
- Aim for **100% coverage** of new code, not just 75%.
- Keep tests independent — don’t rely on data from other tests.
- Include bulk operation tests.
- Use `System.assertEquals()` to check outcomes.
- Avoid hardcoding IDs.

---

### 8. Wrap-Up & Q&A (5 min)
- Recap:
  - Why testing is mandatory.
  - Basic test class structure.
  - Running tests in different environments.
- Field student questions.

---

### Copyright

Copyright © 2023-2025 Cloud Code Academy, Inc. All rights reserved.

This material is proprietary and confidential. Unauthorized use, reproduction, distribution, or modification of this material is strictly prohibited. This material is intended for educational purposes only and may not be shared, distributed, or used for commercial activities without express written permission.

For licensing inquiries or permissions, contact: admin@cloudcodeacademy.com