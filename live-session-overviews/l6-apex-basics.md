# Lesson 6 – Instructor Guide: Working with Variables, Data Types, and Collections in Apex

## Learning Objectives
By the end of this session, students will be able to:
- Declare and initialize variables using Apex syntax.
- Understand and use **primitive data types** (`String`, `Integer`, `Decimal`, `Boolean`, `Date`).
- Create and manipulate **collections** (`List`, `Set`, `Map`).
- Understand collection initialization and iteration patterns.
- Recognize when and why to use each type of collection in Apex.
- Apply best practices for naming, readability, and debugging.

---

## Lesson Outline (1h 30m Total)

### 1. Welcome & Session Context (5 min)
- Recap last lesson’s SOQL basics and using query results in Apex.
- Introduce today’s focus: **variables, data types, and collections**.
- Explain why these are fundamental for data manipulation in Salesforce development.

---

### 2. Variables & Assignment (10 min)
- Explain **what variables are** and how they store data in memory.
- Syntax:
  ```apex
  String companyName = 'Acme Corp';
  Integer employeeCount = 250;
  Decimal revenue = 1050000.50;
  Boolean isActive = true;
  Date today = Date.today();
  ```
- Discuss variable naming best practices (camelCase, descriptive names).
- Show default values for uninitialized variables.

---

### 3. Primitive Data Types (10 min)
- Detail the most common Apex primitive types:
  - `String`
  - `Integer`
  - `Decimal`
  - `Boolean`
  - `Date`, `Datetime`, `Time`
- Demonstrate type-specific operations:
  ```apex
  String greeting = 'Hello';
  greeting += ', Salesforce!'; // Concatenation
  
  Integer x = 5;
  Integer y = 3;
  System.debug(x + y); // Arithmetic
  ```
- Common pitfall: mismatched data types (type casting errors).

---

### 4. Lists (15 min)
- Explain that **Lists** are ordered collections that can contain duplicates.
- Syntax examples:
  ```apex
  List<String> colors = new List<String>{'Red', 'Green', 'Blue'};
  colors.add('Yellow');
  System.debug(colors.size()); // Number of elements
  ```
- Accessing elements by index:
  ```apex
  System.debug(colors[0]); // 'Red'
  ```
- Iterating with a `for` loop:
  ```apex
  for (String color : colors) {
      System.debug(color);
  }
  ```

---

### 5. Sets (10 min)
- Explain that **Sets** are unordered collections with no duplicates.
- Example:
  ```apex
  Set<String> fruits = new Set<String>{'Apple', 'Banana', 'Apple'};
  System.debug(fruits); // Apple appears only once
  fruits.add('Orange');
  ```
- Use cases: ensuring uniqueness, quick membership checks.

---

### 6. Maps (15 min)
- Explain that **Maps** store key–value pairs for fast lookups.
- Example:
  ```apex
  Map<String, String> countryCodes = new Map<String, String>{
      'US' => 'United States',
      'CA' => 'Canada'
  };
  System.debug(countryCodes.get('US')); // United States
  ```
- Iterating over keys:
  ```apex
  for (String code : countryCodes.keySet()) {
      System.debug(code + ' => ' + countryCodes.get(code));
  }
  ```
- Real-world Salesforce example: mapping `Id` to record.

---

### 7. Live Coding – Combining Collections with SOQL (15 min)
- Write a SOQL query to retrieve Account names:
  ```apex
  List<Account> accs = [SELECT Id, Name FROM Account LIMIT 5];
  ```
- Store records in a `Map<Id, Account>`:
  ```apex
  Map<Id, Account> accMap = new Map<Id, Account>(accs);
  ```
- Iterate and debug:
  ```apex
  for (Id accId : accMap.keySet()) {
      System.debug(accMap.get(accId).Name);
  }
  ```

---

### 8. Best Practices & Common Pitfalls (5 min)
- Use the right collection type for the job.
- Initialize collections before adding to them.
- Limit SOQL queries in loops to avoid governor limits.

---

### 9. Q&A & Wrap-Up (5 min)
- Review key concepts: variables, data types, Lists, Sets, Maps.
- Encourage practice by creating and manipulating collections in different ways.

---

## Copyright

Copyright © 2023-2025 Cloud Code Academy, Inc. All rights reserved.

This material is proprietary and confidential. Unauthorized use, reproduction, distribution, or modification of this material is strictly prohibited. This material is intended for educational purposes only and may not be shared, distributed, or used for commercial activities without express written permission.

For licensing inquiries or permissions, contact: admin@cloudcodeacademy.com